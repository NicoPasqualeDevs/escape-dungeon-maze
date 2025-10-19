extends Control

var dungeon_grid = []
var room_buttons = []
var player_position: Vector2i
var initial_position: Vector2i
var cell_size = 80
var visited_cells = {}

func _init():
	player_position = GameConstants.DUNGEON.initial_position
	initial_position = GameConstants.DUNGEON.initial_position

@onready var info_label = $VBoxContainer/TopBar/InfoLabel
@onready var grid_container = $VBoxContainer/CenterContainer/GridContainer
@onready var center_container = $VBoxContainer/CenterContainer
@onready var player_sprite = $PlayerSprite
@onready var inventory_ui = $InventoryUI

func _ready():
	get_viewport().size_changed.connect(_on_viewport_size_changed)
	
	if GameState.has_saved_state():
		restore_dungeon_state()
	else:
		generate_dungeon()
	
	await get_tree().process_frame
	update_player_sprite_position()

func _on_viewport_size_changed():
	calculate_cell_size()

func generate_dungeon():
	clear_grid()
	dungeon_grid.clear()
	room_buttons.clear()
	visited_cells.clear()
	
	initial_position = player_position
	
	var grid_size = GameConstants.DUNGEON.grid_size
	for y in range(grid_size):
		var row = []
		for x in range(grid_size):
			row.append(GameState.RoomType.NORMAL)
		dungeon_grid.append(row)
	
	dungeon_grid[player_position.y][player_position.x] = GameState.RoomType.ENTRANCE
	
	calculate_cell_size()
	create_grid_buttons()
	update_info()

func restore_dungeon_state():
	clear_grid()
	dungeon_grid = GameState.dungeon_grid.duplicate(true)
	player_position = GameState.player_position
	visited_cells = GameState.visited_cells.duplicate()
	room_buttons.clear()
	
	calculate_cell_size()
	create_grid_buttons()
	update_grid_visuals()
	update_info()
	
	await get_tree().process_frame
	update_player_sprite_position()

func calculate_cell_size():
	var viewport_size = get_viewport_rect().size
	var available_width = viewport_size.x - 40
	var available_height = viewport_size.y - 100
	
	var grid_size = GameConstants.DUNGEON.grid_size
	var cell_width = available_width / grid_size
	var cell_height = available_height / grid_size
	
	cell_size = int(min(cell_width, cell_height))
	cell_size = max(cell_size, GameConstants.DUNGEON.cell_min_size)
	
	if room_buttons.size() > 0:
		update_button_sizes()
		await get_tree().process_frame
		update_player_sprite_position()


func clear_grid():
	for child in grid_container.get_children():
		child.queue_free()

func create_grid_buttons():
	var grid_size = GameConstants.DUNGEON.grid_size
	for y in range(grid_size):
		for x in range(grid_size):
			var button = Button.new()
			button.custom_minimum_size = Vector2(cell_size, cell_size)
			button.expand_icon = true
			
			var room_type = dungeon_grid[y][x]
			style_room_button(button, room_type, Vector2i(x, y))
			
			button.pressed.connect(_on_room_pressed.bind(Vector2i(x, y)))
			
			grid_container.add_child(button)
			room_buttons.append(button)

func update_button_sizes():
	for button in room_buttons:
		button.custom_minimum_size = Vector2(cell_size, cell_size)

func is_valid_position(pos: Vector2i) -> bool:
	var grid_size = GameConstants.DUNGEON.grid_size
	return pos.x >= 0 and pos.x < grid_size and pos.y >= 0 and pos.y < grid_size

func style_room_button(button: Button, room_type: GameState.RoomType, pos: Vector2i):
	var style_box = StyleBoxFlat.new()
	
	button.text = ""
	button.icon = null
	
	if visited_cells.has(pos):
		style_box.bg_color = Color(0.15, 0.15, 0.15)
		button.disabled = true
		button.text = "X"
	else:
		button.disabled = false
		
		match room_type:
			GameState.RoomType.ENTRANCE:
				style_box.bg_color = Color(0.2, 0.7, 0.3)
			_:
				style_box.bg_color = Color(0.4, 0.4, 0.45)
	
	var show_border = (pos == player_position and pos != initial_position) or (pos == player_position and pos == initial_position and visited_cells.size() == 0)
	
	if show_border:
		style_box.border_width_left = 4
		style_box.border_width_right = 4
		style_box.border_width_top = 4
		style_box.border_width_bottom = 4
		style_box.border_color = Color(1, 1, 0)
	
	button.add_theme_stylebox_override("normal", style_box)
	button.add_theme_stylebox_override("hover", style_box)
	button.add_theme_stylebox_override("pressed", style_box)
	button.add_theme_stylebox_override("disabled", style_box)

func _on_room_pressed(pos: Vector2i):
	if visited_cells.has(pos):
		info_label.text = "Already visited - cannot return to this location"
		return
	
	var distance = abs(pos.x - player_position.x) + abs(pos.y - player_position.y)
	
	if distance > 1:
		info_label.text = "Too far! Move to adjacent locations"
		return
	
	player_position = pos
	
	var room_type = dungeon_grid[pos.y][pos.x]
	
	visited_cells[pos] = true
	
	enter_room(room_type, pos)

func enter_room(room_type: GameState.RoomType, pos: Vector2i):
	GameState.save_dungeon_state(dungeon_grid, player_position, visited_cells)
	GameState.current_room_type = room_type
	GameState.current_room_position = pos
	
	get_tree().change_scene_to_file("res://scenes/world/room.tscn")

func update_grid_visuals():
	var index = 0
	var grid_size = GameConstants.DUNGEON.grid_size
	for y in range(grid_size):
		for x in range(grid_size):
			var button = room_buttons[index]
			var room_type = dungeon_grid[y][x]
			style_room_button(button, room_type, Vector2i(x, y))
			index += 1

func update_info():
	info_label.text = "Select a location to enter"

func update_player_sprite_position():
	if not player_sprite or room_buttons.size() == 0:
		return
	
	if player_position == initial_position and visited_cells.size() > 0:
		player_sprite.visible = false
		return
	
	player_sprite.visible = true
	
	# Update player sprite texture based on selected character
	var texture_path = ""
	match GameState.selected_character_class:
		"knight":
			texture_path = "res://assets/characters/knight_m_idle_anim_f0.png"
		"archer":
			texture_path = "res://assets/characters/elf_m_idle_anim_f0.png"
		"mage":
			texture_path = "res://assets/characters/wizzard_m_idle_anim_f0.png"
		"angel":
			texture_path = "res://assets/characters/angel_idle_anim_f0.png"
		_:
			texture_path = "res://assets/characters/knight_m_idle_anim_f0.png"
	
	var texture = load(texture_path)
	if texture:
		player_sprite.texture = texture
	
	var grid_size = GameConstants.DUNGEON.grid_size
	var button_index = player_position.y * grid_size + player_position.x
	if button_index >= room_buttons.size():
		return
	
	var button = room_buttons[button_index]
	var button_global_pos = button.global_position
	var button_size = button.size
	
	player_sprite.global_position = button_global_pos + button_size / 2
	player_sprite.scale = Vector2(cell_size / 32.0, cell_size / 32.0)

func _on_generate_button_pressed():
	player_position = GameConstants.DUNGEON.initial_position
	GameState.rooms_completed = 0
	GameState.enemy_multiplier = 1.0
	generate_dungeon()
	await get_tree().process_frame
	update_player_sprite_position()

func _on_inventory_button_pressed():
	if inventory_ui:
		inventory_ui.visible = !inventory_ui.visible

func _on_menu_button_pressed():
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")
