# Style Guide

## File Naming Convention

Files names should be snake case with all lowercase: `my_file_name.txt`.

**Do not** use uppercase letters in file names, Windows does not distinguish
between upper and lowercase letters for file paths so keep everything in lowercase
to avoid confusion.

Use the same naming convention for directories.

Also preferably keep file names short but descriptive of their contents.

## Nodes

Nodes should have camel case names that start with an uppercase letter:
`MyNodeName`.

## Source Code Style

We primarily use GDScript with our games so this style guide will primarily
focus on that.

Function and variable names should be snake case:

```
func my_variable_name
func my_function_name() ...
```

Class names should be camel case: `class_name MyClassName`.

Variable and function names should be fairly descriptive and understandable.

Function definitions must have explicit types in their declaration:

Good:
```
func my_function(a: int, b: int, c: String) -> int:
    print(c)
    return a + b
```

**BAD:**

```
func my_function(a, b, c):
    print(c)
    return a + b
```

Functions that do not return any value **must** be labelled as void:
```
func my_function() -> void:
    print("no return value")
```

**BAD:**
```
func my_function():
    print("no return value")
```

Variables defined as member variables of a class/script file must have types:

Good:
```
var my_value: int = 0
```

**Bad:**
```
var my_value = 0
```

Define member variables at the top of the script file. 

Aim to use typing whenever possible as it improves readability and gives better
autocomplete results.

Do not use semicolons.

Code should be commented well and the comments should be helpful and descriptive.

When I say "helpful and descriptive" I mean that comments should explain the 
reasoning behind code - i.e. explaining that a part of a script doing a thing 
that someone reading it might not understand/think is a mistake is actually for 
performance reasons or is to work around a bug.

I don’t have any hard and fast rules at the moment but I would say that if you 
think that someone reading your code would not at all understand its purpose/why 
it is there, then add a comment. However, do not add comments that are just 
repeating what the line below is doing in English. It is possible that code 
can be fairly easy to read and understand and is not in need of a comment though.

When loading/preloading a scene/resource in GDScript, use the uid, not the actual 
path. The uid allows for the file to still be properly loaded without any changes 
to code if the file gets renamed/moved.

```
var scene: PackedScene = preload("uid://...")
```

Personally, I think that `@export` is a better choice since it allows for direct 
editing in the editor which I feel is more intuitive but this is a personal opinion.

You can add a comment as to what the uid is pointing to.

Format multiline arrays like this:
```
var array: [String] = [
	"Line1",
	"Line2",
	"Line3"
]
```
A similar style applies for dictionaries.

Preferably a line should be limited to 80 - 100 characters (I do not have a 
hard/fast rule on this at the moment but don’t make your lines too long).

Preferably do not use "magic numbers" or "magic values". If you have a specific 
value that you want to use in the code, it is preferred to use a constant/variable 
with a descriptive name so that the code is easier to read.

**BAD:**
```
var area: float = 3.14 * radius * radius
```

Good:
```
# GDScript has a built in PI constant
var area: float = PI * radius * radius
```

**BAD:**
```
func attack(...) -> void:
	...
	damage(player, 5)
    ...
```

Good:
```
const DAMAGE_AMT: int = 5
func attack(...) -> void:
	...
	damage(player, DAMAGE_AMT)
	...
```

or
```
var DAMAGE_AMT: int = 5
func attack(...) -> void:
	...
	damage(player, DAMAGE_AMT)
	...
```

or if you want it to be changed in the editor:
```
@export var DAMAGE_AMT: int = 5
func attack(...) -> void:
	...
	damage(player, DAMAGE_AMT)
	...
```
