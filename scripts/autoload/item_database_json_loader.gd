extends Node

var items_data: Dictionary = {}

func _ready():
	load_items_from_directory("res://data/items/")

func load_items_from_directory(directory_path: String) -> void:
	var dir = DirAccess.open(directory_path)
	if not dir:
		push_error("Cannot open items directory: " + directory_path)
		return
	
	dir.list_dir_begin()
	var file_name = dir.get_next()
	
	while file_name != "":
		if not dir.current_is_dir() and file_name.ends_with(".json"):
			var full_path = directory_path.path_join(file_name)
			_load_json_file(full_path)
		file_name = dir.get_next()
	
	dir.list_dir_end()

func _load_json_file(file_path: String) -> void:
	var file = FileAccess.open(file_path, FileAccess.READ)
	if not file:
		push_error("Cannot open file: " + file_path)
		return
	
	var json_text = file.get_as_text()
	file.close()
	
	var json = JSON.new()
	var error = json.parse(json_text)
	
	if error != OK:
		push_error("JSON Parse Error in " + file_path + ": " + json.get_error_message())
		return
	
	var data = json.data
	
	if data.has("weapons"):
		for weapon_data in data["weapons"]:
			_register_item(weapon_data)
	
	if data.has("armor"):
		for armor_data in data["armor"]:
			_register_item(armor_data)
	
	if data.has("accessories"):
		for accessory_data in data["accessories"]:
			_register_item(accessory_data)
	
	if data.has("consumables"):
		for consumable_data in data["consumables"]:
			_register_item(consumable_data)

func _register_item(item_data: Dictionary) -> void:
	if not item_data.has("id"):
		push_error("Item without ID found")
		return
	
	var processed_data = {
		"name": item_data.get("name", "Unknown"),
		"description": item_data.get("description", ""),
		"icon": item_data.get("icon", ""),
		"type": item_data.get("type", "misc"),
		"rarity": _parse_rarity(item_data.get("rarity", "COMMON"))
	}
	
	if item_data.has("slot"):
		processed_data["slot"] = _parse_equipment_slot(item_data["slot"])
	
	if item_data.has("attributes"):
		processed_data["attributes"] = item_data["attributes"]
	
	if item_data.has("weapon_stats"):
		var ws = item_data["weapon_stats"]
		processed_data["damage"] = ws.get("damage", 0.0)
		processed_data["attack_speed"] = ws.get("attack_speed", 1.0)
		processed_data["range"] = ws.get("range", 100.0)
		processed_data["weapon_type"] = _parse_weapon_type(ws.get("weapon_type", "MELEE"))
	
	items_data[item_data["id"]] = processed_data

func _parse_rarity(rarity_string: String) -> Inventory.ItemRarity:
	match rarity_string:
		"NORMAL":
			return Inventory.ItemRarity.NORMAL
		"COMMON":
			return Inventory.ItemRarity.COMMON
		"UNCOMMON":
			return Inventory.ItemRarity.UNCOMMON
		"RARE":
			return Inventory.ItemRarity.RARE
		"LEGENDARY":
			return Inventory.ItemRarity.LEGENDARY
		"UNIQUE":
			return Inventory.ItemRarity.UNIQUE
		_:
			return Inventory.ItemRarity.COMMON

func _parse_equipment_slot(slot_string: String) -> Equipment.EquipSlot:
	match slot_string:
		"HELMET":
			return Equipment.EquipSlot.HELMET
		"CHEST":
			return Equipment.EquipSlot.CHEST
		"LEGS":
			return Equipment.EquipSlot.LEGS
		"BOOTS":
			return Equipment.EquipSlot.BOOTS
		"GLOVES":
			return Equipment.EquipSlot.GLOVES
		"BELT":
			return Equipment.EquipSlot.BELT
		"NECKLACE":
			return Equipment.EquipSlot.NECKLACE
		"RING1":
			return Equipment.EquipSlot.RING1
		"RING2":
			return Equipment.EquipSlot.RING2
		"WEAPON":
			return Equipment.EquipSlot.WEAPON
		_:
			return Equipment.EquipSlot.HELMET

func _parse_weapon_type(type_string: String) -> Inventory.WeaponType:
	match type_string:
		"MELEE":
			return Inventory.WeaponType.MELEE
		"RANGED":
			return Inventory.WeaponType.RANGED
		"MAGIC":
			return Inventory.WeaponType.MAGIC
		_:
			return Inventory.WeaponType.MELEE

func create_item(item_id: String) -> Inventory.Item:
	if not items_data.has(item_id):
		push_error("Item not found: " + item_id)
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

