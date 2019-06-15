extends Node


export (float) var step = 0.5
export (int) var minRotation = -40;
export (int) var maxRotation = 40;
export (PackedScene) var bullet

export (int) var leftPlayerHealth = 3
export (int) var rightPlayerHealth = 3


var leftFallRate = 2
var leftRaiseStep = -step
var leftLowerStep = step
var leftMinArmRotation = -minRotation
var leftMaxArmRotation = -maxRotation
var leftMasher
var leftTrigger

var rightFallRate = 2
var rightRaiseStep = step
var rightLowerStep = -step
var rightMinArmRotation = minRotation
var rightMaxArmRotation = maxRotation
var rightMasher
var rightTrigger

var possibleInputs = [
# Words
	#{"code": KEY_TAB, "name": "Tab"},
	#{"code": KEY_BACKSPACE, "name": "Backspace"},
	#{"code": KEY_ENTER, "name": "Enter"},
	#{"code": KEY_INSERT, "name": "Insert"},
	#{"code": KEY_DELETE, "name": "Delete"},
	#{"code": KEY_HOME, "name": "Home"},
	#{"code": KEY_END, "name": "End"},
	#{"code": KEY_LEFT, "name": "Left Arrow"},
	#{"code": KEY_UP, "name": "Up Arrow"},
	#{"code": KEY_RIGHT, "name": "Right Arrow"},
	#{"code": KEY_DOWN, "name": "Down Arrow"},
# Specials
	#{"code": KEY_COMMA, "name": ","},
	#{"code": KEY_MINUS, "name": "-"},
	#{"code": KEY_PERIOD, "name": "."},
	#{"code": KEY_SLASH, "name": "/"},
	#{"code": KEY_SEMICOLON, "name": ";"},
	#{"code": KEY_EQUAL, "name": "="},
	#{"code": KEY_BRACKETLEFT, "name": "["},
	#{"code": KEY_BACKSLASH, "name": "\\"},
	#{"code": KEY_BRACKETRIGHT, "name": "]"},
# Numbers
	{"code": KEY_0, "name": "0"},
	{"code": KEY_1, "name": "1"},
	{"code": KEY_2, "name": "2"},
	{"code": KEY_3, "name": "3"},
	{"code": KEY_4, "name": "4"},
	{"code": KEY_5, "name": "5"},
	{"code": KEY_6, "name": "6"},
	{"code": KEY_7, "name": "7"},
	{"code": KEY_8, "name": "8"},
	{"code": KEY_9, "name": "9"},
# Letters
	{"code": KEY_A, "name": "A"},
	{"code": KEY_B, "name": "B"},
	{"code": KEY_C, "name": "C"},
	{"code": KEY_D, "name": "D"},
	{"code": KEY_E, "name": "E"},
	{"code": KEY_F, "name": "F"},
	{"code": KEY_G, "name": "G"},
	{"code": KEY_H, "name": "H"},
	{"code": KEY_I, "name": "I"},
	{"code": KEY_J, "name": "J"},
	{"code": KEY_K, "name": "K"},
	{"code": KEY_L, "name": "L"},
	{"code": KEY_M, "name": "M"},
	{"code": KEY_N, "name": "N"},
	{"code": KEY_O, "name": "O"},
	{"code": KEY_P, "name": "P"},
	{"code": KEY_Q, "name": "Q"},
	{"code": KEY_R, "name": "R"},
	{"code": KEY_S, "name": "S"},
	{"code": KEY_T, "name": "T"},
	{"code": KEY_U, "name": "U"},
	{"code": KEY_V, "name": "V"},
	{"code": KEY_W, "name": "W"},
	{"code": KEY_X, "name": "X"},
	{"code": KEY_Y, "name": "Y"},
	{"code": KEY_Z, "name": "Z"}] 


