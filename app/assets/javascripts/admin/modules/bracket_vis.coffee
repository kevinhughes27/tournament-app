class Admin.BracketVis
  constructor: (container) ->
    $(container).empty()

    @totalNodes = 0
    @maxLabelLength = 0
    @panSpeed = 200
    @panBoundary = 20
    @duration = 750

    # size of the diagram
    @viewerWidth = $(container).width()
    @viewerHeight = $(container).height()

    @tree = d3.layout.tree()
      .size([@viewerHeight, @viewerWidth])

    # define a d3 diagonal projection for use by the node paths later on.
    @diagonal = d3.svg.diagonal()
      .projection( (d) ->
        return [d.y, d.x]
      )

    @zoomListener = d3.behavior.zoom().scaleExtent([0.1, 3]).on("zoom", @zoom)

    @baseSvg = d3.select(container).append("svg")
      .attr("width", @viewerWidth)
      .attr("height", @viewerHeight)
      .attr("class", "overlay")
      .call(@zoomListener)

    @svgGroup = @baseSvg.append("g")

  render: (bracket) ->
    treeData = {
      name: 'root',
      HTMLclass: 'hidden',
      children: UT.bracketToTree(bracket)
    }

    # Call visit function to establish
    # totalNodes and maxLabelLength
    @_visit(treeData,
      (d) => (
        @totalNodes = @totalNodes + 1
        @maxLabelLength = Math.max(d.name.length, @maxLabelLength)
      ),
      (d) => (
        if d.children && d.children.length > 0 then d.children else null
      )
    )

    root = treeData
    root.x0 = @viewerHeight / 2
    root.y0 = 0

    @update(root)
    @centerNode(root)

    #$('#bracketVisModal').on 'shown.bs.modal', (e) ->
      #vis.fit()

  # A recursive helper function for performing some setup by walking through all nodes
  _visit: (parent, visitFn, childrenFn) ->
    return unless parent
    visitFn(parent)
    children = childrenFn(parent)
    _.map(children, (c) => @_visit(c, visitFn, childrenFn))

  pan: (domNode, direction) =>
    speed = @panSpeed
    if (@panTimer)
      clearTimeout(@panTimer)

      translateCoords = d3.transform(@svgGroup.attr("transform"))
      if (direction == 'left' || direction == 'right')
        translateX = direction == 'left' ? translateCoords.translate[0] + speed : translateCoords.translate[0] - speed
        translateY = translateCoords.translate[1]
      else if (direction == 'up' || direction == 'down')
        translateX = translateCoords.translate[0]
        translateY = direction == 'up' ? translateCoords.translate[1] + speed : translateCoords.translate[1] - speed

      scaleX = translateCoords.scale[0]
      scaleY = translateCoords.scale[1]
      scale = @zoomListener.scale()
      @svgGroup.transition().attr("transform", "translate(" + translateX + "," + translateY + ")scale(" + scale + ")")
      d3.select(domNode).select('g.node').attr("transform", "translate(" + translateX + "," + translateY + ")")
      @zoomListener.scale(@zoomListener.scale())
      @zoomListener.translate([translateX, translateY])

      @panTimer = setTimeout ->
        pan(domNode, speed, direction)
      , 50

  zoom: =>
    @svgGroup.attr("transform", "translate(" + d3.event.translate + ")scale(" + d3.event.scale + ")")

  centerNode: (source) ->
    scale = @zoomListener.scale()
    x = -source.y0
    y = -source.x0
    x = x * scale + @viewerWidth / 2
    y = y * scale + @viewerHeight / 2

    d3.select('g').transition()
      .duration(@duration)
      .attr("transform", "translate(" + x + "," + y + ")scale(" + scale + ")")

    @zoomListener.scale(scale)
    @zoomListener.translate([x, y])

  update: (source) ->
    # Compute the new height, function counts total children of root node and sets tree height accordingly.
    # This prevents the layout looking squashed when new nodes are made visible or looking sparse when nodes are removed
    # This makes the layout more consistent.
    levelWidth = [1]
    i = 0
    childCount = (level, n) ->
      if (n.children && n.children.length > 0)
        levelWidth.push(0) if (levelWidth.length <= level + 1)
        levelWidth[level + 1] += n.children.length
        n.children.forEach( (d) ->
          childCount(level + 1, d)
        )

    childCount(0, source)

    newHeight = d3.max(levelWidth) * 25 # 25 pixels per line
    @tree = @tree.size([newHeight, @viewerWidth])

    # Compute the new tree layout.
    nodes = @tree.nodes(source).reverse()
    links = @tree.links(nodes)

    # Set widths between levels based on maxLabelLength.
    nodes.forEach( (d) =>
      d.y = -(d.depth * (@maxLabelLength * 10)) # maxLabelLength * 10px
      # alternatively to keep a fixed scale one can set a fixed depth per level
      # Normalize for fixed-depth by commenting out below line
      # d.y = (d.depth * 500); //500px per level.
    )

    # Update the nodes…
    node = @svgGroup.selectAll("g.node")
    .data(nodes, (d) ->
      return d.id || (d.id = ++i)
    )

    # Enter any new nodes at the parent's previous position.
    nodeEnter = node.enter().append("g")
    .attr("class", "node")
    .attr("transform", (d) ->
      return "translate(" + source.y0 + "," + source.x0 + ")"
    )

    nodeEnter.append("circle")
      .attr('class', 'nodeCircle')
      .attr("r", 0)
      .style("fill", (d) ->
        return if d._children then "lightsteelblue" else "#fff"
      )

    nodeEnter.append("text")
      .attr("dy", ".35em")
      .attr('class', 'nodeText')
      .text( (d) ->
        return d.name
      )
      .style("fill-opacity", 0);

    # Update the text to reflect whether node has children or not.
    node.select('text')
      .attr("x", -10)
      .attr("text-anchor", (d) ->
        return d.children || if d._children then "end" else "start"
      )
      .text( (d) ->
        return d.name
      )

    # Change the circle fill depending on whether it has children and is collapsed
    node.select("circle.nodeCircle")
      .attr("r", 4.5)
      .style("fill", (d) ->
        return if d._children then "lightsteelblue" else "#fff"
      )

    # Transition nodes to their new position.
    nodeUpdate = node.transition()
    .duration(@duration)
    .attr("transform", (d) ->
      return "translate(" + d.y + "," + d.x + ")"
    )

    # Fade the text in
    nodeUpdate.select("text")
      .style("fill-opacity", 1)

    # Update the links…
    link = @svgGroup.selectAll("path.link")
    .data(links, (d) ->
      return d.target.id
    )

    # Enter any new links at the parent's previous position.
    link.enter().insert("path", "g")
      .attr("class", "link")
      .attr("d", (d) =>
        o = {
          x: source.x0,
          y: source.y0
        }
        return @diagonal({
          source: o,
          target: o
        })
      )

    # Transition links to their new position.
    link.transition()
      .duration(@duration)
      .attr("d", @diagonal)
