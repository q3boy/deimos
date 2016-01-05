fs = require 'fs'
path = require 'path'
yaml = require 'js-yaml'
ini = require 'ini'

isObj = (obj) ->
  'object' is typeof obj and obj isnt null and 0 is obj.constructor.toString().indexOf 'function Object()'

merge = (left, right) ->
  for k of right
    l = left[k]
    r = right[k]
    if isObj(l) and isObj(r)
      merge l, r
    else
      left[k] = r
  left

module.exports = (args...) ->
  opts = {}
  if args.length > 0
    for arg in args
      if null is arg or typeof arg is 'undefined'
        continue
      else if typeof arg is 'string'
        merge opts, switch path.extname arg
          when '.ini' then ini.parse fs.readFileSync(arg).toString()
          when '.json' then JSON.parse fs.readFileSync arg
          when '.yml', '.yaml' then yaml.safeLoad fs.readFileSync(arg).toString().trim()
      else
        merge opts, arg
  Object.freeze opts