func _ready():
	get_tree().paused = false
	$PauseMenu/Popup.hide()
	$LeftPlayer/Arm.rotation = deg2rad(leftMinArmRotation)
	$RightPlayer/Arm.rotation = deg2rad(rightMinArmRotation)
	newMashers()
	newTriggers()


func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().paused = true
		$PauseMenu/Popup.show()
	
	process_left_player(delta)
	process_right_player(delta)


func newMashers():
	randomize()
	leftMasher = floor(rand_range(0, possibleInputs.size()))
	randomize()
	rightMasher = floor(rand_range(0, possibleInputs.size()))
	
	# Make both players have different triggers and both triggers and mashers are different
	if ((leftMasher == rightMasher)
			or (leftMasher == leftTrigger)
			or (leftMasher == rightTrigger)
			or (rightMasher == leftTrigger)
			or (rightMasher == rightTrigger)):
		randomize()
		leftMasher = floor(rand_range(0, possibleInputs.size()))
		randomize()
		rightMasher = floor(rand_range(0, possibleInputs.size()))
	
	$HUD/LeftMasher/Text/Key.text = possibleInputs[leftMasher]["name"]
	$HUD/RightMasher/Text/Key.text = possibleInputs[rightMasher]["name"]
	#print("Mashers: ", "L: [", leftMasher, "] = ", possibleInputs[leftMasher]["name"], ", ", "R: [", rightMasher, "] = ", possibleInputs[rightMasher]["name"])


func newTriggers():
	randomize()
	leftTrigger = floor(rand_range(0, possibleInputs.size()))
	randomize()
	rightTrigger = floor(rand_range(0, possibleInputs.size()))
	
	# Make both players have different triggers and both triggers and mashers are different
	if ((leftTrigger == rightTrigger)
			or (leftTrigger == leftMasher)
			or (leftTrigger == rightMasher)
			or (rightTrigger == leftMasher)
			or (rightTrigger == rightMasher)):
		randomize()
		leftTrigger = floor(rand_range(0, possibleInputs.size()))
		randomize()
		rightTrigger = floor(rand_range(0, possibleInputs.size()))
	
	$HUD/LeftTrigger/Text/Key.text = possibleInputs[leftTrigger]["name"]
	$HUD/RightTrigger/Text/Key.text = possibleInputs[rightTrigger]["name"]
	#print("Triggers: ", "L: [", leftTrigger, "] = ", possibleInputs[leftTrigger]["name"], ", ", "R: [", rightTrigger, "] = ", possibleInputs[rightTrigger]["name"])


func process_left_player(delta):
	if Input.is_key_pressed(possibleInputs[leftMasher]["code"]) and !$LeftPlayer/AnimationPlayer.is_playing():
		$LeftPlayer/Arm.rotate(deg2rad(leftRaiseStep))
		$LeftPlayer/Arm.rotation = clamp($LeftPlayer/Arm.rotation, deg2rad(leftMaxArmRotation), deg2rad(leftMinArmRotation))
		leftFallRate = 2
	else:
		if $LeftPlayer/IdleTimer.is_stopped():
			$LeftPlayer/IdleTimer.start()
	
	if Input.is_key_pressed(possibleInputs[leftTrigger]["code"]) and !$LeftPlayer/AnimationPlayer.is_playing():
		left_player_shoot()


func process_right_player(delta):
	if Input.is_key_pressed(possibleInputs[rightMasher]["code"]) and !$RightPlayer/AnimationPlayer.is_playing():
		$RightPlayer/Arm.rotate(deg2rad(rightRaiseStep))
		$RightPlayer/Arm.rotation = clamp($RightPlayer/Arm.rotation, deg2rad(rightMinArmRotation), deg2rad(rightMaxArmRotation))
		rightFallRate = 2
	else:
		if $RightPlayer/IdleTimer.is_stopped():
			$RightPlayer/IdleTimer.start()
	
	if Input.is_key_pressed(possibleInputs[rightTrigger]["code"]) and !$RightPlayer/AnimationPlayer.is_playing():
		right_player_shoot()


