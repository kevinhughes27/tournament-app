@searchTimeout

$(document).on 'ready page:change', ->
  $('#search-form').on 'input', ->
    clearTimeout(@searchTimeout)

    @searchTimeout = setTimeout ->
      $('#search-form').submit()
    , 500

  $('#search-form').on 'submit', (ev) ->
    ev.preventDefault()
    $form = $(ev.target)

    Turbolinks.ProgressBar.start()

    $.ajax
      type: 'GET'
      url: $form.attr('action')
      data: $form.serialize()
      success: (response) ->
        Turbolinks.replace(response)
        Turbolinks.ProgressBar.done()

        $searchInput = $('#search-form').find('input#search')
        length = $searchInput.val().length * 2
        $searchInput.focus()
        $searchInput[0].setSelectionRange(length, length)
