/**
 * Graphs class manages the interactive graph screen within the user interface (UI).
 * 
 * This class provides functionalities for displaying graphs and allows users to control
 * the displayed data through dropdown menus.
 *
 * Abdul/Brian 
 */
class Graphs extends Screens {
  DropDownMenu dropdown1, dropdown2, dropdown3;
  PApplet applet;
  // Constructor: Sets up the graph screen with dropdown menus.
  Graphs(PApplet applet, color backgroundColor, String screenText) {
    super(backgroundColor, screenText);
    this.applet = applet;
    String[] options = {""};
    dropdown1 = new DropDownMenu(applet, 100, 160, 800/4, 30, options );
    dropdown2 = new DropDownMenu(applet, 100+ 800/4, 160, 800/4, 30, options);
    dropdown3 = new DropDownMenu(applet, 100+ 2*800/4, 160, 800/4, 30, options);
  }
  /**
   * This function asynchronously loads flight data from flights_full CSV file, processes it, and populates dropdowns.
   *
   * Uses CompletableFuture for asynchronous data loading and processing. - Brian
   */

  void graphSetup() {

    CompletableFuture<Table> tableFuture = CompletableFuture.supplyAsync(() ->
      loadTable("flights_full.csv", "header"));

    tableFuture.thenAccept(table -> {
      println("Table loaded successfully.");
      ArrayList<String[]> arrayListData = new ArrayList<>();
      for (TableRow tableRow : table.rows()) {
        String date = tableRow.getString("FL_DATE");
        String origin = tableRow.getString("ORIGIN_STATE_ABR");
        String airportOrigin = tableRow.getString("ORIGIN");
        String dest = tableRow.getString("DEST_STATE_ABR");
        String destAirport = tableRow.getString("DEST");
        float distance = tableRow.getFloat("DISTANCE");
        String cancel = str(tableRow.getInt("CANCELLED"));
        String diverted = str(tableRow.getInt("DIVERTED"));
        String airlines = tableRow.getString("MKT_CARRIER");
        String[] arrayData = {date, origin, airportOrigin, dest, destAirport, String.valueOf(distance), cancel, airlines, diverted};
        arrayListData.add(arrayData);
      }

      data = new DataPoint(arrayListData);
      dataLoaded = true;
      println("Data processing finished.");
      dataLoadFuture.complete(data); // Signal that data loading is complete
    }
    );
    dataLoadFuture.thenAcceptAsync(dataPoint -> {
      String[] stringArray = dataPoint.airportOrigin().toArray(new String[0]);
      dropdown1.setOptions(dataPoint.selectData);
      dropdown2.setOptions(stringArray);
      dropdown3.setOptions(stringArray);
    }
    );
  }

/**
 * Handles UI drawing and interaction for the graph screen.
 *
 * This code snippet:
 *  - Draws the background and a "Submit" button.
 *  - Delegates drawing to dropdown menus (`dropdown1`, `dropdown2`, `dropdown3`).
 *  - Handles mouse interactions:
 *      - Updates dropdown states on press (`mousePressed`).
 *      - Triggers a `clickedDropDown` function on "Submit" button click.
 *      - Updates dropdown hover states on mouse movement (`mouseMoved`).
 *      - Processes mouse wheel events for dropdowns (`mouseWheel`).
 */
  void draw() {
    super.draw();
    dropdown1.draw();
    dropdown2.draw();
    dropdown3.draw();
    if (mouseX > 100+ 3*800/4 && mouseX < 100+ 3*800/4 + 800/4 &&
      mouseY > 160 && mouseY < 160 + 30) {
      fill(color(100, 200, 255)+100);
    } else {
      fill(100, 200, 255);
    }

    rect(100+ 3*800/4, 160, 800/4, 30);
    fill(255);
    text("Submit", 173+ 3*800/4, 173);
  }

  // Handles mouse press interactions, primarily for the dropdowns and submit button.
  void mousePressed() {
    dropdown1.mousePressed();
    dropdown2.mousePressed();
    dropdown3.mousePressed();
    if (mouseX > 100+ 3*800/4 && mouseX < 100+ 3*800/4 + 800/4 &&
      mouseY > 160 && mouseY < 160 + 30) {
      clickedDropDown();
    }
  }

  // Tracks mouse movement for interactive elements, such as dropdown menus.
  void mouseMoved() {
    dropdown1.mouseMoved();
    dropdown2.mouseMoved();
    dropdown3.mouseMoved();
  }

  // Processes mouse wheel interactions for scrolling through dropdown menu items.
  void mouseWheel(MouseEvent event) {
    dropdown1.mouseWheel(event);
    dropdown2.mouseWheel(event);
    dropdown3.mouseWheel(event);
  }
}
