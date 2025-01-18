extends Node

func pausing():
	$GameTheme.bus = "Pause"
	
func unpausing():
	$GameTheme.bus = "Master"
	
func game_theme():
	if !$GameTheme.playing:
		$GameTheme.play()
	else:
		$GameTheme.stop()
	
func button_click():
	$ButtonClick.play()
	
func back_button_click():
	$BackButtonClick.play()

func level_button_hover():
	$LevelButtonHover.play()
