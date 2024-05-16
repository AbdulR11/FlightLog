/**
 * Maps class represents the screen for visualizing flight data on a 2D map and a 3D globe.
 *
 * This class extends the Screens class and provides functionalities for:
 *  - Displaying a 2D map (potentially of a specific region like the USA using `mapUsa`).
 *  - Displaying a 3D globe (`earth`) for an alternative data visualization perspective.
 *  - Offering search and filter options through dropdown menus (`dropdown1`, `dropdown2`, `dropdown3`).
 *  - Highlighting data points of interest (`markers`).
 *  - Allowing data path visualization (`drawPath`).
 *  - Displaying additional information related to the data points (`info`).
 *
 *  -Shuban/Ayush
 */
class Maps extends Screens {
  private Planet earth;
  private PImage mapUsa;
  DropDownMenu dropdown1, dropdown2, dropdown3;
  boolean state = false;
  float scaleFactor = 1.0;
  String info = "";
  PApplet applet;
  DataPoint data;
  boolean drawPath = false;
  float angleX = -0.6299998;
  float angleY = 3.3899996;
  float distance = 500;
  Marker markers;
  /**
 *  Maps class constructor: Initializes the flight data visualization screen.
 *
 *  This constructor performs the following tasks:
 *  - Calls the parent class constructor to set background color and screen text.
 *  - Creates a 3D globe object (`earth`) of a certain radius (170 in this case).
 *  - Loads a 2D map image (`mapUsa`).
 *  - Initializes empty dropdown menus (`dropdown1`, `dropdown2`, `dropdown3`).
 *  - Stores a reference to the PApplet instance (`applet`).
 *  - Sets up the first dropdown (`dropdown1`) with options like "All" and "Direct" (potentially for flight filtering).
 *  - Sets up the second and third dropdowns (`dropdown2`, `dropdown3`) with options to be populated later.
 *  - Uses `dataLoadFuture` (likely an asynchronous data loading mechanism) to populate the second and third dropdowns with unique origin airports from the loaded data.
 */
  Maps(PApplet applet, color backgroundColor, String screenText) {
    super(backgroundColor, screenText);
    earth = new Planet(170);
    mapUsa = loadImage("ImageUSA.png");
    String[] options = {""};
    String[] select = {"All", "Direct"};
    this.applet = applet;
    dropdown1 = new DropDownMenu(applet, 100, 160, 800/4, 30, select);
    dropdown2 = new DropDownMenu(applet, 100+ 800/4, 160, 800/4, 30, options);
    dropdown3 = new DropDownMenu(applet, 100+ 2*800/4, 160, 800/4, 30, options);
    dataLoadFuture.thenAcceptAsync(dataPoint -> {
      String[] stringArray = dataPoint.airportOrigin().toArray(new String[0]);
      dropdown2.setOptions(stringArray);
      dropdown3.setOptions(stringArray);
    }
    );
  }
  
