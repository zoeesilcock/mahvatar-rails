game =
  data: {}
  score: 0
  firebase: null
  players: {}

  onload: ->
    # Initialize the video.
    if !me.video.init('screen', me.video.CANVAS, 960, 640, true)
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

    @firebase.on 'child_added', @userAdded
    @firebase.on 'child_changed', @userChanged
    @firebase.on 'child_removed', @userRemoved

  loaded: ->
    me.state.set me.state.PLAY, new (game.PlayScreen)
    me.pool.register 'Player', game.PlayerEntity

    # Start the game.
    me.state.change me.state.PLAY

  userAdded: (userSnapshot)->
    user = userSnapshot.val()
    user.id = userSnapshot.key()

    if user.status == 'active'
      game.addPlayer(user)

  userChanged: (userSnapshot)->
    user = userSnapshot.val()
    user.id = userSnapshot.key()

    if user.status == 'active'
      game.addPlayer(user)
    else
      game.removePlayer user

  userRemoved: (userSnapshot)->
    user = userSnapshot.val()
    user.id = userSnapshot.key()

    game.removePlayer user

  addPlayer: (user)->
    player = new (game.PlayerEntity)(-64, 550,
      name: 'Player'
      height: 64
      width: 64
      spritewidth: 64
      image: 'spritesheet'
      userName: user.name,
      userId: user.id)

    me.game.world.addChild player, 3
    game.players[user.id] = player

  removePlayer: (user)->
    player = game.players[user.id]

    if player
      player.leave()

root = exports ? this
root.game = game
