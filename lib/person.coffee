{ItemRandom} = require './item'
jrands = require 'jrands'
{tpl, hash33, random} = require './util'
date = require './date'
os = require './options'


class Person extends ItemRandom
  constructor : (key, opt) ->
    hideProp = (name, value) => Object.defineProperty @, name, value: value
    hideProp 'options', os {
      pattern : '#{lastName}#{firstName}'
      lastName: ["王","李","张"]
      firstName: ["伟","英杰","柔","初夏"]
    }, opt
    (@birthDay = date(min:0, max:120)).toString = -> @format 'YYYY-MM-DD'
    map = firstName : @options.firstName, lastName: @options.lastName
    super map, key
    hideProp 'toString', -> @name

  next : () ->
    @age = Math.floor (new Date().valueOf() - @birthDay.moment.valueOf()) / 1000 / 86400 / 365
    @birthDay.next()
    super
    @name = tpl @options.pattern, {@firstName, @lastName}

module.exports = (key, opt)-> new Person key, opt