func left_player_shoot():
	$LeftPlayer/Gunshot.play()
	var b = bullet.instance()
	b.global_position = $LeftPlayer/Arm/Gun.global_position
	var dir = ($LeftPlayer/Arm.rotation * -1)
	b.set_direction(Vector2(cos(dir), -sin(dir)))
	get_parent().add_child(b)
	$LeftPlayer/AnimationPlayer.play("spin")
	$LeftPlayer/Arm.rotation = deg2rad(leftMaxArmRotation)
	newTriggers()


func right_player_shoot():
	$RightPlayer/Gunshot.play()
	var b = bullet.instance()
	b.global_position = $RightPlayer/Arm/Gun.global_position
	var dir = $RightPlayer/Arm.rotation
	b.set_direction(Vector2(-cos(dir), -sin(dir)))
	get_parent().add_child(b)
	$RightPlayer/AnimationPlayer.play("spin")
	$RightPlayer/Arm.rotation = deg2rad(rightMinArmRotation)
	newTriggers()


func _on_LeftPlayerTimer_timeout():
	# TODO: potentially use a rand() here to make it more interesting
	# TODO: It would be good if this used lerping so it looked a little smoother
	$LeftPlayer/Arm.rotate(deg2rad(leftLowerStep * leftFallRate))
	$LeftPlayer/Arm.rotation = clamp($LeftPlayer/Arm.rotation, deg2rad(leftMaxArmRotation), deg2rad(leftMinArmRotation))


func _on_RightPlayerTimer_timeout():
	# TODO: potentially use a rand() here to make it more interesting
	# TODO: It would be good if this used lerping so it looked a little smoother
	$RightPlayer/Arm.rotate(deg2rad(rightLowerStep * rightFallRate))
	$RightPlayer/Arm.rotation = clamp($RightPlayer/Arm.rotation, deg2rad(rightMinArmRotation), deg2rad(rightMaxArmRotation))


func _on_LeftPlayerIdleTimer_timeout():
	leftFallRate = 10 # used in _on_LeftPlayerTimer_timeout


func _on_RightPlayerIdleTimer_timeout():
	rightFallRate = 10 # used in _on_RightPlayerTimer_timeout


func _on_MasherTimer_timeout():
	newMashers()
	pass


func _on_RightPlayer_area_entered(bullet):
	bullet.queue_free()
	rightPlayerHealth -= 1
	if rightPlayerHealth == 2:
		$HUD/RightHearts/Heart1.hide()
	if rightPlayerHealth == 1:
		$HUD/RightHearts/Heart2.hide()
	if rightPlayerHealth == 0:
		$HUD/RightHearts/Heart3.hide()

		var title = "Bandit Dead!"
		var message = "Nice work Sheriff! That's one less Bandit to plague your fair town. On to more braveheartedness?"
		show_dead_menu(title, message)


func _on_LeftPlayer_area_entered(bullet):
	bullet.queue_free()
	leftPlayerHealth -= 1
	if leftPlayerHealth == 2:
		$HUD/LeftHearts/Heart1.hide()
	if leftPlayerHealth == 1:
		$HUD/LeftHearts/Heart2.hide()
	if leftPlayerHealth == 0:
		$HUD/LeftHearts/Heart3.hide()
		
		var title = "Sheriff Dead!"
		var message = "Nice work Bandit! Way to dispatch that pesky good for nothing Sheriff. On to more mischievousness?"
		show_dead_menu(title, message)


func show_dead_menu(title, message):
	get_tree().paused = true
	$DeadMenu/Popup/Title/Label.text = title
	$DeadMenu/Popup/Body/Label.text = message
	$DeadMenu/Popup.show()


func _on_Quit_pressed():
	get_tree().quit()


func _on_Resume_pressed():
	get_tree().paused = false
	$PauseMenu/Popup.hide()


func _on_Replay_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()
