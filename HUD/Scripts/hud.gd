extends Control

@onready var label_coin = $Canva/coins

func _process(_delta: float) -> void:
	label_coin.text = str(PlayerData.coins)
