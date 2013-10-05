# Index page

require ['jquery', 'layerslider', 'app/twitch'], ($) ->

  # Enable the LayerSlider
  ls = $('#layerslider').layerSlider
    responsive: off
    skin: 'noskin'
    animateFirstLayer: on
    slideDelay: 6000
