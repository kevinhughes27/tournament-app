import * as d3 from 'd3';
import { max } from 'lodash';
import inflection from 'inflection';

const ordinalize = inflection.ordinalize;

const HeightMultiplier = 120;
const NodeSpacing = 40;

interface Node {
  id: number;
  x: number;
  y: number;
  parent: any;
  data: {
    uid: string;
    home: string;
    away: string;
    round: number;
    root: boolean;
  };
}

class BracketGraph {
  viewerWidth: number;
  viewerHeight: number;
  tree: any;
  zoomListener: any;
  baseSvg: any;
  svgGroup: any;
  treeHeight?: number;
  maxLabelLength?: number;

  constructor(container: HTMLDivElement) {
    // empty the container
    container.innerHTML = '';

    // size of the diagram
    this.viewerWidth = container.clientWidth;
    this.viewerHeight = container.clientHeight;

    // create the tree
    this.tree = d3.tree().size([this.viewerHeight, this.viewerWidth]);

    // attach zoomListener
    this.zoomListener = d3
      .zoom()
      .scaleExtent([0.1, 3])
      .on('zoom', () => {
        this.svgGroup.attr('transform', d3.event.transform);
      });

    // create the baseSvg
    this.baseSvg = d3
      .select(container)
      .append('svg')
      .attr('width', this.viewerWidth)
      .attr('height', this.viewerHeight)
      .attr('cursor', 'pointer')
      .call(this.zoomListener);

    // add an inner svg to allow for pan and zoom
    this.svgGroup = this.baseSvg.append('g');
  }

  render(bracketTree: any) {
    const maxRound = bracketTree[0].round + 1;

    const treeData = {
      root: true,
      round: maxRound,
      children: bracketTree
    };

    const nodeWidth = this.update(treeData);

    this.position(nodeWidth);
  }

  update(source: any) {
    // Compute the tree height
    const levelWidth = [1];
    const childCount = (level: number, n: any) => {
      if (n.children && n.children.length > 0) {
        if (levelWidth.length <= level + 1) {
          levelWidth.push(0);
        }
        levelWidth[level + 1] += n.children.length;
        n.children.forEach((d: any) => {
          childCount(level + 1, d);
        });
      }
    };
    childCount(0, source);

    this.treeHeight = d3.max(levelWidth) * HeightMultiplier;
    this.tree = this.tree.size([this.treeHeight, this.viewerWidth]);

    // Compute the new tree layout.
    const hierarchy = d3.hierarchy(source);
    const nodes = this.tree(hierarchy);

    // compute maxLabelLength
    this.maxLabelLength = 0;
    nodes.descendants().forEach((d: Node) => {
      this.maxLabelLength = max([
        d.data.home ? d.data.home.length : 0,
        d.data.away ? d.data.away.length : 0,
        this.maxLabelLength
      ]);
    });

    // compute the nodeWidth
    const nodeWidth = this.maxLabelLength * 5 + 20;

    // Set horizantal position for each node
    nodes.descendants().forEach((d: Node) => {
      d.y = d.data.round * (nodeWidth + NodeSpacing);
    });

    // Declare the nodes
    let i = 0;
    const node = this.svgGroup
      .selectAll('.node')
      .data(nodes.descendants(), (d: Node) => d.id || (d.id = ++i));

    // Enter the nodes
    const nodeEnter = node
      .enter()
      .append('g')
      .attr('class', 'node')
      .attr('transform', (d: Node) => `translate(${d.y} , ${d.x})`)
      .style('opacity', 0);

    // game rect
    nodeEnter
      .append('rect')
      .attr('rx', 6)
      .attr('ry', 6)
      .attr('width', nodeWidth)
      .attr('height', 30)
      .style('fill', '#fff');

    // home text
    nodeEnter
      .append('text')
      .attr('dy', 12)
      .attr('dx', 8)
      .attr('text-anchor', 'start')
      .text((d: Node) => d.data.home);

    // away text
    nodeEnter
      .append('text')
      .attr('dy', 24)
      .attr('dx', 8)
      .text((d: Node) => d.data.away);

    // place text
    nodeEnter
      .append('text')
      .attr('dy', 18)
      .attr('dx', nodeWidth + 10)
      .attr('font-weight', 'bold')
      .text((d: Node) => {
        if (d.parent && d.parent.data.root) {
          return ordinalize(d.data.uid);
        }
      });

    // uid text
    nodeEnter
      .append('text')
      .attr('dy', -6)
      .attr('dx', nodeWidth / 2 - 4)
      .attr('font-weight', 'bold')
      .text((d: Node) => {
        if (!(d.parent && d.parent.data.root)) {
          return d.data.uid;
        } else {
          return '';
        }
      });

    // Declare the links
    const link = this.svgGroup
      .selectAll('path.link')
      .data(nodes.descendants().slice(1));

    // Enter the links.
    link
      .enter()
      .insert('path', 'g')
      .attr('class', 'link')
      .style('opacity', 0)
      .attr('transform', () => `translate(${nodeWidth / 2} , ${12})`)
      .attr('d', (d: Node) => {
        return (
          'M' +
          d.y +
          ',' +
          d.x +
          'C' +
          (d.y + d.parent.y) / 2 +
          ',' +
          d.x +
          ' ' +
          (d.y + d.parent.y) / 2 +
          ',' +
          d.parent.x +
          ' ' +
          d.parent.y +
          ',' +
          d.parent.x
        );
      });

    // unhide
    const t = d3
      .transition()
      .delay(250)
      .duration(500)
      .ease(d3.easeLinear);

    d3.selectAll('.node')
      .transition(t)
      .style('opacity', (d: Node) => (d.data.root ? 0 : 1));

    d3.selectAll('.link')
      .transition(t)
      .style('opacity', (d: any) => (d.parent.data.root ? 0 : 1));

    return nodeWidth;
  }

  position(nodeWidth: number) {
    const x = -(nodeWidth + 10);
    const y = -30;

    this.svgGroup.transition().attr('transform', `translate(${x}, ${y})`);
  }
}

export default (node: HTMLDivElement, bracketTree: string) => {
  if (bracketTree === '[]') {
    node.innerHTML = '';
  } else {
    const bracketGraph = new BracketGraph(node);
    const tree = JSON.parse(bracketTree);
    bracketGraph.render(tree);
  }
};
