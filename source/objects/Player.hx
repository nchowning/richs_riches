package objects;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;

class Player extends FlxSprite
{
    private static var _acceleration:Int = 300;
    private static var _drag:Int = 300;
    private static var _gravity:Int = 600;
    private static var _jumpForce:Int = -175;
    private static var _walkSpeed:Int = 55;
    private static var _fallingSpeed:Int = 300;

    public function new()
    {
        super();

        loadGraphic(AssetPaths.normal__png, true, 16, 16);

        animation.add("idle", [0]);
        animation.add("walk", [0, 1, 2, 3], 7);
        animation.add("jump", [1]);
        animation.add("fall", [1]);

        setSize(6, 15);
        offset.set(5, 1);

        drag.x = _drag;
        acceleration.y = _gravity;
        maxVelocity.set(_walkSpeed, _fallingSpeed);
    }

    override public function update(elapsed:Float):Void
    {
        if (!Reg.PAUSE)
            move();
        animate();

        super.update(elapsed);

        // Basic over-all map collision
        if (x < 0)
            x = 0;
    }

    private function move()
    {
        acceleration.x = 0;

        if (FlxG.keys.pressed.LEFT)
        {
            flipX = true;
            acceleration.x -= _acceleration;
        }
        else if (FlxG.keys.pressed.RIGHT)
        {
            flipX = false;
            acceleration.x += _acceleration;
        }

        if (velocity.y == 0)
        {
            if (FlxG.keys.justPressed.SPACE && isTouching(FlxObject.FLOOR))
                velocity.y = _jumpForce;
        }

        if ((velocity.y < 0) && (FlxG.keys.justReleased.SPACE))
            velocity.y = velocity.y * 0.5;

    }

    private function animate()
    {
        if ((velocity.y <= 0) && (!isTouching(FlxObject.FLOOR)))
            animation.play("jump");
        else if (velocity.y > 0)
            animation.play("fall");
        else if (velocity.x == 0)
            animation.play("idle");
        else
            animation.play("walk");
    }
}