path = require 'path'
{View} = require 'atom-space-pen-views'

module.exports =
class CachePanelView extends View
  @content: ->
    @div class: 'tool-panel padded package-panel', =>
      @div class: 'inset-panel', =>
        @div class: 'panel-heading', 'Compile Cache'
        @div class: 'panel-body padded', =>
          @div class: 'timing', =>
            @span class: 'inline-block', 'CoffeeScript files compiled'
            @span class: 'inline-block highlight-info', outlet: 'coffeeCompileCount'

          @div class: 'timing', =>
            @span class: 'inline-block', '6to5 files compiled'
            @span class: 'inline-block highlight-info', outlet: 'to5CompileCount'

          @div class: 'timing', =>
            @span class: 'inline-block', 'CSON files compiled'
            @span class: 'inline-block highlight-info', outlet: 'csonCompileCount'

          @div class: 'timing', =>
            @span class: 'inline-block', 'Less files compiled'
            @span class: 'inline-block highlight-info', outlet: 'lessCompileCount'

  initialize: ->
    @populate()

  populate: ->
    @coffeeCompileCount.text(@getCoffeeCompiles())
    @to5CompileCount.text(@get6to5Compiles())
    @csonCompileCount.text(@getCsonCompiles())
    @lessCompileCount.text(@getLessCompiles())

  getCoffeeCompiles: ->
    cacheMisses = 0
    try
      CoffeeCache = require(path.join(atom.getLoadSettings().resourcePath, 'src', 'coffee-cache'))
      cacheMisses = CoffeeCache.getCacheMisses?() ? 0
    cacheMisses

  get6to5Compiles: ->
    cacheMisses = 0
    try
      To5Cache = require(path.join(atom.getLoadSettings().resourcePath, 'src', '6to5'))
      cacheMisses = To5Cache.getCacheMisses?() ? 0
    cacheMisses

  getCsonCompiles: ->
    cacheMisses = 0
    try
      CSON = require(path.join(atom.getLoadSettings().resourcePath, 'node_modules', 'season'))
      cacheMisses = CSON.getCacheMisses?() ? 0
    cacheMisses

  getLessCompiles: ->
    atom.themes.lessCache?.cache?.stats?.misses ? 0
