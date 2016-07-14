class Admin.BracketVis

  options: {
    container: "#bracketGraph",
    levelSeparation:    30,
    siblingSeparation:  15,
    subTeeSeparation:   15,
    rootOrientation: "EAST",
    hideRootNode: true,
    nodeAlign: "CENTER",
    scrollbar: "None",

    node: {
      collapsable: true
    },

    connectors: {
      type: "straight",
      style: {
        "stroke-width": 2,
        "stroke": "#ccc"
      }
    }
  },

  render: (bracket) ->
    options = @options
    nodes = UT.bracketToTree(bracket)

    vis = new Treant({
      chart: options,
      nodeStructure: {
        text: 'fake',
        children: nodes
      }
    })

    #$('#bracketVisModal').on 'shown.bs.modal', (e) ->
      #vis.fit()
