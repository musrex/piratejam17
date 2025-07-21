extends RigidBody2D

@onready var sprite_2d: Sprite2D = $Sprite2D
#var PLAYER: RigidBody2D = $"../Player"

@onready var sight_cast: RayCast2D = $Sprite2D/SightCast
@onready var weak_cast_1: RayCast2D = $Sprite2D/WeakCast1
@onready var weak_cast_2: RayCast2D = $Sprite2D/WeakCast2
@onready var weak_cast_3: RayCast2D = $Sprite2D/WeakCast3

#var PLAYER = player
@export var SPEED = 200.0
@export var MASS = 0.20
var color: int = 0
var my_floor_active := false

func _physics_process(delta: float) -> void:
	sprite_2d.scale.x = -1

	#mass = MASS
	var velocity = Vector2.ZERO
	if not color:
#		while color == PLAYER.sprite_2d.frame:
			color = randi_range(0, 29)
	
	sprite_2d.frame = color
	
	
	if sight_cast.is_colliding():
	#	if PLAYER.position.x < position.x:
	#		sprite_2d.scale.x = -1
	#	else:
	#		sprite_2d.scale.x = 1
		
	#if PLAYER:
	#	velocity = position.direction_to(PLAYER.position) * SPEED
		apply_central_force(velocity)
