package utils;

import entities.Player;
import entities.NonMoveable;
import entities.NonMoveBlock;
import entities.MoveBlock;
import entities.EndState;
import entities.WorldDweller;
import utils.MessageBus;

import com.haxepunk.graphics.Text;
import com.haxepunk.Scene;
import com.haxepunk.HXP;

import tjson.TJSON;

import openfl.Assets;

class WorldLoader {
  public static inline var MIRRORED:String = "mirrored";
  public static inline var SEPARATE:String = "separate";


  public static function loadWorld(worldName:String, scene:Scene, lightWorld:World, darkWorld:World, messageBus:MessageBus):LevelData {
    var raw = Assets.getText("levels/" + worldName + ".json");
    var level = TJSON.parse(raw);
    var levelName = new Text(level.name + ":", 10, 10, 0, 0, {color: 0x222222, size: 36});
    scene.addGraphic(levelName, 0);

    var helpText = new Text(level.helpText, levelName.width + 20, 10, 0, 0, {color: 0x222222, size: 36});
    scene.addGraphic(helpText, 0);

    var levelData:LevelData = {
      name : level.name,
      type : level.type,
      control : level.control,
      helpText : level.helpText
    };

    if (level.type == MIRRORED) {
      // Add player
      var start = level.playerStart;
      lightWorld.addChild(new Player(start.x, start.y, messageBus, true));
      darkWorld.addChild(new Player(start.x, start.y, messageBus, false));

      // Add objects
      var objects = cast(level.objects, Array<Dynamic>);
      addObjects(objects, lightWorld, darkWorld);
    } else if (level.type == SEPARATE) {
      // Add player
      var lightStart = level.light.playerStart;
      var darkStart = level.dark.playerStart;
      lightWorld.addChild(new Player(lightStart.x, lightStart.y, messageBus, true));
      darkWorld.addChild(new Player(darkStart.x, darkStart.y, messageBus, false));

      // Add objects
      var lightObjects = cast(level.light.objects, Array<Dynamic>);
      addObjects(lightObjects, lightWorld, null);
      var darkObjects = cast(level.dark.objects, Array<Dynamic>);
      addObjects(darkObjects, null, darkWorld);
    }
    return levelData;
  }

  public static funtion addObjects(objects:Array<Dynamic>, ?lightWorld:World, ?darkWorld:World) {
    var width = lightWorld != null ? lightWorld.width : darkWorld.width;
    var height = lightWorld != null ? lightWorld.height : darkWorld.height;
    for (object in objects) {
      var classType = Type.resolveClass("entities." + object.classType);
      if (classType != null) {
        var x = normalize(object.position.x, width);
        var y = normalize(object.position.y, height);
        var width = object.size != null? 
          Std.int(normalize(object.size.width, width) + 1) : 0;
        var height = object.size != null? 
          Std.int(normalize(object.size.height, height) + 1) : 0;

        if (lightWorld != null) {
          var lightObject:WorldDweller = Type.createInstance(classType, [x, y, messageBus]);
          if (width != 0 && height != 0) {
            lightObject.width = width;
            lightObject.height = height;
          }
          lightWorld.addChild(lightObject);
        }

        if (darkWorld != null) {
          var darkObject:WorldDweller = Type.createInstance(classType, [x, y, messageBus]);
          if (width != 0 && height != 0) {
            darkObject.width = width;
            darkObject.height = height;
          }
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

typedef LevelData = {
  var name:String;
  var type:String;
  var control:String;
  var helpText:String;
};
