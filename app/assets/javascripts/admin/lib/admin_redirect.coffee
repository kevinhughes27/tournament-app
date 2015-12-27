Admin.Redirect = (subPath)->
  tournament = window.location.pathname.split('/')[1]
  Turbolinks.visit("/#{tournament}/admin/#{subPath}")
