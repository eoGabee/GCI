extends CharacterBody2D


@export var velocidade:float
@export var gravidade:float
@export var aceleracao:float
@export var impulso_vertical:float
var check_pulo = true

@export var doublejump = false

func movimentacao_horizontal():
	if is_on_floor():
		var direcao_raiz = Input.get_axis("esquerda", "direita")
		var direcao
		if direcao_raiz > 0:
			direcao = 1
		elif direcao_raiz < 0:
			direcao = -1
		
		if direcao:
			velocity.x = lerp(velocity.x, direcao * velocidade, aceleracao)
		else:
			if not is_on_floor():
				velocity.x = velocity.x/1.5
			elif is_on_floor():
				velocity.x = 0

func movimentacao_vertical():
	var checar_input = Input.is_action_just_pressed("cima")
	
	if doublejump:
		if checar_input and check_pulo == true:
			check_pulo = false
			velocity.y = -impulso_vertical*2
		
		if is_on_floor():
			check_pulo = true
	else:
		if checar_input and check_pulo == true:
			velocity.y = -impulso_vertical*2
		
		if not is_on_floor():
			check_pulo = false
		
		if is_on_floor():
			check_pulo = true
		
func _process(delta: float) -> void:
	move_and_slide()
	movimentacao_vertical()
	movimentacao_horizontal()
	velocity.y += gravidade
