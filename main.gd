extends Node2D

@onready var player_scene := preload("res://scenes/player.tscn")
@onready var spawn_points = get_tree().get_nodes_in_group("spawn_points")

#func _ready() -> void:
	#call_deferred("spawn")

func spawn(spawn_location: String = "start") -> void:
	var spawn_pos = null
	for spawn_point in spawn_points:
		if spawn_point.location == spawn_location:
			spawn_pos = spawn_point.global_position
			
	if spawn_pos:
		var player = player_scene.instantiate()
		player.global_position = spawn_pos
		$Entities.add_child(player)
	else:
		push_error("Spawn location not found!:", spawn_location)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print("Player entered.")
		get_tree().call_deferred("reload_current_scene")
	if body.is_in_group("Enemies"):
		body.queue_free()


func _on_spawn_timer_timeout() -> void:
	spawn()
