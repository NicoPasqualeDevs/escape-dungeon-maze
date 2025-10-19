extends Node

const PLAYER = {
	"base_speed": 100.0,
	"dash_speed": 300.0,
	"dash_duration": 0.2,
	"dash_cooldown": 2.0,
	"invulnerability_time": 0.5,
	"base_health": 20.0,
	"base_mana": 20.0
}

const ENEMY = {
	"base_health": 50.0,
	"base_damage": 5.0,
	"base_speed": 80.0,
	"base_xp": 10.0,
	"attack_cooldown": 1.0,
	"detection_range": 150.0,
	"chase_range": 200.0,
	"health_bar_display_time": 1.0
}

const BOSS = {
	"health_multiplier": 4.0,
	"damage_multiplier": 3.0,
	"speed_multiplier": 0.75,
	"xp_multiplier": 5.0
}

const ROOM = {
	"left": 200.0,
	"right": 600.0,
	"top": 100.0,
	"bottom": 400.0,
	"tile_size": 16.0
}

const DUNGEON = {
	"grid_size": 8,
	"initial_position": Vector2i(3, 3),
	"min_rooms": 15,
	"max_rooms": 25,
	"cell_min_size": 60
}

const LOOT = {
	"drop_chance": 0.3,
	"boss_unique_chance": 1.0
}

const UI = {
	"inventory_slots": 24,
	"slot_size": 64,
	"damage_text_rise_distance": 20.0,
	"damage_text_duration": 1.0,
	"loot_text_rise_distance": 50.0,
	"loot_text_duration": 1.5
}

const COMBAT = {
	"melee_mana_cost": 0.5,
	"ranged_mana_cost": 2.0,
	"magic_mana_cost": 4.0,
	"attack_animation_duration": 0.2,
	"damage_flash_duration": 0.1,
	"resistance_multiplier": 0.5,
	"crit_damage_multiplier": 2.0
}

const LEVEL_SYSTEM = {
	"base_xp_required": 100.0,
	"xp_scaling": 1.5,
	"stat_points_per_level": 1,
	"stat_points_per_room": 1
}

const COLORS = {
	"damage_player": Color(1, 0.2, 0.2),
	"damage_enemy": Color(1, 0.3, 0.3),
	"damage_crit": Color(1, 1, 0),
	"damage_flash": Color(1, 0.3, 0.3),
	"health_high": Color(0.2, 0.8, 0.2),
	"health_medium": Color(0.8, 0.8, 0.2),
	"health_low": Color(0.8, 0.2, 0.2)
}

