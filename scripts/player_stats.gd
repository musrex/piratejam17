extends Node

signal health_changed(health)

var health: float = 100.0:
	set(value):
		health = clamp(value, 0, max_health)
		emit_signal("health_changed", health)
var max_health: float = 100.0

var player_time : String = "00:00.0"
var sprite_frames : int = 0

var respawn_point: String = "Start"
