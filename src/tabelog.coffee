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

module.exports = (robot) ->
  robot.respond /tabelog(:? (lunch|dinner))?( for [^ ]+)?( (:?in|at) [^ ]+)?$/i, (msg) ->
    params = {}
    for s in msg.match
      if _.isString s
        if s.match /^ (lunch|dinner)/i
          params.type = RegExp.$1
          console.log 'type: ' + params.type
        else if s.match /^ for /i
          params.kw = s.slice(5)
          console.log 'kw: ' + params.kw
        else if s.match /^ in /i
          params.loc = s.slice(4)
          console.log 'loc: ' + params.loc

    unless params.type
      d = new Date()
      h = d.getHours()
      if 12 < h and h < 14
        params.type = 'lunch'
      else if 17 < h and h < 22
        params.type = 'dinner'

    findRestaurants params, (restaurants)->
      message = "I can't find any restaurant"
      if params.kw
        message += ' for ' + params.kw
      if params.loc
        message += ' in ' + params.loc
      restaurant = _.sample(restaurants, 1)[0]
      console.log restaurant
      if restaurant
        msg.send restaurant.image
        messages = []
        messages.push restaurant.name
        if restaurant.stars? and restaurant.stars != '' and restaurant.score? and restaurant.score != ''
          messages.push restaurant.stars + ' ' + restaurant.score
        messages.push restaurant.link
        message = messages.join("\n")
      msg.send message

  endpoint   = 'http://tabelog.com/rst/rstsearch'

  findRestaurants = (params, callback) ->
    qs = []
    if params.type == 'lunch'
      qs.push 'SrtT=rtl'
    else if params.type == 'dinner'
      qs.push 'SrtT=rtd'
    else
      qs.push 'SrtT=rt'
    if params.kw
      qs.push 'sk=' + encodeURIComponent params.kw
    if params.loc
      qs.push 'sa=' + encodeURIComponent params.loc

    url = endpoint + '?' + qs.join('&')
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

