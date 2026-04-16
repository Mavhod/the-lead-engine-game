extends Control

const MemberCount = 4

@onready var member_container = %MemberContainer
@onready var task_container = %TaskContainer
@onready var task_label = %TaskLabel
@onready var trust_label = %TrustLabel
@onready var game_over_dialog = %GameOverDialog

var spawnTaskNode: Node = null
var isGameRunning: bool = false
var task_count: int = 0
var trust_value: float = 100

func _ready():
	game_over_dialog.restart_requested.connect(newGame)
	newGame()


func createMembers():
	var members = []
	for i in range(MemberCount):
		var member = Member.new()
		member.name = ["Alice", "Bob", "Charlie", "Diana"][i]
		member.level_up_points = 0 # randi_range(0, 3) # Give random level up points for testing
		var skillExt = GameUtils.rand_sum_int(3, 12)
		member.technical = 4 + skillExt[0]
		member.admin = 4 + skillExt[1]
		member.creative = 4 + skillExt[2]
		members.append(member)
		#
		var attrExt = GameUtils.rand_sum_int(5, 10)
		#member.max_stamina += attrExt[0]
		#member.stamina = member.max_stamina
		member.recover_speed += attrExt[0]
		member.speed += attrExt[1]
		member.learning_rate += attrExt[2]
		member.multitask_skill += attrExt[3]
		member.teamwork_skill += attrExt[4]
		#
		var member_ui = preload("res://src/ui/member_stats_ui.tscn").instantiate()
		member_container.add_child(member_ui)
		member_ui.member = member

func newGame():
	# Clear existing mockup nodes
	for child in member_container.get_children(): child.queue_free();
	for child in task_container.get_children(): child.queue_free();
	#
	task_count = 0
	task_label.text = "Tasks: 0"
	trust_value = 100
	trust_label.text = "Trust: 100%"
	game_over_dialog.hide()
	#
	createMembers()
	isGameRunning = true
	#
	spawnTaskNode = Node.new()
	spawnTaskNode.set_script(load("res://src/ui/spawn_task.gd"))
	add_child(spawnTaskNode)

func dropTrust(value: float):
	if not isGameRunning: return
	trust_value -= value
	trust_label.text = "Trust: %d" % (floori(trust_value) if trust_value > 0 else 0)
	#
	if trust_value <= 0:
		isGameRunning = false
		if spawnTaskNode != null: spawnTaskNode.queue_free();
		game_over_dialog.show_dialog(task_count)
