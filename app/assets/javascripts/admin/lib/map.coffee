Admin.Map = (center, zoom, editable = false) ->
  map = L.map('map', {
    center: center,
    zoom: zoom,
    editable: editable
  })

  googleSat = L.tileLayer('http://{s}.google.com/vt/lyrs=s&x={x}&y={y}&z={z}', {
    maxZoom: 20,
    subdomains:['mt0','mt1','mt2','mt3']
  })

  map.addLayer(googleSat)

  return map
