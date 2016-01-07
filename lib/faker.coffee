yaml    = require 'js-yaml'
fs      = require 'fs'
path    = require 'path'
coffee  = require 'coffee-script'
rand    = require 'jrands'
os      = require './options'
lodash  = require 'lodash'

lorem   = require './lorem'
number  = require './number'
date    = require './date'
person  = require './person'
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
    @readLocale().initFakers()

  initFakers : ->
    @vars =
      lorem : lorem @key, @data.lorem
      number : number @key
      date : date @key
      person : person @key, @data.person
      address : address @key, @data.address
    @

  next : -> v.next() for k,v of @vars

  fake : (tpl, vars={}) ->
    v = os @vars, vars
    codes = coffee.compile 'return "'+tpl+'"', bare:true
    keys = Object.keys(v)
    args = []
    args.push v[key] for key in keys
    func = new Function keys, codes
    func.apply {}, args

  readLocale: ->
    dataList = [path.join __dirname, '../locale/', "#{@options.locale}.yaml"]
    dataList.concat @options.data_list
    {__predefine: data} = os.apply {}, dataList
    # @data = {}
    @data =
      address :
        data : data.address.data
        patterns : data.address.patterns
      date : data.date
      person :
        name : data.person.name
        gender : parseList data.person.gender
        lastName : parseList data.person.lastName
        firstName : parseList data.person.firstName
      phone :
        format  : data.phone.format
        country : data.phone.country
        prefix  : parseList data.phone.prefix
      mobile :
        format  : data.mobile.format
        country : data.mobile.country
        prefix  : parseList data.mobile.prefix
      lorem :
        space : data.lorem.space
        words : parseList data.lorem.words
        marks : parseList data.lorem.marks

    @data.address.data[k] = parseList v for k, v of @data.address.data

    @

module.exports = (args...)->
  new Faker args