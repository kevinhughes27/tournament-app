big_image = null

$(document).ready ->
  responsive = $(window).width()
  if responsive >= 768
    big_image = $('.parallax-background').find('img')
    $(window).on 'scroll', ->
      parallax()

parallax = ->
  oVal = $(window).scrollTop() / 3
  big_image.css('background-position-y', oVal)
