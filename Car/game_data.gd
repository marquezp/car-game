extends Node

var charges_used : int = 0 : set = set_charges_used, get = get_charges_used
var is_charging: bool = false: set = set_is_charging, get = get_is_charging

signal start_charging
signal start_uncharging
signal score_changed

func set_charges_used(value: int) -> void:
	charges_used = value
	emit_signal("score_changed")

func get_charges_used() -> int:
	return charges_used
	
func increment_charges_used():
	charges_used += 1
	emit_signal("score_changed")

func set_is_charging(value: bool) -> void:
	is_charging = value
	if is_charging:
		emit_signal("start_charging")
	elif !is_charging:
		emit_signal("start_uncharging")

func get_is_charging() -> bool:
	return is_charging
