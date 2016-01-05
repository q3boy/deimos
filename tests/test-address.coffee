{expect:e} = require 'chai'
address = require '../lib/address'

list = ['stateName', 'stateSuffix', 'cityName', 'citySuffix', 'countyName', 'countySuffix'
'roadName', 'roadSuffix', 'no', 'buildingName', 'buildingSuffix']
getReg = (name) ->
data =
  stateName : ["北京"], stateSuffix : ["省"], cityName : ["海口"], citySuffix : ["市"]
  countyName: ["龙泉"], countySuffix : ["县"]
  roadName: ["四会"], roadSuffix: ["路"], no : ["###号"]
  buildingName: ["柳岸景"], buildingSuffix : ["广场"], buildingNo : ["##"]
  zipcode : ["######"]
describe 'Address', ->
  it 'simple', ->
    flag = []
    for i in [0...100]
      a = address Math.random().toString(), {data}
      full = a.full
      flag[0] = true if full is '北京省海口市龙泉县 四会路 柳岸景广场'
      flag[1] = true if full.match /^北京省海口市龙泉县 四会路 柳岸景广场 \d{2}$/
      flag[2] = true if full.match /^北京省海口市龙泉县 四会路\d{3}号 柳岸景广场$/
      flag[3] = true if full.match /^北京省海口市龙泉县 四会路\d{3}号 柳岸景广场 \d{2}$/
    e(flag).to.be.eql [true, true, true, true]
    e(a.state).to.be.eql '北京省'
    e(a.city).to.be.eql '海口市'
    e(a.county).to.be.eql '龙泉县'
    e(a.road).to.be.match /^四会路/
    e(a.building).to.be.match /^柳岸景广场/
