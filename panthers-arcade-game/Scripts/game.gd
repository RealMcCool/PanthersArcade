class_name Game extends Node2D

@onready var ui := $UI
#@onready var health_ui := $UI/HealthUI
#@onready var score_ui := $UI/ScoreUI # remove?
#@onready var rewind_ui := $UI/RewindUI # Remove?
@onready var high_score_game_over := $UI/HighScore
@onready var high_score_display := $UI/HighScoreDisplay
@onready var player : Player = $Player
#@onready var rewind_cooldown_timer := $Player/RewindCooldownTimer # remove?
@onready var background := $Background
@onready var score_multiplier_timer := $ScoreMultiplierTimer # remove?
@onready var background_music := $Sounds/BackgroundMusic
@onready var enemy_death := $Sounds/EnemyDeath
#@onready var rewind_color_rect := $UI/RewindColorRect # remove?
@onready var player_death_sound := $Sounds/PlayerDeath
@onready var wave_completion_sound := $Sounds/WaveCompletion

#var rewind_cooldown_percentage := 1.0 # remove?
#var max_rewind_bars := 131 # remove?

var min_score_multiplier := 1.0
var score_multiplier_increment := 0.2
var max_score_multiplier := 2.0
var score_multiplier := min_score_multiplier
var is_game_over := false

var boss_number := 0

 # INFO: Variable for the lives the player has remaining, with an accompanying set function which updates the UI
var lives := 5:
	set(value):
		lives = value
		ui.lives = lives
@export var default_lives := 5

 # INFO: Variable for score

var score := 0:
	set(value):
		score = value
		ui.score = score

 # INFO: Function run only once when the game starts running
func _ready() -> void:
	lives = default_lives
	score = 0
	high_score_game_over.visible = false
	high_score_display.visible = false
	load_scores()
	# Spawn wave 1
	Enemy._current_wave = 1
	var melee_scene = load("res://Scenes/melee_enemy.tscn")
	for i in Enemy.WAVE_INITIAL_ENEMY_COUNT:
		var enemy = melee_scene.instantiate()
		enemy.position = Vector2(randf_range(Enemy.WAVE_SPAWN_X_MIN, Enemy.WAVE_SPAWN_X_MAX), -80.0)
		_connect_enemy_signals(enemy)
		$Enemies.add_child(enemy)

#region Enemies
func _connect_enemy_signals(enemy: Enemy) -> void:
	enemy.enemy_killed.connect(_on_enemy_killed)
	enemy.tree_exited.connect(_on_enemy_removed)


func _spawn_wave() -> void:
	var canvas_transform = get_canvas_transform()
	var screen_top_y = -canvas_transform.origin.y
	var spawn_y = screen_top_y + Enemy.WAVE_SPAWN_Y_OFFSET

	var enemy_count = mini(Enemy.WAVE_INITIAL_ENEMY_COUNT + Enemy._current_wave - 1, Enemy.WAVE_MAX_ENEMY_COUNT)

	var melee_scene = load("res://Scenes/melee_enemy.tscn")
	var ranged_scene = load("res://Scenes/ranged_enemy.tscn")

	for i in enemy_count:
		var enemy_scene: PackedScene
		if Enemy._current_wave <= 2:
			enemy_scene = melee_scene
		else:
			enemy_scene = melee_scene if randf() > 0.5 else ranged_scene

		var enemy = enemy_scene.instantiate()
		var spawn_x = randf_range(Enemy.WAVE_SPAWN_X_MIN, Enemy.WAVE_SPAWN_X_MAX)
		enemy.position = Vector2(spawn_x, spawn_y + randf_range(-30.0, 30.0))
		_connect_enemy_signals(enemy)
		$Enemies.call_deferred("add_child", enemy)

	if Enemy._current_wave % Enemy.WAVE_MINI_BOSS_EVERY == 0:
		var boss_scene = load("res://Scenes/mini_boss.tscn")
		var boss = boss_scene.instantiate()
		boss.position = Vector2((Enemy.WAVE_SPAWN_X_MIN + Enemy.WAVE_SPAWN_X_MAX) / 2.0, spawn_y - 50.0)
		_connect_enemy_signals(boss)
		$Enemies.call_deferred("add_child", boss)
	
	player.start_invincibility(true)


func _on_enemy_killed(score_value) -> void:
	score = score + score_value*score_multiplier
	score_multiplier = snappedf(score_multiplier + score_multiplier_increment, score_multiplier_increment)
	score_multiplier = minf(score_multiplier, max_score_multiplier)
	score_multiplier_timer.start()
	ui.color_multiplier_bar()
	enemy_death.play()


func _on_score_multiplier_timer_timeout() -> void:
	score_multiplier = min_score_multiplier
	pass # Replace with function body.


func _on_enemy_removed() -> void:
	if is_game_over or !is_inside_tree():
		return
	if get_tree().get_node_count_in_group("enemies") > 0:
		return
	#for e in get_tree().get_nodes_in_group("enemies"):
		#if e is Enemy and e.is_inside_tree():
			#return
	Enemy._current_wave += 1
	wave_completion_sound.play()
	_spawn_wave()


func pause_enemies(pause:=true) -> void:
	for i in get_tree().get_nodes_in_group("pausable"):
		i.pause(pause)
	score_multiplier_timer.paused = pause
#endregion


func game_over() -> void:
	if is_game_over:
		return
	is_game_over = true
	for i in get_tree().get_nodes_in_group("enemies"):
		i.set_physics_process(false)
		if i.attack_sound:
			i.attack_sound.stop()
		if i.attack_sound_2:
			i.attack_sound_2.stop()
		i.queue_free()
	for i in get_tree().get_nodes_in_group("enemy_attack"):
		i.queue_free()
	player.set_physics_process(false)
	background_music.stop()
	player_death_sound.play()
	player.get_node("AnimatedSprite2D").play("death")
	await player.get_node("AnimatedSprite2D").animation_finished
	
	$UI/ColorRect.hide()
	
	high_score_game_over.get_node("VBoxContainer/Score").text = str(score)
	high_score_game_over.visible = true
	


 # Fill the rewind bar, and set its transparency
"""
func _physics_process(_delta: float) -> void:
	rewind_ui.fill_rewind_bar(player.rewind_data_length()/player.max_rewind_length * max_rewind_bars)
	rewind_cooldown_percentage = (1 - rewind_cooldown_timer.time_left/rewind_cooldown_timer.wait_time)
	if rewind_cooldown_percentage != 1:
		rewind_ui.modulate = Color(1.0, 1.0, 1.0, rewind_cooldown_percentage/2)
	else:
		rewind_ui.modulate = Color(1.0, 1.0, 1.0, 1.0)
	fill_multiplier_bar(score_multiplier_timer.time_left)
	rewind_color_rect.visible = player.rewinding


func fill_multiplier_bar(time_left) -> void:
	score_ui.fill_cooldown_bar(time_left, score_multiplier)
	color_multiplier_bar()


func color_multiplier_bar() -> void:
	score_ui.color_multiplier_bar(score_multiplier)
"""




#region Save and Load

#save_score() is called when the player dies and the game is over
#load_scores() is called in the _ready() function

@export_global_dir var save_data_path := "user://save_data.tres"
@export var save_data : SaveData

func save_score() -> void:
	ResourceSaver.save(save_data, save_data_path)


func load_scores() -> void:
	save_data = ResourceLoader.load(save_data_path)
	if save_data == null:
		save_data = load("res://Z - Other files/default_save_data.tres")

#func _exit_tree() -> void:
	#save_score()
#endregion

func _on_background_music_finished() -> void:
	background_music.play()
