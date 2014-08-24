package utils;

import entities.Player;
import entities.NonMoveable;
import entities.EndState;
import entities.WorldDweller;
import utils.MessageBus;

import com.haxepunk.graphics.Text;
import com.haxepunk.Scene;
import com.haxepunk.HXP;

import tjson.TJSON;

import openfl.Assets;

class WorldLoader {
  // World types
  public static inline var MIRRORED:String = "mirrored";


  public static function loadWorld(worldName:String, scene:Scene, lightWorld:World, darkWorld:World, messageBus:MessageBus) {
    var raw = Assets.getText("levels/" + worldName + ".json");
    var level = TJSON.parse(raw);
    var levelName = new Text(level.name, 10, 10, 0, 0);
    scene.addGraphic(levelName, 0);

    if (level.type == MIRRORED) {
      // Add player
      var start = level.playerStart;
      lightWorld.addChild(new Player(start.x, start.y, messageBus, true));
      darkWorld.addChild(new Player(start.x, start.y, messageBus, false));

      // Add objects
      var objects = cast(level.objects, Array<Dynamic>);
      for (object in objects) {
        var classType = Type.resolveClass("entities." + object.classType);
        if (classType != null) {
          var x = normalize(object.position.x, lightWorld.width);
          var y = normalize(object.position.y, lightWorld.height);
          var width = Std.int(normalize(object.size.width, lightWorld.width) + 1);
          var height = Std.int(normalize(object.size.height, lightWorld.height) + 1);

          var lightObject:WorldDweller = Type.createInstance(classType, [x, y, messageBus]);
          lightObject.width = width;
          lightObject.height = height;
          lightWorld.addChild(lightObject);

          var darkObject:WorldDweller = Type.createInstance(classType, [x, y]);
          darkObject.width = width;
          darkObject.height = height;
          darkWorld.addChild(darkObject);
        }
      }
    }
  }

  public static function normalize(number:Float, larger:Float):Float {
    if (Math.abs(number) <= 1) {
      number *= larger;
    }
    if (number < 0) {
      number = larger + number;
    }
    return number;
  }
}
