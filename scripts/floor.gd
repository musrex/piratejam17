@tool
class_name Floor
extends StaticBody2D

@export var width:= 4.0:
	set(value):
		width = value
#		ensure_child_exists()
		_update_floor()
	
#func _enter_tree() -> void:
#	if Engine.is_editor_hint():
#		ensure_child_exists()
#		_update_floor()

func _ready() -> void:
	#if Engine.is_editor_hint():
	#	ensure_child_exists()
	_update_floor()
	
#func ensure_child_exists() -> void:
#	if not has_node("CollisionShape2D"):
#		var shape = CollisionShape2D.new()
#		shape.name = "CollisionShape2D"
#		shape.shape = RectangleShape2D.new()
#		add_child(shape)
#		shape.owner = get_owner()

#	if not has_node("TileMapLayer"):
#		var tilemap = TileMapLayer.new()
#		tilemap.name = "TileMapLayer"
#		add_child(tilemap)
#		tilemap.owner = get_owner()
#		
#		var default_tileset = preload("res://assets/platforms.png")
#		
#		tilemap.tile_set = default_tileset

func _update_floor() -> void:
	var collision_shape_2d: CollisionShape2D = $CollisionShape2D
	var tile_map_layer: TileMapLayer = $TileMapLayer
	
	if not is_instance_valid(tile_map_layer) or not is_instance_valid(collision_shape_2d):
		return
	
	var tile_size_x = tile_map_layer.tile_set.tile_size.x

	var shape := collision_shape_2d.shape
	if shape is RectangleShape2D:
		shape.extents.x = (width * tile_size_x) / 2.0
		collision_shape_2d.position.x = 0

	tile_map_layer.position.x = -(width * tile_size_x) / 2.0
 
	#tile_map_layer.clear()
	#for x in width:
	#	tile_map_layer.set_cell(Vector2i(x, 0), 1, Vector2i(x, 0))
