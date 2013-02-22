# Test helper

chai = require 'chai'
chai.should()

request = require 'supertest'
{app} = require '../app'
GLOBAL.request = request(app)
