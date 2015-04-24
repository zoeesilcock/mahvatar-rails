//= require melonJS-2.1.0
//= require debug/debugPanel
//= require firebase
//= require ./game/game
//= require ./game/resources
//= require_tree ./game/entities
//= require_tree ./game/screens

window.onReady ->
  game.onload()
