# Godot -​ My Library Helpers

This project contains library helper scene files for various use cases for [Godot Engine](godotengine.org​). Its main use is to help make the game development progress become faster.

## Setting up libraries for use in your project

You can directly copy **/Lib** folder and put them in your project. After its sub-folders are integrated with Godot, you can rename or move the main folder anywhere so that Godot will automatically rescan the files.

## Example Usages

Located at **/ExampleUsage** folder. Each sub-folders contain scene files and explanations on how to use each of its libraries.

## Available Libraries

**AudioManager** - A singleton audio player that plays background music and sound effects. The main advantage is to provide an easier way to play audio from anywhere without having to attach a sound effect to a node.

**SpriteCycling2D** - Allows drawing sprites in forward order one frame and backward order the next. This library is inspired by video games like Mega Man for Nintendo Entertainment System. Useful for making two overlapping sprites appear transparent.

**BulletBehavior2D** - The Bullet behavior simply moves parent object forwards at an angle. However, it provides extra options like gravity and angle in degrees that allow it to also be used. Like the name suggests it is ideal for projectiles like bullets, but it is also useful for automatically controlling other types of objects like enemies which move forwards continuously. 

----
Coming soon: SineBehavior2D and PlatformBehavior2D

**SineBehavior2D** - The Sine behavior can adjust an object's properties (like its position, or angle) back and forth according to an oscillating sine wave. This can be used to create interesting visual effects..  

**PlatformBehavior2D** - The Platform behavior applies the parent node of KinematicBody2d a side-view "jump and run" style movement. By default the Platform movement is controlled by the <span style='color:#979797;'>ui_left</span> and <span style='color:#979797;'>ui_right</span> keys and <span style='color:#979797;'>ui_up</span> to jump. To set up custom or automatic controls, see its library's script.

_More coming soon!_
