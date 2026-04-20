extends MobileEnemy

var speed_up_timer: float = 0.0
var pause_timer: float = 0.0
var pause_timer_cooldown: float = 0.0
var hostile: bool = false

const ANGER_TEXT: String = """MY POOR FLUFFY!!! 
YOU MONSTER!!!
"""

func get_animation() -> String:
	if velocity.length() == 0.0:
		return "idle"

	if velocity.normalized().dot(Vector2.DOWN) > 0.9:
		return "walking"

	return "walking_side"

func calculate_velocity() -> Vector2:
	if !hostile or pause_timer > 0.0:
		return Vector2.ZERO

	var enemy_speed: float = player.speed
	if (global_position - player.global_position).length() > 32.0 and speed_up_timer <= 0.0:
		enemy_speed *= 1.2
	else:
		enemy_speed *= 0.8
	enemy_speed = clamp(enemy_speed, 48.0, 96.0)
	return super.calculate_velocity().normalized() * enemy_speed

func _process(delta: float) -> void:	
	pause_timer = max(pause_timer - delta, 0.0)
	speed_up_timer = max(speed_up_timer - delta, 0.0)
	pause_timer_cooldown = max(pause_timer_cooldown - delta, 0.0)
	if (global_position - player.global_position).length() <= 32.0:
		speed_up_timer = 1.0
	super._process(delta)
	set_sprite_dir()
	$ContactDamageZone.disabled = !hostile
	if lawn.killed_rabbit and !hostile:
		$/root/Main/HUD.alert("Mrs. Poofball", ANGER_TEXT, "RUN!", true)
		$FemaleTalk.play()
		hostile = true

func damage(_amt: int) -> void:
	hit.emit()

func _on_hit() -> void:
	if !hostile:
		return
	if pause_timer_cooldown <= 0.0:
		pause_timer = 3.0
	pause_timer_cooldown = 8.0
