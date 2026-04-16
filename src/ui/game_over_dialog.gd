extends Control

signal restart_requested

@onready var task_count_label = %TaskCountLabel
@onready var restart_button = %RestartButton
@onready var mainLayout = get_tree().get_nodes_in_group("main_layout")[0]

func _ready():
	restart_button.pressed.connect(_on_restart_button_pressed)
	hide()

func _on_restart_button_pressed():
	mainLayout.process_mode = Node.PROCESS_MODE_INHERIT
	restart_requested.emit()
	hide()

func show_dialog(task_count: int):
	mainLayout.process_mode = Node.PROCESS_MODE_DISABLED
	task_count_label.text = "Tasks: %d" % task_count
	show()
	
