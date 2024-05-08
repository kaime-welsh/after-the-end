class_name MapView
extends Node2D

@export var scale_speed: float = 0.2

static var cell_size: int = 16
var cells: Dictionary = {}

func _ready() -> void:
	Map.cell_changed.connect(on_cell_changed)
	Map.map_ready.connect(build_map)

func build_map() -> void:
	for child in get_children():
		child.queue_free()
	
	for key in Map.cells:
		var cell: CellData = Map.cells[key] 
		var sprite: Sprite2D = Sprite2D.new()
		
		_set_cell_from_data(sprite, cell)
		sprite.position = Utils.key_to_coord(key) * cell_size
		add_child(sprite, true)
		
		# Animate tile creation
		@warning_ignore('narrowing_conversion')
		var dist: int = Utils.key_to_coord(key).distance_to(Vector2.ZERO)
		get_tree().create_timer(dist * 0.1).timeout.connect(
			func():
				_tween_cell(sprite)
		)
		
		cells[key] = sprite

func _set_cell_from_data(sprite: Sprite2D, cell: CellData) -> void:
		#sprite.name = cell.name + key
		sprite.texture = cell.texture
		sprite.modulate = cell.tint
		sprite.scale = Vector2.ZERO

func _tween_cell(sprite: Sprite2D) -> void:
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(sprite, "scale", Vector2.ONE, scale_speed)

func on_cell_changed(cell_id: String) -> void:
	var sprite: Sprite2D = cells[cell_id]
	var cell: CellData = Map.cells[cell_id]
	
	_set_cell_from_data(sprite, cell)
	_tween_cell(sprite)
