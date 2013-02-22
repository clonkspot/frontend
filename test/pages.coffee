# Basic request tests

request = require 'supertest'

{app} = require '../app'

request = request(app)

describe 'GET /', ->
  it 'should work', (done) ->
    request
      .get('/')
      .expect(200, done)

  describe 'language switching', ->
    it 'should default to English', (done) ->
      request
        .get('/')
        .expect(/lang="en"/, done)

    it 'should automatically detect German language settings', (done) ->
      request
        .get('/')
        .set('Accept-Language', 'de')
        .expect(/lang="de"/, done)

    it 'should use the first fitting language', (done) ->
      request
        .get('/')
        .set('Accept-Language', 'fr, en, de')
        .expect(/lang="en"/, done)

    it 'should allow overriding using the language cookie', (done) ->
      request
        .get('/')
        .set('Accept-Language', 'de')
        .set('cookie', 'language=en')
        .expect(/lang="en"/, done)

describe '404 page', ->
  it 'should show the page on unknown requests', (done) ->
    request
      .get('/sdjifeihakisdf')
      .expect(404)
      .expect(/This is not the page you are looking for/, done)

describe 'GET /impressum', ->
  it 'should work', (done) ->
    request
      .get('/impressum')
      .expect(200, /id="impressum"/, done)

describe 'Comics', ->
  comic = (id) -> ///\/images\/comics\/comic#{id}\.png///
  comics = require '../data/comics'
  describe 'GET /comic', ->
    it 'should show the latest comic', (done) ->
      request
        .get('/comic')
        .expect(200)
        .expect(comic comics.length)
        .end done
  describe 'GET /comic/:id', ->
    it 'should show the correct comic', (done) ->
      request
        .get('/comic/1')
        .expect(200)
        .expect(comic 1)
        .end done
    it 'should show the 404 page for the nonexisting comic 0', (done) ->
      request
        .get('/comic/0')
        .expect(404, done)
    it 'should show the 404 page for a nonexisting comic', (done) ->
      request
        .get('/comic/'+(comics.length+1))
        .expect(404, done)
    it 'should show the 404 page for an invalid comic id', (done) ->
      request
        .get('/comic/foobar')
        .expect(404, done)
