extends KinematicBody2D
"""
================================================================================
GDscript
file agent.gd
================================================================================
Authors : Lucie LEOPOLD, Julie PERE, Clément VIVIER
Date : 19/06/2021
================================================================================
This file contains all the buses's functions.
"""

# Declare member variables here, they can be modified 
var vitesse # agent's speed
var gather_sight = 10 # agent's gathering sight
var separation_sight = 100 # agent's separation sight
var align_sight = 200 # agent's alignement sight
var gather_coef = 2 # agent's gathering coefficient
var separation_coef = 2 # agent's separation coefficient
var alignment_coef = 0.1 # agent's alignment coefficient
var screen_size
var broken = false # the buses aren't broken at the beginning
var rng = RandomNumberGenerator.new()


# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	screen_size = get_viewport_rect().size
	position = Vector2(rng.randi_range(520 ,520),rng.randi_range(30, 400)) # screen-size-20 so that wanis stays in the window
	vitesse = Vector2(rng.randi_range(-1,1),rng.randi_range(-1,1)) # initialization of the agent's speed
	vitesse.normalized() 
	set_process(true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var collision = move_and_collide(vitesse * delta) # make the bus able to move and hit the walls
	move_and_slide(vitesse,Vector2(0,-1))
	if broken:
		vitesse = Vector2(0,0)
		$AnimatedSprite.animation = "broken"
	else:
		if vitesse.x >= 0 :
			$AnimatedSprite.animation = "droite"
		if vitesse.x <= 0 :
			$AnimatedSprite.animation = "gauche"
		
	# using move_and_collide
	if collision:
		vitesse = vitesse.slide(collision.normal)
	if vitesse <= vitesse*0 :
		position += vitesse*delta
		
	# using move_and_slide
	vitesse = move_and_slide(vitesse)
	
	update()

#draw bus
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

