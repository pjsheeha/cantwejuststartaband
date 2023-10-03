extends Control

@onready var roll_daily = get_node("roll-day");
@onready var die1 = get_node("die1");
@onready var die2 = get_node("die2");
@onready var die3 = get_node("die3");
@onready var die4 = get_node("die4");
@onready var die5 = get_node("die5");
@onready var die6 = get_node("die6");
@onready var yourdie = get_node("yourdie");
@onready var selectedText = get_node("selected");
@onready var resultsText = get_node("results");
@onready var whoWinsText = get_node("whowins");
@onready var option1 = get_node("option1");
@onready var option2 = get_node("option2");
@onready var currentPos = get_node("position-label");
@onready var winPosition = get_node("option1/win-position");
@onready var losePosition = get_node("option2/lose-position");
var dice;
var rng;
var selected = '';
var yourdieselected = '';
var roll_daily_rolled = false;
var you_rolled_higher = false;
var yourdieVal = 0;
var dieVal = 0;
var dieIndex = -1;
var dieDailyArchive =[]
var days = 0;
var diceVals = []

var json = JSON.new()
var json_scene= "res://my_scene.json"
var json_data = {}
var json_stage = {}
var current_json_id = 24;
var attributes = [];
var spaces_to_go = 0;
var substituting = false;
var money = 0;
var direction = -1;

# Called when the node enters the scene tree for the first time.
func _ready():
	roll_daily.text = "Click me"

	randomize();
	print('sds')
	dice = [die1,die2,die3,die4,die5,die6]
	diceVals = [0,0,0,0,0,0]
	roll_daily.pressed.connect(self._button_pressed_click_me)
	option1.pressed.connect(self._button_pressed_advance.bind(1))
	option2.pressed.connect(self._button_pressed_advance.bind(2))
	for die in dice :
		die.pressed.connect( self._button_pressed_die_selected.bind(dice.find(die)))
	yourdie.pressed.connect(self._button_pressed_yourdie_selected)
	yourdie.disabled = true
	json_data = load_json_file(json_scene)
	print(json_data['stages'][0]['description'])
	attributes.append('HIRED');
	setupAll();
	initialRoll();
	
	pass # Replace with function body.

func initialRoll():
	roll_daily.disabled = false;
	for die in dice :
		die.disabled = true;
	option1.disabled = true;
	option2.disabled = true;

func setupAll():
	resultsText.text = '';
	whoWinsText.text = ''
	yourdie.text = ''
	selectedText.text = '';
	json_stage = json_data['stages'][current_json_id];

	for a in attributes:
		if (a == json_data['stages'][current_json_id]['substituteIf']):
			json_stage = json_data['stages'][current_json_id]['substituteObject'];

	if (json_stage["value"] == 1337):	##1337 is FIRED
		if (attributes.count('FIRED')==0):
			attributes.append('FIRED');
	elif (json_stage["value"] == 1000):
		if (attributes.count('NEEDS_NOT_MET')==0):	#1000 is NEEDS_NOT_MET
			attributes.append('NEEDS_NOT_MET');
	elif (json_stage["value"] == 7430): 	#7430 is HAS_BAND
		if (attributes.count('HAS_BAND')==0):
			attributes.append('HAS_BAND');
	elif (json_stage["value"] == 6969): #6969 is INFLATED
		if (attributes.count('INFLATED')==0):
			attributes.append('INFLATED');
	elif (json_stage["value"] == 1594): 	#1594 is HAS_LOAN
		if (attributes.count('HAS_LOAN')==0):
			attributes.append('HAS_LOAN');
	elif (json_stage["value"] == 6660):	#6660 is BOSS
		if (attributes.count('BOSS')==0):
			attributes.append('BOSS');
	elif (json_stage["value"] == 1212):	#1212 is IRA
		if (attributes.count('IRA')==0):
			attributes.append('IRA');

	elif (json_stage["value"] == 4424):	#4424 is remove FIRED
		if (attributes.count('FIRED')>0):
			attributes.remove_at(attributes.find('FIRED'));
	elif (json_stage["value"] == 8032):	#8032 is remove HAS_BAND
		if (attributes.count('HAS_BAND')>0):
			attributes.remove_at(attributes.find('HAS_BAND'));
	elif (json_stage["value"]== 1201):	#1201 is remove HAS_LOAN
		if (attributes.count('HAS_LOAN')>0):
			attributes.remove_at(attributes.find('HAS_LOAN'));
	elif (json_stage["value"] == 8080):	#8080 is remove IRA
		if (attributes.count('IRA')>0):
			attributes.remove_at(attributes.find('IRA'));
	elif (json_stage["value"] == 5550):	#5550 is remove NEEDS_NOT_MET
		if (attributes.count('NEEDS_NOT_MET')>0):
			attributes.remove_at(attributes.find('NEEDS_NOT_MET'));
	elif (json_stage["value"] == 9696):	#9696 is remove INFLATED
		if (attributes.count('INFLATED')>0):
			attributes.remove_at(attributes.find('INFLATED'));
	#else:
	#	money += json_stage["value"]
	currentPos.text = json_stage['title'];
	if (json_stage["id"] == 24):
		if (!attributes.has("NEEDS_NOT_MET")):
			attributes.remove_at(attributes.find('NEEDS_NOT_MET'));
		else:
			var opop = 0
			var goalToDelete = randi() % dice.length;
			for d in dice:
				if (goalToDelete == opop):
					dice.remove_at(attributes.find(d));
				opop += 1;

		for v in diceVals:
			v =0
		for o in dice:
			o.text = ''
		initialRoll();
	deciding_die()
	for d in dieDailyArchive:
		dice[d].disabled = true

