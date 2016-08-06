import d3 from 'd3'

class BracketVis {
  constructor(selector) {
    let $container = $(selector);
    $container.empty();

    this.maxLabelLength = 8;
    this.heightMultiplier = 100;
    this.spacingMultiplier = 8;
    this.widthMultiplier = 5;

    // size of the diagram
    this.viewerWidth = $container.width();
    this.viewerHeight = $container.height();

    this.tree = d3.layout.tree()
      .size([this.viewerHeight, this.viewerWidth]);

    // define a d3 diagonal projection for use by the node paths later on.
    this.diagonal = d3.svg.diagonal()
      .projection( (d) => { return [d.y, d.x] });

    this.zoomListener = d3.behavior.zoom().scaleExtent([0.1, 3]).on('zoom', this.zoom.bind(this));

    this.baseSvg = d3.select($container[0]).append('svg')
      .attr('width', this.viewerWidth)
      .attr('height', this.viewerHeight)
      .call(this.zoomListener);

    this.svgGroup = this.baseSvg.append('g');
  }

  render(bracket, bracketTree = null) {
    let treeData = {
      root: true,
      round: bracket.rounds,
      children: bracketTree || bracket.bracket_tree
    };

    this.update(treeData);
    this.center();
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

    this.treeHeight = d3.max(levelWidth) * this.heightMultiplier;
    this.tree = this.tree.size([this.treeHeight, this.viewerWidth]);

    // Compute the new tree layout.
    let nodes = this.tree.nodes(source).reverse();
    let links = this.tree.links(nodes);

    // compute maxLabelLength
    nodes.forEach( (d) => {
      this.maxLabelLength = _.max([
        d.home ? d.home.length : 0,
        d.away ? d.away.length : 0,
        this.maxLabelLength
      ])
    })

    let nodeWidth = this.maxLabelLength * this.widthMultiplier + 10;

    // Set horizantal position for each node
    nodes.forEach( (d) => {
      // alternatively to keep a fixed scale one can set a fixed depth per level
      // Normalize for fixed-depth by commenting out below line
      // d.y = (d.depth * 500); //500px per level.
      d.y = d.round * (this.maxLabelLength * this.spacingMultiplier);
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

    nodeEnter.append('rect')
      .attr('rx', 6)
      .attr('ry', 6)
      .attr('width', nodeWidth)
      .attr('height', 30)
      .style('fill', '#fff');

    nodeEnter.append('text')
      .attr('dy', 12)
      .attr('dx', 10)
      .attr('text-anchor', 'start')
      .text( (d) => { return d.home });

    nodeEnter.append('text')
      .attr("dy", 24)
      .attr('dx', 10)
      .text( (d) => { return d.away });


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
        return d.root || d.leaf ? 0 : 1
      });

    link.transition()
      .duration(750)
      .style('opacity', (d) => {
        return d.source.root || d.target.leaf ? 0 : 1
      });

    // calc treeWidth
    let linksWidth = source.round * (this.maxLabelLength * this.spacingMultiplier);
    let nodesWidth = source.round * nodeWidth;
    this.treeWidth = linksWidth + nodesWidth;
  }

  zoom() {
    this.svgGroup.attr('transform', `translate(${d3.event.translate}) scale(${d3.event.scale})`);
  }

  center() {
    let scale = this.viewerHeight / this.treeHeight;
    let x = this.viewerWidth * 0.5 - this.treeWidth * 0.5;
    let y = 0;

    this.svgGroup.transition()
      .attr('transform', `translate(${x}, ${y}) scale(${scale})`);

    this.zoomListener.scale(scale);
    this.zoomListener.translate([x, y]);
  }
}

module.exports = BracketVis;
