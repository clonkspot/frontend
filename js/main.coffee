# RequireJS configuration.

require.config
  baseUrl: '/js'

  paths:
    jquery: 'lib/jquery/jquery'
    'jquery-easing': 'lib/jquery-easing/index'
    layerslider: '../layerslider/js/layerslider.kreaturamedia.jquery'

  shim:
    'jquery-easing': ['jquery']
    layerslider: ['jquery', 'jquery-easing']

