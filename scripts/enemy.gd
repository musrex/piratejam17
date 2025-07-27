class_name Enemies
extends RigidBody2D

@export var ENEMY_NAME: String;
@onready var label: Label = $Label


@onready var sprite_container: Node2D = $SpriteContainer
@onready var sprite_2d: Sprite2D = $SpriteContainer/Sprite2D


@onready var sight_cast: RayCast2D = $RayCasts/SightCast1
@onready var sight_cast_2: RayCast2D = $RayCasts/SightCast2

@onready var weak_cast_1: RayCast2D = $RayCasts/WeakCast1
@onready var weak_cast_2: RayCast2D = $RayCasts/WeakCast2
@onready var ground_detect: RayCast2D = $RayCasts/GroundDetect
@onready var stun_timer: Timer = $StunTimer
@onready var start_engage_timer: Timer = $StartEngageTimer

@export var SPEED = 200.0
#@export var MASS = 0.20
var wait := true
var color: int = 0
var my_floor_active := false
var grounded := true
var stunned := false
var engaged := false

@onready var player: CharacterBody2D

func set_player(p) -> void:
	player = p

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	var velocity = state.get_linear_velocity()
	# TO DO:
	# THIS PART ISN'T WORKING RIGHT...
	#if not wait:	
	if not stunned:
		#mass = MASS
		
		# set color and get enemy facing player
		if my_floor_active:
			if not color:
				color = randi_range(0, 29)
				sprite_2d.frame = color
			
			if player:
				if player.position.x < position.x:
					sprite_container.scale.x = -1
				else:
					sprite_container.scale.x = 1
			
			if sight_cast.is_colliding():
				start_engage_timer.start()
			
			if ground_detect.is_colliding():
				grounded = true
			else:
				grounded = false
				
			if player and grounded:
				velocity = position.direction_to(player.position) * SPEED
				state.set_linear_velocity(velocity)


func _on_area_2d_body_entered(body: Node2D) -> void:
	print("YO!")
	if body.is_in_group("Player"):
		print("In here")
		my_floor_active = true
		
func stun():
	stunned = true
	add_collision_exception_with(player)
	stun_timer.start()

func _on_stun_timer_timeout() -> void:
	stunned = false
	remove_collision_exception_with(player)
	
func _on_start_engage_timer_timeout() -> void:
	label.text = name
	wait = false
	
	
