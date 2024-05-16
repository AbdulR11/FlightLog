/**
 * Logs class represents the screen for managing and viewing flight log data.
 *
 * This class extends the Screens class and provides functionalities for:
 *  - Search criteria selection: A dropdown menu (`dropdownSearch`) allows users to choose a search parameter
 *      from options like "Origin Airport" or "Destination City".
 *  - Sorting options: Another dropdown menu (`dropdownSort`) allows users to sort the log data
 *      based on criteria like "Alphabetical" or "Distance".
 */

class Logs extends Screens {
  PApplet applet;
  DropDownMenu dropdownSearch, dropdownSort;

  Logs(PApplet applet, color backgroundColor, String screenText) {
    super(backgroundColor, screenText);
    this.applet = applet;
    String[] options = {"Origin Airport", "Origin City", "Destination Airport", "Destination City", "Carrier"};
    String [] sort = {"Alphabetical", "Distance"};
    dropdownSearch = new DropDownMenu(applet, 100, 160, 800/4, 30, options);
    dropdownSort = new DropDownMenu(applet, 100+ 800/4, 160, 800/4, 30, sort);
  }

  void removeSearchBar() {
    searchbar.remove("SEARCH");
  }

  void removeTextArea() {
    if (textArea != null) {
      cp5.remove("txt");
      textArea = null;
    }
  }
  
/**
 * Draws the UI elements for the flight log search screen.
 *
 * This method likely performs the following tasks:
 *  - Calls the parent class's `draw` method (likely for background).
 *  - Draws the dropdown menus (`dropdownSearch` and `dropdownSort`) using their `draw` methods.
 *  - Pushes a style matrix to isolate changes made within this method.
 *  - Draws a small arrow pointing downwards (likely using line and ellipse shapes).
 *      - This might be a visual indicator for the search bar.
 *  - Pops the style matrix to restore previous styling.
 *  - Calls methods likely responsible for drawing the search bar UI (`textArea` and `searchBar`).
 */
  void draw() {
    super.draw();
    dropdownSearch.draw();
    dropdownSort.draw();
     pushStyle();
    stroke(255);
    strokeWeight(3);
    line(343.5, 317, 348, 323);
    fill(0);
    ellipse(338.5, 313, 10, 10);

    popStyle();
    textArea();
    searchBar();
  }

  void mousePressed() {
    dropdownSearch.mousePressed();
    dropdownSort.mousePressed();
  }
  void mouseMoved() {
    dropdownSearch.mouseMoved();
    dropdownSort.mouseMoved();
  }

  void mouseWheel(MouseEvent event) {
    dropdownSearch.mouseWheel(event);
    dropdownSort.mouseWheel(event);
  }
}
