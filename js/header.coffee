# Header interaction

showhide = ->
  showid = null
  hideid = null
  show = ->
    el = $(@).addClass('active').removeClass('active-anim')
    showid = setTimeout (-> el.addClass('active-anim')), 20
    clearTimeout hideid

  hide = ->
    el = $(@).removeClass 'active-anim'
    hideid = setTimeout (-> el.removeClass('active')), 400
    clearTimeout showid

  [show, hide]

$('nav .headeritem').each ->
  sub = $(@).children('.sub')
  if sub.children().length
    [show, hide] = showhide()
    $(@)
      .hover(show, hide)
      .on 'touchstart', (e) ->
        return if $(e.target).parents('.sub').length
        show.call(this)
        e.preventDefault()
