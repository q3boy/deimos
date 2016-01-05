{expect: e} = require 'chai'
faker = require '../lib/faker'

describe 'faker', ->
  it 'load default fake data', ->
    fake = faker()

    {data, patterns} = fake.data.address
    e(patterns).to.have.property 'full'
    e(data).to.have.property 'country'
    e(data).to.have.property 'citySuffix'
    e(data.citySuffix).to.have.length.above 1

    name = fake.data.name
    e(name.pattern).to.contain '#{firstName}'
    e(name.pattern).to.contain '#{lastName}'
    e(name.lastName).to.have.length.above 3
    e(name.firstName).to.have.length.above 3

    phone = fake.data.phone
    e(phone.prefix).to.have.length.above 3
    e(phone).to.have.property 'country'
    e(phone).to.have.property 'format'

    mobile = fake.data.mobile
    e(mobile.prefix).to.have.length.above 3
    e(mobile).to.have.property 'country'
    e(mobile).to.have.property 'format'

    lorem = fake.data.lorem
    e(lorem).to.have.property 'space'
    e(lorem.words).to.have.length.above 3
    e(lorem.marks).to.have.length.above 3

  it 'parse template without vars', ->
    fake = faker()
    out = fake.fake 'var1 var2'
    e(out).to.equal 'var1 var2'
  it 'parse template with vars ', ->
    fake = faker locale : 'zh_CN'
    out = fake.fake '#{var1} #{var2}', var1:'var1', var2:'var2'
    e(out).to.equal 'var1 var2'
  it 'parse template with vars and exp', ->
    fake = faker 'asd', locale : 'zh_CN'
    out = fake.fake '#{var1} #{var2.replace /a/g, "b"}', var1:'var1', var2:'var2'
    e(out).to.equal 'var1 vbr2'