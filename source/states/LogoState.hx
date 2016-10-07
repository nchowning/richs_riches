package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.system.FlxSound;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

import states.PlatformState;

class LogoState extends FlxState
{
    private var logo:FlxSprite;
    private var startupSound:FlxSound;
    private var scrollTween:FlxTween;

    override public function create():Void
    {
        Reg.STATE = cast this;
        Reg.GAMEPAD = FlxG.gamepads.lastActive;

        // Set the background color to the lightest of our pallette
        FlxG.cameras.bgColor = new FlxColor(0xffd3e29a);

        super.create();

        logo = new FlxSprite(0, -16);
        logo.loadGraphic(AssetPaths.logo_scroll__png, true, 160, 16);
        add(logo);

        startupSound = FlxG.sound.load(AssetPaths.gameboy_start_up__ogg);

        scrollTween = FlxTween.tween(logo, {y: (160 / 2) - 16}, 3.0,
                                     {onComplete: playStartupSound})
                      .wait(1.5)
                      .then(FlxTween.tween(logo, {y: (160 / 2) - 16}, 0.05,
                                           {onComplete: startGame}));
    }

    override public function update(elapsed:Float):Void
    {
        // Skip the intro
        if (FlxG.keys.anyPressed([Reg.inputMap["start"]]) ||
            // TODO figure out why this doesn't work
            (Reg.GAMEPAD != null && Reg.GAMEPAD.anyPressed([Reg.gamepadInputMap["start"]])))
        {
            FlxTween.manager.clear();
            FlxG.switchState(new PlatformState());
        }

        super.update(elapsed);
    }

    private function playStartupSound(_)
    {
        startupSound.play(false, 75.0);
    }

    private function startGame(_)
    {
        FlxG.switchState(new PlatformState());
    }
}
