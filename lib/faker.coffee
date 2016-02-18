yaml    = require 'js-yaml'
fs      = require 'fs'
path    = require 'path'
coffee  = require 'coffee-script'
rand    = require 'jrands'
os      = require './options'
lodash  = require 'lodash'

locale  = require './locale'

lorem   = require './lorem'
number  = require './number'
date    = require './date'
person  = require './person'
phone   = require './phone'
address = require './address'

dir = path.join __dirname, '../locale'

parseList = (str)->
  list = []
  for item in str.replace(/\s/g, '').split ',' when '' isnt item = item.trim()
    list.push item
  list

class Faker
  constructor : (args) ->
    [key] = args.filter (v)-> 'string' is typeof v
    [opt] = args.filter (v)-> 'object' is typeof v
    @key = key or ''
    @options = os {data_list: [], locale: 'zh_CN'}, opt
    @data = locale[@options.locale]
    @initFakers()

  initFakers : ->
    @vars =
      lorem : lorem @key, @data.lorem
      number : number @key
      date : date @key
      person : person @key, @data.person
      address : address @key, @data.address
      phone : phone @key, @data.phone, 'phone'
      mobile : phone @key, @data.mobile, 'mobile'
    @

  next : ->
    v.next() for k,v of @vars
    @

  fake : (tpl, vars={}) ->
    v = os @vars, vars
    codes = coffee.compile 'return "'+tpl+'"', bare:true
    keys = Object.keys(v)
    args = []
    args.push v[key] for key in keys
    func = new Function keys, codes
    func.apply {}, args

module.exports = (args...)->
  new Faker args
module.exports.os = os