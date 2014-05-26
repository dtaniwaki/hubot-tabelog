# Hubot Tabelog

[![NPM version](https://badge.fury.io/js/hubot-tabelog.svg)](http://badge.fury.io/js/hubot-tabelog) [![Build Status](https://travis-ci.org/dtaniwaki/hubot-tabelog.png)](https://travis-ci.org/dtaniwaki/hubot-tabelog) [![Coverage Status](https://coveralls.io/repos/dtaniwaki/hubot-tabelog/badge.png?branch=master)](https://coveralls.io/r/dtaniwaki/hubot-tabelog?branch=master)

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

# Configuration

You can set some environment variables for hubot-tabelog.

### `HUBOT_TABELOG_PROXY`

Use proxy to access Tabelog

e.g.

```bash
HUBOT_TABELOG_PROXY=http://your.proxy.host:port hubot
```

# Known Issues

- Some environments are disallowed to access Tabelog

You might be able to access with proxy.

