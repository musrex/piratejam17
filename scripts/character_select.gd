extends Control

@onready var main = get_node("/root/Main")

@onready var char_select_area: Area2D = $CharacterSelect
@onready var select_zone: CollisionShape2D = $CharacterSelect/SelectZone

var player_in_area = false
var selected = false
	
func _process(delta: float) -> void:
	if player_in_area:
		char_select()
	
func char_select() -> void:
	var player = main.get_node("Entities/Player")
	if player_in_area and not selected:
		var sprite_2d : Sprite2D = player.get_node("SpriteContainer/Normal")
		if Input.is_action_just_pressed("left"):
			if sprite_2d.frame <= 0:
				sprite_2d.frame = 0
			else: 
				sprite_2d.frame = sprite_2d.frame - 1
		if Input.is_action_just_pressed("right"):
			if sprite_2d.frame >= len(range(29)):
				sprite_2d.frame = 29
			else:
				sprite_2d.frame = sprite_2d.frame + 1
		if Input.is_action_just_pressed("jump"):
			selected = true

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
			print("Entered")
			player_in_area = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print("Exit")
		player_in_area = false
