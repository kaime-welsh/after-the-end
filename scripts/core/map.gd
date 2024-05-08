extends Node

signal map_ready()
signal cell_changed(cell_id: String)

var data: MapData
var cells: Dictionary = {}

func build_map() -> void:
	cells.clear()
	for y in range(-data.radius, data.radius + 1):
		for x in range(-data.radius, data.radius + 1):
			if (x * x + y * y) <= (data.radius * data.radius):
				cells[Utils.coord_to_key(x, y)] = data.empty_cell
	cells["0,0"] = data.center_cell
	map_ready.emit()

func get_cell_by_coords(x: int, y: int) -> CellData:
	if cells.has(Utils.coord_to_key(x, y)):
		return cells[Utils.coord_to_key(x, y)]
	return null

func set_cell_by_coords(x: int, y: int, new_cell:CellData) -> void:
	cells[Utils.coord_to_key(x, y)] = new_cell
	cell_changed.emit(Utils.coord_to_key(x, y))

func get_cell_by_key(key: String) -> CellData:
	if cells.has(key):
		return cells[key]
	return null

func set_cell_by_key(key: String, new_cell:CellData) -> void:
	cells[key] = new_cell
	cell_changed.emit(key)

func in_bounds(x: int, y: int) -> bool:
	return cells.has(Utils.coord_to_key(x, y))

