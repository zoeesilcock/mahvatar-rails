game.PlayerEntity = me.Entity.extend
  init: (x, y, settings) ->
    @_super me.Entity, 'init', [ x, y, settings ]

    @stateDuration = settings.waitTime
    @setUserDetails settings.userDetails

    @state = 'will_join'
    @velocity = 0

    @alwaysUpdate = true
    @renderable.addAnimation 'stand', [ 1 ]
    @renderable.setCurrentAnimation 'stand'

    size = @body.getBounds().width
    @body.addShape new (me.Rect)(0, 0, size, size)

    @nameContainer = new (game.PlayerName.Container)(@)
    me.game.world.addChild @nameContainer, 5

    @messageContainer = new (game.PlayerMessage.Container)(@)
    me.game.world.addChild @messageContainer, 5

  setUserDetails: (details) ->
    oldHead = @headPath

    @userId = details.id
    @userName = details.name
    @headPath = details.head
    @messages = details.messages

    if oldHead != @headPath
      if @headPath? && @headPath.length
        @loadHeadResource()
      else
        @createHeadEntity 'default_head'

  loadHeadResource: ->
    imageName = "custom_head_#{@userId}"

    me.loader.load({
      name: imageName
      type: 'image'
      src: @headPath
    }, =>
      @createHeadEntity imageName
    )

  createHeadEntity: (imageName) ->
    if @headEntity
      me.game.world.removeChild @headEntity

    @headEntity = new (game.HeadEntity)(@x, @y, playerEntity: @, image: imageName)
    me.game.world.addChild @headEntity, 5

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

    if (@leavingLeftSide() || @leavingRightSide()) && (@state != 'joining' && @state != 'leaving')
      # Don't leave the edge of the area.
      @velocity = -@velocity

    if @state == 'leaving' && @pos.x < -128
      me.game.world.removeChild @
      delete game.players[@userId]

    @body.vel.x = (@velocity * dt) / 10

    @body.update dt
    me.collision.check @
    @_super(me.Entity, 'update', [ dt ])
    true

  leavingLeftSide: ->
    @pos.x < 0 && @velocity < 0

  leavingRightSide: ->
    @pos.x > (me.game.viewport.width - @body.getBounds().width) && @velocity > 0

  join: ->
    @state = 'joining'
    @stateDuration = Number.prototype.random(1000, 2000)
    @velocity = 2

  idle: ->
    @state = 'idle'
    @stateDuration = Number.prototype.random(2000, 8000)
    @velocity = 0

  walk: ->
    @state = 'walking'
    @velocity = Number.prototype.random(-15, 15) / 10
    @stateDuration = Number.prototype.random(3000, 6000)

  leave: ->
    @velocity = -3
    @state = 'leaving'

  onCollision: (response, other) ->
    if other.name == 'Player' then false else true
