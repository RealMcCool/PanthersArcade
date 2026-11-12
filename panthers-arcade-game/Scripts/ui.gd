extends CanvasLayer


@onready var rewind_color_rect := $RewindColorRect
@onready var rewind_ui := $RewindUI
@onready var health_ui := $HealthUI
@onready var score_ui := $ScoreUI
@onready var game_node : Game = get_parent()
@onready var player : Player# = $"../Player"
@onready var rewind_cooldown_timer : Timer # = $Player/RewindCooldownTimer
var rewind_cooldown_percentage := 1.0
@onready var score_multiplier_timer : Timer # = $ScoreMultiplierTimer
var max_rewind_bars := 131

var lives := 5:
	set(value):
		if health_ui:
			health_ui.init_lives(lives)

var score := 0:
	set(value):
		#score = value
		score_ui.score = score

# In this class, move all the logic for updating the UI nodes

func _enter_tree() -> void:
	game_node = get_tree().get_first_node_in_group("game")
	player = get_tree().get_first_node_in_group("player")
	rewind_cooldown_timer = player.get_node("RewindCooldownTimer")
	score_multiplier_timer = game_node.get_node("ScoreMultiplierTimer")


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
	score_ui.fill_cooldown_bar(time_left, game_node.score_multiplier)
	color_multiplier_bar()


func color_multiplier_bar() -> void:
	score_ui.color_multiplier_bar(game_node.score_multiplier)
