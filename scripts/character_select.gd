extends Control

@onready var main = get_node("/root/Main")
@onready var player_scene: PackedScene = load("res://scenes/player.tscn")

@onready var area_2d: Area2D = $Area2D
@onready var char_select_area: CollisionShape2D = area_2d.get_node("CollisionShape2D")


var player_in_area = true
var selected = false

func _ready() -> void:
	spawn_char()

func spawn_char():
	var spawn_zone = char_select_area.shape
	if spawn_zone is RectangleShape2D:
		size = spawn_zone.size
		var spawn_point = Vector2(
			randf_range( -size.x / 2, size.x /2),
			randf_range( -size.y/ 2, size.y /2 )
		)
		
		var global_position = self.global_position + spawn_point
		
		var character = player_scene.instantiate()
		character.global_position = global_position
		main.add_child.call_deferred(character) 
	
func char_select() -> void:
	var player = main.get_node("Player")
	if player_in_area:
		var sprite_2d : Sprite2D = player.get_node("Sprite2D")
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

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
			print("Entered")
			player_in_area = true
			char_select()

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print("Exit")
		player_in_area = false