 /**
 * Draws the UI elements and map visualization for the flight data screen.
 *
 * This method likely performs the following tasks:
 *  - Calls the parent class's `draw` method (likely for background).
 *  - Conditionally renders either 2D or 3D based on the `state` variable:
 *      - 3D globe (`earth`) with rotation and scaling controls (if `state` is true).
 *          - Shows paths between airports if dropdown selections and `drawPath` are set.
 *      - 2D map image (`mapUsa`) with path visualization (if `state` is false).
 *  - Draws dropdown menus (`dropdown1`, `dropdown2`, `dropdown3`) based on selections.
 *  - Handles highlighting buttons based on mouse hover for "Submit" and 2D/3D toggle.
 *  - Draws text labels for "Submit", "2D/3D" mode, and potentially other information using `drawText`.
 */
  void draw() {
    super.draw();
    // if state is true 3D is true and state false 2d is true
    if (state) {
      pushMatrix();
      fill(255);
      //directional
      translate(500, 400, 100);
      scale(scaleFactor);//variables changed in mouseMoved
      rotateX(angleX);//variable changed in mouseDragged
      rotateY(angleY);//variable changed in mouseDragged
      if (dropdown2.getSelectedOption() != null && drawPath && dropdown1.getSelectedOption() != null) {
        markers.createPath();//if dropdown 1 and 2 are not empty markers can be drawn
      }

      earth.draw();
      popMatrix();
    } else {
      if (dropdown2.getSelectedOption() != null && drawPath && dropdown1.getSelectedOption() != null) {
        markers.unfoldingMapCreatePath();
      }
      
      image(mapUsa,100, 190, 800, 400);//placeholder image incase user is offline
      text("Offline mode", 100, 210);
      map.draw();
    }

    dropdown1.draw();
    dropdown2.draw();
    if (dropdown1.getSelectedOption() != "All") {
      dropdown3.draw();
    }
    //change color of buttons
    if (mouseX > 100 + 3 * 800 / 4 && mouseX < 100 + 3 * 800 / 4 + 800 / 4 &&
      mouseY > 160 && mouseY < 160 + 30) {
      fill(color(100, 200, 255) + 100);
    } else {
      fill(100, 200, 255);
    }
    rect(100 + 3 * 800 / 4, 160, 800 / 4, 30);
    if (mouseX > 100 + 3 * 800 / 4 && mouseX < 100 + 3 * 800 / 4 + 800 / 4 &&
      mouseY > 590 && mouseY < 590 + 30) {
      fill(color(100, 200, 255) + 100);
    } else {
      fill(100, 200, 255);
    }
    rect(100 + 3 * 800 / 4, 590, 800 / 4, 30);
    fill(255);
    text("Submit", 173 + 3 * 800 / 4, 173);

    text(state ? "3D" : "2D", 173 + 3 * 800 / 4, 603);

    drawText();
  }
  //change rotation of earth
  void mouseDragged() {
    if(state){
      angleX += (pmouseY - mouseY) * 0.01;
      angleY -= (pmouseX - mouseX) * 0.01;
    }
  }
  //change scale of earth
  void mouseWheel(MouseEvent event) {
    float e = event.getCount();
    if(state){
      scaleFactor -= e * 0.05; // Adjust zoom speed here
      scaleFactor = constrain(scaleFactor, 0.1, 1.1); // Limit zoom range
      float delta = event.getCount() * 10;
      distance += delta;
      distance = constrain(distance, 100, 1000);
    }
    dropdown1.mouseWheel(event);
    dropdown2.mouseWheel(event);
    if (dropdown1.getSelectedOption() != "All") {
      dropdown3.mouseWheel(event);
    }
  }

/**
 * Handles mouse press interactions on the flight data screen.
 *
 * This method performs the following tasks:
 *  - Delegates mouse presses to dropdown menus (`dropdown1`, `dropdown2`, `dropdown3`).
 *  - Handles clicks on the "Submit" button (at 100 + 3 * 800/4, 160):
 *      - Checks if dropdowns have valid selections for origin and destination (if applicable based on dropdown1).
 *      - Clears the map data (likely removes previous markers or paths).
 *      - Creates markers based on dropdown selections and marker type ("ImageMarker" or "SimpleMarker").
 *      - Sets the `drawPath` flag to enable path visualization.
 *  - Handles clicks on the 2D/3D toggle button (at 100 + 3 * 800/4, 590):
 *      - Switches the `state` variable to toggle between 2D and 3D map view.
 */
  void mousePressed() {
    dropdown1.mousePressed();
    dropdown2.mousePressed();
    if (dropdown1.getSelectedOption() != "All") {
      dropdown3.mousePressed();
    }
    if (mouseX > 100+ 3*800/4 && mouseX < 100+ 3*800/4 + 800/4 &&
      mouseY > 160 && mouseY < 160 + 30 && currentScreen == MapsScreen) {
      if (dropdown2.getSelectedOption() != null && dropdown1.getSelectedOption() != null) {
        clearMap();
        switch(dropdown1.getSelectedOption()) {
        case "Direct":
          if (dropdown3.getSelectedOption() != null) {
            String[] airportArray = {
              dropdown3.getSelectedOption()
            };
            markers = new Marker(dropdown2.getSelectedOption(), airportArray, "ImageMarker");
            drawPath = true;
          }

          break;
        case "All":
          dataLoadFuture.thenAcceptAsync(dataPoint -> {
            String[] stringArray = dataPoint.airportOrigin().toArray(new String[0]);
            markers = new Marker(dropdown2.getSelectedOption(), stringArray, "SimpleMarker");
            drawPath = true;
          }
          );

          break;
        }
      }
    } else if (mouseX > 100+ 3*800/4 && mouseX < 100+ 3*800/4 + 800/4 &&
      mouseY > 590 && mouseY < 590 + 30) {
      state = !state;
    }
  }
  void mouseMoved() {
    dropdown1.mouseMoved();
    dropdown2.mouseMoved();
    if (dropdown1.getSelectedOption() != "All") {
      dropdown3.mouseMoved();
    }
  }
  
