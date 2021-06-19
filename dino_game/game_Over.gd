extends CanvasLayer

# Restart the game 
func _on_RestartButton_pressed():
	get_tree().reload_current_scene()

# Quit the game
func _on_QuitButton_pressed():
	get_tree().quit()
