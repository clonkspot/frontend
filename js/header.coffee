# Header interaction

showhide = ->
  showid = null
  hideid = null
  show = ->
    el = $(@).addClass('open').removeClass('open-anim')
    showid = setTimeout (-> el.addClass('open-anim')), 20
    clearTimeout hideid

  hide = ->
    el = $(@).removeClass 'open-anim'
    hideid = setTimeout (-> el.removeClass('open')), 400
    clearTimeout showid

  [show, hide]

$('nav .headeritem').each ->
  sub = $(@).children('.sub')
  if sub.children().length
    if sub.find('.active').length
      $(@).addClass('open open-anim')
      return

    [show, hide] = showhide()
    $(@)
      .hover(show, hide)
      .on 'touchstart', (e) ->
        return if $(e.target).parents('.sub').length
        show.call(this)
        e.preventDefault()
