extends Control

onready var username_input = get_node("Background/VBoxContainer/Username")
onready var userpassword_input = get_node("Background/VBoxContainer/Password")
onready var login_button = get_node("Background/VBoxContainer/Loginbutton")
onready var create_account_screen = get_parent().get_node("CreateAccountScreen")

func _ready():
	pass #
	
func _on_Login_pressed():
	if username_input.text == "" or userpassword_input.text == "":
		#popup and stop
		print("Please provide valid userID and password")
	else:
		login_button.disabled = true
		var username = username_input.get_text()
		var password = userpassword_input.get_text()
		print("Attempting to login")
		Gateway.ConnectToServer(username, password, false)


func _on_CreateAccount_pressed():
	self.visible = false
	create_account_screen.visible = true
	