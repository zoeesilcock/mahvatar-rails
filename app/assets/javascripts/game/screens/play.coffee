game.PlayScreen = me.ScreenObject.extend
  onResetEvent: ->
    game.data.score = 0

    @HUD = new (game.HUD.Container)
    me.game.world.addChild @HUD
    me.levelDirector.loadLevel 'map'

  onDestroyEvent: ->
    me.game.world.removeChild @HUD
