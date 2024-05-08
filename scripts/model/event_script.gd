class_name EventScript
extends Resource

@export_multiline var data: String

func _parse_command_string() -> void:
	var lines := data.split("\n", false)
	
	for line in lines:
		line = line.to_upper()
		
		match line.split(" ")[0]:
			"LOG":
				log_command(line)
			"ADD":
				add_command(line)
			"REMOVE":
				remove_command(line)
			"SETCELL":
				set_cell_command(line)
			"SFX":
				play_sound_command(line)
			"ENDDAY":
				EventBus.end_day.emit()
			"COMBAT":
				EventBus.enter_combat()

func log_command(line: String) -> void:
	var tokens := line.split("=", false)
	EventBus.log_message.emit(tokens[1])

func add_command(line: String) -> void:
	var tokens := line.split(" ", false)
	var target: String = tokens[1]
	var dist = Core.player.grid_position.distance_to(Vector2.ZERO)
	if tokens.size() > 4 and tokens[4] == "STATIC": dist = 1
	if tokens[2] == "SUPPLY": EventBus.add_supply.emit(target, int(tokens[3]) * dist)
	elif tokens[2] == "CARGO": EventBus.add_cargo.emit(target, int(tokens[3]) * dist)

func remove_command(line: String) -> void:
	var tokens := line.split(" ", false)
	var target: String = tokens[1]
	var dist = Core.player.grid_position.distance_to(Vector2.ZERO)
	if tokens.size() > 4 and tokens[4] == "STATIC": dist = 1
	if tokens[2] == "SUPPLY": EventBus.remove_supply.emit(target, int(tokens[3]) * dist)
	elif tokens[2] == "CARGO": EventBus.remove_cargo.emit(target, int(tokens[3]) * dist)

func set_cell_command(line: String) -> void:
	var tokens := line.split(" ", false)
	var cell_type: CellData = Map.data.get_by_id(tokens[1])
	if tokens[1] == "RANDOM":
		var roll: float = randf()
		var cell = Map.data.cells.pick_random()
		while cell.probability <= roll:
			roll = randf()
			cell = Map.data.cells.pick_random()
		cell_type = cell
	
	var cell_pos: Vector2 = Core.player.grid_position
	if tokens.size() >= 3 and tokens[2] == "AT":
		if tokens[3] == "RANDOM":
			var key = Map.cells.keys().pick_random()
			while Map.get_cell_by_key(key) != Map.data.empty_cell and key != "0,0":
				key = Map.cells.keys().pick_random()
			cell_pos = Utils.key_to_coord(key)
		else:
			cell_pos = Vector2(int(tokens[3]), int(tokens[4]))
	
	if cell_pos != Vector2.ZERO:
		@warning_ignore('narrowing_conversion')
		Map.set_cell_by_coords(
			cell_pos.x, cell_pos.y,
			cell_type
		)

func play_sound_command(line: String) -> void:
	var tokens := line.split(" ", false)
	EventBus.play_sfx.emit(tokens[1])

func execute() -> void:
	_parse_command_string()
