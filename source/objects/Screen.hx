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

        // If there's not an active screen, make this the active screen
        if (state.activeScreen == null)
        {
            endTransition(null);
            return;
        }

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
        if ((player.x < this.x) &&
            (player.x + player.width > this.x) &&
            (player.y > this.y) &&
            (player.y + player.height < this.y + this.height))
        {
            // Scroll the camera to the new screen
            FlxTween.tween(FlxG.camera.scroll, {x: this.x}, 2.0, {onComplete: endTransition});
            
            // Move the player into the new screen
            FlxTween.tween(player, {x: player.x + player.width}, 2.0);
        }
        // Entering the screen from the right side
        else if ((player.x < this.x + this.width) &&
                 (player.x + player.width > this.x + this.width) &&
                 (player.y > this.y) &&
                 (player.y + player.height < this.y + this.height))
        {
            // Scroll the camera to the new screen
            FlxTween.tween(FlxG.camera.scroll, {x: this.x + (this.width - 160)}, 2.0, {onComplete: endTransition});

            // Move the player into the new screen
            FlxTween.tween(player, {x: player.x - player.width}, 2.0);
        }
        // Entering the screen from the top
        else if ((player.x > this.x) &&
                 (player.x + player.width < this.x + this.width) &&
                 (player.y < this.y) &&
                 (player.y + player.height > this.y))
        {
            // Scroll the camera to the new screen
            FlxTween.tween(FlxG.camera.scroll, {y: this.y}, 2.0, {onComplete: endTransition});

            // Move the player into the new screen
            FlxTween.tween(player, {y: player.y + player.height}, 2.0);
        }
        // Entering the screen from the bottom
        else if ((player.x > this.x) &&
                 (player.x + player.width < this.x + this.width) &&
                 (player.y < this.y + this.height) &&
                 (player.y + player.height > this.y + this.height))
        {
            // Scroll the camera to the new screen
            FlxTween.tween(FlxG.camera.scroll, {y: this.y + (this.height - 144)}, 2.0, {onComplete: endTransition});

            // Move the player into the new screen
            FlxTween.tween(player, {y: player.y - player.height}, 2.0);
        }
        else
            trace("Could not determine a side");
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