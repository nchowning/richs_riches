package enemies;

import flixel.FlxObject;

import objects.Player;

class Hammer extends Projectile
{
    public function new(x:Float, y:Float)
    {
        super(x, y);

        loadGraphic("assets/images/enemies/hammer.png", true, 8, 8);
        animation.add("moving", [0, 1, 2, 3], 10);
        animation.play("moving");

        setSize(6, 6);
        offset.set(1, 1);
    }

    override public function update(elapsed:Float):Void
    {
        if (alive && !isOnScreen())
            kill();

        super.update(elapsed);
    }
}