jrands = require 'jrands'
{hash33, random} = require './util'

class Item
  constructor : (map={}) ->
    for k, v of map
      @[k] = v

class ItemRandom
  constructor : (map={}, key='') ->
    hideProp = (name, value) => Object.defineProperty @, name, value: value
    hideProp '__jrand', jrands hash33 key
    hideProp '__map', map
    @next()
  random : (args...) -> random args, 0, 1, @__jrand
  next : ->
    @[k] = list[Math.floor @random(0, list.length)] for k, list of @__map
    @

class ListRandom
  constructor : (key, @list, @class)->
    @rand = jrands hash33 key

  fetch : ()->
    if @class?
      new @class @list[Math.floor (@rand()%1) * @list.length]
    else
      @list[Math.floor (@rand()%1) * @list.length]

exports.Item = Item
exports.ItemRandom = ItemRandom
exports.ListRandom = ListRandom
