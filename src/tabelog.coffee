# Description:
#   Pick up a restaurant to go randomly
#
# Configuration:
#   HUBOT_TIMEZONE_OFFSET (optional)
#     timezone offset if you want to use a specific timezone
#
# Commands:
#   hubot tabelog (<lunch|dinner>) for <keyword> in <area> - pick up a restaurant with the keyword in the area
#
# Author:
#   dtaniwaki

_         = require 'underscore'
cheerio   = require 'cheerio'
request   = require 'request'

endpoint   = 'http://tabelog.com/rst/rstsearch'

timeOffset = process.env.HUBOT_TIMEZONE_OFFSET

module.exports = (robot) ->
  robot.respond /tabelog(:? (lunch|dinner))?( for [^ ]+)?( (:?in|at) [^ ]+)?$/i, (msg) ->
    type = undefined
    kw = undefined
    loc = undefined
    for s in msg.match
      if _.isString s
        if s.match /^ (lunch|dinner)/i
          type = RegExp.$1
          console.log 'type' + type
        else if s.match /^ for /i
          kw = s.slice(5)
          console.log 'kw: ' + kw
        else if s.match /^ in /i
          loc = s.slice(4)
          console.log 'loc: ' + loc

    params = []

    unless type
      d = new Date()
      h = d.getHours()
      if 12 < h and h < 14
        type = 'lunch'
      else if 17 < h and h < 22
        type = 'dinner'

    if type == 'lunch'
      params.push 'SrtT=rtl'
    else if type == 'dinner'
      params.push 'SrtT=rtd'
    else
      params.push 'SrtT=rt'
    
    if kw
      params.push 'sk=' + encodeURIComponent kw
    if loc
      params.push 'sa=' + encodeURIComponent loc

    findRestaurants endpoint + '?' + params.join('&'), (restaurants)->
      message = "I can't find any restaurant"
      if kw
        message += ' for ' + kw
      if loc
        message += ' in ' + loc
      restaurant = _.sample(restaurants, 1)[0]
      console.log restaurant
      if restaurant
        message = ''
        message += restaurant.image + "\n"
        message += restaurant.name
        if restaurant.stars? and restaurant.stars != '' and restaurant.score? and restaurant.score != ''
          message += ' (' + restaurant.stars + ' ' + restaurant.score + ')'
        message += ' ' + restaurant.link
      msg.reply message

findRestaurants = (url, callback) ->
  console.log "url: " + url
  request url, (error, response, body) ->
    if !error and response.statusCode is 200
      $ = cheerio.load body
      restaurants = $('.rstlst-group').map (idx, elem)->
        $restaurant = $(this)
        return {
          name: $restaurant.find('.mname a').text(),
          link: $restaurant.find('.mname a').attr('href'),
          image: $restaurant.find('.photoimg img').attr('src'),
          score: $restaurant.find('.score-overall .score').text(),
          stars: $restaurant.find('.score-overall .star').text(),
        }
      callback restaurants


