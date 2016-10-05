package enemies;

import flixel.FlxObject;
import flixel.FlxSprite;

class Enemy extends FlxSprite
{
    private static var _gravity:Int = 600;
    private static var _jumpForce:Int = -175;
    private static var _walkSpeed:Int = 55;
    private static var _fallingSpeed:Int = 300;
    private var _direction:Int = -1;

    public function new(x:Float, y:Float)
    {
        super(x, y);

        acceleration.y = _gravity;
        maxVelocity.y = _fallingSpeed;
    }

    override public function update(elapsed:Float)
    {
        if (isOnScreen() && alive)
        {
            move();

            if (justTouched(FlxObject.WALL))
            {

                _direction *= -1;
                flipX = !flipX;
            }
        }

        if (!Reg.PAUSE)
            super.update(elapsed);
    }

    private function move() {}
}
