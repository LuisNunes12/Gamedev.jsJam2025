extends Node2D

# Pré-carrega as cenas dos inimigos
const RED_GOBLIN_SCENE: PackedScene = preload("res://Cenas/BlueGoblin.tscn")
const BLUE_GOBLIN_SCENE: PackedScene = preload("res://Cenas/RedGoblin.tscn")

# Array com os tipos de inimigos
var enemy_scenes: Array = [RED_GOBLIN_SCENE, BLUE_GOBLIN_SCENE]

@onready var spawn_sound: AudioStreamPlayer = $SpawnSound  # Nó de som do spawn
@onready var game_timer: Timer = $GameTimer  # Nó de Timer para os 3 minutos

var spawn_interval_min: float = 2.0  # Intervalo mínimo de spawn (em segundos)
var spawn_interval_max: float = 5.0  # Intervalo máximo de spawn (em segundos)
var spawn_speed_increased: bool = false  # Flag para garantir que o aumento ocorra apenas uma vez

#=========================================================================================#
func _ready() -> void:
	randomize()  # Garante variabilidade nos números aleatórios
	
	# Configure o GameTimer para disparar depois de 3 minutos
	game_timer.wait_time = 180.0  # 3 minutos
	game_timer.one_shot = true     # Dispara apenas uma vez
	game_timer.timeout.connect(_increase_spawn_speed)
	game_timer.start()             # Inicia explicitamente o Timer
	
	spawn_enemy_loop()

#=========================================================================================#
func spawn_enemy_loop() -> void:
	# Define um intervalo aleatório de spawn com base nos valores atuais
	var wait_time: float = randf_range(spawn_interval_min, spawn_interval_max)
	await get_tree().create_timer(wait_time).timeout
	
	spawn_enemy()
	spawn_enemy_loop()  # Continua o loop de spawns

#=========================================================================================#
func spawn_enemy() -> void:
	# Seleciona aleatoriamente uma cena de inimigo
	var scene_index: int = randi() % enemy_scenes.size()
	var enemy_scene: PackedScene = enemy_scenes[scene_index]
	var enemy_instance: Node = enemy_scene.instantiate()
	
	# Define uma posição de spawn aleatória dentro da viewport
	var viewport_size: Vector2 = get_viewport_rect().size
	enemy_instance.position = Vector2(
		randf_range(0, viewport_size.x),
		randf_range(0, viewport_size.y)
	)
	
	add_child(enemy_instance)
	
	# Reproduz o som de spawn
	spawn_sound.play()

#=========================================================================================#
func _increase_spawn_speed() -> void:
	if not spawn_speed_increased:
		spawn_speed_increased = true  # Garante que modifique os intervalos apenas uma vez
		# Reduzir os intervalos pela metade torna o spawn 2x mais rápido.
		spawn_interval_min *= 0.5  # De 2.0 para 1.0 segundo
		spawn_interval_max *= 0.5  # De 5.0 para 2.5 segundos
		print("Velocidade de spawn aumentada 2x! Novos intervalos:", spawn_interval_min, "a", spawn_interval_max)
