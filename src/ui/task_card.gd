extends Control
class_name TaskCard

@onready var name_label = %TaskName
@onready var type_label = %TaskType
@onready var progress_bar = %ProgressBarUI
@onready var deadline_bar = %DeadlineBar
@onready var scalability_val = %ScalabilityValue
@onready var team_list = %TeamList
@onready var mainGame = get_tree().get_nodes_in_group("main_game")[0]

var task: Task:
	set(value):
		task = value
		update_ui()

func _ready():
	if task:
		update_ui()

func _process(_delta):
	if task:
		# In a real game, the GameManager might handle the logic, 
		# but for this UI component, we'll just update the bars.
		update_ui_progress()
		
func redeemMembers() -> void:
	for member in task.assigned_members:
		member.current_task_count -= 1

func _physics_process(delta: float) -> void:
	task.deadline -= delta
	if(task.deadline <= 0):
		mainGame.dropTrust((1 - (task.completed_work / task.total_work)) * 80)
		redeemMembers()
		queue_free()
		return;
	#
	var memberSize = task.assigned_members.size()
	if(memberSize <= 0): return;
	var effective = (1 + task.scalability_factor * (memberSize - 1)) / memberSize
	for member in task.assigned_members:
		var staminaUse = 0.5 * delta
		if(member.stamina < staminaUse): continue;
		member.drop_stamina(staminaUse)
		member.add_exp(staminaUse)
		member.up_skill(task.get_type_string(), staminaUse * 0.1)
		#var member = task.assigned_members[0]
		var taskSkill = member.get_skill_value(task.get_type_string())
		var teamwork = (1 + member.teamwork_skill * 0.02) if memberSize > 1 else 1.0
		var multi = (1 + member.multitask_skill * 0.02) if member.current_task_count > 1 else 1.0
		var workVal = delta
		workVal *= effective
		workVal *= (1 + member.speed * 0.02)
		workVal *= teamwork
		workVal *= multi
		workVal *= taskSkill * 0.1
		task.completed_work += workVal
		if(task.completed_work >= task.total_work):
			redeemMembers()
			queue_free()
			return;

func update_ui():
	if not is_inside_tree() or not task: return
	name_label.text = task.task_name
	type_label.text = task.get_type_string()
	scalability_val.text = "%.1f" % task.scalability_factor
	update_ui_progress()
	update_team_list()

func update_ui_progress():
	if not task: return
	
	progress_bar.value = (task.completed_work / task.total_work) * 100.0
	deadline_bar.value = (task.deadline / task.max_deadline) * 100.0

func update_team_list():
	if not team_list: return
	
	# Clear existing list
	for child in team_list.get_children():
		child.queue_free()
		
	# Populate list
	for member in task.assigned_members:
		var panel = PanelContainer.new()
		var style = StyleBoxFlat.new()
		style.bg_color = Color(0.2, 0.25, 0.3, 0.5)
		style.corner_radius_top_left = 4
		style.corner_radius_top_right = 4
		style.corner_radius_bottom_right = 4
		style.corner_radius_bottom_left = 4
		panel.add_theme_stylebox_override("panel", style)
		panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		
		var hbox = HBoxContainer.new()
		hbox.add_theme_constant_override("separation", 4)
		panel.add_child(hbox)
		
		var name_lbl = Label.new()
		name_lbl.text = " " + member.name
		name_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		name_lbl.add_theme_font_size_override("font_size", 11)
		hbox.add_child(name_lbl)
		
		var remove_btn = Button.new()
		remove_btn.text = " - "
		remove_btn.flat = true
		remove_btn.add_theme_color_override("font_color", Color.INDIAN_RED)
		remove_btn.add_theme_font_size_override("font_size", 12)
		remove_btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		remove_btn.pressed.connect(_on_remove_member_pressed.bind(member))
		hbox.add_child(remove_btn)
		
		team_list.add_child(panel)

func _on_remove_member_pressed(member):
	if not task: return
	task.assigned_members.erase(member)
	update_team_list()
	member.current_task_count -= 1

# --- Drag and Drop Implementation ---

func _can_drop_data(_at_position, data):
	# Check if the dropped data is a Member and not already assigned
	return data is Member and task and not task.assigned_members.has(data)

func _drop_data(_at_position, data):
	task.assigned_members.append(data)
	update_team_list()
	data.current_task_count += 1
