jrands = require 'jrands'
{hash33, random} = require './util'
numeral = require 'numeral'

class MyNumber

  constructor : (key)->

    hideProp = (name, value) => Object.defineProperty @, name, value: value
    jrand = jrands hash33 key

    hideProp 'random', (args, format, min, max) ->
      [fmt] = args.filter (v) -> 'string' is typeof v # string args as format
      numeral(random args.filter((v) -> 'number' is typeof v), min, max, jrand).format if fmt? then fmt else format

    @[k].toString = @[k].bind @ for k in Object.keys MyNumber.prototype
    hideProp 'toString', @int.bind @

  int : (args...) -> @random args, '0', 0, 0x7fffffff
  float : (args...) -> @random args, '0[.]000', 0, 0xffff
  percent : (args...) -> @random args, '0[.]00%', 0, 2
  next :  ->
module.exports = (key) -> new MyNumber key