class_name Main
extends Node

@export var map_data: MapData

@onready var camera: Camera2D = %Camera
@onready var map_view: MapView = %MapView
@onready var player: Player = %Player

var shuttle_cargo: int = 0
var shuttle_supplies: int = 30

func _ready() -> void:
	EventBus.end_day.connect(_on_end_day)
	EventBus.player_died.connect(_on_player_died)
	EventBus.player_won.connect(_on_player_won)
	
	Core.player = player as Player
	Map.data = map_data
	Map.build_map()
	
	player.supplies = player.data.max_supplies

func _on_end_day() -> void:
	Map.build_map()
	shuttle_cargo += player.cargo
	player.cargo = 0
	
	if player.supplies < player.data.max_supplies:
		var amount: int = player.data.max_supplies - player.supplies
		player.supplies += amount
		shuttle_supplies -= amount
	else:
		shuttle_supplies += player.supplies - player.data.max_supplies
		player.supplies = player.data.max_supplies

func _on_player_died() -> void:
	#get_tree().paused = true
	pass

func _on_player_won() -> void:
	pass
