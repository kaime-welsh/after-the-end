extends Node

signal log_message(msg: String)
signal add_supply(target: String, amount: int)
signal add_cargo(target: String, amount: int)
signal remove_supply(target: String, amount: int)
signal remove_cargo(target: String, amount: int)
signal play_sfx(sound_id: String)

signal begin_combat()
signal end_day()

signal player_died()
signal player_won()
signal player_supplies_changed(amount: int)
signal player_cargo_changed(amount: int)
signal player_moved(new_pos: Vector2)
