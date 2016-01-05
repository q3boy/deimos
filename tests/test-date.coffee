{expect:e} = require 'chai'
date = require '../lib/date'
moment = require 'moment'

describe 'Date', ->
  it 'no pattern', ->
    d = date()
    e(d.toString()).to.be.eql d.fulltime
    e(d.toString()).to.match /^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}$/
    e(d.format 'YYYY').to.match /^\d{4}$/
  it 'some patterns', ->
    d = date 'key1', min:10, max: 10, patterns: fulltime: 'YYYYMMDD'
    e(d.toString()).to.be.eql d.fulltime
    e(d.toString()).to.match /^\d{8}$/
    e(d.toString()).to.be.eql moment().subtract(10, 'days').format 'YYYYMMDD'
