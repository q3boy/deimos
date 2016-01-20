{expect: e} = require 'chai'
faker = require '../lib/faker'

describe 'Faker', ->
  describe 'locale', ->
    it 'load default fake data', ->
      fake = faker()

      {data, patterns} = fake.data.address
      e(patterns).to.have.property 'full'
      e(data).to.have.property 'country'
      e(data).to.have.property 'citySuffix'
      e(data.citySuffix).to.have.length.above 1

      person = fake.data.person
      e(person.name).to.contain '#{firstName}'
      e(person.name).to.contain '#{lastName}'
      e(person.lastName).to.have.length.above 3
      e(person.firstName).to.have.length.above 3

      phone = fake.data.phone
      e(phone).to.have.property 'phone'
      e(phone).to.have.property 'mobile'
      e(phone).to.have.property 'country'
      e(phone.phone).to.have.length.above 2
      e(phone.mobile).to.have.length.above 2

      lorem = fake.data.lorem
      e(lorem).to.have.property 'space'
      e(lorem.words).to.have.length.above 3
      e(lorem.marks).to.have.length.above 3

  describe 'tpl', ->
    describe 'without built-in vars', ->
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
    describe 'with built-in vars', ->
      it 'parse template without vars', ->
        fake = faker()
        e(fake.fake '#{person}').to.be.length.above 1
        e(fake.fake '#{lorem}').to.be.length.above 8
        e(Number.isInteger 1 * fake.fake '#{number}').to.be.ok
        e(fake.fake '#{address}').to.be.length.above 8
        e(fake.fake '#{date}').to.be.match /^\d{4}-\d{2}-\d{2} \d\d:\d\d:\d\d$/
        e(fake.fake '#{phone}').to.be.match /^\d{3,4}-\d{8}$/
        e(fake.fake '#{mobile}').to.be.match /^\d{3}-\d{4}-\d{4}$/
      it 'next works fine', ->
        fake = faker()
        out1 = [
          fake.fake('#{person}'), fake.fake('#{lorem}')
          fake.fake('#{address}'), fake.fake('#{date}'),  1 * fake.fake('#{number}')
        ]
        fake.next()
        out2 = [
          fake.fake('#{person}'), fake.fake('#{lorem}').length
          fake.fake('#{address}'), fake.fake('#{date}'), 1 * fake.fake('#{number}')
        ]
        num = 0
        num++ for i in [0...5] when out1[i] isnt out2[i]
        e(num).to.be.above 3
      it 'parse template with vars', ->
        fake = faker()
        e(fake.fake '#{person} #{var1}', var1:'aaa').to.be.match /^.{2,4} aaa/