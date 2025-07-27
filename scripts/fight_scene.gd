@tool

class_name FightScene
extends Node2D

var fight_complete := false

@export var width := 4.0:
	set(value):
		width = value
		_update_boundary()
	get:
		return width

func _ready() -> void:
	if Engine.is_editor_hint():
		#call_deferred("_update_boundary")
		_update_boundary()
	
func _update_boundary() -> void:
	#var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D
	var tile_map_layer: TileMapLayer = $TileMapLayer
	
	#if not is_instance_valid(collision_shape_2d) and not is_instance_valid(tile_map_layer):
	#	return
	
	var tile_size_x = tile_map_layer.tile_set.tile_size.x

	#var shape := collision_shape_2d.shape
	#if shape is RectangleShape2D:
	#	shape.extents.x = (width * tile_size_x) / 2.0
	#	collision_shape_2d.position.x = 0

	tile_map_layer.position.x = -(width * tile_size_x) / 2.0

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemies"):
		print("Bam! Dead.")
		body.queue_free()
		var player =  get_node("/root/Main/Entities/Player")
		var player_camera = player.get_node("Camera2D")
		player_camera.make_current()
