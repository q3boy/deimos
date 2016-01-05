{expect: e} = require 'chai'
{ListRandom, ItemRandom, Item} = require '../lib/item'

describe 'Item', ->
  it 'empty map', ->
    item = new Item()
    e(Object.keys item).to.eql []

describe 'ItemRandom', ->
  map = a:[1,2,3], b:[4,5,6,7], c:[8,9]
  it 'empty map', ->
    item = new ItemRandom()
    e(Object.keys item).to.eql []
  it 'next 30 times with same order', ->
    tmp = []
    for i in [1...30]
      item = new ItemRandom(map, 'key1')
      i1 = [item.a, item.b, item.c]
      item.next()
      i2 = [item.a, item.b, item.c]
      item.next()
      i3 = [item.a, item.b, item.c]
      item.next()
      i4 = [item.a, item.b, item.c]
      item.next()
      tmp = [i1, i2, i3, i4] if tmp.length is 0

      e(i1[0]).to.be.oneOf [1,2,3]
      e(i1[1]).to.be.oneOf [4,5,6,7]
      e(i1[2]).to.be.oneOf [8,9]
      e(i1).to.be.eql tmp[0]
      e(i2).to.be.eql tmp[1]
      e(i3).to.be.eql tmp[2]
      e(i4).to.be.eql tmp[3]

describe 'ListRandom', ->
  list = [{a:1}, {a:2}, {a:3}]
  it 'with constructor', ->
    class Aa extends Item

    l = new ListRandom 'key1', [{a:1}], Aa
    item = l.fetch()
    e(item).to.be.eql new Aa a:1

  describe 'without constructor', ->
    it 'fetch 30 times with same order', ->
      tmp = []
      for i in [1...30]
        l = new ListRandom 'key1', list
        i1 = l.fetch()
        i2 = l.fetch()
        i3 = l.fetch()
        e(i1).to.be.oneOf list
        e(i2).to.be.oneOf list
        e(i3).to.be.oneOf list
        tmp = [i1, i2, i3] if tmp.length is 0
        e(i1).to.be.eql tmp[0]
        e(i2).to.be.eql tmp[1]
        e(i3).to.be.eql tmp[2]


