extends Control

@onready var level_label = $Panel/VBoxContainer/LevelLabel
@onready var attributes_label = $Panel/VBoxContainer/HBoxContainer/AttributesLabel
@onready var derived_stats_label = $Panel/VBoxContainer/HBoxContainer/DerivedStatsLabel
@onready var weapon_label = $Panel/VBoxContainer/WeaponLabel
@onready var close_label = $Panel/VBoxContainer/CloseLabel

func _ready():
	hide()

func _input(event):
	if event.is_action_pressed("ui_focus_next"):
		toggle_visibility()
		get_viewport().set_input_as_handled()

func toggle_visibility():
	visible = !visible
	if visible:
		update_stats()

func update_stats():
	if not GameState.player_stats:
		return
	
	level_label.text = "LEVEL %d | XP: %d/%d" % [GameState.player_level, int(GameState.current_xp), int(GameState.xp_to_next_level)]
	
	var total_attributes = {
		"brutality": GameState.player_stats.get_attribute("brutality"),
		"spirit": GameState.player_stats.get_attribute("spirit"),
		"intelligence": GameState.player_stats.get_attribute("intelligence"),
		"dexterity": GameState.player_stats.get_attribute("dexterity"),
		"agility": GameState.player_stats.get_attribute("agility"),
		"luck": GameState.player_stats.get_attribute("luck")
	}
	
	var equipment_bonuses = {
		"brutality": 0,
		"spirit": 0,
		"intelligence": 0,
		"dexterity": 0,
		"agility": 0,
		"luck": 0
	}
	
	for equipment_slot in Equipment.equipped_items.keys():
		var item = Equipment.get_equipped_item(equipment_slot)
		if item != null and item.attributes != null:
			for attr_name in item.attributes.keys():
				if equipment_bonuses.has(attr_name):
					equipment_bonuses[attr_name] += item.attributes[attr_name]
					total_attributes[attr_name] += item.attributes[attr_name]
	
	var attr_text = "=== ATTRIBUTES ===\n\n"
	attr_text += "Brutality: %d" % total_attributes["brutality"]
	if equipment_bonuses["brutality"] > 0:
		attr_text += " (+%d)\n" % equipment_bonuses["brutality"]
	else:
		attr_text += "\n"
	
	attr_text += "Spirit: %d" % total_attributes["spirit"]
	if equipment_bonuses["spirit"] > 0:
		attr_text += " (+%d)\n" % equipment_bonuses["spirit"]
	else:
		attr_text += "\n"
	
	attr_text += "Intelligence: %d" % total_attributes["intelligence"]
	if equipment_bonuses["intelligence"] > 0:
		attr_text += " (+%d)\n" % equipment_bonuses["intelligence"]
	else:
		attr_text += "\n"
	
	attr_text += "Dexterity: %d" % total_attributes["dexterity"]
	if equipment_bonuses["dexterity"] > 0:
		attr_text += " (+%d)\n" % equipment_bonuses["dexterity"]
	else:
		attr_text += "\n"
	
	attr_text += "Agility: %d" % total_attributes["agility"]
	if equipment_bonuses["agility"] > 0:
		attr_text += " (+%d)\n" % equipment_bonuses["agility"]
	else:
		attr_text += "\n"
	
	attr_text += "Luck: %d" % total_attributes["luck"]
	if equipment_bonuses["luck"] > 0:
		attr_text += " (+%d)" % equipment_bonuses["luck"]
	
	attributes_label.text = attr_text
	
	var stats = GameState.player_stats
	var derived_text = "=== DERIVED STATS ===\n\n"
	derived_text += "Health: %.1f | Regen: %.2f/s\n" % [stats.get_max_health(), stats.get_stat("health_regen")]
	derived_text += "Mana: %.1f | Regen: %.2f/s\n\n" % [stats.get_max_mana(), stats.get_stat("mana_regen")]
	derived_text += "Physical Damage: %.1f\n" % stats.get_stat("physical_damage")
	derived_text += "Magic Damage: %.1f\n" % stats.get_stat("magic_damage")
	derived_text += "Ranged Bonus: %.1f\n\n" % stats.get_stat("ranged_damage_bonus")
	derived_text += "Resistance: %.1f\n" % stats.get_stat("resistance")
	derived_text += "Precision: %.1f\n" % stats.get_stat("precision")
	derived_text += "Evasion: %.1f\n\n" % stats.get_stat("evasion")
	derived_text += "Crit Chance: %.1f%%\n" % stats.get_stat("crit_chance")
	derived_text += "Loot: %.1f\n" % stats.get_stat("loot_improvement")
	derived_text += "Move Speed: %.2fx" % stats.get_stat("movement_speed")
	derived_stats_label.text = derived_text
	
	var weapon = Equipment.get_weapon()
	if weapon:
		var rarity_name = Inventory.get_rarity_name(weapon.rarity)
		var weapon_type_name = get_weapon_type_name(weapon.weapon_type)
		weapon_label.text = "=== WEAPON ===\n\n%s [%s]\n%s\n\nDamage: %.1f\nSpeed: %.1fx\nRange: %.1f" % [
			weapon.name, rarity_name, weapon_type_name,
			weapon.damage, weapon.attack_speed, weapon.range
		]
		weapon_label.modulate = Inventory.get_rarity_color(weapon.rarity)
	else:
		weapon_label.text = "=== WEAPON ===\n\nNo weapon equipped"
		weapon_label.modulate = Color(1, 1, 1)

func get_weapon_type_name(weapon_type) -> String:
	match weapon_type:
		Inventory.WeaponType.MELEE:
			return "MELEE"
		Inventory.WeaponType.RANGED:
			return "RANGED"
		Inventory.WeaponType.MAGIC:
			return "MAGIC"
	return "UNKNOWN"

