extends Resource
class_name Task

enum TaskType {TECHNICAL, ADMIN, CREATIVE}

@export var task_name: String = "New Task"
@export var task_type: TaskType = TaskType.TECHNICAL
@export var completed_work: float = 0.0 # Progress made
@export var total_work: int = 30 # Total work units 30 to 45
@export var deadline: float = 50 # Remaining time in seconds
@export var max_deadline: int = 50 # 40 to 60
@export var scalability_factor: float = 0.5 # 0.5 to 1.0

var assigned_members: Array[Member] = []

func get_type_string() -> String:
	match task_type:
		TaskType.TECHNICAL: return "Technical"
		TaskType.ADMIN: return "Admin"
		TaskType.CREATIVE: return "Creative"
	return "Unknown"
