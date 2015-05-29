game.HeadEntity = me.Entity.extend
  init: (x, y, settings) ->
    settings.height = 32
    settings.width = 32
    settings.image = 'default_head'

    @_super me.Entity, 'init', [ x, y, settings ]

    @alwaysUpdate = true
    @player = settings.playerEntity

    @renderable.addAnimation 'face', [ 0 ]
    @renderable.setCurrentAnimation 'face'

  update: (dt) ->
    @pos.x = @player.pos.x + (32 / 2)
    @pos.y = @player.pos.y
