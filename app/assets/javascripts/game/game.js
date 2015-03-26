
/* Game namespace */
var game = {

    // an object where to store game information
    data: {
        // score
        score : 0
    },

    firebase: null,

    // Run on page load.
    "onload": function () {
        // Initialize the video.
        if (!me.video.init("screen", me.video.CANVAS, 960, 640, true, 'auto')) {
            alert("Your browser does not support HTML5 canvas.");
            return;
        }

        // Initialize the audio.
        me.audio.init("mp3,ogg");

        // Set a callback to run when loading is complete.
        me.loader.onload = this.loaded.bind(this);

        // Load the resources.
        me.loader.preload(game.resources);

        // add "#debug" to the URL to enable the debug Panel
        if (document.location.hash === "#debug") {
            window.onReady(function () {
                me.plugin.register.defer(this, me.debug.Panel, "debug", me.input.KEY.V);
            });
        }

        // Initialize melonJS and display a loading screen.
        me.state.change(me.state.LOADING);

        this.firebase = new Firebase(FIREBASE_URL + "/users");
        this.firebase.once('value', function(nameSnapshot) {
            var users = nameSnapshot.val();
            var index = 0;

            for (user_id in users) {
                var user = users[user_id];

                var player = new game.PlayerEntity(50 + (index * 100), 550, {
                    name: 'Player', height: 64, width: 64,
                    spritewidth: 64, image: "spritesheet", userName: user.name });

                me.game.world.addChild(player, 3);
                player.userName = user.name;
                index++;
            }
        });
    },

    // Run on game resources loaded.
    "loaded": function () {
        me.state.set(me.state.MENU, new game.TitleScreen());
        me.state.set(me.state.PLAY, new game.PlayScreen());

        me.pool.register("Player", game.PlayerEntity);

        // Start the game.
        me.state.change(me.state.PLAY);
    }
};
