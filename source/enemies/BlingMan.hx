package enemies;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.group.FlxGroup;
import flixel.util.FlxTimer;
import flixel.util.FlxSpriteUtil;

import objects.Player;
import states.PlatformState;

class BlingMan extends Enemy
{
    private var _runSpeed = 100;
    private var running:Bool = false;
    private var runningTime:Float = 5.0;

    private var invulnerable:Bool = false;
    private var invulnerableTime:Float = 2.0;

    private var incapacitated:Bool = false;
    private var incapacitatedTime:Float = 1.0;

    private var hammers:FlxTypedGroup<Hammer> = new FlxTypedGroup<Hammer>();
    private var hammerTimer:FlxTimer = new FlxTimer();

    public function new(x:Float, y:Float)
    {
        super(x, y);

        health = 5.0;
        _walkSpeed = 50;
        _jumpForce = -175;

        loadGraphic("assets/images/enemies/blingman.png", true, 16, 32);
        animation.add("idle", [0]);
        animation.add("walk", [0, 1, 2, 3], 7);
        animation.add("run", [5, 6, 7, 8], 10);
        animation.add("jump", [1]);
        animation.add("fall", [4]);
        animation.add("hurt", [5]);
        animation.add("death", [1]);
        animation.play("idle");

        flipX = true;

        setSize(14, 17);
        offset.set(1, 15);

        hammers.add(new Hammer(x, y));

        Reg.STATE.explosionFragments.add(hammers);

        hammerTimer.start(1.5, function(_)
        {
            if (flipX)
                hammers.members[0].spawn(this.x, this.y, -125, -100);
            else
                hammers.members[0].spawn(this.x, this.y, 125, -100);
        }, 0);
    }

    override public function update(elapsed:Float):Void
    {
        animate();

        if (!Reg.PAUSE && !incapacitated)
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
            Reg.LEVEL = "theend";
            FlxG.switchState(new PlatformState());
            exists = false;
            visible = false;
        }, 1);
    }

    override private function move()
    {
        super.move();


        if (!running)
        {
            velocity.x = _walkSpeed * _direction;

            // Jump near the middle of the screen
            if ((getScreenPosition().x > (160 * 0.49) && getScreenPosition().x < (160 * 0.51)) &&
                    isTouching(FlxObject.FLOOR))
                velocity.y = _jumpForce;
        }
        else
        {
            velocity.x = _runSpeed * _direction;
        }

    }

    override public function hurt(damage:Float):Void
    {
        if (invulnerable)
            return;

        if (health < 0)
            health = 0;

        super.hurt(damage);

        if (health > 0.0)
        {
            invulnerable = true;
            FlxSpriteUtil.flicker(this, invulnerableTime);
            new FlxTimer().start(invulnerableTime, function(_)
            {
                invulnerable = false;
            }, 1);

            incapacitated = true;
            new FlxTimer().start(incapacitatedTime, function(_)
            {
                incapacitated = false;
            }, 1);

            running = true;
            hammerTimer.active = false;
            y += 3;
            setSize(14, 14);
            offset.set(1, 18);
            new FlxTimer().start(runningTime, function(_)
            {
                setSize(14, 17);
                offset.set(1, 15);
                running = false;
                hammerTimer.active = true;
            }, 1);
        }
    }

    override public function interact(player:Player):Void
    {
        // If this enemy is already dead, it doesn't matter
        if (!alive)
            return;

        FlxObject.separateY(this, player);

        if ((player.velocity.y > 0) && (isTouching(FlxObject.UP)))
        {
            canDamage = false;
            canDamageTimer.start(0.5, function(_)
            {
                canDamage = true;
            }, 1);
            player.bounce();

            if (!running)
            {
                hurt(1.0);
            }
        }
        else if (canDamage)
        {
            player.hurt(1.0);
        }
    }

    private function animate()
    {
        if (incapacitated)
            animation.play("hurt");
        else if (velocity.y <= 0 && !isTouching(FlxObject.FLOOR))
            animation.play("jump");
        else if (velocity.y > 0)
            animation.play("fall");
        else if (running)
            animation.play("run");
        else if (velocity.x != 0)
            animation.play("walk");
    }
}