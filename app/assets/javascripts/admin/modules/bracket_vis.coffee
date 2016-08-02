class Admin.BracketVis
  constructor: (selector) ->
    $container = $(selector)
    $container.empty()

    @maxLabelLength = 3
    @panSpeed = 200

    @heightMultiplier = 60
    @widthMultiplier = 15

    # size of the diagram
    @viewerWidth = $container.width()
    @viewerHeight = $container.height()

    @tree = d3.layout.tree()
      .size([@viewerHeight, @viewerWidth])

    # define a d3 diagonal projection for use by the node paths later on.
    @diagonal = d3.svg.diagonal()
      .projection( (d) -> [d.y, d.x] )

    @zoomListener = d3.behavior.zoom().scaleExtent([0.1, 3]).on('zoom', @zoom)

    @baseSvg = d3.select($container[0]).append('svg')
      .attr('width', @viewerWidth)
      .attr('height', @viewerHeight)
      .call(@zoomListener)

    @svgGroup = @baseSvg.append('g')

  render: (bracket, bracketTree = null) ->
    treeData = {
      name: 'root',
      children: bracketTree || bracket.bracket_tree
    }

    @update(treeData)
    @center()

  update: (source) ->
    # Compute the tree height
    levelWidth = [1]
    childCount = (level, n) ->
      if (n.children && n.children.length > 0)
        levelWidth.push(0) if (levelWidth.length <= level + 1)
        levelWidth[level + 1] += n.children.length
        n.children.forEach( (d) ->
          childCount(level + 1, d)
        )
    childCount(0, source)

    @treeHeight = d3.max(levelWidth) * @heightMultiplier
    @tree = @tree.size([@treeHeight, @viewerWidth])

    # Compute the new tree layout.
    nodes = @tree.nodes(source).reverse()
    links = @tree.links(nodes)

    # Set widths between levels based on maxLabelLength.
    @treeWidth = 0
    nodes.forEach( (d) =>
      d.y = -(d.depth * (@maxLabelLength * @widthMultiplier))
      # alternatively to keep a fixed scale one can set a fixed depth per level
      # Normalize for fixed-depth by commenting out below line
      # d.y = (d.depth * 500); //500px per level.
      @treeWidth = _.max([@treeWidth, -1*d.y])
    )

    # Declare the nodes…
    i = 0
    node = @svgGroup.selectAll('g.node')
      .data(nodes, (d) -> d.id || (d.id = ++i))

    # Enter the nodes.
    nodeEnter = node.enter().append('g')
      .attr('class', 'node')
      .attr('transform', (d) ->
        "translate(#{d.y} , #{d.x})"
      )
      .style('opacity', 0)

    nodeEnter.append('circle')
      .attr('class', 'nodeCircle')
      .attr('r', 10)
      .style('fill', '#fff')

    nodeEnter.append('text')
      .attr('class', 'nodeText')
      .attr('dy', '.35em')
      .text( (d) -> d.name )
      .attr('text-anchor', 'middle')

    # Declare the links…
    link = @svgGroup.selectAll('path.link')
      .data(links, (d) -> d.target.id )

    # Enter the links.
    link.enter().insert('path', 'g')
      .attr('class', 'link')
      .attr('d', @diagonal)
      .style('opacity', 0)

    # unhide
    node.transition()
      .duration(750)
      .style('opacity', (d) ->
        if d.name == 'root' then 0 else 1
      )

    link.transition()
      .duration(750)
      .style('opacity', (d) ->
        if d.source.name == 'root' then 0 else 1
      )

  pan: (domNode, direction) =>
    speed = @panSpeed

    if (@panTimer)
      clearTimeout(@panTimer)

      translateCoords = d3.transform(@svgGroup.attr('transform'))
      if (direction == 'left' || direction == 'right')
        translateX = direction == 'left' ? translateCoords.translate[0] + speed : translateCoords.translate[0] - speed
        translateY = translateCoords.translate[1]
      else if (direction == 'up' || direction == 'down')
        translateX = translateCoords.translate[0]
        translateY = direction == 'up' ? translateCoords.translate[1] + speed : translateCoords.translate[1] - speed

      scaleX = translateCoords.scale[0]
      scaleY = translateCoords.scale[1]
      scale = @zoomListener.scale()

      @svgGroup.transition().attr('transform', "translate(#{translateX}, #{translateY}) scale(#{scale})")
      d3.select(domNode).select('g.node').attr("transform", "translate(#{translateX}, #{translateY})")

      @zoomListener.scale(@zoomListener.scale())
      @zoomListener.translate([translateX, translateY])

      @panTimer = setTimeout ->
        pan(domNode, speed, direction)
      , 50

  zoom: =>
    @svgGroup.attr('transform', "translate(#{d3.event.translate}) scale(#{d3.event.scale})")

  center: ->
    scale = @viewerHeight / @treeHeight
    x = @treeWidth * 0.5 + @viewerWidth * 0.5
    y = 0

    @svgGroup.transition()
      .attr('transform', "translate(#{x}, #{y}) scale(#{scale})")

    @zoomListener.scale(scale)
    @zoomListener.translate([x, y])
