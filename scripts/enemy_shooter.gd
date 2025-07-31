extends RigidBody2D

@export var ENEMY_NAME: String;
@export_enum("Cyborg", "Vulcan", "BlackPhillip") var ENEMY_TYPE: String;
@onready var label: Label = $Label
@onready var main = get_node("/root/Main")


@onready var sprite_container: Node2D = $SpriteContainer


@onready var sprite_2d: Sprite2D = $SpriteContainer/Sprite2D

@onready var ray_casts: Node2D = $RayCasts
@onready var sight_cast: RayCast2D = $RayCasts/SightCast1
@onready var sight_cast_2: RayCast2D = $RayCasts/SightCast2

@onready var weak_cast_1: RayCast2D = $RayCasts/WeakCast1
@onready var weak_cast_2: RayCast2D = $RayCasts/WeakCast2
@onready var ground_detect: RayCast2D = $RayCasts/GroundDetect
@onready var stun_timer: Timer = $StunTimer
@onready var start_engage_timer: Timer = $StartEngageTimer

@onready var black_phillip: Node2D = $BlackPhillip
@onready var black_phillip_marker: Marker2D = $BlackPhillip/Marker2D

@onready var cyborg: Node2D = $Cyborg
@onready var cyborg_marker: Marker2D = $Cyborg/Marker2D
@onready var laser_warning_timer: Timer = $Cyborg/LaserWarningTimer
@onready var laser_warning: Sprite2D = $Cyborg/LaserWarning
@onready var cyborg_fire_rate: Timer = $Cyborg/CyborgFireRate

@onready var vulcan_raven: Node2D = $VulcanRaven
@onready var vulcan_marker: Marker2D = $VulcanRaven/Marker2D

@onready var fire_rate: Timer = $FireRate

@export var SPEED = 200.0

var wait := true
var color: int = 0
var my_floor_active := false
var grounded := true
var stunned := false
var engaged := false
var shooting := false
@onready var laser = preload("res://scenes/laser.tscn")
@onready var bullet = preload("res://scenes/bullet.tscn")
@onready var flame = preload("res://scenes/flame.tscn")

@onready var player: CharacterBody2D

#func _ready() -> void:
	
func set_player(p) -> void:
	player = p

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	var velocity = state.get_linear_velocity()
	set_enemy_type(ENEMY_TYPE)
	if not stunned:	
		if not color:
			color = randi_range(0, 27)
			sprite_2d.frame = color
		if my_floor_active:
			
			if player:
				
				if player.position.x < position.x:
					sprite_container.scale.x = -1
					ray_casts.scale.x = -1
				else:
					sprite_container.scale.x = 1
					ray_casts.scale.x = 1
			
			if shooting:
				shoot()
			
			sight(state, velocity, ENEMY_TYPE)


func sight(state, velocity, ENEMY_TYPE):
	if ENEMY_TYPE == "Vulcan":
		if sight_cast.is_colliding():
			shooting = false
			if ground_detect.is_colliding():
				grounded = true
			else:
				grounded = false
				
			if player and grounded:
				velocity = position.direction_to(player.position) * SPEED
				state.set_linear_velocity(velocity)
		elif sight_cast_2.is_colliding():
			shooting = true
		else:
			shooting = false
	
	if ENEMY_TYPE == "Cyborg" or ENEMY_TYPE == "BlackPhillip":
		if sight_cast.is_colliding():
			shooting = true
			if ground_detect.is_colliding():
				grounded = true
			else:
				grounded = false
				
			if player and grounded:
				velocity = position.direction_to(player.position) * SPEED
				state.set_linear_velocity(velocity)
		else:
			shooting = false
			
func _on_area_2d_body_entered(body: Node2D) -> void:
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
	
func shoot():
	if ENEMY_TYPE == "Vulcan":
		fire_rate.start(0.25)
	if ENEMY_TYPE == "Cyborg":
		fire_rate.start(1.0)
		laser_warning.visible = true
		#laser_warning_timer.start()
	if ENEMY_TYPE == "BlackPhillip":
		fire_rate.start(1.0)

func _on_fire_rate_timeout() -> void:
	var projectile_instance
	if ENEMY_TYPE == "Cyborg":
		laser_warning.visible = false
		projectile_instance = laser.instantiate()
		projectile_instance.position = cyborg_marker.global_position
	elif ENEMY_TYPE == "Vulcan":
		projectile_instance = bullet.instantiate()
		projectile_instance.position = vulcan_marker.global_position
	elif ENEMY_TYPE == "BlackPhillip":
		projectile_instance = flame.instantiate()
		projectile_instance.position = black_phillip_marker.global_position
	
	main.add_child(projectile_instance)

func set_enemy_type(enemy_type: String):
	if enemy_type == "Cyborg":
		$Cyborg/Sprite2D.visible = true
		cyborg.visible = true
		vulcan_raven.visible = false
		black_phillip.visible = false
		sprite_container = $Cyborg
		sight_cast = $Cyborg/RayCasts/RayCast2D
		sight_cast_2 = $Cyborg/RayCasts/RayCast2D
	elif enemy_type == "Vulcan":
		$VulcanRaven/VulcanSprite.frame = color
		cyborg.visible = false
		vulcan_raven.visible = true
		black_phillip.visible = false
		sprite_container = $VulcanRaven
	elif enemy_type == "BlackPhillip":
		physics_material_override.friction = 0.23
		cyborg.visible = false
		vulcan_raven.visible = false
		black_phillip.visible = true
		sprite_container = $BlackPhillip
		sight_cast = $BlackPhillip/RayCasts/RayCast2D
		sight_cast_2 = $BlackPhillip/RayCasts/RayCast2D
	else:
		sprite_container = $SpriteContainer
		sprite_container.visible = true
		cyborg.visible = false
		vulcan_raven.visible = false
		black_phillip.visible = false


func _on_laser_warning_timer_timeout() -> void:
	pass # Replace with function body.
