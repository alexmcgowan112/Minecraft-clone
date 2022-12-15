extends Control

onready var text = $"CanvasLayer/MarginContainer/VBoxContainer/CenterContainer/Progress Text"

func set_progress(blocks : int, toLoad : int):
	text.text = "Loaded Chunks:\n" + str(blocks) + " / " + str(toLoad)
	
func fade(fadeTime : float):
	var tween = $Tween
	tween.interpolate_property(self, "modulate", Color(1,1,1,1), Color(1,1,1,0), fadeTime)
	tween.start()
	yield(tween,"tween_completed")
	queue_free()
