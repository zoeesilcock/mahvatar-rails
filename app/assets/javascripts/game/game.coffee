game =
  data: 0
  score: 0
  firebase: null

  'onload': ->
    # Initialize the video.
    if !me.video.init('screen', me.video.CANVAS, 960, 640, true, 'auto')
      alert 'Your browser does not support HTML5 canvas.'
      return

    # Initialize the audio.
    me.audio.init 'mp3,ogg'
    # Set a callback to run when loading is complete.
    me.loader.onload = @loaded.bind(this)
    # Load the resources.
    me.loader.preload game.resources

    # add "#debug" to the URL to enable the debug Panel
    if document.location.hash == '#debug'
      window.onReady ->
        me.plugin.register.defer this, me.debug.Panel, 'debug', me.input.KEY.V
        return

    # Initialize melonJS and display a loading screen.
    me.state.change me.state.LOADING

    @firebase = new Firebase(FIREBASE_URL + '/users')
    @firebase.once 'value', (nameSnapshot) ->
      users = nameSnapshot.val()
      index = 0
      for user_id of users
        `user_id = user_id`
        user = users[user_id]
        player = new (game.PlayerEntity)(50 + index * 100, 550,
          name: 'Player'
          height: 64
          width: 64
          spritewidth: 64
          image: 'spritesheet'
          userName: user.name)
        me.game.world.addChild player, 3
        player.userName = user.name
        index++

  'loaded': ->
    me.state.set me.state.PLAY, new (game.PlayScreen)
    me.pool.register 'Player', game.PlayerEntity

    # Start the game.
    me.state.change me.state.PLAY

root = exports ? this
root.game = game
