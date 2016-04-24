window.UT ||= {}

UT.Map = (center, zoom, options = {}, editable = false) ->
  options = _.extend(options, {
    center: center,
    zoom: zoom,
    doubleClickZoom: false,
    attributionControl: false
  })

  if editable
    options = _.extend(options, {
      editable: true,
      editOptions: {
        skipMiddleMarkers: true
      }
    })

  map = L.map('_map', options)

  googleSat = L.tileLayer('https://{s}.google.com/vt/lyrs=s&x={x}&y={y}&z={z}', {
    maxZoom: 20,
    subdomains:['mt0','mt1','mt2','mt3']
  })

  map.addLayer(googleSat)

  return map
