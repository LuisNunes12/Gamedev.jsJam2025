extends Control

@onready var label_score: Label = $MarginContainer/HBoxContainer/Label_pontos

func _ready() -> void:
	# Exibe a pontuação e o tempo final, recuperados do singleton Globals.
	label_score.text = "Pontuação: " + str(Globals.pontos)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
