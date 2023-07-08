extends Node


#const ConfigPath = "user://config.cfg"
#const Section = "Global"
#const DefaultConfig = {
#	"sound": 1,
#	"volumn": 1,
#	"task": 40,
#	"dictionary": 0,
#}
#
#var setting = {}


# Called when the node enters the scene tree for the first time.
func _ready():
#	var config = ConfigFile.new()
#	var file = File.new()
#	if file.file_exists(ConfigPath):
#		var err = config.load(ConfigPath)
#		if err == OK:
#			for key in config.get_section_keys(Section):
#				setting[key] = config.get_value(Section, key)
#		else:
#			config.clear()
#			new_config(config)
#	else:
#		new_config(config)
	
	$HUD.new_game()


#func new_config(config):
#	for key in DefaultConfig.keys():
#		config.set_value(Section, key, DefaultConfig[key])
#	config.save(ConfigPath)
#	setting = DefaultConfig
