extends Control

@onready var new_game_button = $Panel/VBoxContainer/ButtonsContainer/NewGameButton
@onready var quit_button = $Panel/VBoxContainer/ButtonsContainer/QuitButton
@onready var fullscreen_button = $Panel/VBoxContainer/ButtonsContainer/FullscreenButton

func _ready():
	new_game_button.pressed.connect(_on_new_game_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
	fullscreen_button.pressed.connect(_on_fullscreen_pressed)
	update_fullscreen_button_text()

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		_on_quit_pressed()
	elif event is InputEventKey:
		if event.pressed and event.keycode == KEY_F11:
			_on_fullscreen_pressed()

func _on_new_game_pressed():
	GameState.reset_game()
	get_tree().change_scene_to_file("res://scenes/ui/class_selection.tscn")

func _on_quit_pressed():
	get_tree().quit()

func _on_fullscreen_pressed():
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	update_fullscreen_button_text()

func update_fullscreen_button_text():
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		fullscreen_button.text = "Windowed"
	else:
		fullscreen_button.text = "Fullscreen"
