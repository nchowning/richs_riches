package objects;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.util.FlxSpriteUtil;

class Player extends FlxSprite
{
    private static var _acceleration:Int = 300;
    private static var _drag:Int = 300;
    private static var _gravity:Int = 600;
    private static var _jumpForce:Int = -175;
    private static var _walkSpeed:Int = 55;
    private static var _fallingSpeed:Int = 300;

    // Time (in seconds) that the player is invulnerable
    private static var invulnerableTime:Float = 2.0;
    // Track invulnerability time
    private static var invulnerableCounter:Float = 0.0;
    // Time (in seconds) that the player cannot move after being hit
    private static var incapacitatedTime:Float = 0.5;

    public var lookingUp:Bool = false;
    public var invulnerable:Bool = false;
    public var incapacitated:Bool = false;

    public function new()
    {
        super();

        loadGraphic("assets/images/player.png", true, 16, 16);

        animation.add("idle", [0]);
        animation.add("walk", [0, 1, 2, 3], 7);
        animation.add("jump", [1]);
        animation.add("fall", [1]);
        animation.add("hurt", [4]);
        animation.add("death", [5, 6, 7, 8, 9, 10, 11], 7, false);

        setSize(6, 15);
        offset.set(5, 1);

        drag.x = _drag;
        acceleration.y = _gravity;
        maxVelocity.set(_walkSpeed, _fallingSpeed);

        health = 4.0;
    }

    override public function update(elapsed:Float):Void
    {
        if (!Reg.PAUSE && !incapacitated)
            move();

        // Update the player invulnerability counter
        if (invulnerable)
        {
            if (invulnerableCounter > invulnerableTime)
            {
                invulnerable = false;
                invulnerableCounter = 0.0;
            }
            else
            {
                invulnerableCounter += elapsed;
            }
        }

        animate();

        // Basic over-all map collisions
        if (x < 0)
            x = 0;
        // TODO implement right side bounds

        if (!Reg.STATE.screenTransitioning)
            super.update(elapsed);
    }

    override public function hurt(damage:Float):Void
    {
        // If the player is currently invulnerable, he can't get hurt again
        if (invulnerable)
            return;

        super.hurt(damage);

        // If the player's alive, start invulnerability and incapacitation
        if (health > 0.0)
        {
            invulnerable = true;
            FlxSpriteUtil.flicker(this, invulnerableTime);

            incapacitated = true;

            if (flipX)
                FlxTween.tween(this, {x: x + 2}, incapacitatedTime, {onComplete: resumeMovement});
            else
                FlxTween.tween(this, {x: x - 2}, incapacitatedTime, {onComplete: resumeMovement});
        }
    }

    override public function kill()
    {
        if (alive)
        {
            alive = false;

            velocity.set(0, 0);
            acceleration.set(0, 0);

            Reg.PAUSE = true;

            new FlxTimer().start(2.0, function(_)
            {
                FlxG.resetState();
            }, 1);
        }
    }

    private function resumeMovement(_):Void
    {
        incapacitated = false;
    }

    private function move():Void
    {
        acceleration.x = 0;


        if (FlxG.keys.anyPressed([Reg.inputMap["left"]]) ||
            (Reg.GAMEPAD != null && Reg.GAMEPAD.anyPressed([Reg.gamepadInputMap["left"]])))
        {
            flipX = true;
            acceleration.x -= _acceleration;
        }
        else if (FlxG.keys.anyPressed([Reg.inputMap["right"]]) ||
            (Reg.GAMEPAD != null && Reg.GAMEPAD.anyPressed([Reg.gamepadInputMap["right"]])))
        {
            flipX = false;
            acceleration.x += _acceleration;
        }

        if (velocity.y == 0)
        {
            if ((FlxG.keys.anyJustPressed([Reg.inputMap["a"]]) ||
                    (Reg.GAMEPAD != null && Reg.GAMEPAD.anyJustPressed([Reg.gamepadInputMap["a"]])))
                && isTouching(FlxObject.FLOOR))
            {
                velocity.y = _jumpForce;
            }
        }

        if ((velocity.y < 0) && (FlxG.keys.anyJustReleased([Reg.inputMap["a"]]) ||
            (Reg.GAMEPAD != null && Reg.GAMEPAD.anyJustReleased([Reg.gamepadInputMap["a"]]))))
        {
            velocity.y = velocity.y * 0.5;
        }

        if (FlxG.keys.anyPressed([Reg.inputMap["up"]]) || (Reg.GAMEPAD != null && Reg.GAMEPAD.anyPressed([Reg.gamepadInputMap["up"]])))
            lookingUp = true;
        else
            lookingUp = false;
    }

    private function animate()
    {
        if (!alive)
        {
            // Logic to only play the death animation once since animation.add()'s logic
            // for that doesn't work apparently
            if (animation.name == "death" && animation.finished)
                animation.stop();
            else
                animation.play("death");
        }
        else if (incapacitated)
            animation.play("hurt");
        else if ((velocity.y <= 0) && (!isTouching(FlxObject.FLOOR)))
            animation.play("jump");
        else if (velocity.y > 0)
            animation.play("fall");
        else if (velocity.x == 0)
            animation.play("idle");
        else
            animation.play("walk");
    }
}
