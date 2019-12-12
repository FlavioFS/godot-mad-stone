# [Godot] Mad Stone
Enemy scripts for an Angry smashing stone.

## [:tv: Video sample](http://www.youtube.com/watch?v=jn_XwXac9Go)
[![Preview img failed to load!](https://i.postimg.cc/9Mc7h0J4/preview.gif)](http://www.youtube.com/watch?v=jn_XwXac9Go)

## How does it work?
This enemy has 4 states represented by a enum:
 - **IDLE** (watching player)
 - **CHARGING** (short cast before attacking)
 - **MAD** (attacking)
 - **RAISING** (refreshing attack cooldown)

Enemy script is located in [godot/scenes/MadStone.gd](godot/scenes/MadStone.gd), the scene is [godot/scenes/MadStone.tscn](godot/scenes/MadStone.tscn).