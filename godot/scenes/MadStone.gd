extends KinematicBody2D

enum State {
	IDLE,
	CHARGING,
	MAD,
	RAISING
}

export var falling_speed : float = 600
export var raising_speed : float = 100

var state : int = State.IDLE
var base_position : Vector2
var player_inside : bool = false

# Nodes
onready var anim : AnimatedSprite = $AnimatedSprite
onready var charge_timer : Timer = $ChargeTimer
onready var cooldown_timer : Timer = $CooldownTimer

# Vibrates while charging
var dissipate : float = 1.0
const SHAKE_INTENSITY : float = 8.0
const SHAKE_DISSIPATE : float = 0.5

func _ready():
	anim.play("idle")
	base_position = position
	set_process(false)

func _process(delta):
	match state:
		State.CHARGING:
			dissipate = ease(charge_timer.time_left / charge_timer.wait_time, SHAKE_DISSIPATE)
			position = base_position + dissipate * Vector2(
				rand_range(-SHAKE_INTENSITY, SHAKE_INTENSITY),
				rand_range(-SHAKE_INTENSITY, SHAKE_INTENSITY)
			)
		State.MAD:
			move_and_slide(Vector2.DOWN * falling_speed, Vector2.UP)
			position.x = base_position.x
			if is_on_floor():
				var main_camera = get_tree().get_nodes_in_group("main camera")
				if main_camera.size() > 0:
					main_camera[0].shake = true
				cooldown_timer.start()
				set_process(false)
		State.RAISING:
			move_and_slide(Vector2.UP * raising_speed, Vector2.UP)
			position.x = base_position.x
			if is_on_ceiling():
				if player_inside:
					start_charging()
				else:
					state = State.IDLE
					set_process(false)


func start_charging():
	anim.play("mad")
	state = State.CHARGING
	set_process(true)
	charge_timer.start()

#################################################
# Timers
#################################################
func _on_ChargeTimer_timeout():
	position = base_position
	state = State.MAD

func _on_CooldownTimer_timeout():
	state = State.RAISING
	anim.play("idle")
	set_process(true)

#################################################
# Areas 2D
#################################################
func _on_Field_of_View_body_entered(body):
	if body.name == "Player":
		player_inside = true
		if state == State.IDLE:
			start_charging()

func _on_Field_of_View_body_exited(body):
	if body.name == "Player":
		player_inside = false

func _on_Hitbox_body_entered(body):
	if body.name == "Player":
		body.die()