package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;

import states.PlatformState;

class LogoState extends FlxState
{
    private var logo:FlxSprite;

    override public function create():Void
    {
        Reg.STATE = cast this;

        // Set the background color to the lightest of our pallette
        FlxG.cameras.bgColor = new FlxColor(0xffd3e29a);

        super.create();

        logo = new FlxSprite(0, -16);
        logo.loadGraphic(AssetPaths.logo_scroll__png, true, 160, 16);
        add(logo);

        // TODO have first tween play game boys startup sound on complete
        FlxTween.tween(logo, {y: (160 / 2) - 16}, 4.0)
            .wait(2.0)
            .then(FlxTween.tween(logo, {y: (160 / 2) - 16}, 0.05, {onComplete: startGame}));
    }

    override public update(elapsed:Float):Void
    {
        // TODO add logic to skip this intro

        super.update(elapsed);
    }

    private function startGame(_)
    {
        FlxG.switchState(new PlatformState());
    }
}
