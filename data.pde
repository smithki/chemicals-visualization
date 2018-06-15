// "P3_Human_Body"
// ATLS 3519: Code
// Ian Smith - 11/30/2016


class Data {

  /* ========================== */
  // Class variables
  
  Table table; // table of data
  ArrayList<Visualizer> chems; // array of data entries


  /* ========================== */
  // Constructor
  
  Data(String source, String options) {
    table = loadTable(source, options); // load dataset
    chems = new ArrayList<Visualizer>(); // init array of entries

    for (int r = 0; r < table.getRowCount(); r++) {
      TableRow row = table.getRow(r); // get the current row...

      // ...and extract some information
      String element = row.getString("Element"); // element name
      String symbol = row.getString("Symbol"); // symbol classification
      float percent = row.getFloat("Percentage in Body") / 100; // percentage (the data we are visualizing)
      String rgbSource = row.getString("RGB"); // the color we will display for this entry
      int[] rgb = int(split(rgbSource, "/")); // seperate R/G/B values and parse them as integers

      chems.add(new Visualizer(element, symbol, percent, color(rgb[0], rgb[1], rgb[2]))); // visualize the current entry
      accumulation += percent; // move the "floor" up (stack the data vis)
    }
  }


  /* ========================== */
  // Run the data visualization
  // this function is run in the main draw() loop
  
  void run() {
    for (int i = 0; i < chems.size(); i++) {
      Visualizer part = chems.get(i); // get the current data entry...
      part.display(); // ...and display it
    }
  }
}