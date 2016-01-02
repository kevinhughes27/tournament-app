var big_image;

$(document).ready(function() {
  responsive = $(window).width();
  if (responsive >= 768) {
    big_image = $('.parallax-background').find('img');
    console.log(big_image);
    $(window).on('scroll', function () {
      parallax();
    });
  }
});

var parallax = function () {
  var current_scroll = $(this).scrollTop();

  oVal = ($(window).scrollTop() / 3);
  big_image.css('top', oVal);
};
