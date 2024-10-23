extends  CharacterBody2D

@export var velocidade:float
@export var gravidade:float
@export var aceleracao:float

var detectouJogador:bool

enum StateMachine{
	SEGUINDO,
	COMBATE,
	MECANICA
}
var state

func StateCore():
	match state:
		0:
			motion()

func combate():
	pass

func motion():
	if detectouJogador:
		velocity.x = lerp(velocity.x, get_direction()*velocidade, aceleracao)

func get_direction():
	if detectouJogador:
		var dir = (position.x -  PlayerData.ref.position.x)
		if dir > 0:
			return -1
		elif dir < 0:
			return 1
	else:
		for i in randi_range(-1, 1):
			if i != 0:
				return i
			pass
		pass

func stateManagement():
	if detectouJogador:
		state = StateMachine.SEGUINDO

func _process(_delta: float) -> void:
	StateCore()
	stateManagement()
	side_view()
	move_and_slide()
	velocity.y += gravidade

func side_view():
	match get_direction():
		1:
			$Campo_de_visao/Col.position.x = 88
		-1:
			$Campo_de_visao/Col.position.x = -88

func _on_campo_de_visao_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		detectouJogador = true
