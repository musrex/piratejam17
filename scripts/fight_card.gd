class_name FightCard
extends Control

@export var enemy_name_string: String

func _ready() -> void:
	# Set the size of the FightCard (Control node)
	set_anchors_preset(Control.PRESET_TOP_LEFT)
	custom_minimum_size = Vector2(320, 180)

	# Create black background
	var background = ColorRect.new()
	background.color = Color.BLACK
	background.anchor_right = 1.0
	background.anchor_bottom = 1.0
	background.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	background.size_flags_vertical = Control.SIZE_EXPAND_FILL
	add_child(background)

	# Create container with padding
	var container = MarginContainer.new()
	container.set_anchors_preset(Control.PRESET_FULL_RECT)
	container.add_theme_constant_override("margin_left", 10)
	container.add_theme_constant_override("margin_right", 10)
	container.add_theme_constant_override("margin_top", 10)
	container.add_theme_constant_override("margin_bottom", 10)
	add_child(container)

	# Create and configure label
	var enemy_name = Label.new()
	enemy_name.text = enemy_name_string
	enemy_name.autowrap_mode = TextServer.AUTOWRAP_WORD
	enemy_name.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	enemy_name.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	enemy_name.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	enemy_name.size_flags_vertical = Control.SIZE_EXPAND_FILL

	container.add_child(enemy_name)
