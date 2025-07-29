extends Area2D

@onready var range_timer: Timer = $RangeTimer
@export var SPEED: float
@export var RANGE: float
@export var player: CharacterBody2D

@onready var velocity = Vector2.ZERO

func _ready() -> void:
	range_timer.start(RANGE)

	if not player:
		var players = get_tree().get_nodes_in_group("Player")
		if players.size() > 0:
			player = players[0]
	
	if player:
		velocity = global_position.direction_to(player.global_position) * SPEED

func _process(delta: float) -> void:
	position += velocity * delta

func _on_range_timer_timeout() -> void:
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.take_damage()
		queue_free()
