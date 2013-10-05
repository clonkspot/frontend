# RequireJS configuration.

require.config
  baseUrl: '/js'

  paths:
    jquery: 'bower_components/jquery/jquery'
    'jquery-easing': 'bower_components/jquery-easing/index'
    layerslider: '../layerslider/js/layerslider.kreaturamedia.jquery'

  shim:
    'jquery-easing': ['jquery']
    layerslider: ['jquery', 'jquery-easing']

