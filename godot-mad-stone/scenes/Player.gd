extends KinematicBody2D

signal debug

export var speed : float = 150
export var jump_speed : float = -400
export var gravity : float = 1200

var axis : Vector2 = Vector2.ZERO
var jump : bool = false
var dead : bool = false

var velocity : Vector2 = Vector2.ZERO
onready var sprite : Sprite = $Sprite
onready var anim : AnimationPlayer = $Sprite/AnimationPlayer


func _physics_process(delta):
	if not dead:
		update_inputs()
	else:
		if Input.is_action_just_pressed("ui_accept"):
			get_tree().reload_current_scene()
	animate_and_move(delta)
#	emit_signal("debug", "FPS: %s" % Performance.get_monitor(Performance.TIME_FPS))

func animate_and_move(delta):
	if is_on_floor():
		if jump:
			try_play("jump")
			velocity.y = jump_speed
		elif velocity.y > 0:
			velocity.y = -1
		try_play("idle" if velocity.x == 0 else "walk")
	else:
		if Input.is_action_just_released("ui_accept"):
			velocity.y *= 0.5
		velocity.y += gravity * delta
	
	velocity.x = axis.x * speed
	if velocity.x != 0:
		sprite.flip_h = (velocity.x < 0)
	velocity = move_and_slide(velocity, Vector2.UP)

func try_play(animation_name:String):
	if anim.current_animation != animation_name:
		anim.play(animation_name)

func update_inputs():
	axis.x = (
		int(Input.is_action_pressed("ui_right"))
		- int(Input.is_action_pressed("ui_left"))
	)
	jump = Input.is_action_pressed("ui_jump")
	
func die():
	collision_layer = 0
	dead = true
	velocity = Vector2(
		rand_range(-speed, speed),
		0.8 * jump_speed
	)
	axis.x = 0
	anim.play("idle")
	var tween = $Tween
	tween.interpolate_property($Sprite, "rotation_degrees", 0, 1080, 1, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.interpolate_property(self, "velocity.x", velocity.x, 0, 1, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()