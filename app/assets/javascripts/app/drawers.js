!(function () {
  'use strict';

  var eventDrawerOpen = new CustomEvent('drawerOpen', {
    bubbles: true,
    cancelable: true
  });

  var eventDrawerClose = new CustomEvent('drawerClose', {
    bubbles: true,
    cancelable: true
  });

  var findDrawers = function (target) {
    var i;
    var drawers = document.querySelectorAll('a');

    for (; target && target !== document; target = target.parentNode) {
      for (i = drawers.length; i--;) {
        if (drawers[i] === target) {
          return target;
        }
      }
    }
  };

  var getDrawer = function (event) {
    var drawerToggle = findDrawers(event.target);
    if (drawerToggle && drawerToggle.hash) {
      return document.querySelector(drawerToggle.hash);
    }
  };

  window.addEventListener('touchend', function (event) {
    var drawer = getDrawer(event);
    if (drawer && drawer.classList.contains('drawer')) {
      var eventToDispatch = eventDrawerOpen;
      if (drawer.classList.contains('active')) {
        eventToDispatch = eventDrawerClose;
      }
      drawer.dispatchEvent(eventToDispatch);
      drawer.classList.toggle('active');
    }
    event.preventDefault(); // prevents rewriting url (apps can still use hash values in url)
  });
}());
