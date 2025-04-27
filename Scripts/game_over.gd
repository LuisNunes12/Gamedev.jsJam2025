extends Control

@onready var label_score: Label = $MarginContainer/HBoxContainer/Label_pontos
@onready var label_timer: Label = $MarginContainer2/HBoxContainer2/Label_timer

#=========================================================================================#
func _ready() -> void:
	# Exibe a pontuação e o tempo final, recuperados do singleton Globals.
	label_score.text = "Pontuação: " + str(Globals.pontos)
	label_timer.text = "Tempo: " + Globals.tempo

#=========================================================================================#
func _on_restart_pressed() -> void:
	get_tree().change_scene_to_file("res://Cenas/Game.tscn")

#=========================================================================================#
func _on_quit_game_pressed() -> void:
	get_tree().quit()
