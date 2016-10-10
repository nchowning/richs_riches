package enemies;

import flixel.group.FlxGroup;
import flixel.util.FlxTimer;

import objects.Player;

class Miner extends Enemy
{
    private var hammers:FlxTypedGroup<Hammer>;

    private var hammerTimer:FlxTimer;
    // Amount of time between hammer throw intervals
    private var timeBetweenThrows:Float = 2.0;

    // A throw interval can contain multiple hammers
    private var hammerCount:Int = 2;
    private var timeBetweenHammers:Float = 0.5;

    public function new(x:Float, y:Float)
    {
        super(x + 5, y + 1);

        health = 1.0;

        loadGraphic("assets/images/enemies/miner.png", true, 16, 16);
        animation.add("idle", [0]);
        animation.add("throw", [1, 2], 7, false);
        animation.add("death", [3, 4, 5], 7, false);
        animation.play("idle");

        setSize(6, 15);
        offset.set(5, 1);

        hammers = new FlxTypedGroup<Hammer>();

        // Add hammers to the group
        for (i in 0...hammerCount)
            hammers.add(new Hammer(x, y));

        Reg.STATE.explosionFragments.add(hammers);

        hammerTimer = new FlxTimer().start(timeBetweenThrows, function(_)
        {
            // Switch to the throwing animation
            animation.play("throw");

            // Wait for the animation to run & then throw the hammer
            new FlxTimer().start(0.2, function(_)
            {
                if (flipX)
                    hammers.members[0].spawn(x, y + 5, -75, -100);
                else
                    hammers.members[0].spawn(x, y + 5, 75, -100);
            }, 1);

            // Switch back to the idle animation
            new FlxTimer().start(0.5, function(_)
            {
                if (alive)
                    animation.play("idle");
            }, 1);
            
        }, 0);
    }

    override public function update(elapsed:Float):Void
    {
        // Always face the player
        if (alive)
        {
            if (Reg.STATE.player.x < x)
                flipX = true;
            else
                flipX = false;
        }

        if (!Reg.PAUSE)
            super.update(elapsed);
    }

    override public function kill()
    {
        super.kill();

        hammerTimer.cancel();
    }
}