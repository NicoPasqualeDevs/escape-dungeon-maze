extends Node

func create_item(item_id: String) -> Inventory.Item:
	if not items_data.has(item_id):
		return null
	
	var data = items_data[item_id]
	var icon_path = data.get("icon", "")
	
	var item = Inventory.Item.new(
		item_id,
		data["name"],
		data["description"],
		icon_path,
		data["type"]
	)
	
	item.icon = icon_path
	item.icon_path = icon_path
	
	if data.has("slot"):
		item.equipment_slot = data["slot"]
	
	if data.has("attributes"):
		item.attributes = data["attributes"].duplicate()
	
	if data.has("damage"):
		item.damage = data["damage"]
	
	if data.has("attack_speed"):
		item.attack_speed = data["attack_speed"]
	
	if data.has("range"):
		item.range = data["range"]
	
	if data.has("weapon_type"):
		item.weapon_type = data["weapon_type"]
	
	if data.has("rarity"):
		item.rarity = data["rarity"]
	
	return item

func get_random_weapon() -> Inventory.Item:
	var weapons = []
	for item_id in items_data.keys():
		var data = items_data[item_id]
		if data.has("slot") and data["slot"] == Equipment.EquipSlot.WEAPON:
			weapons.append(item_id)
	
	if weapons.size() > 0:
		var random_weapon = weapons[randi() % weapons.size()]
		return create_item(random_weapon)
	return null

func get_random_item_for_slot(slot: Equipment.EquipSlot) -> Inventory.Item:
	var valid_items = []
	
	for item_id in items_data.keys():
		var data = items_data[item_id]
		if data.has("slot") and (data["slot"] == slot or (slot == Equipment.EquipSlot.RING2 and data["slot"] == Equipment.EquipSlot.RING1)):
			valid_items.append(item_id)
	
	if valid_items.size() > 0:
		var random_id = valid_items[randi() % valid_items.size()]
		return create_item(random_id)
	
	return null

func get_all_item_ids() -> Array:
	return items_data.keys()

func get_items_by_rarity(rarity: Inventory.ItemRarity) -> Array:
	var items_of_rarity = []
	for item_id in items_data.keys():
		var data = items_data[item_id]
		if data.has("rarity") and data["rarity"] == rarity:
			items_of_rarity.append(item_id)
	return items_of_rarity

func get_random_unique_item() -> Inventory.Item:
	var unique_items = get_items_by_rarity(Inventory.ItemRarity.UNIQUE)
	if unique_items.size() > 0:
		var random_id = unique_items[randi() % unique_items.size()]
		return create_item(random_id)
	return null

