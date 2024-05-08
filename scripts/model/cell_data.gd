class_name CellData
extends Resource

@export_category("Data")
@export var name: String
@export_multiline var description: String
@export var probability: float = 1.0
@export var tint: Color = "white"
@export var texture: Texture2D
@export var interact_event: EventScript
@export var bump_event: EventScript
@export var solid: bool = false
