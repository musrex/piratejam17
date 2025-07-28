
extends CharacterBody2D
@onready var health: int
@onready var stamina: int
@onready var flash: ColorRect = $Flash

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var ground_check: RayCast2D = $GroundCheck
@onready var sprite_2d: Sprite2D = $SpriteContainer/Normal
@onready var ramming: Sprite2D = $SpriteContainer/Ramming
@onready var jumping: Sprite2D = $SpriteContainer/Jumping
@onready var eating: Sprite2D = $SpriteContainer/Eating
@onready var sprite_container: Node2D = $SpriteContainer
@onready var ram_to_right: Area2D = $RamToRight
@onready var ram_to_left: Area2D = $RamToLeft

@export var MAX_SPEED = 300.0;
@export var SPEED = 250.0;
@export var JUMP_FORCE = -400.0;
@export var RAM_FORCE: float;
@export_range(0.0, 1.0) var ACCELERATION;
@export_range(0.0, 1.0) var DECELERATION;
@export var POP_UP: float = 0.5;
@export var PUSH_BACK: float = 1.0;


var GRAVITY = 2000.0

# Coyote Time
@export var coyote_frames := 6
var coyote := false
var last_floor := false
@onready var coyote_timer: Timer = $CoyoteTimer
@onready var ram_locked := false

# Momentum stuff
# WORRY ABOUT IT LATER
var momentum = 0.0;
var mass_max = 1000;
var mass_temp = 10.0;

var is_jumping := false

func _ready() -> void:
	for enemy in get_tree().get_nodes_in_group("Enemies"):
		print(enemy)
		enemy.set_player(self)
	
	coyote_timer.wait_time = coyote_frames / 60.0
	
func _physics_process(delta: float) -> void:
	if not ram_locked:
		
		# Movement inputs
		var move_left := Input.is_action_pressed("left")
		var move_right := Input.is_action_pressed("right")
		var jump := Input.is_action_just_pressed("jump")
		var down := Input.is_action_pressed("down")
		
		# States
		var is_ramming := false
	
		
		velocity.y += GRAVITY * delta
		
		if move_left:
			velocity.x = lerp(velocity.x, -SPEED, ACCELERATION)
			sprite_container.scale.x = -1
		elif move_right:
			velocity.x = lerp(velocity.x, SPEED, ACCELERATION)
			sprite_container.scale.x = 1
		else:
			velocity.x = lerp(velocity.x, 0.0, DECELERATION)
	
		if move_left and down:
			ram_to_right.monitoring = false
			ram_to_left.monitoring = true
		elif move_right and down:
			ram_to_right.monitoring = true
			ram_to_left.monitoring = false
		else:
			ram_to_left.monitoring = false
			ram_to_right.monitoring = false
	
		if jump and is_on_floor() or coyote:
			velocity.y = JUMP_FORCE
			is_jumping = true
			
		if not is_on_floor() and last_floor and !jumping:
			coyote_timer.start()
		
		move_and_slide()
		
		last_floor = is_on_floor()
			
		var is_grounded := ground_check.is_colliding()
			
		if is_grounded and velocity.y == 0.0:
			is_jumping = false
	
		if is_jumping:
			pick_state("Jumping")
		elif down:
			pick_state("Ramming")
		else: 
			pick_state("Normal")

func pick_state(state: String) -> void:
	var parent = sprite_container.get_children()
	for child in parent:
		if child.name == state:
			child.visible = 1
		else:
			child.visible = 0
			
func _on_ram_to_right_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemies"):
		print("POW!")
		print(body)
		ram(body)

func _on_ram_to_left_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemies"):
		print("POW!")
		print(body)
		ram(body)

func ram(body):
		var dir = sign(sprite_container.scale.x)
		var momentum = velocity.length()
		if momentum < 0.01:
			momentum = 1
		var force = Vector2(PUSH_BACK, POP_UP) * momentum * dir
		body.apply_impulse(force, body.position)
		body.add_collision_exception_with(self)
		body.stun()
		ram_lock()
		animation_player.play("flash_hit")
		body.remove_collision_exception_with(self)
		print("Dir: ", dir)
		print("Force: ", force)

@onready var lock: Timer = $Lock

func ram_lock() -> void:
	if lock.is_stopped():
		ram_locked = true
		lock.start()
		velocity = Vector2.ZERO
	
func _on_coyote_timer_timeout() -> void:
	coyote = false

func _on_lock_timeout() -> void:
	print("Unlocking RAM")
	velocity = Vector2.ZERO
	ram_locked = false	
