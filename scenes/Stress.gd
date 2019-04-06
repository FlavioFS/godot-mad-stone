extends RigidBody2D

onready var enabler : VisibilityEnabler2D = $VisibilityEnabler2D

func _ready():
	$Sprite/AnimationPlayer.play("run")
	enabler.pause_animated_sprites = true
	enabler.freeze_bodies = true
	enabler.pause_particles = true
	enabler.pause_animations = true
	enabler.process_parent = true
	enabler.physics_process_parent = true

func _physics_process(delta):
	print("%s" % name)
	for i in range(10000):
		var a = i+1