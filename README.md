# Hubot Tabelog

[![NPM version](https://badge.fury.io/js/hubot-tabelog.svg)](http://badge.fury.io/js/hubot-tabelog) [![Dependency Status](https://david-dm.org/dtaniwaki/hubot-tabelog.svg)](https://david-dm.org/dtaniwaki/hubot-tabelog) [![Build Status](https://travis-ci.org/dtaniwaki/hubot-tabelog.png)](https://travis-ci.org/dtaniwaki/hubot-tabelog) [![Coverage Status](https://coveralls.io/repos/dtaniwaki/hubot-tabelog/badge.png)](https://coveralls.io/r/dtaniwaki/hubot-tabelog)

Pick up a restaurant to go randomly

![screenshot](screenshot.png)

## Installation

* install this npm package to your hubot repo
    * `npm i --save hubot-tabelog`
* add `"hubot-tabelog"` to your `external-scripts.json`

## Usage

* `hubot tabelog <lunch|dinner> for <keyword> in/at <area>`
* e.g. `hubot tabelog lunch for 焼肉 in 新宿`

You can omit any of those like the followings.

* `hubot tabelog`
* `hubot tabelog for <keyword>`
* `hubot tabelog in/at <area>`

## Configuration

You can set some environment variables for hubot-tabelog.

### `HUBOT_TABELOG_PROXY`

Use proxy to access Tabelog

e.g.

```bash
HUBOT_TABELOG_PROXY=http://your.proxy.host:port hubot
```

You can pick up a free proxy listed [here](http://www.getproxy.jp/).

## Known Issues

- Some environments are disallowed to access Tabelog

You might be able to access with proxy.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new [Pull Request](../../pull/new/master)

## Copyright

Copyright (c) 2014 Daisuke Taniwaki. See [LICENSE](LICENSE) for details.
