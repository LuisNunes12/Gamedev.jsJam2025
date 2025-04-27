extends Control

@onready var label_pontos: Label = $MarginContainer/Pontos/Label_pontos
@onready var label_timer: Label = $MarginContainer/Timer/Label_timer
@onready var timer: Timer = $Timer
@onready var enemy_balance_bar: ProgressBar = $EnemyBalanceBar

var minutes = 0
var seconds = 0
@export_range(0, 5) var default_minutes := 1
@export_range(0, 59) var default_seconds := 0

# Flag para evitar múltiplas trocas de cena
var game_over_triggered = false

#=========================================================================================#
func _ready() -> void:
	label_pontos.text = str("%03d" % Globals.pontos)
	label_timer.text = str("%02d" % default_minutes) + ":" + str("%02d" % default_seconds)
	reser_clock_timer()
	
	enemy_balance_bar.min_value = 0
	enemy_balance_bar.max_value = 100
	enemy_balance_bar.value = 50

#=========================================================================================#
func _process(delta: float) -> void:
	label_pontos.text = str("%03d" % Globals.pontos)
	update_enemy_counts()

#=========================================================================================#
func _on_timer_timeout() -> void:
	if seconds == 0:
		if minutes > 0:
			minutes -= 1
			seconds = 59
		else:
			timer.stop()
			get_tree().change_scene_to_file("res://Cenas/victory.tscn")
	else:
		seconds -= 1

	label_timer.text = str("%02d" % minutes) + ":" + str("%02d" % seconds)

#=========================================================================================#	
func reser_clock_timer():
	minutes = default_minutes
	seconds = default_seconds

#=========================================================================================#
func update_enemy_counts() -> void:
	var enemy_count_a: int = get_tree().get_nodes_in_group("EnemyA").size()
	var enemy_count_b: int = get_tree().get_nodes_in_group("EnemyB").size()
	var total: int = enemy_count_a + enemy_count_b

	if total == 0:
		enemy_balance_bar.value = 50
	else:
		var ratio: float = (enemy_count_a - enemy_count_b) / float(total)
		enemy_balance_bar.value = (ratio + 1) * 50

	if not game_over_triggered and (enemy_balance_bar.value < 30 or enemy_balance_bar.value > 70):
		game_over_triggered = true
		Globals.tempo = str("%02d" % minutes) + ":" + str("%02d" % seconds)
		get_tree().change_scene_to_file("res://Cenas/GameOver.tscn")
