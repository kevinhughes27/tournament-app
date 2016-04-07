var disableAnimationStyles = 'transition-property: none !important;' +
                             '-o-transition-property: none !important;' +
                             '-moz-transition-property: none !important;' +
                             '-ms-transition-property: none !important;' +
                             '-webkit-transition-property: none !important;' +
                             'transform: none !important;' +
                             '-o-transform: none !important;' +
                             '-moz-transform: none !important;' +
                             '-ms-transform: none !important;' +
                             '-webkit-transform: none !important;' +
                             'animation: none !important;' +
                             '-o-animation: none !important;' +
                             '-moz-animation: none !important;' +
                             '-ms-animation: none !important;' +
                             '-webkit-animation: none !important;' +
                             'html.turbolinks-progress-bar::before {' +
                               'display: none; important!' +
                             '}'

window.onload = function() {
  var animationStyles = document.createElement('style');
  animationStyles.type = 'text/css';
  animationStyles.innerHTML = '* {' + disableAnimationStyles + '}';
  document.head.appendChild(animationStyles);
};
