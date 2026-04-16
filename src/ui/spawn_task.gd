extends Node

@onready var mainGame = get_tree().get_nodes_in_group("main_game")[0]

func _ready():
	var createSpawnQueues = func() -> Array:
		var arr = []
		arr.append(randf_range(1, 4)) # index 0
		for i in range(8): arr.append(randf_range(14, 21));
		for i in range(6): arr.append(randf_range(12, 18));
		for i in range(6): arr.append(randf_range(10, 15));
		for i in range(6): arr.append(randf_range(8, 12));
		for i in range(6): arr.append(randf_range(6, 9));
		for i in range(6): arr.append(randf_range(4, 6));
		return arr
	#
	var createTask = func(_id: int):
		var task = Task.new()
		task.task_name = "Task %3d" % _id # randf_range(0, 99)
		task.task_type = [Task.TaskType.TECHNICAL, Task.TaskType.ADMIN, Task.TaskType.CREATIVE].pick_random()
		task.total_work = randf_range(30, 45)
		task.completed_work = 0
		task.max_deadline = randi_range(40, 60)
		task.deadline = task.max_deadline
		task.scalability_factor = randf_range(0.5, 1.0)
		#
		var task_ui = preload("res://src/ui/task_card.tscn").instantiate()
		mainGame.task_container.add_child(task_ui)
		task_ui.task = task
		#
		mainGame.task_count += 1
		mainGame.task_label.text = "Tasks: %d" % mainGame.task_count
	#
	var spawnQueues = createSpawnQueues.call()
	var id = 1
	while true:
		var t = spawnQueues.pop_front()
		await get_tree().create_timer(5 if t == null else t, false).timeout
		createTask.call(id)
		id += 1
		#print("spawn task ", t)
