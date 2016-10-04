package objects;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.math.FlxRect;
import flixel.tweens.FlxTween;

import states.PlatformState;

class Screen extends FlxObject
{
    public function new(x:Float, y:Float, width:Float, height:Float)
    {
        super(x, y, width, height);
    }

    public function transition(state:PlatformState):Void
    {
        var player = state.player;

        // Pause all movement
        Reg.PAUSE = true;

        // Remove the camera's target (the player) so it can move
        FlxG.camera.target = null;

        // Make the entire map scrollable by the camera
        FlxG.camera.setScrollBoundsRect(0, 0, Reg.STATE.mapCollide.width, Reg.STATE.mapCollide.height, true);

        // Update the touching flags between the player and this screen so we
        // can detect which side the collision happened on
        FlxObject.updateTouchingFlags(this, player);

        // Entering the screen from the left side
        if (player.isTouching(FlxObject.RIGHT))
        {
            // Scroll the camera to the new screen
            FlxTween.tween(FlxG.camera.scroll, {x: this.x}, 2.0, {onComplete: endTransition});
            
            // Move the player into the new screen
            FlxTween.tween(player, {x: player.x + player.width}, 2.0);
        }
        // Entering the screen from the right side
        else if (player.isTouching(FlxObject.LEFT))
        {
            // Scroll the camera to the new screen
            FlxTween.tween(FlxG.camera.scroll, {x: this.x}, 2.0, {onComplete: endTransition}); 

            // Move the player into the new screen
            FlxTween.tween(player, {x: player.x - player.width}, 2.0);
        }
        // Entering the screen from the top
        else if (player.isTouching(FlxObject.FLOOR))
        {
            // Scroll the camera to the new screen
            FlxTween.tween(FlxG.camera.scroll, {y: this.y}, 2.0, {onComplete: endTransition});

            // Move the player into the new screen
            FlxTween.tween(player, {y: player.y + player.height}, 2.0);
        }
        // Entering the screen from the bottom
        else if (player.isTouching(FlxObject.CEILING))
        {
            // Scroll the camera to the new screen
            FlxTween.tween(FlxG.camera.scroll, {y: this.y}, 2.0, {onComplete: endTransition});

            // Move the player into the new screen
            FlxTween.tween(player, {y: player.y - player.height}, 2.0);
        }
    }

    public function endTransition(_):Void
    {
        FlxG.camera.follow(Reg.STATE.player, FlxCameraFollowStyle.PLATFORMER);
        FlxG.camera.setScrollBoundsRect(x, y, width, height, false);
        Reg.STATE.screenTransitioning = false;
        Reg.STATE.activeScreen = this;
        Reg.PAUSE = false;
    }
}