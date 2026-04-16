extends PanelContainer

@onready var name_label = %NameLabel
@onready var level_label = %LevelLabel
@onready var exp_bar = %EXPBar
@onready var stamina_bar = %StaminaBar
@onready var technical_val = %TechnicalValue
@onready var admin_val = %AdminValue
@onready var creative_val = %CreativeValue
@onready var speed_val = %SpeedValue
@onready var learning_val = %LearningValue
@onready var multitask_val = %MultitaskValue
@onready var teamwork_val = %TeamworkValue
@onready var stamina_label = %StaminaLabel

@onready var add_stamina_btn = %AddStaminaButton
@onready var add_speed_btn = %AddSpeedButton
@onready var add_learning_btn = %AddLearningButton
@onready var add_multitask_btn = %AddMultitaskButton
@onready var add_teamwork_btn = %AddTeamworkButton

var member: Member:
	set(value):
		member = value
		update_ui()

func _ready():
	add_stamina_btn.pressed.connect(_on_add_stamina_pressed)
	add_speed_btn.pressed.connect(_on_add_speed_pressed)
	add_learning_btn.pressed.connect(_on_add_learning_pressed)
	add_multitask_btn.pressed.connect(_on_add_multitask_pressed)
	add_teamwork_btn.pressed.connect(_on_add_teamwork_pressed)
	
	if member:
		update_ui()

'''
func _input(event):
	if event is InputEventKey and event.keycode == KEY_SPACE:
		if event.is_pressed() and not event.is_echo():
			print(member.name, ", ", member.current_task_count)
'''

func _process(_delta):
	update_ui()

func _physics_process(delta: float) -> void:
	member.stamina += (delta * 0.2 * (1 + member.recover_speed * 0.07))
	member.stamina = minf(member.stamina, member.max_stamina)

func update_ui():
	if not member: return
	
	name_label.text = member.name
	level_label.text = "Lv. %d" % (1 + floori(member.member_exp / member.exp_per_level))
	if member.level_up_points > 0:
		level_label.text += " (+%d)" % member.level_up_points
	
	exp_bar.max_value = member.exp_to_next_level
	exp_bar.value = member.member_exp
	
	stamina_bar.max_value = member.max_stamina
	stamina_bar.value = member.stamina
	stamina_label.text = "STAMINA"
	
	technical_val.text = "%d" % member.technical
	admin_val.text = "%d" % member.admin
	creative_val.text = "%d" % member.creative
	
	speed_val.text = "%d" % member.speed
	learning_val.text = "%d" % member.learning_rate
	multitask_val.text = "%d" % member.multitask_skill
	teamwork_val.text = "%d" % member.teamwork_skill
	
	# Show/hide upgrade buttons without shifting layout
	var has_points = member.level_up_points > 0
	_set_upgrade_button_state(add_stamina_btn, has_points && member.recover_speed < 20)
	_set_upgrade_button_state(add_speed_btn, has_points && member.speed < 10)
	_set_upgrade_button_state(add_learning_btn, has_points && member.learning_rate < 10)
	_set_upgrade_button_state(add_multitask_btn, has_points && member.multitask_skill < 10)
	_set_upgrade_button_state(add_teamwork_btn, has_points && member.teamwork_skill < 10)

func _set_upgrade_button_state(btn: Button, enabled: bool):
	btn.modulate.a = 1.0 if enabled else 0.0
	btn.disabled = not enabled
	btn.mouse_filter = Control.MOUSE_FILTER_STOP if enabled else Control.MOUSE_FILTER_IGNORE

func _on_add_stamina_pressed():
	if member.level_up_points > 0:
		#member.max_stamina += 1
		member.recover_speed += 1
		member.level_up_points -= 1
		update_ui()

func _on_add_speed_pressed():
	if member.level_up_points > 0:
		member.speed += 1
		member.level_up_points -= 1
		update_ui()

func _on_add_learning_pressed():
	if member.level_up_points > 0:
		member.learning_rate += 1
		member.level_up_points -= 1
		update_ui()

func _on_add_multitask_pressed():
	if member.level_up_points > 0:
		member.multitask_skill += 1
		member.level_up_points -= 1
		update_ui()

func _on_add_teamwork_pressed():
	if member.level_up_points > 0:
		member.teamwork_skill += 1
		member.level_up_points -= 1
		update_ui()

# --- Drag and Drop Implementation ---

func _get_drag_data(_at_position):
	if not member: return null
	
	# Set the drag preview
	var preview = _create_drag_preview()
	set_drag_preview(preview)
	
	return member

func _create_drag_preview():
	var preview = PanelContainer.new()
	var style = get_theme_stylebox("panel").duplicate()
	style.bg_color.a = 0.5 # Make it semi-transparent
	preview.add_theme_stylebox_override("panel", style)
	
	var lbl = Label.new()
	lbl.text = member.name
	lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	preview.add_child(lbl)
	
	preview.custom_minimum_size = Vector2(120, 40)
	return preview
