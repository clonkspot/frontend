(function() {
  require(['jquery', 'layerslider', 'app/twitch'], function($) {
    var ls;
    return ls = $('#layerslider').layerSlider({
      responsive: false,
      skin: 'noskin',
      animateFirstLayer: true,
      slideDelay: 6000
    });
  });

}).call(this);
