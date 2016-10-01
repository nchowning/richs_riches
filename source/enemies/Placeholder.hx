package enemies;

class Placeholder extends Enemy
{
    public function new(x:Float, y:Float)
    {
        super(x, y);

        loadGraphic(AssetPaths.placeholder__png, true, 8, 8);
        animation.add("idle", [0]);
        animation.play("idle");

        setSize(6, 7);
        offset.set(1, 1);
    }
}
