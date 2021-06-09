import java.awt.Rectangle;
import java.util.Map;
ArrayList<Area> areas = new ArrayList();
ArrayList<TextLine> textlines = new ArrayList();
HashMap<String, Record> records = new HashMap();

void setup() {
  Table table = loadTable("data/tags.csv", "header");
  for (TableRow row : table.rows()) {
    areas.add(new Area(row));
  }

  table = loadTable("data/private/all-textlines-transkribus.csv", "header");
  for (TableRow row : table.rows()) {
    textlines.add(new TextLine(row));
  }

  for (TextLine t : textlines) {
    Area a = (Area)getRectangleWithMostOverlap(areas, t);
    if (a!=null) {
      records.putIfAbsent(t.image, new Record());
      Record r = records.get(t.image);
      r.image = t.image; //store image filename in record
      String text = t.text.replaceAll(a.remove, ""); //strip 'remove' words by regexp. See tags.csv
      if (r.containsKey(a.label)) {
        r.merge(a.label, " "+text, String::concat);
      } else {
        r.put(a.label, text);
      }
    } else {
      println("skip: "+t.text, t.x, t.y, t.width, t.height, t.image);
    }
  }

  table = new Table();
  table.addColumn("image");
  for (Area a : areas) {
    table.addColumn(a.label);
  }

  for (Record record : records.values()) {
    TableRow row = table.addRow();
    row.setString("image", record.image);
    for (Map.Entry field : record.entrySet()) {
      String k = (String)field.getKey(); 
      String v = (String)field.getValue();
      row.setString(k,v);
    }
  }

  saveTable(table, "data/private/table.csv");

  exit();
}

void draw() {
}

Area getRectangleWithMostOverlap(ArrayList<Area> areas, TextLine t) {
  Area result = null;
  float maxOverlap = 0;
  for (Area a : areas) {
    if (a.intersects(t)) {
      Rectangle i = a.intersection(t);
      float overlap = float(i.width*i.height)/(t.width*t.height);
      if (overlap>maxOverlap) {
        result = a;
        maxOverlap = overlap;
      }
    }
  }
  return result;
}
