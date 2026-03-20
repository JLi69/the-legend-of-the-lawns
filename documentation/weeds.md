# Weed Enemies

## Creating the Scene for Weed Enemies

When creating a new scene for weed enemies the scene file *must* be placed in
the directory `scenes/enemies/weeds/`.

Weed enemy scenes must have the following node structure:

```
Area2D
|_ CollisionShape2D
|_ Shadow (type: Sprite2D)
|_ AnimatedSprite2D
|_ ContactDamageZone
|_ BulletSpawnPoint (type: Node2D)
|_ Healthbar
```

`ContactDamageZone` is instantiated from the scene 
`scenes/enemies/contact_damage_zone.tscn` and `Healthbar` is instantiated from
the scene `scenes/enemies/healthbar.tscn`.

The `Shadow` node can be excluded though it does help with indicating where the
enemy meets the ground, which creates a nice pseudo-3D effect (which is part of
the art style for the game so therefore should be kept). Note that in the scene
tree the shadow node is above `AnimatedSprite2D` which leads to `AnimatedSprite2D`
being rendered on top of the shadow.

`AnimatedSprite2D` handles the actual enemy sprite which can be animated - it is
also capable of handling multiple animations.

The node `BulletSpawnPoint` is simply a node that indicates the position the
enemy will spawn bullets. Note that it is mandatory that a node called
`BulletSpawnPoint` is present in the scene as if a weed enemy does not have
a child node called `BulletSpawnPoint`, the game will crash.

It is also possible to create a new inherited scene from the scene
`scene/enemies/weeds/weed.tscn` for making a new weed enemy scene.

### Node Positioning

The shadow sprite should be at or close to (0, 0).

Sprites in the game are sorted by their y position so to prevent sprites from
being rendered in the wrong order, try to have `AnimatedSprite2D` be positioned
so that its bottom is aligned with y = 0.

The healthbar should be placed above `AnimatedSprite2D`.

Make sure `ContactDamageZone` is roughly centered on the sprite and should cover
a small distance (you can change the scale in the transform properties) around 
the enemy. `CollisionShape2D` should cover the bounding box of the sprite and
should have shape `RectangleShape2D`.

### Signals

The signal `area_entered` should be connected to the method `_on_area_entered`
as without the signal being connected, the enemy will not take damage from bullets.

Optionally, the signal `hit` can be connected to a method `_on_hit` (which must
be defined in any script for a weed enemy). This allows the enemy to respond
to being hit by a player bullet. An example response would be shooting bullets
at the player.

### Properties

`bullet_scene: PackedScene` - This is the scene that will be instantiated as the 
bullet this enemy shoots. Enemy bullet scene files are located in `scenes/enemies/bullets`.

`bullet_cooldown: float` - The delay the enemy takes before shooting another set of
bullets, in seconds.

`max_shoot_distance: float` - The maximum distance that the player can be at
before the enemy does not bother shooting the player anymore.

`explosion_bullet_count: int` - The number of bullets that are shot out whenever
the enemy dies.

`max_health: int`- The maximum health points the enemy has.

`boss: bool` - Indicates whether the weed a boss enemy. If true, the camera will
shake when the enemy spawns.

`grow_delay: float` - Typically, when an enemy spawns, it goes through a quick
growing animation. By default this animation starts instantly but this value
can be set to a number of seconds in which the enemy will wait before beginning
its spawning animation.

## Scripting Weed Enemies

When writing scripts for weed enemies, they must inherit from the `WeedEnemy`
class, which can be done by adding this line at the top of the script file:
```
extends WeedEnemy
```

### Methods

`player_in_range() -> bool` - Returns true if the player is within a sufficient
distance to the enemy, when it does return true the enemy will start shooting
at the player. By default, it uses `max_shoot_distance` as its distance but
if the enemy is hit by the player, it will set an `engaged` flag which will
lead to it doubling the distance it will start shooting at the player.

`explode() -> void` - Upon death, by default, enemies will explode into a collection 
of bullets. This function can be overridden to have different behaviors for
when the enemy dies.

`shoot_bullet(offset: float = 0.0, bullet_template: PackedScene = null) -> void` - 
Attempts to shoot a bullet at the player. The value `offset` is added to the angle
that is calculated for the direction of the player - by default it is `0.0`,
`offset` is in radians. The argument `bullet_template` allows for a bullet scene
to be passed into the function. If `bullet_template` is null (which it is by
default), the enemy will instead use `bullet_scene`. Note: you can actually
use this function to effectively shoot bullets in a random direction by simply 
calling `shoot_bullet(randf_range(0.0, 2.0 * PI))`.

`shoot() -> void` - Controls how the enemy shoots bullets. By default the enemy
shoots a single bullet aimed at the player (by simply calling `shoot_bullet`
This can be changed by overriding the method.

`get_animation() -> String` - Returns a string that will be set as the enemy's
current animation in `$AnimatedSprite2D`. Can be overridden to allow for
different conditions to change the enemy's animation.

`get_dir() -> String` - Returns a string telling the direction the player is
compared to the position of the enemy. "left" if the player is to the left,
"right" if the player is to the right, "up" if the player is above, "down"
if the player is below. Helpful for enemies that might have animations that
'look' in the general direction of the player.

`bullet_spawn_point() -> Vector2` - Returns the global position of the bullet
spawn point node.

It is possible to override `_process`, `_ready`, and `_on_area_entered` though
it is recommended that in the overriden versions the version in the superclass
is called as there is code present in these methods that are important for
having the enemy behave and work correctly.
