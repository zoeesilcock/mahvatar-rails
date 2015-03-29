game.PlayerEntity = me.Entity.extend
  init: (x, y, settings) ->
    @_super me.Entity, 'init', [ x, y, settings ]

    @alwaysUpdate = true
    @renderable.addAnimation 'stand', [ 1 ]
    @renderable.setCurrentAnimation 'stand'

    size = @body.getBounds().width
    @body.addShape new (me.Rect)(0, 0, size, size)

    canvas = me.video.renderer.getCanvas()
    @context = me.CanvasRenderer.getContext2d(canvas)

    @nameLabel = new (me.Font)('Verdana', 14, 'white')
    @userName = settings.userName

  draw: (renderer) ->
    @context.save()

    if @nameLabel
      @nameLabel.draw @context, @userName, @pos.x - me.game.viewport.pos.x + 16, @pos.y - me.game.viewport.pos.y - 20

    @_super me.Entity, 'draw', [ renderer ]

  update: (dt) ->
    @body.update dt
    me.collision.check this

    @_super(me.Entity, 'update', [ dt ])

  onCollision: (response, other) ->
    true
