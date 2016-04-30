window.React = require('react');
window.ReactDOM = require('react-dom');

function mount(node) {
  return $('[data-react-class]', node).each(function() {
    const propsString = this.getAttribute('data-react-props');
    const props = propsString && JSON.parse(propsString);
    return ReactDOM.render(React.createElement(eval.call(window, this.getAttribute('data-react-class')), props), this);
  });
};

function unmount (node) {
  return $('[data-react-class]', node).each(function() {
    return ReactDOM.unmountComponentAtNode(this);
  });
};

document.addEventListener('DOMContentLoaded', function() {
  return mount(document);
});

document.addEventListener('turbolinks:load', function(event) {
  return mount(document);
});
