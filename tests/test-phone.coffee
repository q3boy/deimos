{expect:e} = require 'chai'
phone = require '../lib/phone'

describe 'Phone', ->
  it 'phone number', ->
    p = phone 'key1', {}, 'phone'
    for i in [0..10]
      e(p.phone()).to.be.match /^\d{3,4}-\d{8}$/
      e("#{p.country} #{p.phone}").to.be.match /^\+86 \d{3,4}-\d{8}$/
      e("#{p}").to.be.match /^\d{3,4}-\d{8}$/
  it 'mobile number', ->
    p = phone 'key1', {}, 'mobile'
    for i in [0..10]
      e(p.mobile()).to.be.match /^\d{3}-\d{4}-\d{4}$/
      e("#{p.country} #{p.mobile}").to.be.match /^\+86 \d{3}-\d{4}-\d{4}$/
      e("#{p}").to.be.match /^\d{3}-\d{4}-\d{4}$/

