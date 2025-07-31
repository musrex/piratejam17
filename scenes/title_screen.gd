extends Node2D
@onready var label: Label = $MarginContainer/Label
@onready var timer: Timer = $Timer

func _ready() -> void:
	timer.start()

func _process(delta: float) -> void:	
	if Input.is_anything_pressed():
		get_tree().change_scene_to_file("res://scenes/main.tscn")
		queue_free()

func _on_timer_timeout() -> void:
	label.visible = true
