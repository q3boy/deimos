{expect: e} = require 'chai'
lorem = require '../lib/lorem'
lodash = require 'lodash'


describe 'Lorem', ->
  l = opt = null
  beforeEach ->
    opt =
      words : ['aa', 'bb']
      marks : ['c', 'd', 'ef', 'gh']
      space : ' '
      pair  : ratio: 0
    l = lorem 'key1', opt

  it 'word', ->
    e(l.word()).to.be.oneOf opt.words

  it 'words with max min', ->
    words = l.words(5, 6).split ' '
    e(words).to.be.length.within 5,6
    e(opt.words).to.include.members lodash.uniq l.words(5, 6).split ' '

  it 'words without max min', ->
    e(opt.words).to.include.members lodash.uniq l.words().split ' '

  it 'words without space', ->
    opt.space = ''
    l =  lorem null, opt
    e(opt.words).to.not.match /\s/


  it 'sentence without pair-marks', ->
    s = l.sentence()
    words = s.substr 0, s.length - 1
    mark = s.substr s.length - 1
    e(opt.words).to.include.members lodash.uniq words.split ' '
    e(mark).to.be.oneOf opt.marks

  it 'sentence with pair-marks', ->
    opt.pair.ratio = 1
    l =  lorem null, opt
    s = l.sentence()
    words = s.substr 0, s.length - 1
    mark = s.substr s.length - 1
    words = words.split ' '
    e(opt.words).to.not.be.members words
    paired = words.filter (v) -> v not in opt.words
    e(paired).to.be.length.within 1, 2
    switch paired.length
      when 1
        [word] = paired
        e(word).to.be.length 4
        e(word[3]).to.be.eql 'f' if word[0] is 'e'
        e(word[3]).to.be.eql 'h' if word[0] is 'g'
      when 2
        [word1, word2] = paired
        e(word1).to.be.length 3
        e(word2).to.be.length 3
        e(word2[2]).to.be.eql 'f' if word1[0] is 'e'
        e(word2[2]).to.be.eql 'h' if word1[0] is 'g'

    e(mark).to.be.oneOf opt.marks

  it 'sentences', ->
    txt = l.sentences(5, 6)
    for s in txt.split /[cd]/ when '' isnt s = s.trim()
      e(opt.words).to.include.members s.split ' '

  it 'paragraph', ->
    txt = l.paragraph()
    e(txt[txt.length - 1]).to.be.eql '\n'
    for s in txt.trim().split /[cd]/ when '' isnt s = s.trim()
      e(opt.words).to.include.members s.split ' '

  it 'paragraphs with max min', ->
    txt = l.paragraphs(3,4)
    lines = txt.trim().split '\n'
    e(lines).to.be.length.within 3,4
    for line in lines
      for s in line.trim().split /[cd]/ when '' isnt s = s.trim()
        e(opt.words).to.include.members s.split ' '
  it 'paragraphs witouth max min', ->
    txt = l.paragraphs()
    lines = txt.trim().split '\n'
    for line in lines
      for s in line.trim().split /[cd]/ when '' isnt s = s.trim()
        e(opt.words).to.include.members s.split ' '
        # e(s.split ' ').to.include.members opt.words

