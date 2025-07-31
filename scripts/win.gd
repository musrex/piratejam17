extends Node2D

@onready var label_2: Label = $Control/HBoxContainer/Label2

func _ready() -> void:
	label_2.text = PlayerStats.player_time
	
	
