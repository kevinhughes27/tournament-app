@searchTimeout

$(document).on 'ready turbolinks:load', ->

  $searchInput = $('#search-form').find('input#search')
  if $searchInput.length == 1
    length = $searchInput.val().length * 2
    $searchInput.focus()
    $searchInput[0].setSelectionRange(length, length)

  $('#search-form').on 'input', ->
    clearTimeout(@searchTimeout)

    @searchTimeout = setTimeout ->
      $('#search-form').submit()
    , 500
