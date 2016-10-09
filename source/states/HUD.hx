package states;

import flixel.FlxCamera;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;

class HUD extends FlxSpriteGroup
{
    private var textMoney:FlxText;
    private var iconHealth:FlxSprite;

    static var OFFSET:Int = 4;

    public function new()
    {
        super();

        textMoney = new FlxText(OFFSET, OFFSET, 0);

        iconHealth = new FlxSprite(OFFSET, OFFSET);
        iconHealth.loadGraphic("assets/images/HUD_health.png", true, 40, 8);
        for (i in 0...5)
        {
            iconHealth.animation.add(Std.string(i), [i]);
        }
        iconHealth.animation.play("4");

        add(iconHealth);

        forEach(function(member)
        {
            member.scrollFactor.set(0, 0);
        });
    }

    override public function update(elapsed:Float)
    {
        if (Reg.STATE.player.health < 0)
            Reg.STATE.player.health = 0;
        else if (Reg.STATE.player.health > 4)
            Reg.STATE.player.health = 4;

        iconHealth.animation.play(Std.string(Std.int(Reg.STATE.player.health)));
        super.update(elapsed);
    }
}