extends Node2D

func _ready() -> void:
	PlayerStats.health = 100.0

func _process(delta: float) -> void:
	if Input.is_anything_pressed():
		get_tree().change_scene_to_file("res://scenes/main.tscn")
		queue_free()
