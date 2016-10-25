import d3 from 'd3'
import _max from 'lodash/max';
import inflection from 'inflection';
let ordinalize = inflection.ordinalize;

const HeightMultiplier = 120;
const NodeSpacing = 20;

class BracketVis {
  constructor($container) {
    // empty the container
    $container.empty();

    // size of the diagram
    this.viewerWidth = $container.width();
    this.viewerHeight = $container.height();

    // create the tree
    this.tree = d3.layout.tree()
      .size([this.viewerHeight, this.viewerWidth]);

    // define a d3 diagonal projection for use by the node paths later on.
    this.diagonal = d3.svg.diagonal()
      .projection( (d) => { return [d.y, d.x] });

    // attach zoomListener
    this.zoomListener = d3.behavior.zoom()
      .scaleExtent([0.1, 3])
      .on('zoom', this.zoom.bind(this));

    // create the baseSvg
    this.baseSvg = d3.select($container[0]).append('svg')
      .attr('width', this.viewerWidth)
      .attr('height', this.viewerHeight)
      .attr('cursor', 'pointer')
      .call(this.zoomListener);

    // add an inner svg to allow for pan and zoom
    this.svgGroup = this.baseSvg.append('g');
  }

  render(bracket, bracketTree = null) {
    let treeData = {
      root: true,
      round: bracket.rounds,
      children: bracketTree || bracket.bracket_tree
    };

    let nodeWidth = this.update(treeData);
    this.position(nodeWidth);
  }

  update(source) {
    // Compute the tree height
    let levelWidth = [1];
    let childCount = function (level, n) {
      if (n.children && n.children.length > 0) {
        if (levelWidth.length <= level + 1) { levelWidth.push(0) }
        levelWidth[level + 1] += n.children.length;
        n.children.forEach( (d) => {
          childCount(level + 1, d);
        });
      }
    }
    childCount(0, source);

    this.treeHeight = d3.max(levelWidth) * HeightMultiplier;
    this.tree = this.tree.size([this.treeHeight, this.viewerWidth]);

    // Compute the new tree layout.
    let nodes = this.tree.nodes(source).reverse();
    let links = this.tree.links(nodes);

    // compute maxLabelLength
    this.maxLabelLength = 0;
    nodes.forEach( (d) => {
      this.maxLabelLength = _max([
        d.home ? d.home.length : 0,
        d.away ? d.away.length : 0,
        this.maxLabelLength
      ])
    })

    // compute the nodeWidth
    let nodeWidth = (this.maxLabelLength * 5) + 20;

    // Set horizantal position for each node
    nodes.forEach( (d) => {
      d.y = d.round * (nodeWidth + NodeSpacing);
    });

    // Declare the nodes…
    let i = 0;
    let node = this.svgGroup.selectAll('g.node')
      .data(nodes, (d) => { return d.id || (d.id = ++i) });

    // Enter the nodes.
    let nodeEnter = node.enter().append('g')
      .attr('class', 'node')
      .attr('transform', (d) => {
        return `translate(${d.y} , ${d.x})`;
      })
      .style('opacity', 0);

    // game rect
    nodeEnter.append('rect')
      .attr('rx', 6)
      .attr('ry', 6)
      .attr('width', nodeWidth)
      .attr('height', 30)
      .style('fill', '#fff');

    // home text
    nodeEnter.append('text')
      .attr('dy', 12)
      .attr('dx', 8)
      .attr('text-anchor', 'start')
      .text( (d) => { return d.home });

    // away text
    nodeEnter.append('text')
      .attr('dy', 24)
      .attr('dx', 8)
      .text( (d) => { return d.away });

    // place text
    nodeEnter.append('text')
      .attr('dy', 18)
      .attr('dx', nodeWidth + 10)
      .attr('font-weight', 'bold')
      .text( (d) => {
        if (d.parent && d.parent.root) ordinalize(d.uid);
      });

    // uid text
    nodeEnter.append('text')
      .attr('dy', -6)
      .attr('dx', nodeWidth/2 - 4)
      .attr('font-weight', 'bold')
      .text( (d) => {
        if (!(d.parent && d.parent.root)) return d.uid;
      });

    // Declare the links…
    let link = this.svgGroup.selectAll('path.link')
      .data(links, (d) => { return d.target.id });

    // Enter the links.
    link.enter().insert('path', 'g')
      .attr('class', 'link')
      .attr('d', this.diagonal)
      .attr('transform', (d) => {
        return `translate(${nodeWidth/2} , ${12})`;
      })
      .style('opacity', 0);

    // unhide
    node.transition()
      .duration(750)
      .style('opacity', (d) => {
        return d.root ? 0 : 1
      });

    link.transition()
      .duration(750)
      .style('opacity', (d) => {
        return d.source.root ? 0 : 1
      });

    return nodeWidth;
  }

  zoom() {
    let transformString = `translate(${d3.event.translate}) scale(${d3.event.scale})`;
    this.svgGroup.attr('transform', transformString);
  }

  position(nodeWidth) {
    let x = -(nodeWidth+10);
    let y = -30;
  //let scale = this.viewerHeight / this.treeHeight;

    this.svgGroup.transition()
      .attr('transform', `translate(${x}, ${y})`);
    //.attr('transform', `scale(${scale})`);

    this.zoomListener.translate([x, y]);
  }
}

module.exports = BracketVis;
