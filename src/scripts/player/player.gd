class_name Player
extends CharacterBody2D

@export var walk_speed: float = 200.0
@export var sprint_speed: float = 350.0
@export var max_hp: int = 100

var hp: int = 100
var weapon: Weapon
var inventory: Inventory

signal hp_changed(new_hp: int, max_hp: int)
signal died


func _ready() -> void:
	hp = max_hp
	add_to_group("player")
	inventory = Inventory.new()
	inventory.max_weight_kg = 30.0


func _physics_process(_delta: float) -> void:
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * walk_speed
	move_and_slide()
	# TODO: rotate sprite to face nearest enemy (auto-aim target)
	# TODO: if Input.is_action_pressed("fire") and weapon != null, weapon.try_fire(target_pos)


func take_damage(amount: int) -> void:
	hp = max(0, hp - amount)
	hp_changed.emit(hp, max_hp)
	if hp == 0:
		died.emit()
		# TODO: GameManager.complete_raid(false)
