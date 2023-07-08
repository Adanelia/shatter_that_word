extends Control


signal start_game
signal end_game

#const PATH = "user://config.json"
const ConfigPath = "user://config.cfg"
const Section = "Global"
const DefaultConfig = {
	"sound": false,
	"volumn": 100,
	"task": 40,
	"dictionary": 0,
}

var settings : Dictionary

onready var background = $Backgroud
# Settings
onready var SettingSound = $Settings/VBoxContainer/HBoxContainer/MusicButton
onready var SettingVolumn = $Settings/VBoxContainer/Volumn/VolumnSlider
onready var SettingTask = $Settings/VBoxContainer/Plan/SpinBox
onready var SettingDictionary = $Settings/VBoxContainer/Dictionary/OptionButton
onready var AudioManager = $"/root/Main/GameManger/AudioManager"


func _ready():
	var config = ConfigFile.new()
	var file = File.new()
	if file.file_exists(ConfigPath):
		var err = config.load(ConfigPath)
		if err == OK:
			for key in config.get_section_keys(Section):
				settings[key] = config.get_value(Section, key)
		else:
			config.clear()
			new_config(config)
	else:
		new_config(config)
	
#	settings = load_settings()
	AudioManager.enabled = !settings["sound"]
	AudioServer.set_bus_volume_db(0, settings["volumn"] / 2 - 50)
	
	background.color.h = randf()


func _process(delta):
	var h = background.color.h + delta / 10
	if h > 1:
		h = 0
	background.color.h = h


func new_game():
	$VBoxContainer/HBoxContainer/PauseButton.disabled = true
	$VBoxContainer/HBoxContainer/ContinueButton.hide()
	$VBoxContainer/HBoxContainer/HomeButton.disabled =true
	$VBoxContainer/Bottom.show()
	$VBoxContainer/CenterContainer/Menu.show()
	
	emit_signal("end_game")

func start(arg : int = 0):
	$VBoxContainer/HBoxContainer/PauseButton.disabled = false
#	$VBoxContainer/HBoxContainer/ContinueButton.disabled = false
	$VBoxContainer/HBoxContainer/HomeButton.disabled =false
	$VBoxContainer/Bottom.hide()
	$VBoxContainer/CenterContainer/Menu.hide()
	
	emit_signal("start_game", arg)


func new_config(config):
	for key in DefaultConfig.keys():
		config.set_value(Section, key, DefaultConfig[key])
	config.save(ConfigPath)
	settings = DefaultConfig

func save_config():
	var config = ConfigFile.new()
	for key in settings.keys():
		config.set_value(Section, key, settings[key])
	config.save(ConfigPath)

#func load_settings():
#	var f = File.new()
#	if f.file_exists(PATH):
#		f.open(PATH, File.READ)
#		var content = f.get_as_text()
#		f.close()
#		return parse_json(content)
#	else:
#		f.open(PATH, File.WRITE)
#		var default_setting = {
#			"volumn": true,
#			"plan": 40,
#			"current_dictionary": 0,
#			"custom_dictionary": [],
#		}
#		f.store_string(to_json(default_setting))
#		f.close()
#		return default_setting


# Main menu --------------------------------------------------------------------
func _on_PlayButton_pressed():
	AudioManager.play(AudioManager.Click)
#	$ChooseMode/HBoxContainer/PanelContainer/Mode1.text = tr("QUIZ") + "(" + str(settings["task"]) + tr("WORDS") + ")"
	$ChooseMode/CenterContainer/HBoxContainer/PanelContainer/Mode1.text = tr("QUIZ") + "(" + str(settings["task"]) + tr("WORDS") + ")"
	$ChooseMode.popup()
#	start()


func _on_SettingButton_pressed():
	AudioManager.play(AudioManager.Click)
	SettingSound.set_pressed_no_signal(settings["sound"])
	SettingVolumn.value = settings["volumn"]
	SettingTask.value = settings["task"]
	SettingDictionary.selected = settings["dictionary"]
	
	$Settings.popup()


func _on_ExitButton_pressed():
	AudioManager.play(AudioManager.Click)
	get_tree().quit()


# Top button -------------------------------------------------------------------
func _on_PauseButton_pressed():
	AudioManager.play(AudioManager.Switch)
	get_tree().paused = true
	$VBoxContainer/HBoxContainer/PauseButton.disabled = true
	$ColorRect.show()
	$VBoxContainer/HBoxContainer/ContinueButton.show()


func _on_ContinueButton_pressed():
	AudioManager.play(AudioManager.Switch)
	get_tree().paused = false
	$VBoxContainer/HBoxContainer/PauseButton.disabled = false
	$ColorRect.hide()
	$VBoxContainer/HBoxContainer/ContinueButton.hide()


func _on_HomeButton_pressed():
	AudioManager.play(AudioManager.Click)
	get_tree().paused = false
	$ColorRect.hide()
	new_game()


# Choose mode ------------------------------------------------------------------
func _on_Mode1_pressed():
	AudioManager.play(AudioManager.Click)
	start(settings["task"])
	$ChooseMode.hide()


func _on_Mode2_pressed():
	AudioManager.play(AudioManager.Click)
	start(0)
	$ChooseMode.hide()


# Restart ----------------------------------------------------------------------
func _on_AnimationPlayer_animation_finished(anim_name):
	new_game()


# Settings ---------------------------------------------------------------------
func _on_SaveButton_pressed():
	AudioManager.play(AudioManager.Click)
	settings["sound"] = SettingSound.pressed
	settings["volumn"] = SettingVolumn.value
	settings["task"] = SettingTask.value
	settings["dictionary"] = SettingDictionary.selected
	save_config()
	
#	settings.volumn = $Settings/VBoxContainer/Volumn/CheckButton.pressed
#	settings.plan = $Settings/VBoxContainer/Plan/SpinBox.value
#	settings.current_dictionary = $Settings/VBoxContainer/Dictionary/OptionButton.selected
	# Saving--------------------------
#	var f = File.new()
#	f.open(PATH, File.WRITE)
#	f.store_string(to_json(settings))
#	f.close()
	# Close---------------------------
	$Settings.hide()


func _on_CancelButton_pressed():
	AudioManager.play(AudioManager.Click)
	$Settings.hide()


func _on_MusicButton_toggled(button_pressed):
	AudioManager.play(AudioManager.Switch)
	AudioManager.enabled = !button_pressed


func _on_LeaderBoardButton_pressed():
	AudioManager.play(AudioManager.Click)
	OS.alert(tr("LEADERBOARD"))


func _on_InformationButton_pressed():
	AudioManager.play(AudioManager.Click)
	$Information.popup()


func _on_QuestionButton_pressed():
	AudioManager.play(AudioManager.Click)
	OS.alert("?")


func _on_InfoCloseButton_pressed():
	AudioManager.play(AudioManager.Click)
	$Information.hide()


func _on_VolumnSlider_value_changed(value):
#	print(AudioServer.get_bus_volume_db(0))
	AudioServer.set_bus_volume_db(0, value / 2 - 50)


func _on_LoadButton_pressed():
	AudioManager.play(AudioManager.Click)
#	$FileDialog.popup()
	$Notice.popup()


