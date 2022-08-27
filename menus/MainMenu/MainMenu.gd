extends Node

#TODO

onready var currentScene = $TitleScreen

func _ready():
	register_buttons()
	change_screen(currentScene)

func register_buttons():
	var buttons = get_tree().get_nodes_in_group("Buttons")
	for button in buttons:
		button.connect("pressed", self, "_on_button_pressed", [button])

		match button.name:
			"Music":
				button.pressed = !Settings.enable_music
			"Sound":
				button.pressed = !Settings.enable_sound

func _on_button_pressed(button):
	match button.name:
		"Home":
			print("test")
			Settings.save_settings()
			change_screen($TitleScreen)
		"Settings":
			change_screen($SettingsMenu)
		"Play":
			change_screen(null)
		"Music":
			Settings.enable_music = !button.pressed
		"Sound":
			Settings.enable_sound = !button.pressed

func change_screen(newScene):
	if newScene:
		if currentScene:
			currentScene.disappear()
		currentScene = newScene
		currentScene.appear()
		yield(currentScene.tween, "tween_completed")
	else:
		pass
		#Transitions.change_scene(self, "res://Game.tscn", 1)
