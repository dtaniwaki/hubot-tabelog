chai   = require 'chai'
sinon  = require 'sinon'
chai.use require 'sinon-chai'

expect = chai.expect

describe 'tabelog', ->
  beforeEach ->
    @robot =
      respond: sinon.spy()

    require('../src/tabelog')(@robot)

  # TODO: Add tests
  # it 'respond to a message', ->
  #   expect(@robot.respond).to.have.been.calledWith(/tabelog for/)

