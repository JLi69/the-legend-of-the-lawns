extends PlayerBullet

@export var explosion_scene: PackedScene

func explode() -> void:
	super.explode()

	var lawn: Lawn = get_node_or_null("/root/Main/Lawn")
	if lawn == null:
		return

	var explosion: Explosion = explosion_scene.instantiate()
	explosion.global_position = global_position
	explosion.scale *= 0.3
	explosion.modulate = Color8(20, 100, 255)
	explosion.damage = 5
	explosion.can_damage_mobile = true
	explosion.can_damage_plants = true
	lawn.call_deferred("add_child", explosion)
	Sfx.play_at_pos(global_position, "explosion", lawn, 0.25)
