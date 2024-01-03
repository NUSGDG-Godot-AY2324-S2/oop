# oop

Template game to practice object-oriented programming (OOP) and event-driven programming.

By the end of this session, the following features should have been completed:

* E

## Guide

This is a top-down game, with basic implementation of player, enemy and map.

### Scenes

1. Player

These have been implemented:
* Movement
* Shooting towards the direction of the mouse.
* Taking damage.

Assets for player are found at `/assets/sprites/character`

2. Map

A background layer and a layer with walls have been implemented. Collision shapes have also been defined.

Assets for map are found at `/assets/sprites/tileset`

3. Enemies

Minions with the same bullet has been implemented. Minions shoot at the direction of the player.

4. Bullets

Bullets have been implemented with various speed, damage and shape (sprite).

### Collision

#### Layers

* Player: 1
* Map: 2
* Enemy: 3

#### Masks

* Player: 2
* Map: no mask
* Enemy: no mask
* Bullet: 3

## Acknowledgements

Assets are obtained from [Mystic Woods](https://game-endeavor.itch.io/mystic-woods).

Bullets assets are obtained from [16x16 Bullets](https://bdragon1727.itch.io/free-effect-and-bullet-16x16).
