game.PlayScreen = me.ScreenObject.extend
  onResetEvent: ->
    game.data.score = 0

    me.levelDirector.loadLevel 'map'

  onDestroyEvent: ->
    me.game.world.removeChild @HUD
