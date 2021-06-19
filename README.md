# D.ino Game
## A crowd emotion contagion simulation 
___

The D.ino Game is a computeur science project we had to do during the fourth semester of our studies at ESEO. Our Team is composed of [Clément][C], [Julie][J] and [Lucie][L].
This simulation runs under the Godot game engine. This project is then coded in GDscript.

- Dowload [Godot][G]
- Click on the scan button to import the simulation file
- Select the project with the Dino image
- Click on the run button
- ✨[Let's get the Dinosaur Out !][music]✨

![image](https://cdn.discordapp.com/attachments/777931469162020944/854385857066041400/sketch1623770814552.png)

## A little bit of context
___
>This little dinosaur, named Wanis, has a very special story. Since 2018, he is the symbol of our Team. By making this simulation we pay tribute to his story.
In a nutshell, one day, Wanis wanted to take the tram. However he was too tall to get in. Therefore, he became angry and knocked down every buses he bumped into in the street. Unfortunately, one of our friend, [Kewe][K], was in one of those buses hence her lateness at school.
Nonetheless, Wanis isn't a naughty [T.Rex][T.R], he is a good dino.

## Features
___
This project uses Object Oriented Programming. It is then divided into 3 main files, one for the dinosaurs, one for the buses and a main one which gather everything needed to run the simulation. All the methods of our two objects, the dinos and the buses, are executed in the main file thanks to the rules function.
Conserning the functioning of the simulation, it is splitted  into : the crowd simulation, the emotion transmission and the behaviours.

#### The crowd simulation
The [BOIDS algorithms][BA] is used for the simulation. You can then find 3 mains functions controlling the crowd : **separation, gather and alignment**. The three depends on a sight range and on an application coefficient. 

#### Emotion transmission

Our dinosaurs have an **emotion scale**. It fluctuates between 0 and 20. Between 0 and 4, the dinosaurs are **blue** because they are **scared**. Between 5 and 15, they are **green**, it means they are **neutral**. Between 16 and 20, the dinosaurs are **angry** hence **red**.
Their level of emotion varies according to the **density of dinosaurs around**. Therefore, a group of 4 dinosaurs makes their emotion rise. When a dino is alone, its emotion decrease. When they are 2 or 3, their emotion variation depends on their actual emotion. If they are angry, it decreases. If they are scared, it rises.
This kind of transmission is based on the [SIR model][SM].

#### Behaviours
The **angry dinos** are more likely to stay together as a group and they are willing to knock down every buses on the map.
The **scared dinos** want to find as soon as possible a new group of dinosaurs in order to avoid beeing alone.
The **green dinos** have a default normal behaviour.
The **bus** can only move in the streets of the maps. When a red dino touches them, they broke.

## Upgrades
___
Various upgrades will be done in the future to improve this fun simulation such has an ambulance which goal will be to repare the broken buses.

## License
___
[MIT](https://choosealicense.com/licenses/mit/)

[G]: https://godotengine.org/
[music]: https://www.youtube.com/watch?v=vV7DrNCoRro
[T.R]: https://www.cbc.ca/natureofthings/features/everything-we-thought-we-knew-about-t-rex-is-wrong
[L]: https://cdn.discordapp.com/attachments/780511008837206056/855820127828049970/20210619_163746.jpg
[J]: https://cdn.discordapp.com/attachments/780511008837206056/855820226271772702/20210619_163543.jpg
[K]: https://cdn.discordapp.com/attachments/780511008837206056/855820496163045397/20210619_164122.jpg
[C]:https://cdn.discordapp.com/attachments/777931469162020944/855821442666987580/20210619_163617.jpg
[BA]: https://cs.stanford.edu/people/eroberts/courses/soco/projects/2008-09/modeling-natural-systems/boids.html
[SM]: https://www.maa.org/press/periodicals/loci/joma/the-sir-model-for-spread-of-disease-the-differential-equation-model
