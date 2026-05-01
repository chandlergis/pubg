class_name WeaponConfig
extends Resource

@export var display_name: String = ""
@export var damage_per_shot: int = 30
@export var fire_rate_rpm: float = 600.0
@export var mag_size: int = 30
@export var reload_seconds: float = 2.5
@export var spread_degrees: float = 5.0
@export var bullet_speed: float = 1500.0
@export var effective_range_pixels: float = 600.0
@export var bullet_scene: PackedScene
@export var fire_sound: AudioStream
@export var reload_sound: AudioStream
