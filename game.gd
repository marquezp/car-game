# This script is supposed to handle the stage transitions
extends Node

func stage_over():
	call_deferred("reset_stage")
	
func reset_stage():
	get_tree().reload_current_scene()
