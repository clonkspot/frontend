# General data

module.exports =
  nav:
    blog:
      url: '/blog'
      width: 155
    forums:
      url: '/forum/forum.pl'
      width: 145
    community:
      url: '/community'
      width: 145
    development:
      url: '/development'
      width: 160
    play:
      width: 135
      sub:
        games: 
          url: '/games'
        league:
          url: '/league/'
    comic:
      url: '/comic'

  home: require './home'
  comics: require './comics'
