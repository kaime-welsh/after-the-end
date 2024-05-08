extends Node

var player: Player

func _ready() -> void:
	EventBus.log_message.connect(_on_log_message)
	EventBus.add_supply.connect(_on_add_supply)
	EventBus.add_cargo.connect(_on_add_cargo)
	EventBus.remove_supply.connect(_on_remove_supply)
	EventBus.remove_cargo.connect(_on_remove_cargo)

func _on_log_message(msg: String):
	print(msg)

func _on_add_supply(target: String, amount: int):
	match target:
		"PLAYER":
			player.supplies += amount

func _on_add_cargo(target: String, amount: int):
	match target:
		"PLAYER":
			player.cargo += amount

func _on_remove_supply(target: String, amount: int):
	match target:
		"PLAYER":
			player.supplies -= amount

func _on_remove_cargo(target: String, amount: int):
	match target:
		"PLAYER":
			player.cargo -= amount

