import java.awt.Rectangle;

class Area extends Rectangle {
  String label,remove;
  int recordOffset;
  int tplWidth, tplHeight;
  
  Area() {
  }
  
  Area(TableRow row) {
    this.x = row.getInt("x");
    this.y = row.getInt("y");
    this.width = row.getInt("width");
    this.height = row.getInt("height");
    this.label = row.getString("label");
    this.remove = row.getString("remove");
    this.recordOffset = row.getInt("recordOffset");
    this.tplWidth = row.getInt("tplWidth");
    this.tplHeight = row.getInt("tplHeight");
  }
}
