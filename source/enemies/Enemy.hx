package enemies;

import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxTimer;

import objects.Player;

class Enemy extends FlxSprite
{
    private var _gravity:Int = 600;
    private var _jumpForce:Int = -175;
    private var _walkSpeed:Int = 55;
    private var _fallingSpeed:Int = 300;
    private var _direction:Int = -1;

    private var canDamage:Bool = true;
    private var canDamageTimer:FlxTimer = new FlxTimer();

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
        }

        if (!Reg.PAUSE)
            super.update(elapsed);
    }

    override public function kill()
    {
        alive = false;

        velocity.x = 0;
        acceleration.x = 0;
        animation.play("death");

        new FlxTimer().start(1.0, function(_)
        {
            exists = false;
            visible = false;
        }, 1);
    }

    private function move()
    {
        if (justTouched(FlxObject.WALL))
        {

            _direction *= -1;
            flipX = !flipX;
        }
    }

    public function interact(player:Player)
    {
        // If this enemy is already dead, it doesn't matter
        if (!alive)
            return;

        FlxObject.separateY(this, player);

        if ((player.velocity.y > 0) && (isTouching(FlxObject.UP)))
        {
            canDamage = false;
            hurt(1.0);
            player.bounce();
            canDamageTimer.cancel();
            canDamageTimer.start(0.5, function(_)
            {
                canDamage = true;
            }, 1);

        }
        else if (canDamage)
        {
            player.hurt(1.0);
        }
    }
}