import d3 from 'd3';
import { max } from 'lodash';
import inflection from 'inflection';

const ordinalize = inflection.ordinalize;

const HeightMultiplier = 120;
const NodeSpacing = 20;

interface Node {
  id: number;
  uid: string;
  x: number;
  y: number;
  root: boolean;
  parent: any;
  home: string;
  away: string;
  round: number;
}

class BracketGraph {
  viewerWidth: number;
  viewerHeight: number;
  tree: any;
  diagonal: any;
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
    this.tree = d3.layout.tree().size([this.viewerHeight, this.viewerWidth]);

    // define a d3 diagonal projection for use by the node paths later on.
    this.diagonal = d3.svg.diagonal().projection((d: Node) => [d.y, d.x]);

    // attach zoomListener
    this.zoomListener = d3.behavior
      .zoom()
      .scaleExtent([0.1, 3])
      .on('zoom', this.zoom.bind(this));

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
    const nodes = this.tree.nodes(source).reverse();
    const links = this.tree.links(nodes);

    // compute maxLabelLength
    this.maxLabelLength = 0;
    nodes.forEach((d: Node) => {
      this.maxLabelLength = max([
        d.home ? d.home.length : 0,
        d.away ? d.away.length : 0,
        this.maxLabelLength
      ]);
    });

    // compute the nodeWidth
    const nodeWidth = this.maxLabelLength * 5 + 20;

    // Set horizantal position for each node
    nodes.forEach((d: Node) => {
      d.y = d.round * (nodeWidth + NodeSpacing);
    });

    // Declare the nodes…
    let i = 0;
    const node = this.svgGroup
      .selectAll('g.node')
      .data(nodes, (d: Node) => d.id || (d.id = ++i));

    // Enter the nodes.
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
      .text((d: Node) => d.home);

    // away text
    nodeEnter
      .append('text')
      .attr('dy', 24)
      .attr('dx', 8)
      .text((d: Node) => d.away);

    // place text
    nodeEnter
      .append('text')
      .attr('dy', 18)
      .attr('dx', nodeWidth + 10)
      .attr('font-weight', 'bold')
      .text((d: Node) => {
        if (d.parent && d.parent.root) {
          return ordinalize(d.uid);
        }
      });

    // uid text
    nodeEnter
      .append('text')
      .attr('dy', -6)
      .attr('dx', nodeWidth / 2 - 4)
      .attr('font-weight', 'bold')
      .text((d: Node) => {
        if (!(d.parent && d.parent.root)) {
          return d.uid;
        } else {
          return '';
        }
      });

    // Declare the links…
    const link = this.svgGroup
      .selectAll('path.link')
      .data(links, (d: any) => d.target.id);

    // Enter the links.
    link
      .enter()
      .insert('path', 'g')
      .attr('class', 'link')
      .attr('d', this.diagonal)
      .attr('transform', ({  }: Node) => `translate(${nodeWidth / 2} , ${12})`)
      .style('opacity', 0);

    // unhide
    node
      .transition()
      .duration(750)
      .style('opacity', (d: Node) => (d.root ? 0 : 1));

    link
      .transition()
      .duration(750)
      .style('opacity', (d: any) => (d.source.root ? 0 : 1));

    return nodeWidth;
  }

  zoom() {
    const transformString = `translate(${d3.event.translate}) scale(${
      d3.event.scale
    })`;
    this.svgGroup.attr('transform', transformString);
  }

  position(nodeWidth: number) {
    const x = -(nodeWidth + 10);
    const y = -30;
    // const scale = this.viewerHeight / this.treeHeight

    this.svgGroup.transition().attr('transform', `translate(${x}, ${y})`);
    // .attr("transform", `scale(${scale})`)

    this.zoomListener.translate([x, y]);
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
