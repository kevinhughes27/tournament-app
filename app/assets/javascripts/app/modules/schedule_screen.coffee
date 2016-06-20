class App.ScheduleScreen

  constructor: (@app) ->
    @active = false

  show: ->
    @active = true
    location.hash = "schedule"
    # unless @scheduleScrolled
    #   # only run this once. then remember the users scroll
    #   @scheduleScrolled = true
    #
    #   # ensure scroll has run at least once so scroll buffer is resolved
    #   nodes = $('.divider-container')
    #   @_scrollSchedule(nodes[0])
    #
    #   nowNode = _.find(nodes, (node) ->
    #     timeString = $(node).find('.divider-time').data('time')
    #     moment.utc() < moment.utc(timeString).add(@app.timeCap, 'minutes')
    #   )
    #
    #   @_scrollSchedule(nowNode)
    Twine.refresh()

  # _scrollSchedule: (node) ->
  #   $('.left-screen > .content').scrollTo(node).offset({top: 88}) # 2 x $bar-base-height

  close: ->
    @active = false
    location.hash = ""
    Twine.refresh()

  searchChange: (event)->
    @lastSearch = $.trim( $(event.target).val() )
    Twine.refresh()

  filter: (teamNames) ->
    teamNames = teamNames.join(',') if $.isArray(teamNames)

    if @lastSearch
      teamNames.match("#{@lastSearch} vs") ||
      teamNames.match("vs #{@lastSearch},") ||
      teamNames.endsWith("vs #{@lastSearch}")
    else
      true

  findField: (fieldName) ->
    if field = _.find(@app.fields, (field) -> field.name is fieldName)
      @app.findText = "#{field.name}"
      @app.pointToField(field)

    @close()
