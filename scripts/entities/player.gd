class_name Player
extends Node2D

@export var data: PlayerData

var grid_position: Vector2 = Vector2.ZERO

@onready var sprite: Sprite2D = $Sprite2D

var supplies: int:
	set(value):
		if value < 0:
			EventBus.player_died.emit()
		EventBus.player_supplies_changed.emit(value)
		supplies = value
	get:
		return supplies
var cargo: int:
	set(value):
		EventBus.player_cargo_changed.emit(value)
		cargo = value
	get:
		return cargo

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed('move_up'): move(0, -1)
	elif Input.is_action_just_pressed('move_down'): move(0, 1)
	elif Input.is_action_just_pressed('move_left'): move(-1, 0)
	elif Input.is_action_just_pressed('move_right'): move(1, 0)
	
	if Input.is_action_just_pressed('interact'):
		@warning_ignore('narrowing_conversion')
		var cell: CellData = Map.get_cell_by_coords(grid_position.x, grid_position.y)
		if not cell.interact_event == null:
			cell.interact_event.execute()

func move(x: int, y: int) -> void:
	@warning_ignore('narrowing_conversion')
	var cell: CellData = Map.get_cell_by_coords(grid_position.x + x, grid_position.y + y)
	
	EventBus.play_sfx.emit("FOOTSTEP")
	
	if cell:
		if not cell.solid:
			grid_position += Vector2(x, y)
			EventBus.player_moved.emit(grid_position)
			supplies -= 1
		
			var move_tween = create_tween()
			move_tween.set_ease(Tween.EASE_IN)
			move_tween.tween_property(
				self,
				"position",
				grid_position * MapView.cell_size,
				data.move_speed
			)
			
			sprite.scale.y = 0.2
			var scale_tween = create_tween()
			scale_tween.set_ease(Tween.EASE_IN)
			scale_tween.tween_property(
				sprite,
				"scale",
				Vector2.ONE,
				data.scale_speed
			)
	
		if cell.bump_event:
			cell.bump_event.execute()

func teleport_to(x: int, y: int) -> void:
	grid_position = Vector2(x, y)
	position = grid_position * MapView.cell_size
