game.PlayerName = game.PlayerName or {}
game.PlayerName.Container = me.Container.extend
  init: (playerEntity) ->
    @_super me.Container, 'init'
    @floating = true
    @z = Infinity
    @player = playerEntity

    @nameLabel = new (game.PlayerName.Label)(0, -50)
    @nameBackground = new (game.PlayerName.Background)(@pos.x, @pos.y, 0, 20)

  draw: (renderer) ->
    labelSize = @nameLabel.label.measureText renderer, @player.userName
    @pos.x = @player.pos.x + 32 - (labelSize.width / 2)
    @pos.y = @player.pos.y + 64
    @nameBackground.width = labelSize.width + 10
    @nameLabel.userName = @player.userName

    @nameBackground.draw renderer, @pos.x - 5, @pos.y
    @nameLabel.draw renderer, @pos.x, @pos.y

game.PlayerName.Label = me.Renderable.extend
  init: (x, y) ->
    @_super me.Renderable, 'init', [ x, y, 0, 14 ]
    @label = new (me.Font)('Verdana', 14, 'black')

  draw: (renderer, x, y) ->
    @label.draw renderer, @userName, x, y

game.PlayerName.Background = me.Renderable.extend
  init: (x, y, w, h) ->
    @_super(me.Renderable, "init", [x, y, w, h])
    @color = new (me.Color)(167, 183, 229)
    @z = 0

  draw: (renderer, x, y) ->
    renderer.setColor @color
    renderer.fillRect x, y, @width, @height
