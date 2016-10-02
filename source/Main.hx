package;

import flixel.FlxGame;
import flixel.util.FlxColor;
import openfl.Lib;
import openfl.display.Sprite;

import states.LogoState;

class Main extends Sprite
{
	public function new()
	{
		super();
		addChild(new FlxGame(160, 144, LogoState, true));
	}
}
