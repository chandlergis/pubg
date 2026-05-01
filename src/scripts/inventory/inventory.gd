class_name Inventory
extends Resource

@export var max_weight_kg: float = 30.0

var entries: Array = []  ## Array of {"config": ItemConfig, "count": int}


func current_weight() -> float:
	var total := 0.0
	for e in entries:
		var cfg: ItemConfig = e["config"]
		total += cfg.weight_kg * e["count"]
	return total


func try_add(item_config: ItemConfig, count: int = 1) -> bool:
	var added_weight := item_config.weight_kg * count
	if current_weight() + added_weight > max_weight_kg:
		return false
	# stack into existing entry of same config_id
	for e in entries:
		var cfg: ItemConfig = e["config"]
		if cfg.config_id == item_config.config_id:
			var room: int = item_config.stack_max - e["count"]
			if room > 0:
				var stacked: int = min(count, room)
				e["count"] += stacked
				count -= stacked
				if count == 0:
					return true
	if count > 0:
		entries.append({"config": item_config, "count": count})
	return true


func remove_at(index: int) -> void:
	if index < 0 or index >= entries.size():
		return
	entries.remove_at(index)


func merge_into(other: Inventory) -> int:
	## All-or-nothing per stack. Returns total count not transferred.
	var leftover := 0
	for e in entries:
		if not other.try_add(e["config"], e["count"]):
			leftover += e["count"]
	entries.clear()
	# TODO: support partial-stack transfer when whole stack doesn't fit
	return leftover
