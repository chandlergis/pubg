class_name ExtractionZone
extends Area2D

@export var zone_id: String = "north_exit"
@export var dwell_seconds: float = 5.0
@export var requires_key: bool = false
@export var required_key_id: String = ""

signal progress_changed(progress: float)
signal completed

var _player_in_zone: bool = false
var _dwell_progress: float = 0.0


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


func _process(delta: float) -> void:
	if not _player_in_zone:
		if _dwell_progress > 0.0:
			_dwell_progress = 0.0
			progress_changed.emit(0.0)
		return
	_dwell_progress += delta
	progress_changed.emit(clamp(_dwell_progress / dwell_seconds, 0.0, 1.0))
	if _dwell_progress >= dwell_seconds:
		completed.emit()
		_player_in_zone = false
		# TODO: GameManager.complete_raid(true)


func _on_body_entered(body: Node) -> void:
	if not body.is_in_group("player"):
		return
	if requires_key:
		# TODO: check player.inventory for required_key_id; refuse if missing
		return
	_player_in_zone = true


func _on_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		_player_in_zone = false
