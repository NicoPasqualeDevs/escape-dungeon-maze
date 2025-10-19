extends Control

@onready var knight_button = $Panel/VBoxContainer/ClassesContainer/KnightButton
@onready var archer_button = $Panel/VBoxContainer/ClassesContainer/ArcherButton
@onready var mage_button = $Panel/VBoxContainer/ClassesContainer/MageButton
@onready var angel_button = $Panel/VBoxContainer/ClassesContainer/AngelButton
@onready var description_label = $Panel/VBoxContainer/DescriptionLabel

func _ready():
	knight_button.pressed.connect(_on_knight_selected)
	archer_button.pressed.connect(_on_archer_selected)
	mage_button.pressed.connect(_on_mage_selected)
	angel_button.pressed.connect(_on_angel_selected)
	
	knight_button.mouse_entered.connect(_on_knight_hover)
	archer_button.mouse_entered.connect(_on_archer_hover)
	mage_button.mouse_entered.connect(_on_mage_hover)
	angel_button.mouse_entered.connect(_on_angel_hover)

func _on_knight_hover():
	description_label.text = "KNIGHT - Melee Warrior\n\nStarts with Iron Sword\nHigh damage, close range\nBrutal and resistant\n\nWeapon: MELEE\nDamage: 25 | Speed: 0.8 | Range: 150"

func _on_archer_hover():
	description_label.text = "ARCHER - Ranged Fighter\n\nStarts with Longbow\nPrecise long range attacks\nDexterous and accurate\n\nWeapon: RANGED\nDamage: 18 | Speed: 1.3 | Range: 200"

func _on_mage_hover():
	description_label.text = "MAGE - Magic User\n\nStarts with Magic Staff\nPowerful magic attacks\nIntelligent and mystical\n\nWeapon: MAGIC\nDamage: 20 | Speed: 1.5 | Range: 150"

func _on_angel_hover():
	description_label.text = "ANGEL - Divine Support\n\nStarts with Holy Staff\nHealing and support magic\nSpiritual and balanced\n\nWeapon: SUPPORT\nDamage: 15 | Speed: 1.8 | Range: 160"

func _on_knight_selected():
	GameState.selected_character_class = "knight"
	select_class("iron_sword_common")

func _on_archer_selected():
	GameState.selected_character_class = "archer"
	select_class("longbow_common")

func _on_mage_selected():
	GameState.selected_character_class = "mage"
	select_class("magic_staff_common")

func _on_angel_selected():
	GameState.selected_character_class = "angel"
	select_class("holy_staff_common")

func select_class(weapon_id: String):
	GameState.reset_game()
	
	var weapon = ItemDatabase.create_item(weapon_id)
	if weapon:
		Equipment.equip_item(weapon, Equipment.EquipSlot.WEAPON)
	
	await get_tree().process_frame
	
	if GameState.player_stats:
		GameState.player_stats.calculate_derived_stats()
		GameState.player_stats.current_health = GameState.player_stats.get_max_health()
		GameState.player_stats.current_mana = GameState.player_stats.get_max_mana()
	
	get_tree().change_scene_to_file("res://scenes/world/main.tscn")

