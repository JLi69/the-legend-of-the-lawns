extends HBoxContainer

"""
For debugging purposes

Commands available:
	enabletest - enables the test neighbor
	
	setlevel [level] - sets the current game level to the value given
	(example: setlevel 2)
	
	setmoney [money] - sets the current amount of money the player has to the
	value given	
	(example: setmoney 20)

	addmoney [money] - adds the amount given to the current amount of money
	(example: addmoney 10, this will add $10 to the player's money count, so
	if they have $20 before, they would now have $30)
	
	goto [neighbor id] - teleports the player to the neighbor given, must
	match the name of the node in the editor
	(example: goto NeighborBob, teleports the player to Neighbor Bob's
	position)

	disablecheats - disables cheat console

	die - set health to 0 while in the lawn
"""

## Should be disabled in release
@onready var main: Main = $/root/Main
	
func _ready() -> void:
	if !OS.is_debug_build():
		queue_free()

func toggle() -> void:
	visible = !visible
	if visible:
		$ErrMessage.text = ""
		$Input.grab_focus.call_deferred()
		main.player.can_move = false
	else:
		main.player.can_move = true

func _input(event: InputEvent) -> void:	
	if get_tree().paused:
		return

	if event is InputEventKey and event.is_pressed():
		# Toggle console with F2
		if event.keycode == KEY_F2:
			toggle()
		# Run command with enter
		elif event.keycode == KEY_ENTER:
			var err: String = run_command($Input.text)
			if !err.is_empty():	
				$ErrMessage.text = "< %s >" % err
			else:
				toggle()
				$Input.text = ""
				$ErrMessage.text = ""

func _on_run_pressed() -> void:
	if !visible:
		return
	
	var err: String = run_command($Input.text)
	if !err.is_empty():	
		$Input.grab_focus.call_deferred()
		$ErrMessage.text = "< %s >" % err
	else:
		toggle()
		$Input.text = ""
		$ErrMessage.text = ""

func _process(_delta: float) -> void:
	if get_tree().paused and visible:
		toggle()

static func convert_to_args(cmd: String) -> PackedStringArray:
	return cmd.strip_edges().split(" ")

# Returns error messages, returns an empty string if there is no error
func run_command(cmd: String) -> String:
	var args: PackedStringArray = convert_to_args(cmd)
	if args.is_empty():
		return "Nothing to run."

	match args[0]:
		"enabletest":
			var test: NeighborNPC = main.neighborhood.get_neighbor("TestNeighbor")
			if test:
				test.enable()
			return ""
		"setlevel":
			if args.size() <= 1:
				return "Missing argument: level."
			var level: int = int(args[1])
			if level < 1:
				return "Invalid level."
			main.current_level = level
			return ""
		"setmoney":
			if args.size() <= 1:
				return "Missing argument: money."
			var money: int = int(args[1])
			if money < 0:
				return "Invalid money amount."
			main.money = money
			return ""
		"addmoney":
			if args.size() <= 1:
				return "Missing argument: money."
			var money: int = int(args[1])
			if money < 0:
				return "Invalid money amount."
			main.money += money
			return ""
		"goto":
			if main.lawn_loaded:
				return "Can not go to neighbor while in lawn."
			if args.size() <= 1:
				return "Missing argument: location."
			if args[1] == "store":
				var node: Node2D = main.neighborhood.get_node_or_null("Store/StoreDoor/StoreExterior")
				if node:
					main.player.global_position = node.global_position
					return ""
				return "Store does not exist!"
			var neighbor: NeighborNPC = main.neighborhood.get_neighbor(args[1])
			if neighbor == null:
				return "Neighbor does not exist."
			main.player.global_position = neighbor.global_position + Vector2(0.0, 10.0)
			return ""
		"disablecheats":
			queue_free()
			return ""
		"die":
			if !main.lawn_loaded:
				return "Lawn must be loaded!"
			main.player.health = 0
			return ""
			
	return "Invalid command!"
