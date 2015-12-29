Admin.Map = (center, zoom, editable = false) ->
  options = {
    center: center,
    zoom: zoom,
    doubleClickZoom: false
  }

  if editable
    options = _.extend(options, {
      editable: true,
      editOptions: {
        skipMiddleMarkers: true
      }
    })

  map = L.map('map', options)

  googleSat = L.tileLayer('http://{s}.google.com/vt/lyrs=s&x={x}&y={y}&z={z}', {
    maxZoom: 20,
    subdomains:['mt0','mt1','mt2','mt3']
  })

  map.addLayer(googleSat)

  return map
