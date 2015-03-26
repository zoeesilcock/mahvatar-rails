/**
 * Player Entity
 */
game.PlayerEntity = me.Entity.extend({

    /**
     * constructor
     */
    init: function (x, y, settings) {
        // call the constructor
        this._super(me.Entity, 'init', [x, y , settings]);

        this.alwaysUpdate = true;
        this.renderable.addAnimation("stand",  [1]);
        this.renderable.setCurrentAnimation("stand");

        var size = this.body.getBounds().width;
        this.body.addShape(new me.Rect(0, 0, size, size));

        var canvas = me.video.renderer.getCanvas();
        this.context = me.CanvasRenderer.getContext2d(canvas);
        this.nameLabel = new me.Font("Verdana", 14, "white");
        this.userName = settings.userName;
    },

    draw: function(renderer) {
        this._super(me.Entity, 'draw', [renderer]);
        this.context.save();

        if (this.nameLabel) {
            this.nameLabel.draw(this.context, this.userName, this.pos.x - me.game.viewport.pos.x + 16, this.pos.y - me.game.viewport.pos.y - 20);
        }
    },

    /**
     * update the entity
     */
    update: function (dt) {
        // apply physics to the body (this moves the entity)
        this.body.update(dt);

        // handle collisions against other shapes
        me.collision.check(this);

        // return true if we moved or if the renderable was updated
        return (this._super(me.Entity, 'update', [dt]) || this.body.vel.x !== 0 || this.body.vel.y !== 0);
    },

   /**
     * colision handler
     * (called when colliding with other objects)
     */
    onCollision: function (response, other) {
        // Make all other objects solid
        return true;
    }
});
