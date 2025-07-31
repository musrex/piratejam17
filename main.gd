extends Node2D

@onready var player_scene := preload("res://scenes/player.tscn")
@onready var spawn_points = get_tree().get_nodes_in_group("spawn_points")
@onready var player : CharacterBody2D
@onready var player_camera : Camera2D
@onready var tutorial_stage: Camera2D = $BossCamera
@onready var goat_theme: AudioStreamPlayer2D = $GoatTheme
@onready var boss_theme: AudioStreamPlayer2D = $BossTheme
@onready var fight_card: Control = $FightCard
@onready var boss_fight = $SpawnPoints/BossFight.global_position

@onready var top_goat = false


var fight_one := false

func _ready() -> void:
	goat_theme.play()

func _process(delta: float) -> void:
	if PlayerStats.health <= 0:
		game_over()

func spawn(last_location: String = "Start") -> void:
	var enemies = get_tree().get_nodes_in_group("Enemies")
	for enemy in enemies:
		enemy.set_player(player)
	var spawn_pos = null
	for spawn_point in spawn_points:
		if spawn_point.location == last_location:
			spawn_pos = spawn_point.global_position
			
	if spawn_pos:
		player = player_scene.instantiate()
		player.global_position = spawn_pos
		$Entities.add_child(player)
		player_camera = player.get_node("Camera2D")
		player_camera.make_current()
		#tutorial_stage.enabled = true

	else:
		push_error("Spawn location not found!:", last_location)

func _on_spawn_timer_timeout() -> void:
	spawn()

func _on_kill_zone_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if PlayerStats.respawn_point == "Start":
			get_tree().call_deferred("reload_current_scene")
		else:
			PlayerStats.health -= 10
			body.queue_free()
			spawn(PlayerStats.respawn_point)
	if body.is_in_group("Enemies"):
		body.queue_free()

func _on_title_card_timer_timeout() -> void:
	var fight_card_container = $FightCardContainer
	for child in fight_card_container.get_children():
		child.visible = false	

	get_tree().paused = false

func game_over():
	get_tree().change_scene_to_file("res://scripts/gameover.tscn")
	queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemies"):
		body.queue_free()
		var players =  get_tree().get_nodes_in_group("Player")
		var player = players[0]
		var player_camera = player.get_node("Camera2D")
		player_camera.make_current()
		top_goat = true
		end_game()

signal activated()

func _on_boss_trigger_body_entered(body: Node2D) -> void:
	if not fight_one and body.is_in_group("Player"):
		emit_signal("activated")
		goat_theme.stop()
		boss_theme.play()
		player = get_node("Entities/Player")
		player_camera = player.get_node("Camera2D")
		print("entering fight")
		fight_card.activated = true
		fight_card.visible = true
		get_tree().paused = true
		fight_card.process_mode = Node.PROCESS_MODE_ALWAYS
		player_camera.enabled = false
		tutorial_stage.enabled = true
		player.global_position = boss_fight

func end_game():
	get_tree().change_scene_to_file("res://scenes/win.tscn")
