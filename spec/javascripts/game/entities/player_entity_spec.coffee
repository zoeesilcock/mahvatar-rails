describe 'PlayerEntity', ->
  before ->
    @player = new game.PlayerEntity 0, 0,
      name: 'Player'
      height: 64
      width: 64
      image: 'spritesheet'
      userName: 'Ricky'
      userId: '123'
      waitTime: 0

  describe '#init()', ->
    it 'starts with the will_join state', ->
      expect(@player.state).to.equal('will_join')

    it 'stores the users name', ->
      expect(@player.userName).to.equal('Ricky')

    it 'stores the users id', ->
      expect(@player.userId).to.equal('123')

  describe '#update()', ->
    it 'subtracts the delta time from the stateDuration', ->
      @player.stateDuration = 100
      @player.update(50)
      expect(@player.stateDuration).to.equal(50)

    context 'when the stateDuration is zero or less', ->
      beforeEach ->
        @player.stateDuration = 0

      it 'goes from will_join state to join state', ->
        @player.state = 'will_join'
        @player.update(1)
        expect(@player.state).to.equal('joining')

      it 'goes from joining state to idle state', ->
        @player.state = 'joining'
        @player.update(1)
        expect(@player.state).to.equal('idle')

      it 'goes from idle state to walking state', ->
        @player.state = 'idle'
        @player.update(1)
        expect(@player.state).to.equal('walking')

      it 'goes from walking state to idle state', ->
        @player.state = 'walking'
        @player.update(1)
        expect(@player.state).to.equal('idle')

    context 'when not joining or leaving', ->
      it 'turns around when it reaches the left edge of the screen', ->
        @player.body.vel.x = -3
        @player.pos.x = -1
        @player.state = 'walking'
        @player.update(1)
        expect(@player.body.vel.x).to.equal(3)

      it 'turns around when it reaches the right edge of the screen', ->
        @player.body.vel.x = 3
        @player.pos.x = 1920
        @player.state = 'walking'
        @player.update(1)
        expect(@player.body.vel.x).to.equal(-3)

  describe '#join()', ->
    before ->
      @player.join()

    it 'sets the state to joining', ->
      expect(@player.state).to.equal('joining')

    it 'sets the player x velocity to a positive number', ->
      expect(@player.body.vel.x).to.be.above(0)

  describe '#idle()', ->
    before ->
      @player.idle()

    it 'sets the state to idle', ->
      expect(@player.state).to.equal('idle')

    it 'sets the player x velocity to zero', ->
      expect(@player.body.vel.x).to.equal(0)

  describe '#walk()', ->
    before ->
      @previousVelocity = @player.body.vel.x
      @player.walk()

    it 'sets the state to walking', ->
      expect(@player.state).to.equal('walking')

    it 'changes the player x velocity', ->
      expect(@player.body.vel.x).to.not.equal(@previousVelocity)

  describe '#leave()', ->
    before ->
      @player.leave()

    it 'sets the state to leaving', ->
      expect(@player.state).to.equal('leaving')

    it 'sets the player x velocity to a negative number', ->
      expect(@player.body.vel.x).to.be.below(0)
