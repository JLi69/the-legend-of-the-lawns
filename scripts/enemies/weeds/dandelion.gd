extends WeedEnemy

const SPREAD: float = PI / 5.0

func shoot() -> void:
	for i in range(3):
		var offset = SPREAD * (float(i) - 1.0)
		shoot_bullet(offset)

func _on_hit() -> void:
	if randi() % 2 == 0:
		call_deferred("shoot_bullet")

