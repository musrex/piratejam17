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
		var sprite_2d_norm : Sprite2D = player.get_node("SpriteContainer/Normal")
		var sprite_2d_jump : Sprite2D = player.get_node("SpriteContainer/Jumping")
		var sprite_2d_ram : Sprite2D = player.get_node("SpriteContainer/Ramming")
		var frame = PlayerStats.sprite_frames
		if Input.is_action_just_pressed("left"):
			if sprite_2d_norm.frame <= 0:
				sprite_2d_norm.frame = 0
				frame = 0 
			else: 
				
				sprite_2d_norm.frame = sprite_2d_norm.frame - 1
				sprite_2d_jump.frame = sprite_2d_jump.frame - 1
				sprite_2d_ram.frame = sprite_2d_ram.frame - 1
				frame -= 1
				PlayerStats.sprite_frames = frame
		if Input.is_action_just_pressed("right"):
			if sprite_2d_norm.frame >= len(range(28)):
				sprite_2d_norm.frame = 28
				frame = 28
			else:
				sprite_2d_norm.frame = sprite_2d_norm.frame + 1
				sprite_2d_jump.frame = sprite_2d_jump.frame + 1
				sprite_2d_ram.frame = sprite_2d_ram.frame + 1
				frame += 1
				PlayerStats.sprite_frames = frame
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
