extends CanvasLayer
"""
================================================================================
GDscript
file game_Over.gd
================================================================================
Authors : Lucie LEOPOLD, Julie PERE, Clément VIVIER
Date : 19/06/2021
================================================================================
This file contains the function needed to show the end screen.
"""

# Restart the game 
func _on_RestartButton_pressed():
	get_tree().reload_current_scene()

# Quit the game
func _on_QuitButton_pressed():
	get_tree().quit()
