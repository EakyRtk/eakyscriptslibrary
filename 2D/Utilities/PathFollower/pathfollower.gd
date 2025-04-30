class_name PathFollower2D extends Path2D

signal path_ended
signal follow_started

@onready var _path_follow : PathFollow2D = PathFollow2D.new()
@onready var _remote_transform : RemoteTransform2D = RemoteTransform2D.new()

@export_group("Path Logic")
##Set it to 'false' if a node is going to be added later by an another PathFollower2D
@export var start_follow_on_start : bool = true
##Speed of following
@export var follow_speed : float = 100.0
##Which node is going to be following
@export var target_node : Node2D 
##Is the path going to be loop infinitely
@export var path_loop : bool = true: set = _loop_setter
##Second PathFollower2D to be place the node to
@export var second_path : PathFollower2D
##If the path going to put its node to 'second_path' at the end
@export var auto_advence : bool = false
##At what threshold the path will count as it ended.
@export var path_end_threshold : float = 10.0

@export_group("Remote Update")
@export var position_update : bool = true: set = _position_setter
@export var rotation_update : bool = true: set = _rotation_setter
@export var scale_update : bool = true: set = _scale_setter

func start_following() -> void:
	follow_started.emit()
	set_process(true)

func put_on_path(t_node: Node2D) -> void:
	target_node = t_node
	_remote_transform.remote_path = target_node.get_path()

	_remote_transform.update_position = position_update
	_remote_transform.update_rotation = rotation_update
	_remote_transform.update_scale = scale_update

	_path_follow.loop = path_loop

func place_on_other_path(new_path: PathFollower2D = second_path) -> void:
	var t_node : Node2D = target_node
	#target_node = null
	set_process(false)
	new_path.put_on_path(t_node)
	target_node = null

func _init() -> void:
	set_process(false)

func _ready() -> void:
	add_child(_path_follow)
	_path_follow.add_child(_remote_transform)

	if start_follow_on_start: 
		put_on_path(target_node)
		start_following()


func _process(delta: float) -> void:
	_path_follow.progress += follow_speed * delta
	if _path_follow.progress > self.curve.get_baked_length() - 10: 
		path_ended.emit()
		if auto_advence:
			place_on_other_path()

#region Setters
func _position_setter(new_value: bool) -> void:
	position_update = new_value
	if _remote_transform:
		_remote_transform.update_position = position_update

func _rotation_setter(new_value: bool) -> void:
	rotation_update = new_value
	if _remote_transform:
		_remote_transform.update_rotation = rotation_update

func _scale_setter(new_value: bool) -> void:
	scale_update = new_value
	if _remote_transform:
		_remote_transform.update_scale = scale_update

func _loop_setter(new_value: bool) -> void:
	path_loop = new_value
	_path_follow.loop = path_loop

#endregion
