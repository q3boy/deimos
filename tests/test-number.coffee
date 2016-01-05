{expect:e} = require 'chai'
number = require '../lib/number'

describe 'Number', ->
  n = number 'key1'
  describe 'int', ->
    it 'simple', ->
      for i in [0..100]
        nn = n.int() * 1
        e(Number.isInteger nn).to.be.ok
        e(nn).to.be.within 0, 0x7fffffff
    it 'with max \& min', ->
      for i in [0..100]
        nn = n.int(100, 200) * 1
        e(Number.isInteger nn).to.be.ok
        e(nn).to.be.within 100, 200
    it 'with format', ->
      e(n.int(1000, 1000, '0,0')).to.be.eql '1,000'
  describe 'float', ->
    it 'simple', ->
      for i in [0..100]
        nn = n.float()
        e(nn).to.match /^\d{1,5}(\.\d{0,3})?$/
        e(nn).to.be.within 0, 0xffff
    it 'with max \& min', ->
      for i in [0..100]
        nn = n.float(100, 200) * 1
        e(nn).to.match /^\d{1,3}(\.\d{0,3})?$/
        e(nn).to.be.within 100, 200
  describe 'percent', ->
    it 'simple', ->
      for i in [0..100]
        e(n.percent()).to.match /^\d{1,3}(\.\d{0,2})?%$/
    it 'with max \& min', ->
      for i in [0..100]
        e(n.percent 0.2, 0.5).to.match /^\d{1,2}(\.\d{0,2})?%$/

