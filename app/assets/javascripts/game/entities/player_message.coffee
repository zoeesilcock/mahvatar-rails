game.PlayerMessage = game.PlayerMessage or {}
game.PlayerMessage.Container = me.Container.extend
  init: (playerEntity) ->
    @_super me.Container, 'init'
    @floating = true
    @z = Infinity
    @player = playerEntity
    @timeout = null

    @messageLabel = new (game.PlayerMessage.Label)(0, -50)
    @messageBackground = new (game.PlayerMessage.Background)(@pos.x, @pos.y, 0, 0)

  draw: (renderer) ->
    if !@currentMessage && @player.messages && @player.messages.length > 0
      @currentMessage = @player.messages.shift()

      firebase = new Firebase("#{FIREBASE_URL}/users/#{@player.userId}/messages")
      firebase.set(@player.messages)

    if @currentMessage && @currentMessage.length > 0
      labelSize = @messageLabel.label.measureText renderer, @currentMessage
      @pos.x = @player.pos.x + 64
      @pos.y = @player.pos.y
      @messageBackground.width = labelSize.width + 10
      @messageBackground.height = labelSize.height + 15
      @messageLabel.message = @currentMessage

      @messageBackground.draw renderer, @pos.x - 5, @pos.y - 5
      @messageLabel.draw renderer, @pos.x, @pos.y

      unless @timeout
        @timeout = window.setTimeout ( =>
          @currentMessage = null
          @timeout = null
        ), 5000

game.PlayerMessage.Label = me.Renderable.extend
  init: (x, y) ->
    @_super me.Renderable, 'init', [ x, y, 0, 14 ]
    @label = new (me.Font)('Verdana', 12, 'black')

  draw: (renderer, x, y) ->
    @label.draw renderer, @message, x, y

game.PlayerMessage.Background = me.Renderable.extend
  init: (x, y, w, h) ->
    @_super(me.Renderable, "init", [x, y, w, h])
    @color = new (me.Color)(255, 255, 255)
    @z = 0

  draw: (renderer, x, y) ->
    renderer.setColor @color
    renderer.fillRect x, y, @width, @height
