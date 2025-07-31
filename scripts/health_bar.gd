extends TextureProgressBar

func _ready() -> void:
	max_value = PlayerStats.max_health
	value = PlayerStats.health
	PlayerStats.health_changed.connect(_on_health_changed)
	
func _on_health_changed(new_value):
	value = new_value