 /**
 * Clears existing markers from the map to prepare for new selections or a reset.
 *
 * This method likely performs the following tasks:
 *  - Checks if any markers exist on the map.
 *  - Iterates through different marker types (lines, points, images) and removes them from the map's marker manager.
 *  - Additionally clears the internal collections holding these markers for proper memory management.
 */
  void clearMap() {
    if (lineMarker. size() != 0) {
      for (SimpleLinesMarker marker : lineMarker) {
        map.getDefaultMarkerManager().removeMarker(marker);
      }
      if (pointMarker.size() != 0) {
        for (SimplePointMarker marker : pointMarker) {
          map.getDefaultMarkerManager().removeMarker(marker);
        }
      } else {
        for (ImageMarker marker : imageMarker) {
          map.getDefaultMarkerManager().removeMarker(marker);
        }
      }
      imageMarker.clear();
      pointMarker.clear();
      lineMarker.clear();
    }
  }

/**
 * Updates and displays informational text based on user interactions and dropdown selections.
 *
 * This method likely performs the following tasks:
 *  - Checks for specific conditions:
 *      - User has selected valid options from dropdowns (origin and potentially destination based on dropdown1).
      - User has clicked on the "Submit" button (mouse interaction check).
 *  - Based on the selection in dropdown1:
 *      - "Direct": Fetches data asynchronously (using `dataLoadFuture`) to calculate distance
        between the origin (dropdown2) and destination (dropdown3) airports and update the `info` string.
      - "All": Updates the `info` string to indicate it's displaying all flights from the origin (dropdown2).
 *  - If `info` is not empty, it gets displayed on the screen using `text`.
 */
  void drawText() {
    if (dropdown2.getSelectedOption() != null && dropdown1.getSelectedOption() != null  & (mouseX > 100+ 3*800/4 && mouseX < 100+ 3*800/4 + 800/4 &&
      mouseY > 160 && mouseY < 160 + 30 && currentScreen == MapsScreen) && mousePressed) {
      switch (dropdown1.getSelectedOption()) {
      case "Direct":
      dataLoadFuture.thenAcceptAsync(dataPoint -> {
        if (dropdown3.getSelectedOption() != null) {
          info = String.format("\nThis is a visual of the %s flight between %s and %s \n and distance between the aiports is %s",
            dropdown1.getSelectedOption().toLowerCase(),
            dropdown2.getSelectedOption(), dropdown3.getSelectedOption(),
            dataPoint.distanceBetweenTwoAirports(dropdown2.getSelectedOption(), dropdown3.getSelectedOption()));
        }
      });
        break;
      case "All":
        info = String.format("This is a visual of %s the flights from %s",
          dropdown1.getSelectedOption().toLowerCase(),
          dropdown2.getSelectedOption());
        break;
      }
    }
    if (!info.isEmpty()) {
      text(info, 110, 600);
    }
  }
}
