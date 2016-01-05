{expect: e} = require 'chai'
{tpl, hash33, random} = require '../lib/util'

describe 'Util', ->
  describe 'random', ->
    rand = (args...) -> random args, 10, 20, Math.random
    it 'without args', ->
      e(rand()).to.be.within 10, 20
    it 'max 0', ->
      e(rand 0).to.be.within 0, 10
    it 'min 30 \& max 40', ->
      e(rand 30, 40).to.be.within 30, 40
    it 'min 40 \& max 30', ->
      e(rand 30, 40).to.be.within 30, 40
    it 'max overflow', ->
      e(rand 0x80000000, 0x7fffffff).to.be.eql 0x7fffffff
      e(rand 0x7fffffff, 0x80000000).to.be.eql 0x7fffffff
    it 'min overflow', ->
      e(rand -0x80000001, -0x80000000).to.be.eql -0x80000000
      e(rand -0x80000000, -0x80000001).to.be.eql -0x80000000
  describe 'hash33', ->
    it 'return same value with same key', ->
      e(hash33 'aaa').to.be.eql hash33 'aaa'
    it 'return signed int value', ->
      i = 0
      while i++ < 100
        r = hash33 Math.random().toString()
        e(typeof r).to.be.eql 'number'
        e(r).to.be.within -0x80000000, 0x7fffffff
  describe 'tpl', ->
    rand = (min, max) -> Math.round Math.random() * (max - min) + min
    describe 'without ?', ->
      it ' \& numbers', ->
        txt = tpl '#{a}, #{b}, #{c}', a:"a", b:2
        e(txt).to.be.eql 'a, 2, '
      it 'with number', ->
        txt = tpl '#{a}, #{b}, #{c} #####', a:"a", b:2, rand
        e(txt).to.be.match /^a, 2,  \d{5}$/

    describe 'with ?', ->
      it 'without \& numbers', ->
        flag = [false, false]
        for i in [0...30]
          txt = tpl '#{a}, #{b}?, #{c}', a:"a", b:2, rand
          flag[0] = true if txt is 'a, 2, '
          flag[1] = true if txt is 'a, , '
        e(flag).to.be.eql [true, true]
      it '\& number', ->
        flag = [false, false]
        for i in [0...30]
          txt = tpl '#{a}, #{b}, #{c} #####?', a:"a", b:2, rand
          flag[0] = true if txt.match /^a, 2,  \d{5}$/
          flag[1] = true if txt is 'a, 2,  '
        e(flag).to.be.eql [true, true]

