{expect:e} = require 'chai'
person = require '../lib/person'

describe 'Person', ->
  opt = pattern : '#{lastName}#{firstName}', lastName: ["王"], firstName: ["伟"], gender : ['男']
  it 'simple', ->
    p = person 'key', opt
    for i in [0...10]
      e(p.name).to.be.eql '王伟'
      e(p.gender).to.be.eql '男'
      e(p.data).to.be.defined
      e(p.age).to.be.above 0
      p.next()

