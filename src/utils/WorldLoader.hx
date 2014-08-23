package utils;

import com.haxepunk.graphics.Text;
import com.haxepunk.Scene;
import com.haxepunk.HXP;

import entities.*;

import tjson.TJSON;

import openfl.Assets;

class WorldLoader {
  // World types
  public static inline var MIRRORED:String = "mirrored";


  public static function loadWorld(worldName:String, scene:Scene, lightWorld:World, darkWorld:World) {
    var raw = Assets.getText("levels/" + worldName + ".json");
    var level = TJSON.parse(raw);
    var levelName = new Text(level.name, 10, 10, 0, 0);
    scene.addGraphic(levelName, 0);

    if (level.type == MIRRORED) {
      // Add player
      var start = level.playerStart;
      lightWorld.addChild(new Player(start.x, start.y));
      darkWorld.addChild(new Player(start.x, start.y));

      // Add objects
      var objects = cast(level.objects, Array<Dynamic>);
      for (object in objects) {
        var classType = Type.resolveClass("entities." + object.classType);
        if (classType != null) {
          HXP.log(object.classType);
          var x = normalize(object.position.x, lightWorld.width);
          var y = normalize(object.position.y, lightWorld.height);
          var width = Std.int(normalize(object.size.width, lightWorld.width));
          var height = Std.int(normalize(object.size.height, lightWorld.height));

          HXP.log(x, y, width, height);

          var lightObject:WorldDweller = Type.createInstance(classType, [x, y]);
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
