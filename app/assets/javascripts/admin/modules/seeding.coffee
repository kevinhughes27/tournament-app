class Admin.Seeding
  constructor: ->
    @rd = REDIPS.drag
    @rd.style.borderEnabled = 'none'
    @rd.init()
    @rd.rowDropMode = 'after'
    @rd.event.rowDropped = @rowDropped

  rowDropped: (row) =>
    table = $(row).closest('table')
    _.each(table.find('tr'), (tr, idx) ->
      $(tr).find('#seeds_').val(idx)
    )
