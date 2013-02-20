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
