extends RigidBody2D

@onready var ground_check: RayCast2D = $GroundCheck
@onready var sprite_2d: Sprite2D = $Sprite2D


var SPEED = 500.0;
var JUMP_FORCE = 250.0;

var momentum = 0.0;

var mass_og = mass;
var mass_temp = 0.0;

func _physics_process(delta: float) -> void:
	var velocity := Vector2.ZERO
	
	if rotation >= 15:
		rotation = 15
	elif rotation <= -15:
		rotation = -15
		
	
	
	var move_left := Input.is_action_pressed("left")
	var move_right := Input.is_action_pressed("right")
	var jump := Input.is_action_just_pressed("jump")
	var jumping := false
	
	var direction = 0.0
	#print("Direction: ", direction)
	
	if move_left:
		direction -= 1.0
		sprite_2d.scale.x = -1
		print("Left")
		
	if move_right:
		direction += 1.0
		sprite_2d.scale.x = 1
		print("Right")

		
	if jump:
		mass_temp = .05
	
		jumping = true
		
		# jumping will get a rolled over sheep back on its feet
		if jumping and not ground_check.is_colliding():
			if jump:
				rotation = 0.0
	
	if jumping and ground_check.is_colliding():
		apply_impulse(Vector2(0, -JUMP_FORCE))
		jumping = false
		
	if not jumping:
		if direction != 0:
			apply_central_force(Vector2(direction * SPEED, 0))
