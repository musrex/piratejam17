extends Label

var elapsed_time := 0.0
var running := true

@onready var timer_label: Label = $"."

func _process(delta: float) -> void:
	if running:
		elapsed_time += delta
		update_timer_label()

func update_timer_label() -> void:
	var minutes := int(elapsed_time) / 60
	var seconds := int(elapsed_time) % 60
	var milliseconds := int((elapsed_time - int(elapsed_time)) * 100)
	timer_label.text = "%02d:%02d.%02d" % [minutes, seconds, milliseconds]

	PlayerStats.player_time = timer_label.text
