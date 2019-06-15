extends Node


func _ready():
	get_tree().paused = false


func _on_QuitButton_pressed():
	get_tree().quit()


func _on_PlayButton_pressed():
	get_tree().change_scene("res://Main/Main.tscn")
