extends Control

@onready var label_coin = $Canva/coins

func _process(delta: float) -> void:
	label_coin.text = str(PlayerData.coins)
