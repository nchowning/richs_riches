package enemies;

import flixel.FlxObject;

import objects.Player;

class Projectile extends Enemy
{
    public function new(x:Float, y:Float)
    {
        super(x, y);

        maxVelocity.x = 500;
        maxVelocity.y = 500;

        // Fragments shouldn't be visible or alive until spawn() is called
        visible = false;
        alive = false;
    }

    override public function kill()
    {
        alive = false;
        visible = false;

        velocity.x = 0;
        velocity.y = 0;
    }

    override public function update(elapsed:Float):Void
    {
        if (alive)
            super.update(elapsed);
    }

    override public function interact(player:Player):Void
    {
        // If this enemy is already dead, it doesn't matter
        if (!alive)
            return;

        player.hurt(1.0);
    }

    public function spawn(x:Float, y:Float, forceX:Int, forceY:Int):Void
    {
        this.x = x;
        this.y = y;

        alive = true;
        visible = true;

        velocity.x = forceX;
        velocity.y = forceY;
    }
}