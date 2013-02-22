
describe 'Comics', ->
  # Matches the comic image path
  comic = (id) -> ///\/images\/comics\/comic#{id}\.png///
  comics = require '../data/comics'

  describe 'GET /comic', ->
    it 'should show the latest comic', (done) ->
      request
        .get('/comic')
        .expect(200)
        .expect(comic comics.length)
        .end done

    describe 'Archive', ->
      it 'should exist', (done) ->
        request.get('/comic')
          .expect(200, /Archive/, done)
      it 'should contain all comics', (done) ->
        request.get('/comic')
          .end (err, res) ->
            throw err if err
            for c in comics
              res.text.should.contain c
            done()

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

  describe 'GET /comic/random', ->
    it 'should redirect to a comic', (done) ->
      request.get('/comic/random')
        .expect(302)
        .expect('Location', /\/comic\/\d+/)
        .end done
