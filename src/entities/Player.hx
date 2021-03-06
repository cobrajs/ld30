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
  public static inline var JUMP_SPEED:Float = 5;

  private var spriteMap:Spritemap;

  public function new(x:Float, y:Float, messageBus:MessageBus, ?light:Bool = true) {
    super(x, y, messageBus);

    width = 32;
    height = 64;

    grounded = false;

    spriteMap = new Spritemap("graphics/player.png", 64, 64);
    setHitbox(32, 64, -16);

    baseTypename = "player";

    type = getTypename();
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
        acceleration.y = -JUMP_SPEED;
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

  public override function moveCollideX(e:Entity):Bool {
    if (e.type == getTypename("moveblock")) {
      e.moveBy(oldAcceleration.x, 0);
    }
    return true;
  }

  public override function setupGraphics(color:Int, inverseColor:Int) {
    if (color == World.LIGHT) {
      spriteMap.add("stand", [0]);
      spriteMap.add("walk", [1, 2], 4);
      spriteMap.add("air", [3]);
      spriteMap.add("win", [4]);
    } else {
      spriteMap.add("stand", [8]);
      spriteMap.add("walk", [9, 10], 4);
      spriteMap.add("air", [11]);
      spriteMap.add("win", [12]);
    }

    spriteMap.play("walk");

    graphic = spriteMap;
  }

  public override function die() {
    messageBus.addMessage(MessageBus.DEATH, _world.color == World.LIGHT);
  }
}

