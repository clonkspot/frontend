/* Angular News Application */

angular.module('clonkspotNewsApp', [])
  .constant('language', document.documentElement.lang)
  .constant('dpd', '/dpd')

  .factory('Authenticator', ['$rootScope', '$http', 'dpd', function($rootScope, $http, dpd) {
    var auth =  {
      // Check for authentication.
      check: function() {
        $http.get(dpd+'/users/me').success(function(result) {
          $rootScope.me = auth.me = result
        })
      },
      login: function(credentials) {
        $http.post(dpd+'/users/login', credentials)
          .success(function(result) {
            $rootScope.me = auth.me = result
          })
          .error(function(error) {
            alert('Could not log in: ' + error.message)
          })
      },
      logout: function() {
        $http.post(dpd+'/users/logout')
          .success(function() {
            $rootScope.me = auth.me = null
          })
          .error(function(error) {
            alert('Could not log out: ' + error.message)
          })
      }
    }
    return auth
  }])

  .factory('News', ['$http', 'Authenticator', 'language', 'dpd', function($http, Authenticator, language, dpd) {
    return {
      // Requests four news items.
      get: function() {
        return $http.get(dpd+'/news?' + JSON.stringify({lang: language, $limit: 4, $sort: {date: -1}}))
      },
      // Saves the given news item.
      post: function(item) {
        return $http.post(dpd+'/news', item)
      },
      // Returns a new news item with some default values.
      create: function() {
        return {
          author: Authenticator.me ? Authenticator.me.username : '',
          date: new Date().toISOString().slice(0, 10),
          lang: language
        }
      }
    }
  }])

  .run(['Authenticator', function(Authenticator) {
    Authenticator.check()
  }])

  .controller('NewsCtrl', ['$scope', 'News', 'Authenticator', function($scope, News, Authenticator) {
    // Load the news from the server.
    News.get().success(function(news) {
        $scope.news = news
      })

    // Whether the admin view or the slider is shown.
    $scope.adminView = false

    // Logout
    $scope.logout = Authenticator.logout

    // The item that is being edited.
    $scope.editItem = 1

    // Change above item.
    $scope.changeEditItem = function(to) {
      $scope.editItem = to
    }

    // Adds another news item on top.
    $scope.addItem = function(item) {
      var n = $scope.news.slice(0, 3)
      n.unshift(item || News.create())
      $scope.news = n
    }

    // Save the edited news items on the server.
    $scope.updateNewsItems = function() {
      $scope.news.forEach(function(item, index) {
        News.post(item)
          .success(function(result) {
            $scope.news[index] = result
          })
          .error(function(error) {
            alert('There was an error while saving: ' + error.message)
          })
      })
    }
  }])

  .controller('LoginCtrl', ['$scope', 'Authenticator', function($scope, Authenticator) {
    $scope.login = {}
    $scope.authenticate = Authenticator.login
  }])

  .factory('ImportYouTube', ['$http', 'language', function($http, language) {
    function ImportYouTube(playlist) {
      this.playlist = playlist
      this.items = []
    }

    ImportYouTube.prototype.name = 'YouTube'
    ImportYouTube.prototype.getItems = function() {
      var self = this
      $http.jsonp('http://gdata.youtube.com/feeds/api/playlists/' + this.playlist + '?alt=json&callback=JSON_CALLBACK')
        .success(function(videos) {
          // Transform videos.
          self.items = videos.feed.entry.map(function(video) {
            return {
              title: video.title.$t,
              author: 'Nachtfalter',
              link: video.link[0].href,
              date: video.published.$t.slice(0, 10),
              type: 'youtube',
              lang: language
            }
          })
        })
    }
    return ImportYouTube
  }])
  .factory('ImportAtom', ['$http', 'language', function($http, language) {
    function ImportAtom(name, type, feed) {
      this.name = name
      this.type = type
      this.feed = feed
      this.items = []
    }

    ImportAtom.prototype.name = 'Atom Feed'
    ImportAtom.prototype.type = 'newpost'
    ImportAtom.prototype.url = function() {
      return "http://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20xml%20where%20url%3D'" + encodeURIComponent(this.feed) + "'%20and%20itemPath%3D'feed.entry'&format=json&callback=JSON_CALLBACK"
    }
    ImportAtom.prototype.getItems = function() {
      var self = this
      $http.jsonp(this.url())
        .success(function(feed) {
          // Transform videos.
          self.items = feed.query.results.entry.map(function(entry) {
            return {
              title: entry.title.content,
              author: entry.author.name,
              link: entry.link[0].href,
              date: entry.published.slice(0, 10),
              type: self.type,
              lang: language
            }
          })
        })
    }
    return ImportAtom
  }])
  .factory('ImportSites', ['ImportYouTube', 'ImportAtom', 'language', function(ImportYouTube, ImportAtom, language) {
    var youtubeList = language == 'de' ? 'PLigNApmAXiiRp69Gw_2U1MN1vhiYLdkQH' : 'PLigNApmAXiiTBM7vXR0hwyBV2o61lqj0S'
    return {
      youtube: new ImportYouTube(youtubeList),
      blog: new ImportAtom('Blog', 'blog', 'http://clonkspot.org/blog/feed/atom/')
    }
  }])
  .controller('ImportCtrl', ['$scope', 'ImportSites', function($scope, ImportSites) {
    $scope.importSites = ImportSites
    $scope.selected = function(site) {
      // Load the selected site's items.
      ImportSites[site].getItems()
    }
  }])

  // Toggles a variable when pressing a certain key combination.
  .directive('keyToggle', function() {
    return function(scope, element, attrs) {
      var keys = attrs.keys.split('+'),
          toggle = attrs.keyToggle
      angular.element(document).bind('keydown', function(event) {
        for (var i = 0; i < keys.length; i++) {
          if (keys[i].charCodeAt() != event.which && !event[keys[i].toLowerCase()+'Key']) {
            return;
          }
        }
        scope[toggle] = !scope[toggle]
        scope.$apply()
      })
    }
  })
