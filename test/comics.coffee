
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
