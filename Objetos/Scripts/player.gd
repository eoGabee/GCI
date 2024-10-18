extends CharacterBody2D


@export var velocidade:float
@export var gravidade:float
@export var aceleracao:float
@export var aceleracao_aerea:float
@export var aceleracao_parada:float
@export var impulso_vertical:float
var check_pulo = true

@export var arma:int  # 1-espada

@export var doublejump_ = false
var can_doubleJump = true

func movimentacao_horizontal():
	var direcao = Input.get_axis("esquerda", "direita")
	
	if direcao and not is_on_floor():
		velocity.x = lerp(velocity.x, direcao * velocidade, aceleracao_aerea)
	
	if direcao and is_on_floor():
		velocity.x = lerp(velocity.x, direcao * velocidade, aceleracao)

	else:
		velocity.x = lerp(velocity.x, 0.0, aceleracao_parada)

	if direcao != 0:
		PlayerData.side = direcao

func movimentacao_vertical():
	var _checar_input = Input.is_action_just_pressed("cima")
	doublejump()
	pulo_base()
	
	if is_on_floor():
		check_pulo = true
		can_doubleJump = true

	elif not is_on_floor():
		check_pulo = false

func doublejump():
	var checar_input = Input.is_action_just_pressed("cima")
	if doublejump_:
		if checar_input and can_doubleJump:
			can_doubleJump = false
			velocity.y = -impulso_vertical * 1.5

func pulo_base():
	var checar_input = Input.is_action_just_pressed("cima")
	if checar_input and check_pulo == true:
		velocity.y = -impulso_vertical*2

func ataque():
	var anim = $Anim
	if Input.is_action_just_pressed("Ataque"):
		match arma:
			1:
				anim.play("ataque_espada")

func trocaLado_Hitbox():
	if PlayerData.side == 1:
		$HitBox_espada.position.x = 31
	elif PlayerData.side == -1:
		$"HitBox_espada".position.x = -31

func _process(_delta: float) -> void:
	move_and_slide()
	movimentacao_vertical()
	movimentacao_horizontal()
	trocaLado_Hitbox()
	ataque()
	velocity.y += gravidade
