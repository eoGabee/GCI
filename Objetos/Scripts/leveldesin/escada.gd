extends StaticBody2D


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("baixo"):
		$Col.disabled = true
		$Cooldown.start()

func _on_cooldown_timeout() -> void:
	$Col.disabled = false
