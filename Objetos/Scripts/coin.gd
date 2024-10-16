extends Area2D

@export var gravidade:float

@onready var raycast = $RayCast2D

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("cima"):
		bounce()
	
	if not raycast.is_colliding():
		position.y += gravidade

func body_on(body: Node2D) -> void:
	if body.is_in_group("Player"):
		PlayerData.coins += 1
		queue_free()

func bounce():
	position.y -= (gravidade/2)
