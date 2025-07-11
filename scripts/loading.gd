extends Control

@export_file("*.tscn") var next_scene_path: String
@export var progress_bar: TextureProgressBar

var progress_array := []  # This will hold our progress value

func _ready():
	ResourceLoader.load_threaded_request(next_scene_path)
	if progress_bar:
		progress_bar.value = 0
		progress_bar.visible = true

func _process(delta):
	# Get status and populate progress_array with the current progress
	var load_status = ResourceLoader.load_threaded_get_status(next_scene_path, progress_array)
	
	# Update progress bar if we got a progress value
	if progress_array.size() > 0:
		var current_progress = progress_array[0] * 100  # Convert to percentage
		if progress_bar:
			progress_bar.value = current_progress
	
	# Check if loading is complete
	if load_status == ResourceLoader.THREAD_LOAD_LOADED:
		progress_bar.value = 100
		await get_tree().create_timer(0.5).timeout
		set_process(false)
		var new_scene = ResourceLoader.load_threaded_get(next_scene_path)
		get_tree().change_scene_to_packed(new_scene)