var items_data = {
	"warrior_helmet_common": {
		"name": "Warrior Helmet",
		"description": "Basic warrior helmet. +2 Brutality",
		"icon": "res://assets/characters/knight_m_idle_anim_f0.png",
		"type": "equipment",
		"slot": Equipment.EquipSlot.HELMET,
		"attributes": {"brutality": 2},
		"rarity": Inventory.ItemRarity.COMMON
	},
	"warrior_helmet_uncommon": {
		"name": "Warrior Helmet",
		"description": "Reinforced warrior helmet. +3 Brutality",
		"icon": "res://assets/characters/knight_m_idle_anim_f1.png",
		"type": "equipment",
		"slot": Equipment.EquipSlot.HELMET,
		"attributes": {"brutality": 3},
		"rarity": Inventory.ItemRarity.UNCOMMON
	},
	"warrior_helmet_rare": {
		"name": "Warrior Helmet",
		"description": "Masterwork warrior helmet. +5 Brutality",
		"icon": "res://assets/characters/knight_m_idle_anim_f2.png",
		"type": "equipment",
		"slot": Equipment.EquipSlot.HELMET,
		"attributes": {"brutality": 5},
		"rarity": Inventory.ItemRarity.RARE
	},
	"warrior_helmet_legendary": {
		"name": "Warrior Helmet",
		"description": "Legendary warrior helmet. +10 Brutality",
		"icon": "res://assets/characters/knight_m_idle_anim_f3.png",
		"type": "equipment",
		"slot": Equipment.EquipSlot.HELMET,
		"attributes": {"brutality": 10},
		"rarity": Inventory.ItemRarity.LEGENDARY
	},
	
	"mage_hat_common": {
		"name": "Wizard Hat",
		"description": "Basic wizard hat. +2 Intelligence",
		"icon": "res://assets/characters/wizzard_m_idle_anim_f0.png",
		"type": "equipment",
		"slot": Equipment.EquipSlot.HELMET,
		"attributes": {"intelligence": 2},
		"rarity": Inventory.ItemRarity.COMMON
	},
	"mage_hat_uncommon": {
		"name": "Wizard Hat",
		"description": "Enchanted wizard hat. +3 Intelligence",
		"icon": "res://assets/characters/wizzard_m_idle_anim_f1.png",
		"type": "equipment",
		"slot": Equipment.EquipSlot.HELMET,
		"attributes": {"intelligence": 3},
		"rarity": Inventory.ItemRarity.UNCOMMON
	},
	"mage_hat_rare": {
		"name": "Wizard Hat",
		"description": "Arcane wizard hat. +5 Intelligence",
		"icon": "res://assets/characters/wizzard_m_idle_anim_f2.png",
		"type": "equipment",
		"slot": Equipment.EquipSlot.HELMET,
		"attributes": {"intelligence": 5},
		"rarity": Inventory.ItemRarity.RARE
	},
	"mage_hat_legendary": {
		"name": "Wizard Hat",
		"description": "Legendary archmage hat. +10 Intelligence",
		"icon": "res://assets/characters/wizzard_m_idle_anim_f3.png",
		"type": "equipment",
		"slot": Equipment.EquipSlot.HELMET,
		"attributes": {"intelligence": 10},
		"rarity": Inventory.ItemRarity.LEGENDARY
	},
	
	"ranger_hood_common": {
		"name": "Ranger Hood",
		"description": "Basic ranger hood. +2 Dexterity",
		"icon": "res://assets/characters/elf_m_idle_anim_f0.png",
		"type": "equipment",
		"slot": Equipment.EquipSlot.HELMET,
		"attributes": {"dexterity": 2},
		"rarity": Inventory.ItemRarity.COMMON
	},
	"ranger_hood_uncommon": {
		"name": "Ranger Hood",
		"description": "Enhanced ranger hood. +3 Dexterity",
		"icon": "res://assets/characters/elf_m_idle_anim_f1.png",
		"type": "equipment",
		"slot": Equipment.EquipSlot.HELMET,
		"attributes": {"dexterity": 3},
		"rarity": Inventory.ItemRarity.UNCOMMON
	},
	"ranger_hood_rare": {
		"name": "Ranger Hood",
		"description": "Masterwork ranger hood. +5 Dexterity",
		"icon": "res://assets/characters/elf_m_idle_anim_f2.png",
		"type": "equipment",
		"slot": Equipment.EquipSlot.HELMET,
		"attributes": {"dexterity": 5},
		"rarity": Inventory.ItemRarity.RARE
	},
	"ranger_hood_legendary": {
		"name": "Ranger Hood",
		"description": "Legendary ranger hood. +10 Dexterity",
		"icon": "res://assets/characters/elf_m_idle_anim_f3.png",
		"type": "equipment",
		"slot": Equipment.EquipSlot.HELMET,
		"attributes": {"dexterity": 10},
		"rarity": Inventory.ItemRarity.LEGENDARY
	},
	
	"holy_crown_common": {
		"name": "Holy Crown",
		"description": "Divine crown. +2 Spirit",
		"icon": "res://assets/characters/angel_idle_anim_f0.png",
		"type": "equipment",
		"slot": Equipment.EquipSlot.HELMET,
		"attributes": {"spirit": 2},
		"rarity": Inventory.ItemRarity.COMMON
	},
	"holy_crown_uncommon": {
		"name": "Holy Crown",
		"description": "Blessed divine crown. +3 Spirit",
		"icon": "res://assets/characters/angel_idle_anim_f1.png",
		"type": "equipment",
		"slot": Equipment.EquipSlot.HELMET,
		"attributes": {"spirit": 3},
		"rarity": Inventory.ItemRarity.UNCOMMON
	},
	"holy_crown_rare": {
		"name": "Holy Crown",
		"description": "Sacred divine crown. +5 Spirit",
		"icon": "res://assets/characters/angel_idle_anim_f2.png",
		"type": "equipment",
		"slot": Equipment.EquipSlot.HELMET,
		"attributes": {"spirit": 5},
		"rarity": Inventory.ItemRarity.RARE
	},
	"holy_crown_legendary": {
		"name": "Holy Crown",
		"description": "Legendary angelic crown. +10 Spirit",
		"icon": "res://assets/characters/angel_idle_anim_f3.png",
		"type": "equipment",
		"slot": Equipment.EquipSlot.HELMET,
		"attributes": {"spirit": 10},
		"rarity": Inventory.ItemRarity.LEGENDARY
	},
	
	"iron_sword_common": {
		"name": "Iron Sword",
		"description": "Standard iron sword. +2 Brutality\nDamage: 25 | Speed: 0.8 | Range: 150",
		"icon": "res://assets/weapons/weapon_knight_sword.png",
		"type": "weapon",
		"slot": Equipment.EquipSlot.WEAPON,
		"attributes": {"brutality": 2},
		"damage": 25.0,
		"attack_speed": 0.8,
		"range": 150.0,
		"weapon_type": Inventory.WeaponType.MELEE,
		"rarity": Inventory.ItemRarity.COMMON
	},
	"iron_sword_uncommon": {
		"name": "Iron Sword",
		"description": "Quality iron sword. +3 Brutality\nDamage: 35 | Speed: 0.85 | Range: 155",
		"icon": "res://assets/weapons/weapon_regular_sword.png",
		"type": "weapon",
		"slot": Equipment.EquipSlot.WEAPON,
		"attributes": {"brutality": 3},
		"damage": 35.0,
		"attack_speed": 0.85,
		"range": 155.0,
		"weapon_type": Inventory.WeaponType.MELEE,
		"rarity": Inventory.ItemRarity.UNCOMMON
	},
	"iron_sword_rare": {
		"name": "Iron Sword",
		"description": "Masterwork iron sword. +5 Brutality\nDamage: 55 | Speed: 0.9 | Range: 160",
		"icon": "res://assets/weapons/weapon_duel_sword.png",
		"type": "weapon",
		"slot": Equipment.EquipSlot.WEAPON,
		"attributes": {"brutality": 5},
		"damage": 55.0,
		"attack_speed": 0.9,
		"range": 160.0,
		"weapon_type": Inventory.WeaponType.MELEE,
		"rarity": Inventory.ItemRarity.RARE
	},
	"iron_sword_legendary": {
		"name": "Iron Sword",
		"description": "Legendary golden blade. +10 Brutality\nDamage: 110 | Speed: 1.0 | Range: 180",
		"icon": "res://assets/weapons/weapon_golden_sword.png",
		"type": "weapon",
		"slot": Equipment.EquipSlot.WEAPON,
		"attributes": {"brutality": 10},
		"damage": 110.0,
		"attack_speed": 1.0,
		"range": 180.0,
		"weapon_type": Inventory.WeaponType.MELEE,
		"rarity": Inventory.ItemRarity.LEGENDARY
	},
	"iron_sword_unique": {
		"name": "Iron Sword",
		"description": "Unique anime blade. +15 Brutality\nDamage: 220 | Speed: 1.2 | Range: 200",
		"icon": "res://assets/weapons/weapon_anime_sword.png",
		"type": "weapon",
		"slot": Equipment.EquipSlot.WEAPON,
		"attributes": {"brutality": 15},
		"damage": 220.0,
		"attack_speed": 1.2,
		"range": 200.0,
		"weapon_type": Inventory.WeaponType.MELEE,
		"rarity": Inventory.ItemRarity.UNIQUE
	},
	
	"battle_axe_common": {
		"name": "Battle Axe",
		"description": "Heavy battle axe. +2 Brutality\nDamage: 30 | Speed: 0.7 | Range: 140",
		"icon": "res://assets/weapons/weapon_axe.png",
		"type": "weapon",
		"slot": Equipment.EquipSlot.WEAPON,
		"attributes": {"brutality": 2},
		"damage": 30.0,
		"attack_speed": 0.7,
		"range": 140.0,
		"weapon_type": Inventory.WeaponType.MELEE,
		"rarity": Inventory.ItemRarity.COMMON
	},
	"battle_axe_uncommon": {
		"name": "Battle Axe",
		"description": "Sharp battle axe. +3 Brutality\nDamage: 40 | Speed: 0.75 | Range: 145",
		"icon": "res://assets/weapons/weapon_waraxe.png",
		"type": "weapon",
		"slot": Equipment.EquipSlot.WEAPON,
		"attributes": {"brutality": 3},
		"damage": 40.0,
		"attack_speed": 0.75,
		"range": 145.0,
		"weapon_type": Inventory.WeaponType.MELEE,
		"rarity": Inventory.ItemRarity.UNCOMMON
	},
	"battle_axe_rare": {
		"name": "Battle Axe",
		"description": "Double-bladed war axe. +5 Brutality\nDamage: 60 | Speed: 0.85 | Range: 155",
		"icon": "res://assets/weapons/weapon_double_axe.png",
		"type": "weapon",
		"slot": Equipment.EquipSlot.WEAPON,
		"attributes": {"brutality": 5},
		"damage": 60.0,
		"attack_speed": 0.85,
		"range": 155.0,
		"weapon_type": Inventory.WeaponType.MELEE,
		"rarity": Inventory.ItemRarity.RARE
	},
	"battle_axe_legendary": {
		"name": "Battle Axe",
		"description": "Legendary cleaver. +10 Brutality\nDamage: 120 | Speed: 0.95 | Range: 175",
		"icon": "res://assets/weapons/weapon_cleaver.png",
		"type": "weapon",
		"slot": Equipment.EquipSlot.WEAPON,
		"attributes": {"brutality": 10},
		"damage": 120.0,
		"attack_speed": 0.95,
		"range": 175.0,
		"weapon_type": Inventory.WeaponType.MELEE,
		"rarity": Inventory.ItemRarity.LEGENDARY
	},
	
	"longbow_common": {
		"name": "Longbow",
		"description": "Standard longbow. +2 Dexterity\nDamage: 18 | Speed: 1.3 | Range: 200",
		"icon": "res://assets/weapons/weapon_bow.png",
		"type": "weapon",
		"slot": Equipment.EquipSlot.WEAPON,
		"attributes": {"dexterity": 2},
		"damage": 18.0,
		"attack_speed": 1.3,
		"range": 200.0,
		"weapon_type": Inventory.WeaponType.RANGED,
		"rarity": Inventory.ItemRarity.COMMON
	},
	"longbow_uncommon": {
		"name": "Longbow",
		"description": "Reinforced longbow. +3 Dexterity\nDamage: 28 | Speed: 1.4 | Range: 210",
		"icon": "res://assets/weapons/weapon_bow_2.png",
		"type": "weapon",
		"slot": Equipment.EquipSlot.WEAPON,
		"attributes": {"dexterity": 3},
		"damage": 28.0,
		"attack_speed": 1.4,
		"range": 210.0,
		"weapon_type": Inventory.WeaponType.RANGED,
		"rarity": Inventory.ItemRarity.UNCOMMON
	},
	"longbow_rare": {
		"name": "Longbow",
		"description": "Elven longbow. +5 Dexterity\nDamage: 48 | Speed: 1.5 | Range: 225",
		"icon": "res://assets/weapons/weapon_arrow.png",
		"type": "weapon",
		"slot": Equipment.EquipSlot.WEAPON,
		"attributes": {"dexterity": 5},
		"damage": 48.0,
		"attack_speed": 1.5,
		"range": 225.0,
		"weapon_type": Inventory.WeaponType.RANGED,
		"rarity": Inventory.ItemRarity.RARE
	},
	"longbow_legendary": {
		"name": "Longbow",
		"description": "Legendary composite bow. +10 Dexterity\nDamage: 98 | Speed: 1.7 | Range: 250",
		"icon": "res://assets/weapons/weapon_bow.png",
		"type": "weapon",
		"slot": Equipment.EquipSlot.WEAPON,
		"attributes": {"dexterity": 10},
		"damage": 98.0,
		"attack_speed": 1.7,
		"range": 250.0,
		"weapon_type": Inventory.WeaponType.RANGED,
		"rarity": Inventory.ItemRarity.LEGENDARY
	},
	
	"magic_staff_common": {
		"name": "Magic Staff",
		"description": "Basic magic staff. +2 Intelligence\nDamage: 20 | Speed: 1.5 | Range: 150",
		"icon": "res://assets/weapons/weapon_red_magic_staff.png",
		"type": "weapon",
		"slot": Equipment.EquipSlot.WEAPON,
		"attributes": {"intelligence": 2},
		"damage": 20.0,
		"attack_speed": 1.5,
		"range": 150.0,
		"weapon_type": Inventory.WeaponType.MAGIC,
		"rarity": Inventory.ItemRarity.COMMON
	},
	"magic_staff_uncommon": {
		"name": "Magic Staff",
		"description": "Enchanted staff. +3 Intelligence\nDamage: 30 | Speed: 1.6 | Range: 160",
		"icon": "res://assets/weapons/weapon_green_magic_staff.png",
		"type": "weapon",
		"slot": Equipment.EquipSlot.WEAPON,
		"attributes": {"intelligence": 3},
		"damage": 30.0,
		"attack_speed": 1.6,
		"range": 160.0,
		"weapon_type": Inventory.WeaponType.MAGIC,
		"rarity": Inventory.ItemRarity.UNCOMMON
	},
	"magic_staff_rare": {
		"name": "Magic Staff",
		"description": "Arcane staff. +5 Intelligence\nDamage: 50 | Speed: 1.75 | Range: 175",
		"icon": "res://assets/weapons/weapon_red_magic_staff.png",
		"type": "weapon",
		"slot": Equipment.EquipSlot.WEAPON,
		"attributes": {"intelligence": 5},
		"damage": 50.0,
		"attack_speed": 1.75,
		"range": 175.0,
		"weapon_type": Inventory.WeaponType.MAGIC,
		"rarity": Inventory.ItemRarity.RARE
	},
	"magic_staff_legendary": {
		"name": "Magic Staff",
		"description": "Staff of the archmage. +10 Intelligence\nDamage: 100 | Speed: 2.0 | Range: 200",
		"icon": "res://assets/weapons/weapon_green_magic_staff.png",
		"type": "weapon",
		"slot": Equipment.EquipSlot.WEAPON,
		"attributes": {"intelligence": 10},
		"damage": 100.0,
		"attack_speed": 2.0,
		"range": 200.0,
		"weapon_type": Inventory.WeaponType.MAGIC,
		"rarity": Inventory.ItemRarity.LEGENDARY
	},
	
	"holy_staff_common": {
		"name": "Holy Staff",
		"description": "Divine support staff. +2 Spirit\nDamage: 15 | Speed: 1.8 | Range: 160",
		"icon": "res://assets/weapons/weapon_green_magic_staff.png",
		"type": "weapon",
		"slot": Equipment.EquipSlot.WEAPON,
		"attributes": {"spirit": 2},
		"damage": 15.0,
		"attack_speed": 1.8,
		"range": 160.0,
		"weapon_type": Inventory.WeaponType.MAGIC,
		"rarity": Inventory.ItemRarity.COMMON
	},
	"holy_staff_uncommon": {
		"name": "Holy Staff",
		"description": "Blessed support staff. +3 Spirit\nDamage: 22 | Speed: 1.9 | Range: 170",
		"icon": "res://assets/weapons/weapon_red_magic_staff.png",
		"type": "weapon",
		"slot": Equipment.EquipSlot.WEAPON,
		"attributes": {"spirit": 3},
		"damage": 22.0,
		"attack_speed": 1.9,
		"range": 170.0,
		"weapon_type": Inventory.WeaponType.MAGIC,
		"rarity": Inventory.ItemRarity.UNCOMMON
	},
	"holy_staff_rare": {
		"name": "Holy Staff",
		"description": "Sacred divine staff. +5 Spirit\nDamage: 35 | Speed: 2.1 | Range: 185",
		"icon": "res://assets/weapons/weapon_green_magic_staff.png",
		"type": "weapon",
		"slot": Equipment.EquipSlot.WEAPON,
		"attributes": {"spirit": 5},
		"damage": 35.0,
		"attack_speed": 2.1,
		"range": 185.0,
		"weapon_type": Inventory.WeaponType.MAGIC,
		"rarity": Inventory.ItemRarity.RARE
	},
	"holy_staff_legendary": {
		"name": "Holy Staff",
		"description": "Legendary angelic staff. +10 Spirit\nDamage: 70 | Speed: 2.5 | Range: 220",
		"icon": "res://assets/weapons/weapon_red_magic_staff.png",
		"type": "weapon",
		"slot": Equipment.EquipSlot.WEAPON,
		"attributes": {"spirit": 10},
		"damage": 70.0,
		"attack_speed": 2.5,
		"range": 220.0,
		"weapon_type": Inventory.WeaponType.MAGIC,
		"rarity": Inventory.ItemRarity.LEGENDARY
	},
	
	"health_potion_common": {
		"name": "Health Potion",
		"description": "Restores 50 HP.",
		"icon": "res://assets/objects/flask_red.png",
		"type": "consumable",
		"rarity": Inventory.ItemRarity.COMMON
	},
	"health_potion_uncommon": {
		"name": "Health Potion",
		"description": "Restores 100 HP.",
		"icon": "res://assets/objects/flask_big_red.png",
		"type": "consumable",
		"rarity": Inventory.ItemRarity.UNCOMMON
	},
	
	"mana_potion_common": {
		"name": "Mana Potion",
		"description": "Restores 30 Mana.",
		"icon": "res://assets/objects/flask_blue.png",
		"type": "consumable",
		"rarity": Inventory.ItemRarity.COMMON
	},
	"mana_potion_uncommon": {
		"name": "Mana Potion",
		"description": "Restores 60 Mana.",
		"icon": "res://assets/objects/flask_big_blue.png",
		"type": "consumable",
		"rarity": Inventory.ItemRarity.UNCOMMON
	},
	
	"warrior_armor_common": {
		"name": "Warrior Armor",
		"description": "Heavy plate armor. +3 Brutality",
		"icon": "res://assets/characters/knight_m_idle_anim_f0.png",
		"type": "equipment",
		"slot": Equipment.EquipSlot.CHEST,
		"attributes": {"brutality": 3},
		"rarity": Inventory.ItemRarity.COMMON
	},
	"warrior_armor_uncommon": {
		"name": "Warrior Armor",
		"description": "Reinforced plate armor. +5 Brutality",
		"icon": "res://assets/characters/knight_m_idle_anim_f1.png",
		"type": "equipment",
		"slot": Equipment.EquipSlot.CHEST,
		"attributes": {"brutality": 5},
		"rarity": Inventory.ItemRarity.UNCOMMON
	},
	"warrior_armor_rare": {
		"name": "Warrior Armor",
		"description": "Masterwork plate armor. +8 Brutality",
		"icon": "res://assets/characters/knight_m_idle_anim_f2.png",
		"type": "equipment",
		"slot": Equipment.EquipSlot.CHEST,
		"attributes": {"brutality": 8},
		"rarity": Inventory.ItemRarity.RARE
	},
	"warrior_armor_legendary": {
		"name": "Warrior Armor",
		"description": "Legendary dragon plate. +15 Brutality",
		"icon": "res://assets/characters/knight_m_idle_anim_f3.png",
		"type": "equipment",
		"slot": Equipment.EquipSlot.CHEST,
		"attributes": {"brutality": 15},
		"rarity": Inventory.ItemRarity.LEGENDARY
	},
	
	"mage_robe_common": {
		"name": "Mage Robe",
		"description": "Enchanted robe. +3 Intelligence",
		"icon": "res://assets/characters/wizzard_m_idle_anim_f0.png",
		"type": "equipment",
		"slot": Equipment.EquipSlot.CHEST,
		"attributes": {"intelligence": 3},
		"rarity": Inventory.ItemRarity.COMMON
	},
	"mage_robe_uncommon": {
		"name": "Mage Robe",
		"description": "Arcane robe. +5 Intelligence",
		"icon": "res://assets/characters/wizzard_m_idle_anim_f1.png",
		"type": "equipment",
		"slot": Equipment.EquipSlot.CHEST,
		"attributes": {"intelligence": 5},
		"rarity": Inventory.ItemRarity.UNCOMMON
	},
	"mage_robe_rare": {
		"name": "Mage Robe",
		"description": "Mystical robe. +8 Intelligence",
		"icon": "res://assets/characters/wizzard_m_idle_anim_f2.png",
		"type": "equipment",
		"slot": Equipment.EquipSlot.CHEST,
		"attributes": {"intelligence": 8},
		"rarity": Inventory.ItemRarity.RARE
	},
	"mage_robe_legendary": {
		"name": "Mage Robe",
		"description": "Legendary archmage robe. +15 Intelligence",
		"icon": "res://assets/characters/wizzard_m_idle_anim_f3.png",
		"type": "equipment",
		"slot": Equipment.EquipSlot.CHEST,
		"attributes": {"intelligence": 15},
		"rarity": Inventory.ItemRarity.LEGENDARY
	},
	
	"ranger_armor_common": {
		"name": "Ranger Armor",
		"description": "Leather armor. +3 Dexterity",
		"icon": "res://assets/characters/elf_m_idle_anim_f0.png",
		"type": "equipment",
		"slot": Equipment.EquipSlot.CHEST,
		"attributes": {"dexterity": 3},
		"rarity": Inventory.ItemRarity.COMMON
	},
	"ranger_armor_uncommon": {
		"name": "Ranger Armor",
		"description": "Studded leather armor. +5 Dexterity",
		"icon": "res://assets/characters/elf_m_idle_anim_f1.png",
		"type": "equipment",
		"slot": Equipment.EquipSlot.CHEST,
		"attributes": {"dexterity": 5},
		"rarity": Inventory.ItemRarity.UNCOMMON
	},
	"ranger_armor_rare": {
		"name": "Ranger Armor",
		"description": "Elven leather armor. +8 Dexterity",
		"icon": "res://assets/characters/elf_m_idle_anim_f2.png",
		"type": "equipment",
		"slot": Equipment.EquipSlot.CHEST,
		"attributes": {"dexterity": 8},
		"rarity": Inventory.ItemRarity.RARE
	},
	"ranger_armor_legendary": {
		"name": "Ranger Armor",
		"description": "Legendary shadowstep armor. +15 Dexterity",
		"icon": "res://assets/characters/elf_m_idle_anim_f3.png",
		"type": "equipment",
		"slot": Equipment.EquipSlot.CHEST,
		"attributes": {"dexterity": 15},
		"rarity": Inventory.ItemRarity.LEGENDARY
	},
	
	"holy_vestments_common": {
		"name": "Holy Vestments",
		"description": "Sacred robes. +3 Spirit",
		"icon": "res://assets/characters/angel_idle_anim_f0.png",
		"type": "equipment",
		"slot": Equipment.EquipSlot.CHEST,
		"attributes": {"spirit": 3},
		"rarity": Inventory.ItemRarity.COMMON
	},
	"holy_vestments_uncommon": {
		"name": "Holy Vestments",
		"description": "Blessed robes. +5 Spirit",
		"icon": "res://assets/characters/angel_idle_anim_f1.png",
		"type": "equipment",
		"slot": Equipment.EquipSlot.CHEST,
		"attributes": {"spirit": 5},
		"rarity": Inventory.ItemRarity.UNCOMMON
	},
	"holy_vestments_rare": {
		"name": "Holy Vestments",
		"description": "Divine robes. +8 Spirit",
		"icon": "res://assets/characters/angel_idle_anim_f2.png",
		"type": "equipment",
		"slot": Equipment.EquipSlot.CHEST,
		"attributes": {"spirit": 8},
		"rarity": Inventory.ItemRarity.RARE
	},
	"holy_vestments_legendary": {
		"name": "Holy Vestments",
		"description": "Legendary angelic vestments. +15 Spirit",
		"icon": "res://assets/characters/angel_idle_anim_f3.png",
		"type": "equipment",
		"slot": Equipment.EquipSlot.CHEST,
		"attributes": {"spirit": 15},
		"rarity": Inventory.ItemRarity.LEGENDARY
	},
	
	"gold_coin": {
		"name": "Gold Coin",
		"description": "Shiny gold coin",
		"icon": "res://assets/objects/coin_anim_f0.png",
		"type": "misc",
		"rarity": Inventory.ItemRarity.COMMON
	},
	
	"treasure_chest": {
		"name": "Treasure Chest",
		"description": "Contains valuable loot",
		"icon": "res://assets/objects/chest_full_open_anim_f0.png",
		"type": "misc",
		"rarity": Inventory.ItemRarity.RARE
	},
	
	"demon_helm_unique": {
		"name": "Demon Lord Helm",
		"description": "Helm of the demon lord. +20 Brutality",
		"icon": "res://assets/enemies/big_demon_idle_anim_f0.png",
		"type": "equipment",
		"slot": Equipment.EquipSlot.HELMET,
		"attributes": {"brutality": 20},
		"rarity": Inventory.ItemRarity.UNIQUE
	},
	
	"necromancer_crown_unique": {
		"name": "Necromancer Crown",
		"description": "Crown of the dark arts. +20 Intelligence",
		"icon": "res://assets/enemies/necromancer_anim_f0.png",
		"type": "equipment",
		"slot": Equipment.EquipSlot.HELMET,
		"attributes": {"intelligence": 20},
		"rarity": Inventory.ItemRarity.UNIQUE
	},
	
	"spear_common": {
		"name": "Spear",
		"description": "Long reaching spear. +2 Dexterity\nDamage: 22 | Speed: 1.0 | Range: 180",
		"icon": "res://assets/weapons/weapon_spear.png",
		"type": "weapon",
		"slot": Equipment.EquipSlot.WEAPON,
		"attributes": {"dexterity": 2},
		"damage": 22.0,
		"attack_speed": 1.0,
		"range": 180.0,
		"weapon_type": Inventory.WeaponType.MELEE,
		"rarity": Inventory.ItemRarity.COMMON
	},
	"spear_rare": {
		"name": "Spear",
		"description": "Legendary dragon spear. +8 Dexterity\nDamage: 70 | Speed: 1.2 | Range: 200",
		"icon": "res://assets/weapons/weapon_spear.png",
		"type": "weapon",
		"slot": Equipment.EquipSlot.WEAPON,
		"attributes": {"dexterity": 8},
		"damage": 70.0,
		"attack_speed": 1.2,
		"range": 200.0,
		"weapon_type": Inventory.WeaponType.MELEE,
		"rarity": Inventory.ItemRarity.RARE
	},
	
	"hammer_common": {
		"name": "War Hammer",
		"description": "Heavy war hammer. +2 Brutality\nDamage: 35 | Speed: 0.6 | Range: 130",
		"icon": "res://assets/weapons/weapon_hammer.png",
		"type": "weapon",
		"slot": Equipment.EquipSlot.WEAPON,
		"attributes": {"brutality": 2},
		"damage": 35.0,
		"attack_speed": 0.6,
		"range": 130.0,
		"weapon_type": Inventory.WeaponType.MELEE,
		"rarity": Inventory.ItemRarity.COMMON
	},
	"hammer_rare": {
		"name": "War Hammer",
		"description": "Titan's war hammer. +8 Brutality\nDamage: 90 | Speed: 0.75 | Range: 150",
		"icon": "res://assets/weapons/weapon_big_hammer.png",
		"type": "weapon",
		"slot": Equipment.EquipSlot.WEAPON,
		"attributes": {"brutality": 8},
		"damage": 90.0,
		"attack_speed": 0.75,
		"range": 150.0,
		"weapon_type": Inventory.WeaponType.MELEE,
		"rarity": Inventory.ItemRarity.RARE
	},
	
	"dagger_common": {
		"name": "Dagger",
		"description": "Quick dagger. +2 Agility\nDamage: 12 | Speed: 2.5 | Range: 100",
		"icon": "res://assets/weapons/weapon_knife.png",
		"type": "weapon",
		"slot": Equipment.EquipSlot.WEAPON,
		"attributes": {"agility": 2},
		"damage": 12.0,
		"attack_speed": 2.5,
		"range": 100.0,
		"weapon_type": Inventory.WeaponType.MELEE,
		"rarity": Inventory.ItemRarity.COMMON
	},
	"dagger_uncommon": {
		"name": "Dagger",
		"description": "Serrated dagger. +3 Agility\nDamage: 18 | Speed: 2.7 | Range: 110",
		"icon": "res://assets/weapons/weapon_machete.png",
		"type": "weapon",
		"slot": Equipment.EquipSlot.WEAPON,
		"attributes": {"agility": 3},
		"damage": 18.0,
		"attack_speed": 2.7,
		"range": 110.0,
		"weapon_type": Inventory.WeaponType.MELEE,
		"rarity": Inventory.ItemRarity.UNCOMMON
	},
	"dagger_rare": {
		"name": "Dagger",
		"description": "Katana blade. +5 Agility\nDamage: 35 | Speed: 3.0 | Range: 125",
		"icon": "res://assets/weapons/weapon_katana.png",
		"type": "weapon",
		"slot": Equipment.EquipSlot.WEAPON,
		"attributes": {"agility": 5},
		"damage": 35.0,
		"attack_speed": 3.0,
		"range": 125.0,
		"weapon_type": Inventory.WeaponType.MELEE,
		"rarity": Inventory.ItemRarity.RARE
	},
	"dagger_legendary": {
		"name": "Dagger",
		"description": "Legendary assassin blade. +10 Agility\nDamage: 70 | Speed: 3.5 | Range: 150",
		"icon": "res://assets/weapons/weapon_red_gem_sword.png",
		"type": "weapon",
		"slot": Equipment.EquipSlot.WEAPON,
		"attributes": {"agility": 10},
		"damage": 70.0,
		"attack_speed": 3.5,
		"range": 150.0,
		"weapon_type": Inventory.WeaponType.MELEE,
		"rarity": Inventory.ItemRarity.LEGENDARY
	},
	
	"throwing_axe_common": {
		"name": "Throwing Axe",
		"description": "Balanced throwing axe. +2 Brutality\nDamage: 20 | Speed: 1.5 | Range: 170",
		"icon": "res://assets/weapons/weapon_throwing_axe.png",
		"type": "weapon",
		"slot": Equipment.EquipSlot.WEAPON,
		"attributes": {"brutality": 2},
		"damage": 20.0,
		"attack_speed": 1.5,
		"range": 170.0,
		"weapon_type": Inventory.WeaponType.RANGED,
		"rarity": Inventory.ItemRarity.COMMON
	},
	
	"mace_uncommon": {
		"name": "Mace",
		"description": "Heavy mace. +3 Brutality\nDamage: 32 | Speed: 0.75 | Range: 135",
		"icon": "res://assets/weapons/weapon_mace.png",
		"type": "weapon",
		"slot": Equipment.EquipSlot.WEAPON,
		"attributes": {"brutality": 3},
		"damage": 32.0,
		"attack_speed": 0.75,
		"range": 135.0,
		"weapon_type": Inventory.WeaponType.MELEE,
		"rarity": Inventory.ItemRarity.UNCOMMON
	},
	
	"spiked_baton_rare": {
		"name": "Spiked Baton",
		"description": "Brutal spiked weapon. +6 Brutality\nDamage: 58 | Speed: 0.9 | Range: 145",
		"icon": "res://assets/weapons/weapon_baton_with_spikes.png",
		"type": "weapon",
		"slot": Equipment.EquipSlot.WEAPON,
		"attributes": {"brutality": 6},
		"damage": 58.0,
		"attack_speed": 0.9,
		"range": 145.0,
		"weapon_type": Inventory.WeaponType.MELEE,
		"rarity": Inventory.ItemRarity.RARE
	},
	
	"lavish_sword_legendary": {
		"name": "Lavish Sword",
		"description": "Ornate royal blade. +12 Brutality\nDamage: 105 | Speed: 1.1 | Range: 185",
		"icon": "res://assets/weapons/weapon_lavish_sword.png",
		"type": "weapon",
		"slot": Equipment.EquipSlot.WEAPON,
		"attributes": {"brutality": 12},
		"damage": 105.0,
		"attack_speed": 1.1,
		"range": 185.0,
		"weapon_type": Inventory.WeaponType.MELEE,
		"rarity": Inventory.ItemRarity.LEGENDARY
	},
	
	"saw_sword_unique": {
		"name": "Saw Sword",
		"description": "Demonic chainsaw blade. +18 Brutality\nDamage: 190 | Speed: 1.3 | Range: 160",
		"icon": "res://assets/weapons/weapon_saw_sword.png",
		"type": "weapon",
		"slot": Equipment.EquipSlot.WEAPON,
		"attributes": {"brutality": 18},
		"damage": 190.0,
		"attack_speed": 1.3,
		"range": 160.0,
		"weapon_type": Inventory.WeaponType.MELEE,
		"rarity": Inventory.ItemRarity.UNIQUE
	},
	
	"iron_greaves_common": {
		"name": "Iron Greaves",
		"description": "Sturdy leg armor. +2 Brutality",
		"icon": "res://assets/characters/knight_m_run_anim_f0.png",
		"type": "equipment",
		"slot": Equipment.EquipSlot.LEGS,
		"attributes": {"brutality": 2},
		"rarity": Inventory.ItemRarity.COMMON
	},
	"iron_greaves_uncommon": {
		"name": "Iron Greaves",
		"description": "Reinforced leg armor. +3 Brutality",
		"icon": "res://assets/characters/knight_m_run_anim_f1.png",
		"type": "equipment",
		"slot": Equipment.EquipSlot.LEGS,
		"attributes": {"brutality": 3},
		"rarity": Inventory.ItemRarity.UNCOMMON
	},
	"iron_greaves_rare": {
		"name": "Iron Greaves",
		"description": "Masterwork leg armor. +5 Brutality",
		"icon": "res://assets/characters/knight_m_run_anim_f2.png",
		"type": "equipment",
		"slot": Equipment.EquipSlot.LEGS,
		"attributes": {"brutality": 5},
		"rarity": Inventory.ItemRarity.RARE
	},
	
	"scholar_pants_common": {
		"name": "Scholar Pants",
		"description": "Comfortable for study. +2 Intelligence",
		"icon": "res://assets/characters/wizzard_m_run_anim_f0.png",
		"type": "equipment",
		"slot": Equipment.EquipSlot.LEGS,
		"attributes": {"intelligence": 2},
		"rarity": Inventory.ItemRarity.COMMON
	},
	"scholar_pants_rare": {
		"name": "Scholar Pants",
		"description": "Enchanted scholar pants. +5 Intelligence",
		"icon": "res://assets/characters/wizzard_m_run_anim_f2.png",
		"type": "equipment",
		"slot": Equipment.EquipSlot.LEGS,
		"attributes": {"intelligence": 5},
		"rarity": Inventory.ItemRarity.RARE
	},
	
	"hunter_trousers_common": {
		"name": "Hunter Trousers",
		"description": "Perfect for stalking. +2 Dexterity",
		"icon": "res://assets/characters/elf_m_run_anim_f0.png",
		"type": "equipment",
		"slot": Equipment.EquipSlot.LEGS,
		"attributes": {"dexterity": 2},
		"rarity": Inventory.ItemRarity.COMMON
	},
	"hunter_trousers_rare": {
		"name": "Hunter Trousers",
		"description": "Masterwork hunting pants. +5 Dexterity",
		"icon": "res://assets/characters/elf_m_run_anim_f2.png",
		"type": "equipment",
		"slot": Equipment.EquipSlot.LEGS,
		"attributes": {"dexterity": 5},
		"rarity": Inventory.ItemRarity.RARE
	},
	
	"blessed_leggings_common": {
		"name": "Blessed Leggings",
		"description": "Spiritually empowered. +2 Spirit",
		"icon": "res://assets/characters/angel_run_anim_f0.png",
		"type": "equipment",
		"slot": Equipment.EquipSlot.LEGS,
		"attributes": {"spirit": 2},
		"rarity": Inventory.ItemRarity.COMMON
	},
	"blessed_leggings_rare": {
		"name": "Blessed Leggings",
		"description": "Divine leggings. +5 Spirit",
		"icon": "res://assets/characters/angel_run_anim_f2.png",
		"type": "equipment",
		"slot": Equipment.EquipSlot.LEGS,
		"attributes": {"spirit": 5},
		"rarity": Inventory.ItemRarity.RARE
	},
	
	"warrior_boots_common": {
		"name": "Warrior Boots",
		"description": "Heavy combat boots. +2 Brutality",
		"icon": "res://assets/characters/knight_m_run_anim_f0.png",
		"type": "equipment",
		"slot": Equipment.EquipSlot.BOOTS,
		"attributes": {"brutality": 2},
		"rarity": Inventory.ItemRarity.COMMON
	},
	"warrior_boots_rare": {
		"name": "Warrior Boots",
		"description": "Masterwork combat boots. +5 Brutality",
		"icon": "res://assets/characters/knight_m_run_anim_f2.png",
		"type": "equipment",
		"slot": Equipment.EquipSlot.BOOTS,
		"attributes": {"brutality": 5},
		"rarity": Inventory.ItemRarity.RARE
	},
	
	"sage_boots_common": {
		"name": "Sage Boots",
		"description": "Steps of wisdom. +2 Intelligence",
		"icon": "res://assets/characters/wizzard_m_run_anim_f0.png",
		"type": "equipment",
		"slot": Equipment.EquipSlot.BOOTS,
		"attributes": {"intelligence": 2},
		"rarity": Inventory.ItemRarity.COMMON
	},
	"sage_boots_rare": {
		"name": "Sage Boots",
		"description": "Arcane sage boots. +5 Intelligence",
		"icon": "res://assets/characters/wizzard_m_run_anim_f2.png",
		"type": "equipment",
		"slot": Equipment.EquipSlot.BOOTS,
		"attributes": {"intelligence": 5},
		"rarity": Inventory.ItemRarity.RARE
	},
	
	"marksman_boots_common": {
		"name": "Marksman Boots",
		"description": "Stable footing. +2 Dexterity",
		"icon": "res://assets/characters/elf_m_run_anim_f0.png",
		"type": "equipment",
		"slot": Equipment.EquipSlot.BOOTS,
		"attributes": {"dexterity": 2},
		"rarity": Inventory.ItemRarity.COMMON
	},
	"marksman_boots_rare": {
		"name": "Marksman Boots",
		"description": "Perfect aim boots. +5 Dexterity",
		"icon": "res://assets/characters/elf_m_run_anim_f2.png",
		"type": "equipment",
		"slot": Equipment.EquipSlot.BOOTS,
		"attributes": {"dexterity": 5},
		"rarity": Inventory.ItemRarity.RARE
	},
	
	"monk_sandals_common": {
		"name": "Monk Sandals",
		"description": "Walk the path. +2 Spirit",
		"icon": "res://assets/characters/angel_run_anim_f0.png",
		"type": "equipment",
		"slot": Equipment.EquipSlot.BOOTS,
		"attributes": {"spirit": 2},
		"rarity": Inventory.ItemRarity.COMMON
	},
	
	"warrior_gloves_common": {
		"name": "Warrior Gloves",
		"description": "Heavy gauntlets. +2 Brutality",
		"icon": "res://assets/characters/knight_m_idle_anim_f0.png",
		"type": "equipment",
		"slot": Equipment.EquipSlot.GLOVES,
		"attributes": {"brutality": 2},
		"rarity": Inventory.ItemRarity.COMMON
	},
	"warrior_gloves_rare": {
		"name": "Warrior Gloves",
		"description": "Reinforced gauntlets. +5 Brutality",
		"icon": "res://assets/characters/knight_m_idle_anim_f2.png",
		"type": "equipment",
		"slot": Equipment.EquipSlot.GLOVES,
		"attributes": {"brutality": 5},
		"rarity": Inventory.ItemRarity.RARE
	},
	
	"mystic_gloves_common": {
		"name": "Mystic Gloves",
		"description": "Channel arcane power. +2 Intelligence",
		"icon": "res://assets/characters/wizzard_m_idle_anim_f0.png",
		"type": "equipment",
		"slot": Equipment.EquipSlot.GLOVES,
		"attributes": {"intelligence": 2},
		"rarity": Inventory.ItemRarity.COMMON
	},
	"mystic_gloves_rare": {
		"name": "Mystic Gloves",
		"description": "Enhanced arcane gloves. +5 Intelligence",
		"icon": "res://assets/characters/wizzard_m_idle_anim_f2.png",
		"type": "equipment",
		"slot": Equipment.EquipSlot.GLOVES,
		"attributes": {"intelligence": 5},
		"rarity": Inventory.ItemRarity.RARE
	},
	
	"archer_gloves_common": {
		"name": "Archer Gloves",
		"description": "Steady hands. +2 Dexterity",
		"icon": "res://assets/characters/elf_m_idle_anim_f0.png",
		"type": "equipment",
		"slot": Equipment.EquipSlot.GLOVES,
		"attributes": {"dexterity": 2},
		"rarity": Inventory.ItemRarity.COMMON
	},
	"archer_gloves_rare": {
		"name": "Archer Gloves",
		"description": "Perfect shot gloves. +5 Dexterity",
		"icon": "res://assets/characters/elf_m_idle_anim_f2.png",
		"type": "equipment",
		"slot": Equipment.EquipSlot.GLOVES,
		"attributes": {"dexterity": 5},
		"rarity": Inventory.ItemRarity.RARE
	},
	
	"prayer_gloves_common": {
		"name": "Prayer Gloves",
		"description": "Hands of healing. +2 Spirit",
		"icon": "res://assets/characters/angel_idle_anim_f0.png",
		"type": "equipment",
		"slot": Equipment.EquipSlot.GLOVES,
		"attributes": {"spirit": 2},
		"rarity": Inventory.ItemRarity.COMMON
	},
	
	"war_belt_common": {
		"name": "War Belt",
		"description": "Belt of strength. +2 Brutality",
		"icon": "res://assets/characters/knight_m_idle_anim_f0.png",
		"type": "equipment",
		"slot": Equipment.EquipSlot.BELT,
		"attributes": {"brutality": 2},
		"rarity": Inventory.ItemRarity.COMMON
	},
	"war_belt_rare": {
		"name": "War Belt",
		"description": "Titan's belt. +5 Brutality",
		"icon": "res://assets/characters/knight_m_idle_anim_f2.png",
		"type": "equipment",
		"slot": Equipment.EquipSlot.BELT,
		"attributes": {"brutality": 5},
		"rarity": Inventory.ItemRarity.RARE
	},
	
	"scholar_belt_common": {
		"name": "Scholar Belt",
		"description": "Holds tomes. +2 Intelligence",
		"icon": "res://assets/characters/wizzard_m_idle_anim_f0.png",
		"type": "equipment",
		"slot": Equipment.EquipSlot.BELT,
		"attributes": {"intelligence": 2},
		"rarity": Inventory.ItemRarity.COMMON
	},
	
	"quiver_belt_common": {
		"name": "Quiver Belt",
		"description": "Quick draw. +2 Dexterity",
		"icon": "res://assets/characters/elf_m_idle_anim_f0.png",
		"type": "equipment",
		"slot": Equipment.EquipSlot.BELT,
		"attributes": {"dexterity": 2},
		"rarity": Inventory.ItemRarity.COMMON
	},
	
	"meditation_sash_common": {
		"name": "Meditation Sash",
		"description": "Centers spirit. +2 Spirit",
		"icon": "res://assets/characters/angel_idle_anim_f0.png",
		"type": "equipment",
		"slot": Equipment.EquipSlot.BELT,
		"attributes": {"spirit": 2},
		"rarity": Inventory.ItemRarity.COMMON
	},
	
	"bear_tooth_necklace_common": {
		"name": "Bear Tooth Necklace",
		"description": "Primal power. +2 Brutality",
		"icon": "res://assets/enemies/skull.png",
		"type": "equipment",
		"slot": Equipment.EquipSlot.NECKLACE,
		"attributes": {"brutality": 2},
		"rarity": Inventory.ItemRarity.COMMON
	},
	"bear_tooth_necklace_rare": {
		"name": "Bear Tooth Necklace",
		"description": "Ancient primal power. +5 Brutality",
		"icon": "res://assets/enemies/skull.png",
		"type": "equipment",
		"slot": Equipment.EquipSlot.NECKLACE,
		"attributes": {"brutality": 5},
		"rarity": Inventory.ItemRarity.RARE
	},
	
	"angel_pendant_common": {
		"name": "Angel Pendant",
		"description": "Divine protection. +2 Spirit",
		"icon": "res://assets/objects/flask_big_red.full.png",
		"type": "equipment",
		"slot": Equipment.EquipSlot.NECKLACE,
		"attributes": {"spirit": 2},
		"rarity": Inventory.ItemRarity.COMMON
	},
	
	"eye_of_knowledge_common": {
		"name": "Eye of Knowledge",
		"description": "Sees all truths. +2 Intelligence",
		"icon": "res://assets/objects/flask_big_red.half.png",
		"type": "equipment",
		"slot": Equipment.EquipSlot.NECKLACE,
		"attributes": {"intelligence": 2},
		"rarity": Inventory.ItemRarity.COMMON
	},
	
	"hawk_talon_common": {
		"name": "Hawk Talon",
		"description": "Sharp vision. +2 Dexterity",
		"icon": "res://assets/objects/flask_big_red.empty.png",
		"type": "equipment",
		"slot": Equipment.EquipSlot.NECKLACE,
		"attributes": {"dexterity": 2},
		"rarity": Inventory.ItemRarity.COMMON
	},
	
	"ring_of_might_common": {
		"name": "Ring of Might",
		"description": "Empowers strikes. +1 Brutality",
		"icon": "res://assets/objects/coin_anim_f0.png",
		"type": "equipment",
		"slot": Equipment.EquipSlot.RING1,
		"attributes": {"brutality": 1},
		"rarity": Inventory.ItemRarity.COMMON
	},
	"ring_of_might_uncommon": {
		"name": "Ring of Might",
		"description": "Enhanced power ring. +2 Brutality",
		"icon": "res://assets/objects/coin_anim_f1.png",
		"type": "equipment",
		"slot": Equipment.EquipSlot.RING1,
		"attributes": {"brutality": 2},
		"rarity": Inventory.ItemRarity.UNCOMMON
	},
	"ring_of_might_rare": {
		"name": "Ring of Might",
		"description": "Powerful magic ring. +3 Brutality",
		"icon": "res://assets/objects/coin_anim_f2.png",
		"type": "equipment",
		"slot": Equipment.EquipSlot.RING1,
		"attributes": {"brutality": 3},
		"rarity": Inventory.ItemRarity.RARE
	},
	"ring_of_might_legendary": {
		"name": "Ring of Might",
		"description": "Legendary titan ring. +6 Brutality",
		"icon": "res://assets/objects/coin_anim_f3.png",
		"type": "equipment",
		"slot": Equipment.EquipSlot.RING1,
		"attributes": {"brutality": 6},
		"rarity": Inventory.ItemRarity.LEGENDARY
	},
	
	"soul_ring_common": {
		"name": "Soul Ring",
		"description": "Nurtures soul. +1 Spirit",
		"icon": "res://assets/objects/coin_anim_f0.png",
		"type": "equipment",
		"slot": Equipment.EquipSlot.RING1,
		"attributes": {"spirit": 1},
		"rarity": Inventory.ItemRarity.COMMON
	},
	"soul_ring_rare": {
		"name": "Soul Ring",
		"description": "Divine soul ring. +3 Spirit",
		"icon": "res://assets/objects/coin_anim_f2.png",
		"type": "equipment",
		"slot": Equipment.EquipSlot.RING1,
		"attributes": {"spirit": 3},
		"rarity": Inventory.ItemRarity.RARE
	},
	
	"mind_ring_common": {
		"name": "Mind Ring",
		"description": "Sharpens thoughts. +1 Intelligence",
		"icon": "res://assets/objects/coin_anim_f0.png",
		"type": "equipment",
		"slot": Equipment.EquipSlot.RING1,
		"attributes": {"intelligence": 1},
		"rarity": Inventory.ItemRarity.COMMON
	},
	"mind_ring_rare": {
		"name": "Mind Ring",
		"description": "Arcane mind ring. +3 Intelligence",
		"icon": "res://assets/objects/coin_anim_f2.png",
		"type": "equipment",
		"slot": Equipment.EquipSlot.RING1,
		"attributes": {"intelligence": 3},
		"rarity": Inventory.ItemRarity.RARE
	},
	
	"precision_ring_common": {
		"name": "Precision Ring",
		"description": "Never miss. +1 Dexterity",
		"icon": "res://assets/objects/coin_anim_f0.png",
		"type": "equipment",
		"slot": Equipment.EquipSlot.RING1,
		"attributes": {"dexterity": 1},
		"rarity": Inventory.ItemRarity.COMMON
	},
	"precision_ring_rare": {
		"name": "Precision Ring",
		"description": "Perfect aim ring. +3 Dexterity",
		"icon": "res://assets/objects/coin_anim_f2.png",
		"type": "equipment",
		"slot": Equipment.EquipSlot.RING1,
		"attributes": {"dexterity": 3},
		"rarity": Inventory.ItemRarity.RARE
	},
	
	"dodge_ring_common": {
		"name": "Dodge Ring",
		"description": "Quick reflexes. +1 Agility",
		"icon": "res://assets/objects/coin_anim_f0.png",
		"type": "equipment",
		"slot": Equipment.EquipSlot.RING1,
		"attributes": {"agility": 1},
		"rarity": Inventory.ItemRarity.COMMON
	},
	
	"fortune_ring_common": {
		"name": "Fortune Ring",
		"description": "Lucky charm. +1 Luck",
		"icon": "res://assets/objects/coin_anim_f0.png",
		"type": "equipment",
		"slot": Equipment.EquipSlot.RING1,
		"attributes": {"luck": 1},
		"rarity": Inventory.ItemRarity.COMMON
	}
}
