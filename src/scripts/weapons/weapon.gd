class_name Weapon
extends Node2D

@export var config: WeaponConfig

var current_ammo: int = 0
var _cooldown_remaining: float = 0.0
var _is_reloading: bool = false


func _ready() -> void:
	if config:
		current_ammo = config.mag_size


func _physics_process(delta: float) -> void:
	_cooldown_remaining = max(0.0, _cooldown_remaining - delta)


func try_fire(target_position: Vector2) -> bool:
	if _is_reloading or _cooldown_remaining > 0.0 or current_ammo <= 0:
		return false
	if config == null or config.bullet_scene == null:
		return false
	current_ammo -= 1
	_cooldown_remaining = 60.0 / config.fire_rate_rpm
	var bullet := config.bullet_scene.instantiate()
	bullet.global_position = global_position
	var direction := (target_position - global_position).normalized()
	var spread := deg_to_rad(randf_range(-config.spread_degrees, config.spread_degrees))
	direction = direction.rotated(spread)
	# Bullets must expose: direction (Vector2), speed (float), damage (int), max_distance (float)
	bullet.set("direction", direction)
	bullet.set("speed", config.bullet_speed)
	bullet.set("damage", config.damage_per_shot)
	bullet.set("max_distance", config.effective_range_pixels)
	get_tree().current_scene.add_child(bullet)
	return true


func reload() -> void:
	if _is_reloading or current_ammo == config.mag_size:
		return
	_is_reloading = true
	await get_tree().create_timer(config.reload_seconds).timeout
	current_ammo = config.mag_size
	_is_reloading = false
