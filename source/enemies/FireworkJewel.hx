package enemies;

import flixel.group.FlxGroup;

import objects.Player;

class FireworkJewel extends Enemy
{
    private var fragments:FlxTypedGroup<JewelFragment>;

    public function new(x:Float, y:Float)
    {
        super(x, y);

        // We don't want anything to interfere with the trajectory
        immovable = true;

        maxVelocity.y = 500;
        _jumpForce = -375;

        loadGraphic("assets/images/enemies/fireworkjewel.png", true, 16, 16);
        animation.add("idle", [0]);
        animation.play("idle");

        setSize(12, 12);
        offset.set(2, 2);

        velocity.y = _jumpForce;

        fragments = new FlxTypedGroup<JewelFragment>();

        // Add 4 JewelFragments to the group
        for (i in 0...4)
            fragments.add(new JewelFragment(x, y));

        Reg.STATE.explosionFragments.add(fragments);
    }

    override public function update(elapsed:Float):Void
    {
        if (velocity.y > 50)
        {
            explode();
            kill();
        }

        if (alive)
            super.update(elapsed);
    }

    override public function kill()
    {
        alive = false;

        velocity.y = 0;
        visible = false;
    }

    override public function interact(player:Player)
    {
        if (!alive)
            return;

        player.hurt(1.0);
    }

    public function spawn(x:Float, y:Float):Void
    {
        alive = true;
        visible = true;

        this.x = x;
        this.y = y;

        velocity.y = _jumpForce;
    }

    private function explode():Void
    {
        fragments.members[0].spawn(x + 8, y, 75, -25);
        fragments.members[1].spawn(x + 8, y + 8, 60, 0);
        fragments.members[2].spawn(x, y, -75, -25);
        fragments.members[3].spawn(x, y + 8, -60, 0);
    }
}