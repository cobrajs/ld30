class LevelManager {
  public static function nextLevel(currentLevel:String):String {
    if (currentLevel == "") {
      return "world1";
    } else if (currentLevel == "world1") {
      return "world2";
    } else if (currentLevel == "world2") {
      return "world3";
    } else if (currentLevel == "world3") {
      return "world4";
    } else if (currentLevel == "world4") {
      return "world5";
    } else if (currentLevel == "world5") {
      return "";
    }
    return "";
  }
}
