package enemies;

import flixel.FlxObject;

import objects.Player;

class JewelFragment extends Enemy
{
    public function new(x:Float, y:Float)
    {
        super(x, y);

        maxVelocity.x = 500;
        maxVelocity.y = 500;

        loadGraphic("assets/images/enemies/jewelfragment.png", true, 8, 8);
        animation.add("idle", [0]);
        animation.play("idle");

        setSize(6, 6);
        offset.set(1, 1);

        // Fragments shouldn't be visible or alive until spawn() is called
        visible = false;
        alive = false;
    }

    override public function update(elapsed:Float):Void
    {
        if (velocity.y < 0)
            solid = false;
        else
            solid = true;
        if (alive)
            super.update(elapsed);
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