extends RigidBody2D

@onready var ground_check: RayCast2D = $GroundCheck

var SPEED = 500.0;
var JUMP_FORCE = 200.0;

func _physics_process(delta: float) -> void:
	var velocity := Vector2.ZERO
	
	var move_left := Input.is_action_pressed("left")
	var move_right := Input.is_action_pressed("right")
	var jump := Input.is_action_just_pressed("jump")
	var jumping := false
	
	if move_left:
		velocity.x -= SPEED
		print("Left")
	if move_right:
		velocity.x += SPEED
		print("Right")	
	if jump:
		jumping = true
		#velocity.y -= JUMP_FORCE
		print("Jumping?: ", jumping)
		print("Raycasting?: ", ground_check.is_colliding())
	
	if jumping and ground_check.is_colliding():
		apply_impulse(Vector2(0, -JUMP_FORCE))
		jumping = false
	if not jumping:
	#	velocity.y = 0.0
		apply_central_force(velocity)
