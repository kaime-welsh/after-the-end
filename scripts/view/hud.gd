extends Control

@onready var supply_label: Label = %SupplyLabel
@onready var cargo_label: Label = %CargoLabel

func _ready() -> void:
	EventBus.player_cargo_changed.connect(_on_cargo_changed)
	EventBus.player_supplies_changed.connect(_on_supplies_changed)

func _on_cargo_changed(amount: int) -> void:
	cargo_label.text = str(amount)

func _on_supplies_changed(amount: int) -> void:
	supply_label.text = str(amount)
