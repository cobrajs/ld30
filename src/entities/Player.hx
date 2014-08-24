package entities;

import utils.MessageBus;

import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.graphics.Animation;
import com.haxepunk.utils.Key;
import com.haxepunk.utils.Input;

class Player extends WorldDweller {
  public static inline var MOVE_ACCELERATION_GROUND:Float = 0.5;
  public static inline var MOVE_ACCELERATION_AIR:Float = 0.05;

  private var spriteMap:Spritemap;

  public function new(x:Float, y:Float, messageBus:MessageBus, ?light:Bool = true) {
    super(x, y, messageBus);

    width = 32;
    height = 64;

    grounded = false;

    spriteMap = new Spritemap("graphics/player.png", 64, 64);
    setHitbox(32, 64, -16);

    //originX = -16;

    type = "player";
  }

  public override function update() {
    if (_world.receiveEvents) {
      if (Input.check("left") || Input.check("right")) {
        if (Input.check("left")) {
          acceleration.x += -(grounded ? MOVE_ACCELERATION_GROUND : MOVE_ACCELERATION_AIR);
        } else {
          acceleration.x += (grounded ? MOVE_ACCELERATION_GROUND : MOVE_ACCELERATION_AIR);
        }
      } else {
        applyDrag();
      }
      if (Input.pressed("jump") && grounded) {
        acceleration.y = -8;
        grounded = false;
      }
    } else {
      applyDrag();
    }

    if (Math.abs(acceleration.x) > 0) {
      if (grounded) {
        spriteMap.play("walk");
      } else {
        spriteMap.play("air");
      }
      spriteMap.flipped = acceleration.x < 0;
    } else {
      spriteMap.play("stand");
    }

    spriteMap.update();

    super.update();
  }

  public override function setupGraphics(color:Int, inverseColor:Int) {
    if (color == World.LIGHT) {
      spriteMap.add("stand", [0]);
      spriteMap.add("walk", [1, 2], 4);
      spriteMap.add("air", [2]);
    } else {
      spriteMap.add("stand", [4]);
      spriteMap.add("walk", [5, 6], 4);
      spriteMap.add("air", [6]);
    }

    spriteMap.play("walk");

    graphic = spriteMap;
  }

  public override function die() {
    messageBus.addMessage(MessageBus.DEATH, _world.color);
  }
}

