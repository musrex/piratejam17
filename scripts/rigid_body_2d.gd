extends RigidBody2D

var speed = 500.0;

func _physics_process(delta: float) -> void:
	var velocity := Vector2.ZERO
	
	var move_left := Input.is_action_pressed("left")
	var move_right := Input.is_action_pressed("right")
	var jump := Input.is_action_pressed("jump")
	
	if move_left:
		velocity.x -= speed
		print("Left")
	if move_right:
		velocity.x += speed
		print("Right")
	apply_central_force(velocity)
