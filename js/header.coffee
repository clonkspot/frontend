# Header interaction

$ = window.jQuery

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

nav = ->
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

stream = ->
  # Check whether there's a stream running.
  checkStream = (streams) ->
    if streams?.length
      $('header .twitch')
        .slideDown()
        .find('a')
          .attr('href', streams[0].url)

  $.getJSON('/api/stream-notification/').then checkStream

main = ->
  nav()
  stream()

# Check if jQuery is available.
if $?
  main()
else
  head = document.getElementsByTagName('head')[0]
  script = document.createElement('script')
  script.src = 'https://clonkspot.org/js/jquery.js'
  script.onload = ->
    $ = window.jQuery
    main()
  head.appendChild(script)
