game.HUD = game.HUD or {}
game.HUD.Container = me.Container.extend init: ->
  # call the constructor
  @_super me.Container, 'init'
  # persistent across level change
  @isPersistent = true
  # make sure we use screen coordinates
  @floating = true
  # make sure our object is always draw first
  @z = Infinity
  # give a name
  @name = 'HUD'
  # add our child score object at the top left corner
  @addChild new (game.HUD.ScoreItem)(5, 5)

game.HUD.ScoreItem = me.Renderable.extend
  init: (x, y) ->
    # call the parent constructor
    # (size does not matter here)
    @_super me.Renderable, 'init', [ x, y, 10, 10 ]
    # local copy of the global score
    @score = -1
    @nameLabel = new (me.Font)('Verdana', 32, 'white')
    @name = game.data.name

    canvas = me.video.renderer.getCanvas()
    @context = me.CanvasRenderer.getContext2d(canvas)

  update: ->
    # we don't do anything fancy here, so just
    # return true if the score has been updated
    if @name != game.data.name
      @name = game.data.name
      return true
    false

  draw: (renderer) ->
    @nameLabel.draw @context, @name, @pos.x, @pos.y
