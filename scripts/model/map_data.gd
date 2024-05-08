class_name MapData
extends Resource

@export var radius: int = 5
@export var cells: Array[CellData]
@export var empty_cell: CellData
@export var center_cell: CellData
@export var blocked_cell: CellData

func get_by_id(cell_id: String) -> CellData:
	match cell_id:
		"EMPTY":
			return empty_cell
		"BLOCKED":
			return blocked_cell
	for cell in cells:
		if cell.name.to_upper() == cell_id.to_upper():
			return cell
	return null
