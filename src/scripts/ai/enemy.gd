class_name Enemy
extends CharacterBody2D

enum AIState { PATROL, SUSPECT, COMBAT, DEAD }

@export var move_speed: float = 100.0
@export var vision_range: float = 300.0
@export var attack_range: float = 250.0
@export var max_hp: int = 50
@export var weapon_config: WeaponConfig
@export var patrol_points: Array[Marker2D] = []

@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D

var current_state: int = AIState.PATROL
var hp: int = 50
var _patrol_index: int = 0
var _last_seen_player_pos: Vector2 = Vector2.ZERO


func _ready() -> void:
	hp = max_hp
	add_to_group("enemy")
	if patrol_points.size() > 0:
		nav_agent.target_position = patrol_points[0].global_position


func _physics_process(_delta: float) -> void:
	match current_state:
		AIState.PATROL:
			_tick_patrol()
		AIState.SUSPECT:
			_tick_suspect()
		AIState.COMBAT:
			_tick_combat()
		AIState.DEAD:
			return
	move_and_slide()


func take_damage(amount: int) -> void:
	if current_state == AIState.DEAD:
		return
	hp = max(0, hp - amount)
	if hp == 0:
		_die()
	elif current_state == AIState.PATROL:
		# TODO: switch to SUSPECT walking toward bullet origin
		pass


func _tick_patrol() -> void:
	if patrol_points.is_empty():
		velocity = Vector2.ZERO
		return
	if nav_agent.is_navigation_finished():
		_patrol_index = (_patrol_index + 1) % patrol_points.size()
		nav_agent.target_position = patrol_points[_patrol_index].global_position
	var next_pos := nav_agent.get_next_path_position()
	velocity = (next_pos - global_position).normalized() * move_speed


func _tick_suspect() -> void:
	# TODO: walk to _last_seen_player_pos; if see player → COMBAT;
	# if reach pos and no sight → PATROL
	pass


func _tick_combat() -> void:
	# TODO: keep distance ≈ attack_range; weapon.try_fire(player.global_position)
	pass


func _die() -> void:
	current_state = AIState.DEAD
	velocity = Vector2.ZERO
	# TODO: drop loot, play death anim, queue_free after delay
