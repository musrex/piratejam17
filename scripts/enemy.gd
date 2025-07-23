extends RigidBody2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var player: RigidBody2D

@onready var sight_cast: RayCast2D = $Sprite2D/SightCast
@onready var weak_cast_1: RayCast2D = $Sprite2D/WeakCast1
@onready var weak_cast_2: RayCast2D = $Sprite2D/WeakCast2
@onready var ground_detect: RayCast2D = $Sprite2D/GroundDetect

@export var SPEED = 200.0
@export var MASS = 0.20
var color: int = 0
var my_floor_active := false
var grounded := true

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	mass = MASS
	var velocity = state.get_linear_velocity()
	if player:
		if not color:
			while color == player.sprite_2d.frame:
				color = randi_range(0, 29)
		if player.position.x < position.x:
			sprite_2d.scale.x = -1
		else:
			sprite_2d.scale.x = 1
			
	sprite_2d.frame = color
	
	

	
	if ground_detect.is_colliding():
		grounded = true
	else:
		grounded = false
		
	if player and grounded:
		velocity = position.direction_to(player.position) * SPEED
		state.set_linear_velocity(velocity)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player = $"../Player"
	
