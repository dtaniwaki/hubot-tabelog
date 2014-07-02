"use strict"

expect    = require("chai").expect
path      = require("path")
chai      = require("chai")
sinon     = require("sinon")
chai.use require("sinon-chai")

Robot       = require("hubot/src/robot")
TextMessage = require("hubot/src/message").TextMessage
process.env.HUBOT_LOG_LEVEL = 'debug'

describe 'tabelog', ->
  robot = null
  user = null
  adapter = null

  beforeEach (done)->
    robot = new Robot(null, "mock-adapter", false, "hubot")

    robot.adapter.on "connected", ->
      robot.loadFile path.resolve('.', 'src', 'scripts'), 'tabelog.coffee'

      # load help scripts to test help messages
      hubotScripts = path.resolve 'node_modules', 'hubot', 'src', 'scripts'
      robot.loadFile hubotScripts, 'help.coffee'
    
      user = robot.brain.userForId '1', {
        name: 'dtaniwaki'
        room: '#mocha'
      }
      adapter = robot.adapter

      # Wait until hubot is ready
      waitForHelp = ->
        if robot.helpCommands().length > 0
          do done
        else
          setTimeout waitForHelp, 100
      do waitForHelp
    do robot.run

  afterEach ->
    do robot.shutdown

  describe 'help', ->
    it 'has help messages', ->
      commands = robot.helpCommands()
      expect(commands).to.eql [
        "hubot help - Displays all of the help commands that Hubot knows about.",
        "hubot help <query> - Displays all help commands that match <query>.",
        "hubot tabelog (<lunch|dinner>) for <keyword> in <area> - pick up a restaurant with the keyword in the area"
      ]

  describe 'respond tabelog', ->
    it 'replies tabelog', (done)->
      adapter.on "send", (envelope, strings)->
        try
          expect(strings).to.have.length(2)
          expect(strings[0]).to.match /^http:\/\/.*\.jpg/
          expect(strings[1]).to.match /tabelog.com/
          do done
        catch e
          done e
      adapter.receive new TextMessage(user, "hubot tabelog")

    it 'reply tabelog', (done)->
      adapter.on "send", (envelope, strings)->
        try
          expect(strings).to.have.length(2)
          expect(strings[0]).to.match /^http:\/\/.*\.jpg/
          expect(strings[1]).to.match /tabelog.com/
          do done
        catch e
          done e
      adapter.receive new TextMessage(user, "hubot tabelog for ラーメン")

    it 'replies tabelog with location', (done)->
      adapter.on "send", (envelope, strings)->
        try
          expect(strings).to.have.length(2)
          expect(strings[0]).to.match /^http:\/\/.*\.jpg/
          expect(strings[1]).to.match /tabelog.com/
          do done
        catch e
          done e
      adapter.receive new TextMessage(user, "hubot tabelog in 東京")

