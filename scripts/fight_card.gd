extends Control

@onready var fight_card: Control = $"."
@onready var timer: Timer = $Timer
@onready var main = get_node("/root/Main")

var activated = false
var key_lock = true

func _ready() -> void:
	main.activated.connect(_on_boss_trigger_activated)

func _process(delta: float) -> void:
	if activated:
		if not key_lock:
			if Input.is_anything_pressed():
				get_tree().paused = false
				fight_card.visible = false


func _on_timer_timeout() -> void:
	key_lock = false

func _on_boss_trigger_activated():
	timer.start()
