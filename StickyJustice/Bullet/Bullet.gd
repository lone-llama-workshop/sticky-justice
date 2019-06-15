extends Area2D


export (int) var speed = 1000

var screensize = Vector2()
var angle = Vector2()


func _ready():
	screensize = get_viewport_rect().size
	set_physics_process(true)


func set_direction(dir):
	angle = dir


func _physics_process(delta):
	global_position += (angle * (speed * delta))
	if ((position.x > screensize.x) 
		or (position.x < 0) 
		or (position.y > screensize.y) 
		or (position.y < 0)):
		destroy()


func destroy():
	self.queue_free()