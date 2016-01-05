exports.hash33 = (str) ->
  hash = 0x7FED7FED
  return hash unless str?
  for i in [0...str.length] by 1
    hash = (hash * 33 + str.charCodeAt i) & 0xffffffff
  hash

exports.random = (args, min, max, random) ->
  # max when 1 args
  if args.length is 1 then [max] = args
  # min & max when 2 args
  else if args.length is 2 then [min, max] = args
  # range of max & min
  max = -0x80000000 if max < -0x80000000
  max =  0x7fffffff if max > 0x7fffffff
  min = -0x80000000 if min < -0x80000000
  min =  0x7fffffff if min > 0x7fffffff
  # skip when max is min
  return max if max is min
  # swap max & min
  [max, min] = [min, max] if max < min
  # get random value
  Math.abs(random() % 1) * (max - min) + min

regTpl = [/(#\{\w+\})\??/g, /#+\??/g]
exports.tpl = (tpl, vars, random) ->
  tpl.replace regTpl[0], (txt) ->
    if txt[txt.length-1] is '?'
      return '' if random(0, 2) < 1
      txt = txt.substr(2, txt.length - 4)
    else
      txt = txt.substr(2, txt.length - 3)
    if vars[txt]? then vars[txt] else ''
  .replace regTpl[1], (txt) ->
    if txt[txt.length-1] is '?'
      return '' if random(0, 2) < 1
      len = txt.length - 1
    else
      len = txt.length
    min = -1 + Math.pow 10, len
    max = Math.pow 10, len-1
    random(min, max)




