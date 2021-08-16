import java.awt.Rectangle;

class TextLine extends Rectangle {
  String image,id,text;
  int imageWidth,imageHeight;
  
  TextLine(TableRow row) {
    this.image = row.getString("image");
    this.imageWidth = row.getInt("imageWidth");
    this.imageHeight = row.getInt("imageHeight");
    this.id = row.getString("id");
    this.text = row.getString("text");
    this.x = row.getInt("x");
    this.y = row.getInt("y");
    this.width = row.getInt("width");
    this.height = row.getInt("height");
  }
}
