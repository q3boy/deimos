{ItemRandom} = require './item'
jrands = require 'jrands'
{tpl, hash33, random} = require './util'
date = require './date'
os = require './options'

class Person extends ItemRandom
  constructor : (key, opt) ->
    hideProp = (name, value) => Object.defineProperty @, name, value: value
    hideProp 'options', os {
      gender : ['男', '女']
      name : '#{lastName}#{firstName}'
      lastName: ["王","李","张"]
      firstName: ["伟","英杰","柔","初夏"]
    }, opt
    hideProp '__key', key

    (birthday = date key).toString = -> @format 'YYYY-MM-DD'
    map =
      gender: @options.gender
      firstName : @options.firstName
      lastName: @options.lastName

    super map, key
    hideProp 'toString', -> @name

  next : () ->
    (@birthday = date @__key).toString = -> @format 'YYYY-MM-DD'
    @age = Math.floor (new Date().valueOf() - @birthday.moment.valueOf()) / 1000 / 86400 / 365
    @nominalAge = Math.ceil (new Date().valueOf() - @birthday.moment.valueOf()) / 1000 / 86400 / 365 + 1
    super
    @name = tpl @options.name, {@firstName, @lastName}

module.exports = (key, opt)-> new Person key, opt