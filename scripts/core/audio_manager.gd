class_name AudioManager
extends Node

@onready var sfx: Node = %SFX
@onready var ambient: AudioStreamPlayer = %Ambient
@onready var music: AudioStreamPlayer = %Music
@onready var ui: AudioStreamPlayer = %UI

@export var sound_data: Array[SoundData]

func _ready() -> void:
	EventBus.play_sfx.connect(_play_sfx)
	
	for sound in sound_data:
		var playback := AudioStreamPlayer.new()
		playback.name = sound.name
		playback.bus = "SFX"
		sfx.add_child(playback, true)

func _play_sfx(sound_id: String) -> void:
	for data in sound_data:
		if data.name == sound_id:
			var player = sfx.get_node(sound_id)
			player.stream = data.streams.pick_random()
			player.pitch_scale = data.pitch  + randf_range(-0.3, 0.4)
			player.volume_db = data.gain
			player.play()
