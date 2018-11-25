var big_image = null;

$(document).ready(function() {
  var responsive = $(window).width();

  if (responsive >= 768) {
    big_image = $('.parallax-background').find('img');

    $(window).on('scroll', function() {
      parallax();
    });
  }
});

var parallax = function() {
  oVal = $(window).scrollTop() / 3;
  big_image.css('background-position-y', oVal);
};
