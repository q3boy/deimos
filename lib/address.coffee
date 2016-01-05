{ItemRandom} = require './item'
jrands = require 'jrands'
{tpl, hash33, random} = require './util'
os = require './options'

class Address extends ItemRandom
  constructor : (key, opt)->
    hideProp = (name, value) => Object.defineProperty @, name, value: value
    hideProp 'options', os {
      patterns:
        full : '#{state}#{city}#{county} #{road} #{building}'
        state : '#{stateName}#{stateSuffix}'
        city : '#{cityName}#{citySuffix}'
        county : '#{countyName}#{countySuffix}'
        road : '#{roadName}#{roadSuffix}#{no}?'
        building : '#{buildingName}#{buildingSuffix} #{buildingNo}?'
      data :
        country : ["中国"]
        stateName : ["北京", "上海", "天津"]
        stateSuffix : ["省", "市", "自治区"]
        cityName : ["海口", "赤壁", "新郑"]
        citySuffix : ["市", "县"]
        countyName: ["龙泉", "安康", "即墨"]
        countySuffix : ["县", "区", "镇"]
        roadName: ["四会", "营口", "彰化"]
        roadSuffix: ["路", "街", "胡同", "巷", "村"]
        no : ["###号"]
        buildingName: ["柳岸景", "蓝天苑", "裕泽"]
        buildingSuffix : ["广场", "大厦", "小区"]
        buildingNo : ["#-##-###", "##-##"]
        zipcode : ["######"]
    }, opt
    super @options.data, key
    hideProp 'toString', -> @full

  next : ->
    rand = (min, max) => Math.floor @random min, max
    super
    for k in Object.keys @
      @[k] = tpl @[k], {}, rand
    for k ,v of @options.patterns
      @[k] = tpl v, @, rand
    @full = tpl @options.patterns.full, @, rand
    for k in Object.keys @
      @[k] = @[k].replace(/\s+/g, ' ').trim()
# a = new Address 'key3'
# for i in [0...100]
#   console.log "#{a}"
#   a.next()

module.exports = (key, opt)-> new Address key, opt
