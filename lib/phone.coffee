jrands = require 'jrands'
os = require './options'
{hash33, random, tpl} = require './util'

class Phone
  constructor : (key, opt)->
    hideProp = (name, value) => Object.defineProperty @, name, value: value
    hideProp 'options', os {
      country : '+86'
      mobile : ['13#-####-####', '18#-####-####', '15#-####-####']
      phone : ['01#-########', '02#-########', '03##-########', '04##-########', '05##-########'
        '06##-########', '07##-########', '08##-########', '09##-########']
    }, opt
    rand = jrands hash33 key
    hideProp 'random', (min, max)->Math.floor random [], min, max, rand
    @country = @options.country
    @phone.toString = @phone.bind @
    @mobile.toString = @mobile.bind @

  phone : -> @tpl @options.phone
  mobile : -> @tpl @options.mobile
  tpl : (tpls)-> tpl tpls[@random 0, tpls.length], {}, @random

module.exports = (key, opt) ->
  new Phone key, opt