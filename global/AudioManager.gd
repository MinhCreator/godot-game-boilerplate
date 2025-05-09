extends Node

# signal message(message)

@onready var Music_Player = get_node("/root/main/Music_Player")
@onready var Voice_Player = get_node("/root/main/Voice_Player")
@onready var FX_Player = get_node("/root/main/FX_Player")

@onready var audio_bus = {
		"Master": AudioServer.get_bus_index("Master"),
		"Music": AudioServer.get_bus_index("Music"),
		"Voice": AudioServer.get_bus_index("Voice"),
		"FX": AudioServer.get_bus_index("FX")
		}

@onready var navigate_audio = preload ("res://assets/audio/ui_effects/navigate.wav")
@onready var deny_audio = preload ("res://assets/audio/ui_effects/deny.wav")
@onready var accept_audio = preload ("res://assets/audio/ui_effects/accept.wav")
@onready var cancel_audio = preload ("res://assets/audio/ui_effects/cancel.wav")

func _ready():
	await get_node("/root/main").ready # Wait For Main Scene to be ready.
	self.process_mode = Node.PROCESS_MODE_ALWAYS
	ConfigManager.connect("config_update", Callable(self, "apply_config"))

func apply_config():
	for bus in audio_bus.keys():
		set_audio(audio_bus[bus], ConfigManager.config_data.audio[bus].mute, ConfigManager.config_data.audio[bus].volume)

func set_audio(bus=0, mute=false, volume=50):
	AudioServer.set_bus_mute(bus, mute)
	AudioServer.set_bus_volume_db(bus, linear_to_db(clamp(volume * 0.01, 0.01, 0.99)))

func ui_navigate_audio_effect(_val=false):
	FX_Player.set_stream(navigate_audio)
	FX_Player.play()

func ui_deny_audio_effect(_val=false):
	FX_Player.set_stream(deny_audio)
	FX_Player.play()

func ui_accept_audio_effect(_val=false):
	FX_Player.set_stream(accept_audio)
	FX_Player.play()

func ui_cancel_audio_effect(_val=false):
	FX_Player.set_stream(cancel_audio)
	FX_Player.play()
