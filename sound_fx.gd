extends Node

func pausing():
	$GameTheme.bus = "Pause"
	
func unpausing():
	$GameTheme.bus = "Master"
	
func game_theme():
	if $MainMenuTheme.playing:
		$MainMenuTheme.stop()
		
	if !$GameTheme.playing:
		$GameTheme.play()
	else:
		$GameTheme.stop()

func main_menu_theme():
	if $GameTheme.playing:
		$GameTheme.stop()
		
	if !$MainMenuTheme.playing:
		$MainMenuTheme.play()
	
func button_click():
	$ButtonClick.play()
	
func back_button_click():
	$BackButtonClick.play()

func level_button_hover():
	$LevelButtonHover.play()
