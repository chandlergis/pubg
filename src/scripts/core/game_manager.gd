extends Node
## Autoload singleton. Register in Project Settings → AutoLoad as "GameManager".

signal state_changed(new_state: int)

const LOBBY_SCENE := "res://src/scenes/lobby.tscn"
const RAID_SCENE := "res://src/scenes/raid.tscn"

var current_state: int = GameState.State.LOBBY
var stash_inventory: Inventory
var raid_inventory: Inventory


func _ready() -> void:
	stash_inventory = Inventory.new()
	stash_inventory.max_weight_kg = 50.0
	var data := SaveSystem.load_data()
	# TODO: rebuild stash_inventory entries from data["stash"] via ItemDatabase


func enter_raid() -> void:
	raid_inventory = Inventory.new()
	raid_inventory.max_weight_kg = 30.0
	_transition_to(GameState.State.LOADING_RAID)
	get_tree().change_scene_to_file(RAID_SCENE)
	_transition_to(GameState.State.IN_RAID)


func complete_raid(extracted: bool) -> void:
	if extracted and raid_inventory != null:
		raid_inventory.merge_into(stash_inventory)
	raid_inventory = null
	SaveSystem.save(_serialize())
	_transition_to(GameState.State.RAID_RESULT)
	get_tree().change_scene_to_file(LOBBY_SCENE)
	_transition_to(GameState.State.LOBBY)


func _transition_to(next: int) -> void:
	current_state = next
	state_changed.emit(next)


func _serialize() -> Dictionary:
	# TODO: serialize stash_inventory entries to [{config_id, count}, ...]
	return {
		"gold": 0,
		"stash": [],
		"owned_keys": [],
		"stats": {"raids_run": 0, "raids_extracted": 0, "kills": 0},
	}
