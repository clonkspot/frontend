# Test helper

chai = require 'chai'
chai.should()

request = require 'supertest'
{app} = require '../app'
global.request = request(app)
