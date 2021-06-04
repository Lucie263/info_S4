extends Area2D

"""
================================================================================
GDscript
file agent.gd
================================================================================
Authors : Lucie LEOPOLD, Julie PERE, Clément VIVIER
Date : 30/04/2021
================================================================================
This file contains all the agent's functions.
"""

# Declare member variables here, they can be modified 
var vitesse # agent's speed
var gather_sight = 200 # agent's gathering sight
var separation_sight = 50 # agent's separation sight
var align_sight = 180 # agent's alignement sight
var gather_coef = 2.5 # agent's gathering coefficient
var separation_coef = 3 # agent's separation coefficient
var alignment_coef = 0.4 # agent's alignment coefficient
var screen_size
var anger
var anger_signt = 70
var rng = RandomNumberGenerator.new()
var near = []


# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	screen_size = get_viewport_rect().size
	anger = rng.randi_range(0,6)
	position = Vector2(rng.randi_range(20,screen_size.x-20),rng.randi_range(20,screen_size.y-20 )) # screen-size-20 so that wanis stays in the window
	vitesse = Vector2(rng.randi_range(-1,1),rng.randi_range(-1,1)) # initialization of the agent's speed
	vitesse.normalized() 
	set_process(true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	bordure() 
	position += vitesse*delta # making the agent move at each frame
	if anger >= 7:
		if vitesse.x >= 0 :
			$AnimatedSprite.animation = "bad_droite"
		if vitesse.x <= 0 :
			$AnimatedSprite.animation = "bad_gauche"
	else:
		if vitesse.x >= 0 :
			$AnimatedSprite.animation = "droite"
		if vitesse.x <= 0 :
			$AnimatedSprite.animation = "gauche"
	update()


# Checking if the agent is still in the window
func bordure():
	# speed indicates also the direction ( positive = to the right, negative = to the left)
	if position.x >= screen_size.x-20:
		vitesse.x = rng.randi_range(-1,0) #changing the agent's direction to go to opposite way
	if position.y >= screen_size.y-20:
		vitesse.y = rng.randi_range(-1,0)
	if position.y <= 20:
		vitesse.y = rng.randi_range(0,1)
	if position.x <= 20:
		vitesse.x = rng.randi_range(0,1)


#draw green wanis dinosaure
func _draw():
	$AnimatedSprite.play()


#Calculate the distance between the agent
func dist(agent):
	return position.distance_to(agent.position)


#Contains the application of gather, separate and alignement
func rules(swarm,mem):
	var temp 
	temp = gather(swarm)
	vitesse += temp # modify the agent's speed with the resulat of gather 
	temp = separation(swarm)
	vitesse += temp # modify the agent's speed with the resulat of separation
	temp = alignment(swarm,mem)
	vitesse += temp # modify the agent's speed with the resulat of alignement
	let_anger(swarm)
	print(anger)

# Calculate the direction needed to get closer to other agents
func gather(swarm):
	var centroid = Vector2(0,0)
	var N = 0
	for agent in swarm:
		var d = dist(agent) 
		if d < gather_sight: #Verify if the agents are in the gather sight
			N += 1
			centroid += agent.position 
	centroid /= N # Calculate the centroid of the gather sight
	var result = gather_coef*(centroid-position).normalized() 
	return result # return a vector pointing to the centroid


# Calculate the direction needed to move away from the other agents
func separation(swarm):
	var neigbor_pos = Vector2(0,0)
	var N = 0
	for agent in swarm:
		var d = dist(agent)
		if d < separation_sight:
			N += 1
			neigbor_pos += agent.position
	neigbor_pos /= N
	return separation_coef*(position-neigbor_pos).normalized() # return a vecteur which permits to stay away from the other agent


# Calculate the direction needed to have the same one as the agent's neighbours
func alignment(swarm,mem):
	var N = 0
	var sum = Vector2(0,0)
	var mean = Vector2(0,0)
	for agent in swarm:
		var d = dist(agent)
		if d <= align_sight:
			sum += mem[N] # sum the agent's speed only if in the align sight
			N += 1
		mean = sum / N
	return alignment_coef*mean.normalized() # return a vector which is the mean all of neighbours' speed


func let_anger(swarm):
	for wanis in swarm:
		if anger >= 0:
			if anger <= 10:
				if wanis != self:
					if dist(wanis) <= anger_signt:
						if !(near.has(wanis)):
							near.append(wanis)
					elif near.has(wanis): #if not close to the others, change his anger and remove it of the list if in it
						if anger <= 0:
							wanis.anger = 0
							near.erase(wanis)
							wanis.near.erase(self)
						else:
							wanis.anger += -1
							near.erase(wanis)
							wanis.near.erase(self)
				if near.size() + 1 >= 4: # +1 to count the actual wanis
					if anger >= 10:
						anger = 10
					else:
						anger += 1
					for i in near.size():
						if anger >= 10:
							anger = 10
						else:
							near[i].anger += 1
				elif anger >= 7: # to prevent border group wanis to "disable" all 
					if anger <= 0:
						anger = 0
					else:
						anger += -1
					for i in near.size():
						if anger <= 0:
							anger = 0
						else:
							near[i].anger += -1
			else:
				anger = 10
		else:
			anger = 0

