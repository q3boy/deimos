os = require './options'
jrands = require 'jrands'
moment = require 'moment'
{random, hash33} = require './util'
{ItemRandom} = require './item'


class MyDate extends ItemRandom
  constructor : (key, opt) ->
    hideProp = (name, value) => Object.defineProperty @, name, value: value
    hideProp 'options', os {
      min: 0, max: 120 * 365
      patterns:
        fulldate: 'YYYY-MM-DD', fulltime: 'YYYY-MM-DD HH:mm:ss', time: 'HH:mm:ss'
        year: 'YYYY', month: 'M', day: 'D', week: 'w', weekday: 'e'
        hour: 'H', minute: 'm', second: 's', zone: 'Z'
    }, opt
    super {}, key
    hideProp 'toString', -> @fulltime

  next : ->
    @moment = moment().subtract @random(@options.min, @options.max) * 86400, 'seconds'
    @[k] = @moment.format v for k,v of @options.patterns
    @

  format : (fmt)-> @moment.format fmt

module.exports = (key, opt) -> new MyDate key, opt
