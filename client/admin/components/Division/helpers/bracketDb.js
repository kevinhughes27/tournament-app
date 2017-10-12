module.exports = function load (handle, cb) {
  $.get({
    url: '/admin/bracket',
    data: {handle: handle},
    success: cb
  })
}
