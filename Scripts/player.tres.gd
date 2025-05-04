extends CharacterBody2D

const SPEED = 300.0

@onready var anim: AnimatedSprite2D = $Animação
@onready var attack_area: Area2D = $AttackArea
@onready var attack_sound: AudioStreamPlayer = $AttackSound  # Certifique-se de ter adicionado um nó AudioStreamPlayer à cena

# Flag para controlar se o personagem está atacando
var is_attacking: bool = false

#=========================================================================================#
func _ready() -> void:
	# Inicialmente, a área de ataque não detecta colisões
	attack_area.monitoring = false
	# Conecta o sinal de colisão para tratar o ataque imediatamente
	attack_area.body_entered.connect(_on_attack_area_body_entered)
	# Conecta o sinal de término da animação para liberar o ataque e verificar colisões pendentes
	anim.animation_finished.connect(_on_animation_finished)

#=========================================================================================#
func _physics_process(_delta: float) -> void:
	# Se não estivermos atacando, permite o movimento
	if not is_attacking:
		var direction = Vector2.ZERO
		# Verifica as teclas para movimento à esquerda: seta esquerda e tecla "A" (ou a ação "move_left")
		if Input.is_action_pressed("move_left") or Input.is_action_pressed("ui_left"):
			direction.x -= 1
		# Verifica as teclas para movimento à direita: seta direita e tecla "D" (ou a ação "move_right")
		if Input.is_action_pressed("move_right") or Input.is_action_pressed("ui_right"):
			direction.x += 1
		# Verifica as teclas para movimento para cima: seta para cima e tecla "W" (ou a ação "move_up")
		if Input.is_action_pressed("move_up") or Input.is_action_pressed("ui_up"):
			direction.y -= 1
		# Verifica as teclas para movimento para baixo: seta para baixo e tecla "S" (ou a ação "move_down")
		if Input.is_action_pressed("move_down") or Input.is_action_pressed("ui_down"):
			direction.y += 1

		if direction.length() > 0:
			direction = direction.normalized()
			velocity = direction * SPEED
		else:
			velocity = Vector2.ZERO

		# Inicia o ataque se a ação implementada (por exemplo, "ui_accept") for pressionada
		if Input.is_action_just_pressed("ui_accept"):
			attack()
	else:
		velocity = Vector2.ZERO

	# Atualiza as animações dependendo do movimento
	if not is_attacking:
		if velocity.length() > 0:
			anim.play("Run")
			# Ajuste visual para inverter a animação conforme a direção
			anim.flip_h = velocity.x < 0
		else:
			anim.play("Idle")
	
	# O método move_and_slide() movimenta o personagem com base na velocidade configurada
	move_and_slide()

#=========================================================================================#
func attack() -> void:
	is_attacking = true
	anim.play("Attack")
	attack_sound.play()  # Reproduz o som do ataque
	
	# Sincroniza a ativação da área de ataque com a animação
	await get_tree().create_timer(0.2).timeout
	attack_area.monitoring = true
	await get_tree().create_timer(0.2).timeout
	attack_area.monitoring = false

#=========================================================================================#
func _on_animation_finished() -> void:
	# Quando a animação de ataque termina, verifica se há inimigos na área de ataque
	if anim.animation == "Attack":
		for body in attack_area.get_overlapping_bodies():
			if body.is_in_group("inimigos"):
				print("Ataque atingiu (via overlapping): ", body.name)
				Globals.pontos += 10
				body.queue_free()
		# Libera o personagem para realizar novas ações
		is_attacking = false

#=========================================================================================#
func _on_attack_area_body_entered(body: Node) -> void:
	# Se o ataque estiver ativado no momento da colisão, trata o impacto
	if is_attacking and anim.animation == "Attack":
		print("Ataque atingiu: ", body.name)
		if body.is_in_group("inimigos"):
			Globals.pontos += 10
			body.queue_free()
