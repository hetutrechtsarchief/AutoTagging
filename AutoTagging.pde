import java.awt.Rectangle;
import java.util.Map;
ArrayList<Area> areas = new ArrayList();
ArrayList<TextLine> textlines = new ArrayList();
ArrayList<String> imageNames = new ArrayList();
HashMap<String, Record> records = new HashMap();

boolean originRightBottom = true;

void setup() {
  Table table = loadTable("data/tags.csv", "header");
  for (TableRow row : table.rows()) {
    Area area = new Area(row);
    areas.add(area);
  }

  table = loadTable("data/private/all-textlines-abbyy.csv", "header");
  for (TableRow row : table.rows()) {
    textlines.add(new TextLine(row));
  }

  Record prevRecord = null;
  Record curRecord = null;

  for (TextLine t : textlines) {
  
    Area a = (Area)getRectangleWithMostOverlap(areas, t);
    if (a!=null) {

      if (!records.containsKey(t.image)) { //nieuwe record gevonden
        imageNames.add(t.image);
        prevRecord = curRecord;
      }

      records.putIfAbsent(t.image, new Record());
      curRecord = records.get(t.image);

      curRecord.image = t.image; //store image filename in 'current' record

      //kinderen en opmerkingen horen bij vorige scan. Zie tags.csv template
      Record r = null;
      if (a.recordOffset==-1 && prevRecord!=null) {
        r = prevRecord;
        //println("data hoort bij vorige record: ", r.image, t.text);
      } else {
        r = curRecord;
      }

      String text = t.text;
      text = t.text.replaceAll("\r", "");
      text = text.replaceAll("\n", "");

      text = text.replaceAll(a.remove, ""); //strip 'remove' words by regexp. See tags.csv

      if (a.remove.equals("Gewijzigd in:")) {
        //println("xxxx", text);
      }

      if (r.containsKey(a.label)) {
        r.merge(a.label, " "+text, String::concat);
      } else {
        r.put(a.label, text);
      }
    } else {
      //println("skip: "+t.text, t.x, t.y, t.width, t.height, t.image);
    }
  }

  table = new Table();
  table.addColumn("image");
  for (Area a : areas) {
    table.addColumn(a.label);
  }

  //for (Record record : records.values()) {
  for (String imageName : imageNames) { //this way records stay sorted
    Record record = records.get(imageName);
    TableRow row = table.addRow();
    row.setString("image", record.image);
    for (Map.Entry field : record.entrySet()) {
      String k = (String)field.getKey();
      String v = (String)field.getValue();
      row.setString(k, v.trim());
    }
  }

  saveTable(table, "data/private/table-abbyy.csv");

  exit();
}

void draw() {
}

Area getRectangleWithMostOverlap(ArrayList<Area> areas, TextLine t) {
  int imgWidth = t.imageWidth;
  int imgHeight = t.imageHeight;
  
  Area result = null;
  float maxOverlap = 0;
  for (Area a : areas) {

    //if originRightBottom then offset the template according to size of both images
    Rectangle areaWithOffset = new Rectangle(a); //a.copy();
    if (originRightBottom) {
      areaWithOffset.x += (imgWidth-a.tplWidth);
      areaWithOffset.y += (imgHeight-a.tplHeight);
    }
    
    if (areaWithOffset.intersects(t)) {
      Rectangle i = areaWithOffset.intersection(t);
      float overlap = float(i.width*i.height)/(t.width*t.height);
      if (overlap>maxOverlap) {
        result = a;
        maxOverlap = overlap;
      }
    }
  }
  return result;
}
