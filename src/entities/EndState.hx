package entities;

import utils.MessageBus;

import com.haxepunk.HXP;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Spritemap;

class EndState extends NonMoveable {

  private var spriteMap:Spritemap;
  private var playerIn:Bool;

  public function new(x:Float, y:Float, messageBus:MessageBus) {
    super(x, y, messageBus);

    playerIn = false;

    spriteMap = new Spritemap("graphics/endgate.png", 64, 64, function() {
      if (playerIn) {
        messageBus.addMessage(MessageBus.WIN_STATE, light);
      } else {
        messageBus.addMessage(MessageBus.NON_WIN_STATE, light);
      }
    });

    width = Std.int(spriteMap.width / 2);
    height = Std.int(spriteMap.height);

    originX = -16;
    originY = 0;

    baseTypename = "endstate";
    type = getTypename();
  }

  public override function setupGraphics(color:Int, inverseColor:Int) {
    if (color == World.LIGHT) {
      spriteMap.add("stand", [0]);
      spriteMap.add("close", [0, 1, 2, 3], 24, false);
      spriteMap.add("open", [3, 2, 1, 0], 24, false);
    } else {
      spriteMap.add("stand", [4]);
      spriteMap.add("close", [4, 5, 6, 7], 24, false);
      spriteMap.add("open", [7, 6, 5, 4], 24, false);
    }

    spriteMap.play("stand");

    graphic = spriteMap;
  }

  public override function update() {
    var playerCollide = collide(getTypename("player"), x, y) != null;
    if (!playerIn && playerCollide) {
      playerIn = true;
      spriteMap.play("close");
    } else if (playerIn && !playerCollide) {
      playerIn = false;
      spriteMap.play("open");
    }
  }
}
