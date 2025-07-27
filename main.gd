extends Node2D

@onready var player_scene := preload("res://scenes/player.tscn")
@onready var spawn_points = get_tree().get_nodes_in_group("spawn_points")
@onready var player : CharacterBody2D
@onready var player_camera : Camera2D
@onready var tutorial_stage: Camera2D = $CameraContainer/TutorialStage
@onready var title_card_scene = preload("res://scenes/fight_card.tscn")
@onready var title_card_timer: Timer = $TitleCardTimer

var fight_one := false


#func _ready() -> void:
	#call_deferred("spawn")

func spawn(spawn_location: String = "start") -> void:
	var spawn_pos = null
	for spawn_point in spawn_points:
		if spawn_point.location == spawn_location:
			spawn_pos = spawn_point.global_position
			
	if spawn_pos:
		player = player_scene.instantiate()
		player.global_position = spawn_pos
		$Entities.add_child(player)
		player_camera = player.get_node("Camera2D")
		player_camera.make_current()
		tutorial_stage.enabled = true
	else:
		push_error("Spawn location not found!:", spawn_location)

func _on_spawn_timer_timeout() -> void:
	spawn()

func _on_tutorial_start_body_entered(body: Node2D) -> void:
	print("entering fight")
	if not fight_one and body.is_in_group("Player"):
		body.velocity.x = 0
		print("Fight 1")
		fight_one = true
		$FightCardContainer/TitleCard1.visible = true
		title_card_timer.start()
		title_card_timer.process_mode = Node.PROCESS_MODE_ALWAYS
		get_tree().paused = true
		
		if player_camera:
			tutorial_stage.make_current()
			print(player_camera.is_current())

func _on_kill_zone_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print("Player entered.")
		get_tree().call_deferred("reload_current_scene")
	if body.is_in_group("Enemies"):
		body.queue_free()

func _on_title_card_timer_timeout() -> void:
	var fight_card_container: CanvasLayer = $FightCardContainer
	for child in fight_card_container.get_children():
		child.visible = false
		
	get_tree().paused = false
