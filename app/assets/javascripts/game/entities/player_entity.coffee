game.PlayerEntity = me.Entity.extend
  init: (x, y, settings) ->
    @_super me.Entity, 'init', [ x, y, settings ]

    @alwaysUpdate = true
    @renderable.addAnimation 'stand', [ 1 ]
    @renderable.setCurrentAnimation 'stand'

    size = @body.getBounds().width
    @body.addShape new (me.Rect)(0, 0, size, size)

    @nameLabel = new (me.Font)('Verdana', 14, 'white')
    @userName = settings.userName
    @userId = settings.userId

    @state = 'will_join'
    @stateDuration = settings.waitTime

  draw: (renderer) ->
    if @nameLabel
      @nameLabel.draw renderer, @userName, @pos.x - me.game.viewport.pos.x + 16, @pos.y - me.game.viewport.pos.y + 64

    @_super me.Entity, 'draw', [ renderer ]

  update: (dt) ->
    @stateDuration -= dt

    if @state == 'will_join' && @stateDuration <= 0
      @join()

    if @state == 'joining' && @stateDuration <= 0
      @idle()

    if @state == 'idle' && @stateDuration <= 0
      @walk()

    if @state == 'walking' && @stateDuration <= 0
      @idle()

    if (@state != 'joining' && @state != 'leaving') && (@pos.x < 0 || @pos.x > (me.game.viewport.width - @body.getBounds().width))
      # Don't leave the edge of the area.
      @body.vel.x = -@body.vel.x

    if @state == 'leaving' && @pos.x < -50
      me.game.world.removeChild @
      delete game.players[@userId]

    @body.update dt
    me.collision.check @
    @_super(me.Entity, 'update', [ dt ])
    true

  join: ->
    @state = 'joining'
    @stateDuration = Number.prototype.random(3000, 5000)
    @body.vel.x = 2

  idle: ->
    @state = 'idle'
    @stateDuration = Number.prototype.random(2000, 8000)
    @body.vel.x = 0

  walk: ->
    @state = 'walking'
    @body.vel.x = Number.prototype.random(-20, 20) / 10
    @stateDuration = Number.prototype.random(3000, 6000)

  leave: ->
    @body.vel.x = -3
    @state = 'leaving'

  onCollision: (response, other) ->
    if other.name == 'Player' then false else true