#	pass
	
func deciding_die():
	var winId = 0;
	var loseId = 0;
	var win = ''
	var lose = ''
	if (json_stage['type'] == 'contest'):
		for p in dice:
			p.disabled = false
		winId = current_json_id + direction;
		loseId= current_json_id + -1*direction;
		option1.disabled = true;
		option2.disabled = true;
		win = json_data['stages'][winId]['title']
		lose = json_data['stages'][loseId]['title']
	else:
		for piu in dice:
			print('oko')
			piu.disabled = true

		if (json_stage['spacesForward']>0):
			winId= current_json_id + json_stage['spacesForward'];
			option2.disabled = true;
			option1.disabled = false;
			win = json_data['stages'][winId]['title']
		elif (json_stage['spacesForward']<0):
			loseId= current_json_id + json_stage['spacesForward'];
			lose = json_data['stages'][loseId]['title']
			option2.disabled = false;
			option1.disabled = true;
	winPosition.text = win
	losePosition.text = lose
func _button_pressed_advance(opt):

	print(json_stage)
	if (json_stage["type"] == "a"):
		current_json_id += json_stage["spacesForward"];
	elif (json_stage["type"] == "payday"):
		money += json_stage["value"];
		current_json_id += json_stage["spacesForward"];
	elif (json_stage["type"] == "rollpaydayboss"):
		money += json_stage["value"]+ ((randi() % 6)+1);
		current_json_id += json_stage["spacesForward"];
	elif (json_stage["type"] == "teleport"):
		current_json_id = json_stage["spacesForward"];
	elif (json_stage["type"] == 'contest'):
		
		dieDailyArchive.append(dieIndex);
		if (opt == 1):
			current_json_id += (direction);
		elif (opt == 2):
			current_json_id += -1*direction;

	setupAll();


	pass

func load_json_file(filePath : String):
	if FileAccess.file_exists(filePath):
		var dataFile = FileAccess.open(filePath, FileAccess.READ);
		var parsedResult = JSON.parse_string(dataFile.get_as_text())
		if parsedResult is Dictionary:
			return parsedResult
		else:
			print("error")
	else:
		print("don't exist")

func _button_pressed_yourdie_selected():

		var rol = randi() % 6;
		yourdieVal = rol+1;
		yourdie.text = str(rol+1);
		
		yourdieselected = str(rol+1);
		if (yourdieselected != ''):
				if dieVal == 6 or dieVal == 1:
					resultsText.text = 'doesnt matter';
				else:
					resultsText.text = 'your rolled die is ' + yourdieselected+ '.';
					yourdie.disabled = false
					whoWinsText.text = ''
					if yourdieVal < dieVal:
						
						you_rolled_higher = false;
						whoWinsText.text = 'Your roll of ' + str(yourdieVal) + ' was less than your competitions which was ' + str(dieVal) +'. You win!'
					elif yourdieVal == dieVal:
						you_rolled_higher = true;
						print('asasa',str(yourdieVal));
						whoWinsText.text = 'Your roll of ' + str(yourdieVal) + ' was equal to your competitions which was ' + str(dieVal) +'. You lose.'
					else:
						you_rolled_higher = true;
						whoWinsText.text = "Your roll of " + str(yourdieVal) + ' was higher than your competitors roll which was ' + str(dieVal) + '. You lose.'
					for die in dice :
						die.disabled = true;
					yourdie.disabled = true

				_which_option()


func _button_pressed_die_selected(di):
	print(di)
	if (dice[di].text != selected or selected == ''):
		dieVal = int(diceVals[di])
		dieIndex = di;
		selected = str(diceVals[di])
	elif ( dieIndex == di):
		dieVal = 0;
		dieIndex = di;
		print('index', dieIndex)
		selected = ''
	if (selected != ''):
		selectedText.text = 'your selected die is '+selected+ '.';
		yourdie.disabled = false
	else: 
		selectedText.text = "You haven't selected a die to roll against";
	if (selected != ''):
		if (dieVal == 6):
			
			whoWinsText.text = 'You automatically pass this check'
			yourdie.disabled = true
			you_rolled_higher = false;
			_which_option()
		elif (dieVal ==1):
			whoWinsText.text = 'You automatically fail this check'
			yourdie.disabled = true
			you_rolled_higher = true;
			_which_option()
		else:
			option1.disabled = true;
			option1.disabled = true;

			
	pass

func _button_pressed_click_me():

	if (roll_daily_rolled == false):
		for die in dice :
			if (json_stage["type"] == "a"):
				die.disabled = true
				
			elif (json_stage["type"] == "contest"):
				die.disabled = false
			else:
				die.disabled = true
			var rol = randi() % 6;
			die.text = str(rol+1);
			diceVals[dice.find(die)] = str(rol+1);

			roll_daily.disabled = true;
		roll_daily_rolled = true;
	deciding_die();


	pass
	
func _which_option():
	if (you_rolled_higher == false):
		option1.disabled = false;
		option2.disabled = true;
	elif (you_rolled_higher == true):
		option1.disabled = true;
		option2.disabled = false;
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	

	pass
