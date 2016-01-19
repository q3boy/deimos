jrands = require 'jrands'
os = require './options'
{hash33, random} = require './util'

floor = Math.floor

class Lorem
  constructor : (key, opt)->
    hideProp = (name, value) => Object.defineProperty @, name, value: value
    options = os {words:[], marks:[], space: '', pair: ratio:0.1, pad:2, min:1, max:3}, opt
    jrand = jrands hash33 key

    hideProp 'options',    options
    hideProp 'random',     (min, max, args=[]) -> random args, min, max, jrand
    hideProp 'randomList', (list) -> list[floor list.length * @random 0, 1]
    hideProp 'marks',      options.marks.filter (v) -> v.length is 1
    hideProp 'pairMarks',  options.marks.filter (v) -> v.length is 2

    @[k].toString = @[k].bind @ for k in Object.keys Lorem.prototype
    hideProp 'toString', @sentence.bind @


  word : -> @randomList @options.words

  words : (args...)->
    words = []; i = 0; num = floor @random 3, 20, args # words number
    words.push @word() while i++ < num
    words.join @options.space

  sentence : ->
    words = []; i = 0; num = floor @random 3, 20 # words number
    # no paired marks
    if @random 0, 1 > @options.pair.ratio
      words.push @word() while i++ < num
    # has paired marks
    else
      {pad, max, min} = @options.pair # get config
      mark = @randomList @pairMarks # random a pair
      begin = floor @random pad, num-pad; len = floor @random min, max # mark begin & mark contents length
      while i++ < num
        words.push @word() # push word
        switch i
          when begin then words[i-1] = mark[0] + words[i-1] # add left mark before first word
          when begin + len then words[i-2] += mark[1] # add right mark after last word
    words.join(@options.space) + @randomList @marks

  sentences : (args...)->
    sents = []; i = 0; num = floor @random 3, 20, args # sentence number
    sents.push @sentence() while i++ < num
    sents.join @options.space

  paragraph : ->
    @sentences() + "\n"

  paragraphs : (args...)->
    paras = []; i = 0; num = floor @random 3, 20, args # paragraph number
    paras += @paragraph() while i++ < num
    paras

  next :  ->

module.exports = (key, opt) -> new Lorem key, opt
