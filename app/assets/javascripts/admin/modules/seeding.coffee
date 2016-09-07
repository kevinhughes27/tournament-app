class Admin.Seeding
  constructor: ->
    @rd = REDIPS.drag
    @rd.style.borderEnabled = 'none'
    @rd.init()
    @rd.rowDropMode = 'after'
    @rd.event.rowDropped = @rowDropped

  rowDropped: (row) =>
    table = $(row).closest('table')
    (table.find('tr').forEach(tr, idx) ->
      $(tr).find('#seeds_').val(idx)
    )
