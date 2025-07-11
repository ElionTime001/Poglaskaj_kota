extends Control


@export_file("*.tscn") var next_scene_path: String 


func _ready():
	ResourceLoader.load_threaded_request(next_scene_path) 


func _process(delta):
	if ResourceLoader.load_threaded_get_status(next_scene_path) == ResourceLoader.THREAD_LOAD_LOADED: # Checks to see if the file is finished loading
		set_process(false)
		var new_scene: PackedScene = ResourceLoader.load_threaded_get(next_scene_path)
		get_tree().change_scene_to_packed(new_scene)
