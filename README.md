# Hubot Tabelog

[![Build Status](https://travis-ci.org/dtaniwaki/hubot-tabelog.png)](https://travis-ci.org/dtaniwaki/hubot-tabelog)

Pick up a restaurant to go randomly

# Installation

* install this npm package to your hubot repo
    * `npm i --save hubot-tabelog`
* add `"hubot-tabelog"` to your `external-scripts.json`

# usage

* `hubot tabelog <lunch|dinner> for <keyword> in/at <area>`
* e.g. `hubot tabelog lunch for 焼肉 in 新宿`

You can omit any of those like the followings.

* `hubot tabelog`
* `hubot tabelog for <keyword>`
* `hubot tabelog in/at <area>`
