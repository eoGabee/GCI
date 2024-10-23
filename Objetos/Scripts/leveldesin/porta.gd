extends StaticBody2D

@export var aberta:bool

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and aberta == true:
		$Col.queue_free()
		$Hitbox.queue_free()
	elif body.is_in_group("Player") and aberta == false:
		if PlayerData.keys > 0:
			$Col.queue_free()
			$Hitbox.queue_free()
