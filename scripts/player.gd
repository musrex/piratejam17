extends RigidBody2D

@onready var ground_check: RayCast2D = $GroundCheck
@onready var sprite_2d: Sprite2D = $Normal
@onready var ramming: Sprite2D = $Ramming
@onready var jumping: Sprite2D = $Jumping
@onready var eating: Sprite2D = $Eating


var MAX_SPEED = 300.0;
var SPEED = 250.0;
var JUMP_FORCE = -250.0;
var RAM_FORCE = 500.0

# Coyote Time
var coyote_frames := 6
var coyote := false
var last_floor := false
@onready var coyote_timer: Timer = $CoyoteTimer

var momentum = 0.0;

var mass_max = 1000;
var mass_og = mass;
var mass_temp = 10.0;

func _ready() -> void:
	coyote_timer.wait_time = coyote_frames / 60.0
	
func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	print("Mass: ", mass)
	var velocity = state.get_linear_velocity()
	var move_vector = Vector2.ZERO
	var force = velocity.length() * RAM_FORCE
	
	# Movement inputs
	var move_left := Input.is_action_pressed("left")
	var move_right := Input.is_action_pressed("right")
	var jump := Input.is_action_just_pressed("jump")
	var down := Input.is_action_pressed("down")
	
	# States
	var is_ramming := false
	var is_grounded := ground_check.is_colliding()
	
	if move_left:
		move_vector.x -= 1
		sprite_2d.scale.x = -1
		ramming.scale.x = -1
	elif move_right:
		move_vector.x += 1
		sprite_2d.scale.x = 1
		ramming.scale.x = 1
	else:
		velocity.x = 0
	
	if down:
		is_ramming = true
		sprite_2d.visible = 0
		ramming.visible = 1
		
	else:
		sprite_2d.visible = 1
		ramming.visible = 0

	if jump and is_grounded:
		sprite_2d.visible = 0
		jumping.visible = 1
		velocity.y = JUMP_FORCE
		state.set_linear_velocity(velocity)
	
	if not jump and is_grounded:
		jumping.visible = 0
		sprite_2d.visible = 1
	
	if not is_grounded or is_ramming:
		mass += mass_temp
		if mass > mass_max:
			mass = mass_max
	else:
		mass = mass_og
		
	move_vector = move_vector.normalized()
	velocity.x = move_vector.x * SPEED
	state.set_linear_velocity(velocity)
