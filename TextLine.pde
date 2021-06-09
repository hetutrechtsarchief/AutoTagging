import java.awt.Rectangle;

class TextLine extends Rectangle {
  String image,id,text;
  
  TextLine(TableRow row) {
    this.image = row.getString("image");
    this.id = row.getString("id");
    this.text = row.getString("text");
    this.x = row.getInt("x");
    this.y = row.getInt("y");
    this.width = row.getInt("width");
    this.height = row.getInt("height");
  }
}
