extends CharacterBody2D

@onready var ground_check: RayCast2D = $GroundCheck
@onready var sprite_2d: Sprite2D = $Normal
@onready var ramming: Sprite2D = $Ramming
@onready var jumping: Sprite2D = $Jumping
@onready var eating: Sprite2D = $Eating
@onready var sprite_container: Node2D = $SpriteContainer


@export var MAX_SPEED = 300.0;
@export var SPEED = 250.0;
@export var JUMP_FORCE = -400.0;
@export var RAM_FORCE = 500.0
@export_range(0.0, 1.0) var ACCELERATION
@export_range(0.0, 1.0) var DECELERATION

var GRAVITY = 2000.0

# Coyote Time
@export var coyote_frames := 6
var coyote := false
var last_floor := false
@onready var coyote_timer: Timer = $CoyoteTimer

# Momentum stuff
# WORRY ABOUT IT LATER
var momentum = 0.0;
var mass_max = 1000;
var mass_temp = 10.0;


func _ready() -> void:
	coyote_timer.wait_time = coyote_frames / 60.0
	
func _process(delta: float) -> void:
	print("velocity.y: ", velocity.y)
	var force = velocity.length() * RAM_FORCE
	
	# Movement inputs
	var move_left := Input.is_action_pressed("left")
	var move_right := Input.is_action_pressed("right")
	var jump := Input.is_action_just_pressed("jump")
	var down := Input.is_action_pressed("down")
	
	# States
	var is_ramming := false
	var is_grounded := ground_check.is_colliding()
	
	velocity.y += GRAVITY * delta
	
	if move_left:
		velocity.x = lerp(velocity.x, -SPEED, ACCELERATION)
		sprite_container.scale.x = -1
	elif move_right:
		velocity.x = lerp(velocity.x, SPEED, ACCELERATION)
		sprite_container.scale.x = 1
	else:
		velocity.x = lerp(velocity.x, 0.0, DECELERATION)
	
	move_and_slide()
	if jump and is_grounded:
		velocity.y = JUMP_FORCE
