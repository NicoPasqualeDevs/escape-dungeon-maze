extends Node

enum RoomType {
	EMPTY,
	NORMAL,
	ENEMY,
	TREASURE,
	BOSS,
	ENTRANCE,
	EXIT
}

var dungeon_grid = []
var player_position = Vector2i(3, 3)
var visited_cells = {}

var current_room_type: RoomType = RoomType.NORMAL
var current_room_position: Vector2i = Vector2i.ZERO

var player_stats: PlayerStats = null
var game_initialized: bool = false
var rooms_completed: int = 0
var enemy_multiplier: float = 1.0

var player_level: int = 1
var current_xp: float = 0.0
var xp_to_next_level: float = 100.0
var pending_stat_points: int = 1

var selected_character_class: String = "knight"

func _ready():
	player_stats = PlayerStats.new()
	add_child(player_stats)
	
	if not game_initialized:
		initialize_player()
		game_initialized = true

func initialize_player():
	pass

func save_dungeon_state(grid, pos, visited):
	dungeon_grid = grid.duplicate(true)
	player_position = pos
	visited_cells = visited.duplicate()

func has_saved_state() -> bool:
	return dungeon_grid.size() > 0

func clear_state():
	dungeon_grid.clear()
	visited_cells.clear()
	player_position = Vector2i(3, 3)
	rooms_completed = 0
	enemy_multiplier = 1.0
	player_level = 1
	current_xp = 0.0
	xp_to_next_level = 100.0
	pending_stat_points = 1

func complete_room():
	rooms_completed += 1
	enemy_multiplier = pow(1.5, rooms_completed)
	pending_stat_points += 1

func get_enemy_count(base_count: int) -> int:
	return int(ceil(base_count * enemy_multiplier))

func add_experience(amount: float):
	current_xp += amount
	
	while current_xp >= xp_to_next_level:
		level_up()

func level_up():
	current_xp -= xp_to_next_level
	player_level += 1
	xp_to_next_level = 100.0 * pow(1.5, player_level - 1)
	pending_stat_points += 1

func use_stat_point():
	if pending_stat_points > 0:
		pending_stat_points -= 1

func reset_game():
	clear_state()
	Inventory.clear_inventory()
	Equipment.clear_equipment()
	if player_stats:
		player_stats.reset_stats()
	game_initialized = false
