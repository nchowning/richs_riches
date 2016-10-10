package enemies;

import flixel.FlxObject;

import objects.Player;

class JewelFragment extends Projectile
{
    public function new(x:Float, y:Float)
    {
        super(x, y);

        loadGraphic("assets/images/enemies/jewelfragment.png", true, 8, 8);
        animation.add("moving", [0]);
        animation.play("moving");

        setSize(6, 6);
        offset.set(1, 1);
    }
}