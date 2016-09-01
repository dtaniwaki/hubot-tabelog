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
'use strict'

_         = require 'underscore'
cheerio   = require 'cheerio'
request   = require 'request'

categories = require '../../data/categories.json'
areas = require '../../data/areas.json'

if proxy = process.env.HUBOT_TABELOG_PROXY
  console.log 'proxy: ' + proxy
  request = request.defaults {'proxy': proxy}

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

     if params.loc && !params.loc.match(/駅$/)
       params.loc += '駅'

     if params.kw && !categories[params.kw]?
       return msg.reply('Category ' + params.kw + ' does not exist. http://tabelog.com/cat_lst/')
     if params.loc && !areas[params.loc]?
       return msg.reply('Area ' + params.loc + ' does not exist.')

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
        messages = []
        messages.push restaurant.name
        if restaurant.stars? and restaurant.stars != '' and restaurant.score? and restaurant.score != ''
          messages.push restaurant.stars + ' ' + formatScore(restaurant.score)
        messages.push restaurant.link
        message = messages.join("\n")
      msg.send restaurant.image, message

  endpoint   = 'http://tabelog.com/'

  findRestaurants = (params, callback) ->
    # construct URL like this: http://tabelog.com/tokyo/A1304/A130401/R7443/rstLst/YC99/?RdoCosTp=2
    url = new String(endpoint)
    qs = []
    if params.type == 'lunch'
      qs.push 'RdoCosTp=1'
    else if params.type == 'dinner'
      qs.push 'RdoCosTp=2'
    if params.loc
      area = areas[params.loc]
      url += area.city + '/' + area.code1 + '/' + area.code2 + '/' + area.code3 + '/'
    url += 'rstLst/'
    if params.kw
      category = categories[params.kw]
      url += category.code + '/'

    url = url + '?' + qs.join('&')
    console.log "url: " + url
    request url, (error, response, body) ->
      if !error and response.statusCode is 200
        $ = cheerio.load body
        restaurants = $('.list-rst').map (idx, elem)->
          $restaurant = $(this)
          return {
            name: $restaurant.find('.list-rst__rst-name a').text(),
            link: $restaurant.find('.list-rst__rst-name a').attr('href'),
            image: $restaurant.find('.cpy-main-image').attr('data-original'),
            score: $restaurant.find('.list-rst__rating-val').text(),
            stars: $restaurant.find('.cpy-review-count').text(),
          }
        callback restaurants
      else
        console.log error

  formatScore = (str) ->
    score = ''
    f = parseFloat(str)
    i = Math.round(f)
    for j in [1..5]
      if i >= j
        score += '★'
      else
        score += '☆'
    return score

