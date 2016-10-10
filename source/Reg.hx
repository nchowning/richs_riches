package;

import flixel.FlxState;
import flixel.input.keyboard.FlxKey;
import flixel.input.gamepad.FlxGamepad;
import flixel.input.gamepad.FlxGamepadInputID;

import states.PlatformState;

class Reg
{
    public static var STATE:PlatformState;
    public static var LEVEL:String = "title";
    public static var PAUSE:Bool = false;

    public static var MONEY:Int = 0;

    public static var inputMap:Map<String, Int> = [
        "left"  => FlxKey.LEFT,
        "right" => FlxKey.RIGHT,
        "up"    => FlxKey.UP,
        "down"  => FlxKey.DOWN,
        "b"     => 0,
        "a"     => FlxKey.SPACE,
        "start" => FlxKey.ESCAPE,
    ];

    public static var GAMEPAD:FlxGamepad;
    public static var gamepadInputMap:Map<String, Int> = [
        "left"   => FlxGamepadInputID.DPAD_LEFT,
        "right"  => FlxGamepadInputID.DPAD_RIGHT,
        "up"     => FlxGamepadInputID.DPAD_UP,
        "down"   => FlxGamepadInputID.DPAD_DOWN,
        "b"      => FlxGamepadInputID.X,
        "a"      => FlxGamepadInputID.A,
        "start"  => FlxGamepadInputID.START,
        "select" => FlxGamepadInputID.BACK,
    ];
}
