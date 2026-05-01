class_name LootSpawner
extends Node2D

@export var loot_table: Array[ItemConfig] = []
@export var weights: Array[float] = []  ## same length as loot_table; default 1.0 if shorter
@export var roll_count: int = 3
@export var spawn_points: Array[Marker2D] = []
@export var pickup_scene: PackedScene


func spawn_loot() -> void:
	if loot_table.is_empty() or spawn_points.is_empty() or pickup_scene == null:
		return
	var available_points := spawn_points.duplicate()
	available_points.shuffle()
	var rolls: int = min(roll_count, available_points.size())
	for i in range(rolls):
		var item_config := _weighted_pick()
		if item_config == null:
			continue
		var pickup := pickup_scene.instantiate()
		pickup.global_position = available_points[i].global_position
		pickup.set("config", item_config)
		get_tree().current_scene.add_child(pickup)


func _weighted_pick() -> ItemConfig:
	var total: float = 0.0
	for i in range(loot_table.size()):
		total += weights[i] if i < weights.size() else 1.0
	if total <= 0.0:
		return null
	var r := randf() * total
	var acc: float = 0.0
	for i in range(loot_table.size()):
		acc += weights[i] if i < weights.size() else 1.0
		if r <= acc:
			return loot_table[i]
	return loot_table.back()
