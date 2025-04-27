extends CharacterBody2D

const SPEED = 75.0

# Armazena a direção atual de movimento
var random_direction: Vector2 = Vector2.ZERO

# Referência ao AnimatedSprite2D que contém as animações
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

#=========================================================================================#
func _ready() -> void:
	randomize()  # Garante que os números aleatórios sejam diferentes a cada execução
	choose_new_direction()  # Inicia o ciclo de mudança de direção

#=========================================================================================#
# Função para escolher uma nova direção aleatória e agendar a próxima alteração
func choose_new_direction() -> void:
	# Gera números aleatórios para os eixos X e Y no intervalo [-1, 1]
	var x = randf_range(-1.0, 1.0)
	var y = randf_range(-1.0, 1.0)
	random_direction = Vector2(x, y).normalized()
	
	# Define um intervalo aleatório entre 1 e 3 segundos para a próxima mudança
	var wait_time = randf_range(1.0, 3.0)
	
	# Aguarda o tempo definido para alterar a direção novamente usando await
	await get_tree().create_timer(wait_time).timeout
	choose_new_direction()  # Chama a função novamente para manter o movimento aleatório

#=========================================================================================#
func _physics_process(delta: float) -> void:
	velocity = random_direction * SPEED
	
	# Verifica se o inimigo está se movendo para ativar a animação de corrida
	if velocity.length() > 0:
		anim.play("Run")
		# Opcional: inverte a sprite conforme a direção (se necessário)
		anim.flip_h = velocity.x < 0
	else:
		anim.play("Idle")
		
	# Aplica o movimento e trata colisões
	move_and_slide()
