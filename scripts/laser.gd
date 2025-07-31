extends Area2D

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

@onready var range_timer: Timer = $RangeTimer
@export var SPEED: float
@export var RANGE: float
@export var player: CharacterBody2D

@onready var velocity = Vector2.ZERO

func _ready() -> void:
	if not player:
		var players = get_tree().get_nodes_in_group("Player")
		if players.size() > 0:
			player = players[0]
	
	if player:
		var direction = sign(player.global_position.x - global_position.x)
		velocity = Vector2(direction * SPEED, 0)

		
func _process(delta: float) -> void:
	position += velocity * delta

func _on_range_timer_timeout() -> void:
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.take_damage(10)
		queue_free()
