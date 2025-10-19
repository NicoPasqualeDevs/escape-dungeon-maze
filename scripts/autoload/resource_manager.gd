extends Node

var texture_cache: Dictionary = {}
var stylebox_cache: Dictionary = {}

func get_texture(path: String) -> Texture2D:
	if not texture_cache.has(path):
		if ResourceLoader.exists(path):
			texture_cache[path] = load(path)
		else:
			return null
	return texture_cache[path]

func preload_textures(paths: Array) -> void:
	for path in paths:
		get_texture(path)

func clear_cache() -> void:
	texture_cache.clear()
	stylebox_cache.clear()

func get_stylebox_flat(bg_color: Color, border_width: int = 0, border_color: Color = Color.WHITE) -> StyleBoxFlat:
	var cache_key = "%s_%d_%s" % [bg_color.to_html(), border_width, border_color.to_html()]
	
	if not stylebox_cache.has(cache_key):
		var style = StyleBoxFlat.new()
		style.bg_color = bg_color
		if border_width > 0:
			style.border_width_left = border_width
			style.border_width_right = border_width
			style.border_width_top = border_width
			style.border_width_bottom = border_width
			style.border_color = border_color
		stylebox_cache[cache_key] = style
	
	return stylebox_cache[cache_key]

func get_button_stylebox(bg_color: Color, border_color: Color = Color(0.4, 0.4, 0.45), border_width: int = 2) -> StyleBoxFlat:
	return get_stylebox_flat(bg_color, border_width, border_color)

func get_health_bar_style(health_percent: float) -> StyleBoxFlat:
	var color: Color
	if health_percent > 0.6:
		color = GameConstants.COLORS.health_high
	elif health_percent > 0.3:
		color = GameConstants.COLORS.health_medium
	else:
		color = GameConstants.COLORS.health_low
	
	# Añadir un borde sutil para mejor visibilidad
	return get_stylebox_flat(color, 1, Color(0.2, 0.2, 0.2))

