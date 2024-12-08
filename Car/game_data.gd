extends Node

var charges_used : int = 0 : set = set_charges_used, get = get_charges_used
var total_score: int = 0: get = get_total_score


func set_charges_used(value: int) -> void:
	charges_used = value
	print(charges_used) 

func get_charges_used() -> int:
	return charges_used
	
func increment_charges_used():
	charges_used += 1

func get_total_score():
	return total_score

func add_to_total():
	total_score += charges_used
	charges_used = 0
