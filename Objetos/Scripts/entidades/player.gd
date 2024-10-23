extends CharacterBody2D

@export var vida:float
@export var velocidade: float
@export var gravidade: float
@export var aceleracao: float
@export var aceleracao_aerea: float
@export var aceleracao_parada: float
@export var impulso_de_ataque:float
@export var impulso_vertical: float
@export var velocidade_abaixado: float
@export var dash_force: float
@export var arma: int  # 0-espada
@export var doublejump_: bool = false

var batendo: bool = false
var desviando: bool = false
var abaixado: bool = false
var knockbacked:bool = false
var can_doubleJump: bool = true
var check_pulo: bool = true
var velocidade_real: float

func movimentacao_horizontal():
	if not batendo and not knockbacked:
		var direcao = Input.get_axis("esquerda", "direita")
		
		if direcao:
			if is_on_floor():
				velocity.x = lerp(velocity.x, direcao * velocidade_real, aceleracao)
			else:
				velocity.x = lerp(velocity.x, direcao * velocidade_real, aceleracao_aerea)
		else:
			velocity.x = lerp(velocity.x, 0.0, aceleracao_parada)

		if direcao != 0:
			PlayerData.side = direcao
	else:
		velocity.x = lerp(velocity.x, 0.0, aceleracao_parada)

func movimentacao_vertical():
	if not batendo and not desviando:
		if not knockbacked:
			doublejump()
			pulo_base()
	
	if is_on_floor():
		check_pulo = true
		can_doubleJump = true
	else:
		check_pulo = false

	abaixado = Input.is_action_pressed("baixo")

func doublejump():
	if doublejump_ and Input.is_action_just_pressed("cima") and can_doubleJump:
		can_doubleJump = false
		velocity.y = -impulso_vertical * 1.5

func pulo_base():
	if Input.is_action_just_pressed("cima") and check_pulo:
		velocity.y = -impulso_vertical * 2

func ataque():
	if Input.is_action_just_pressed("Ataque") and not knockbacked:
		var anim = $Anim
		if arma == 0:
			velocity.y = 0
			batendo = true
			anim.play("ataque_espada")
			if not abaixado:
				velocity.x += PlayerData.side*100

func abaixar():
	if not knockbacked:
		if abaixado and is_on_floor():
			$Col.disabled = true
			$Col2.disabled = false
			velocidade_real = velocidade_abaixado
		else:
			$Col.disabled = false
			$Col2.disabled = true
			velocidade_real = velocidade

func dash():
	if Input.is_action_just_pressed("Dash") and is_on_floor() and not batendo and not abaixado and not knockbacked:
		desviando = true
		$Timers/Dash_Cooldown.start()
		velocity.x = -PlayerData.side * dash_force

func trocaLado_Hitbox():
	var pos_x: float
	var pos_y: float
	
	if abaixado and is_on_floor():
		if PlayerData.side == 1:
			pos_x = 31
			pos_y = 15
		elif PlayerData.side == -1:
			pos_x = -31
			pos_y = 15
	else:
		if PlayerData.side == 1:
			pos_x = 31
			pos_y = 0
		elif PlayerData.side == -1:
			pos_x = -31
			pos_y = 0

	$HitBox_espada.position = Vector2(pos_x, pos_y)

func _process(_delta: float) -> void:
	move_and_slide()
	movimentacao_vertical()
	movimentacao_horizontal()
	trocaLado_Hitbox()
	ataque()
	abaixar()
	dash()
	
	if not batendo and not is_on_floor():
		velocity.y += gravidade

func knockBack():
	knockbacked = true


func _enter_tree() -> void:
	PlayerData.ref = self

func _on_anim_animation_finished(anim_name: StringName) -> void:
	if anim_name == "ataque_espada":
		batendo = false
		
func _on_dash_cooldown_timeout() -> void:
	desviando = false
