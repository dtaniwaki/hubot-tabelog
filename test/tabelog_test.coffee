chai   = require 'chai'
sinon  = require 'sinon'
chai.use require 'sinon-chai'

expect = chai.expect

describe 'tabelog', ->
  beforeEach ->
    @robot =
      respond: sinon.spy()

    require('../src/tabelog')(@robot)

  it 'respond to a message', ->
    # TODO: Add tests

