# Header interaction

setTimeout ->
  toggle = ->
    $(@).toggleClass 'active'

  $('nav .headeritem').each ->
    as = $(@).children()
    if as.length > 1
      $(@).hover(toggle, toggle)
, 1

