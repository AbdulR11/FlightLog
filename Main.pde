// Import statements for various functionalities within the UnfoldingMaps library //<>// //<>//
import de.fhpotsdam.unfolding.*;
import de.fhpotsdam.unfolding.core.*;
import de.fhpotsdam.unfolding.data.*;
import de.fhpotsdam.unfolding.events.*;
import de.fhpotsdam.unfolding.geo.*;
import de.fhpotsdam.unfolding.interactions.*;
import de.fhpotsdam.unfolding.mapdisplay.*;
import de.fhpotsdam.unfolding.mapdisplay.shaders.*;
import de.fhpotsdam.unfolding.marker.*;
import de.fhpotsdam.unfolding.providers.*;
import de.fhpotsdam.unfolding.texture.*;
import de.fhpotsdam.unfolding.tiles.*;
import de.fhpotsdam.unfolding.ui.*;
import de.fhpotsdam.unfolding.utils.*;
import de.fhpotsdam.utils.*;
import processing.core.PApplet;

import de.fhpotsdam.unfolding.UnfoldingMap;
import de.fhpotsdam.unfolding.geo.Location;
import de.fhpotsdam.unfolding.utils.MapUtils;

import controlP5.*;

//import libraries
import java.util.ArrayList;
import java.util.ArrayList;
import java.util.concurrent.*;
import processing.data.Table;
import processing.data.TableRow;
import controlP5.*;

// constants
final int SCROLLBAR_COLOR = #0799fa;  // Color for the scrollbar
final int SCREEN_X = 1024;            // Width of the application window
final int SCREEN_Y = 780;            // Height of the application window
// Event constants for different button interactions
final int EVENT_BUTTON1= 1;
final int EVENT_BUTTON2= 2;
final int EVENT_BUTTON3= 3;
final int EVENT_BUTTON4 = 4;
final int EVENT_BUTTON5 = 5;
final int EVENT_BUTTON_NEXT = 6;
final int EVENT_BUTTON_BACK = 7;
final int EVENT_RIGHT_ARROW = 8;
final int EVENT_LEFT_ARROW = 9;
final int EVENT_NULL=0; // No event triggered

// Global variables
UnfoldingMap map;    // Instance of the UnfoldingMap object
Screens screen;      // Manages different screens within the application
Graphs GraphScreen;  // Screen for displaying graphs
Maps MapsScreen;     // Screen for displaying maps
Home HomeScreen;     // Home screen of the application
Logs LogScreen;      // Screen for displaying logs
ArrayList<Widget> widgetList;    // List of UI widgets
color defaultBorderColor = color(0);  // Default border color
color rectColor;        // Color for rectangles (undefined here)
PFont stdFont;          // Standard font for text elements
Screens screen5, currentScreen;  // Additional screen instances and the current active screen
ControlP5 cp5, cp, searchbar;    // ControlP5 library elements for creating interactive UI components
boolean dataLoaded = false;    // Flag to indicate if data is loaded
String selectedTab;            // Currently selected tab/section
String selectedData = "";         // Currently selected data
CompletableFuture<DataPoint> dataLoadFuture = new CompletableFuture<>();      // Future object for asynchronous data loading
int arrowClicked = 0; // Tracks which arrow button was clicked
ArrowWidget rightArrow = new ArrowWidget(150, 185, 65, 30, "Right Arrow", color(255, 0, 0), stdFont, EVENT_RIGHT_ARROW, "right");  // Arrow widget instances for navigation
ArrowWidget leftArrow = new ArrowWidget(150, 215, 65, 30, "Left Arrow", color(0, 255, 0), stdFont, EVENT_LEFT_ARROW, "left");
Location americaLocation = new Location(39.8283f, -98.5795f);    // Default location (America)
ArrayList<SimpleLinesMarker> lineMarker = new ArrayList<SimpleLinesMarker>();  // List to store line markers for the map
ArrayList<SimplePointMarker> pointMarker = new ArrayList<SimplePointMarker>();  // List to store point markers for the map
ArrayList<ImageMarker> imageMarker = new ArrayList<ImageMarker>();   // List to store image markers for the map
DataPoint data;    // Object to store loaded data
PApplet mainApplet;  // Reference to the main PApplet instance
// Chart objects for different visualization types
Chart barchart;  
Chart scatterplot;
Chart linegraph;
Chart piechart;
AirportLocations loc; // Object containing airport locations
boolean chartLoaded = false; // Flag to indicate if chart is loaded
String selectingData = "";  // Data being selected for chart display
String search;   // Search query string
Textarea textArea;   // Textarea UI element (user input)

ArrayList<String> airportOrign = new ArrayList<String>();  // List to store airport origin information
ArrayList<Integer> airportCancelled = new ArrayList<Integer>();  // List to store airport cancellation data
PImage imgEarth;  // Image for the Earth

/**
 * This function is called once at the beginning of the program and sets up the environment for visualization.
 *
 * - Initializes the Processing window size and rendering mode.
 * - Configures additional settings (potentially for 3D graphics).
 * - Loads an Earth texture image.
 * - Creates a font for text rendering.
 * - Initializes various UI elements using ControlP5 library (assuming it's used for UI).
 * - Creates different screen objects for visualization (Home, Logs, Graphs, and Maps).
 * - Sets the current screen to the Home screen.
 * - Initializes an ArrayList to store UI widgets.
 * - Prints a loading message.
 * - Calls the `graphSetup` function (likely for data processing and graph preparation).
 * - Creates an object (`loc`) for handling airport locations (assumed functionality).
 */
void setup() {
size(1024, 780, P3D);
  mapSettings();
  mainApplet = this;
  imgEarth = loadImage("Earth_Texture.jpg");
  stdFont = createFont("Aachen Bold.ttf", 20);
  
  searchbar = new ControlP5(this);
  LogScreen = new Logs(this, color(225), "");
  GraphScreen = new Graphs(mainApplet, color(225), "");
  MapsScreen = new Maps(this, color(225), "");
  HomeScreen = new Home(color(255), "");
  currentScreen = HomeScreen;
  
  widgetList = new ArrayList<Widget>();
  println("System Loading...");
  GraphScreen.graphSetup();
  loc = new AirportLocations();
}
/**
 * Configures the map object and its behavior.
 *
 * - Creates a new UnfoldingMap object with specified position and size.
 * - Sets up a default event dispatcher for the map (likely for user interaction).
 * - Zooms and pans the map to a specific location ("americaLocation") at zoom level 4.
 * - Enables map tweening for smoother animation during zoom and pan operations.
 * - Sets the valid zoom range between 4 and 8 (higher zoom levels correspond to closer views).
 * - Restricts panning to a certain distance around "americaLocation" (3000 pixels).
 */
void mapSettings() {
  map = new UnfoldingMap(this, 100, 190, 800, 400);
  MapUtils.createDefaultEventDispatcher(this, map);
  map.zoomAndPanTo(americaLocation, 4);
  map.setTweening(true);
  map.setZoomRange(4, 8);
  map.setPanningRestriction(americaLocation, 3000);
}
/**
 * This function is called repeatedly to update the visualization on the screen.
 *
 * - Draws all UI widgets from the widget list.
 * - Draws the current active screen (Home, Logs, Graphs, or Maps).
 * - Conditionally removes search bar and text area from the LogScreen if it's not the current screen.
 * - Draws graphs on the GraphScreen if the chart data is loaded and an arrow button was clicked:
 *   - Uses a switch statement based on the `arrowClicked` value to draw the appropriate graph type
 *     (line graph, bar chart, scatter plot, or pie chart) at specified coordinates.
 */
void draw() {
  for (int i = 0; i < widgetList.size(); i++) {
    Widget aWidget = widgetList.get(i);
    aWidget.draw();
  }

  currentScreen.draw();
  if (currentScreen != LogScreen) {
    LogScreen.removeSearchBar();
    LogScreen.removeTextArea();
  }
  if(currentScreen == GraphScreen && chartLoaded){
    switch(arrowClicked){
      case 0:
      linegraph.draw(280, 315, 450, 250);
      break;
      case 1:
      barchart.draw(280, 315, 450, 220);
      break;
      case 2:
      scatterplot.draw(280, 315, 450, 220);
      break;
      case 3:
      piechart.draw(280, 315, 450, 220);
      break;
    }
  }
}
/**
 * Handles events from UI controls (potentially using ControlP5 library).
 *
 * - Checks if the event is from a Textfield control.
 *   - If it is, extracts the entered text value and stores it in the `search` variable.
 */
void controlEvent(ControlEvent event) {
  if (event.isAssignableFrom(Textfield.class)) {
     search = event.getStringValue();
  }
}
/**
 * Sets markers on the map to visualize a connection between two locations.
 *
 * - Creates markers for the starting and ending locations using custom ImageMarker class:
 *   - Sets marker images ("ui/marker_gray.png" for start and "ui/marker_red.png" for end).
 *   - Uses dropdown selections from MapsScreen (potentially for origin/destination airports).
 * - Creates a line marker to connect the starting and ending locations (SimpleLinesMarker class).
 * - Adds all markers to the map and maintains separate lists for line and image markers.
 */
void setMarkerImage(Location startLocation, Location endLocation) {
  
  ImageMarker startMarker = new ImageMarker(startLocation, loadImage("ui/marker_gray.png"),
  MapsScreen.dropdown2.getSelectedOption());
  ImageMarker endMarker = new ImageMarker(endLocation, loadImage("ui/marker_red.png"), MapsScreen.dropdown3.getSelectedOption());
  SimpleLinesMarker connectionMarker = new SimpleLinesMarker(startLocation, endLocation);
  map.addMarker(connectionMarker);
  map.addMarkers(startMarker, endMarker);
  lineMarker.add(connectionMarker);
  imageMarker.add(startMarker);
  imageMarker.add(endMarker);
  
}
/**
 * Sets colored point markers on the map to visualize a connection between two locations.
 *
 * - Creates markers for the starting and ending locations using SimplePointMarker class:
 *   - Sets default colors (green for start and red for end with some transparency).
 * - Creates a line marker to connect the starting and ending locations (SimpleLinesMarker class).
 * - Adds all markers to the map and maintains separate lists for line and point markers. 
 */
void setMarker(Location startLocation, Location endLocation) {

  SimplePointMarker startMarker = new SimplePointMarker(startLocation);
  SimplePointMarker endMarker = new SimplePointMarker(endLocation);
  SimpleLinesMarker connectionMarker = new SimpleLinesMarker(startLocation, endLocation);
  endMarker.setColor(color(255, 0, 0, 100));
  startMarker.setColor(color(0, 255, 0, 100));
  //map.addMarker](notion://map.addmarker/)(connectionMarker);
  map.addMarkers(startMarker, endMarker);
  lineMarker.add(connectionMarker);
  pointMarker.add(startMarker);
  pointMarker.add(endMarker);
  
}
/**
 * Handles mouse press events and dispatches them to the current screen or handles specific UI interactions on the GraphScreen. - Patrick
 *
 * - Calls the `mousePressed` method of the current active screen (HomeScreen, LogScreen, MapsScreen, or GraphScreen).
 * - Retrieves the event type (`EVENT_BUTTON1`, `EVENT_BUTTON2`, etc.) returned by the current screen.
 * - Switches the active screen based on the event type (buttons 1-4 correspond to Graph, Maps, Log, and Home screens, button 5 switches to a separate screen5).
 * - Detects clicks within a specific dropdown area on the GraphScreen and calls the `clickedDropDown` function if clicked.
 * - Defines click detection areas for left and right arrow buttons (assumed for graph selection).
 * - Increments or decrements the `arrowClicked` variable based on left/right arrow clicks and enforces boundaries.
 */
void mousePressed() {
    currentScreen.mousePressed();
    int event = currentScreen.getEvent(); // Get event from the current screen
    switch (event) {
        case EVENT_BUTTON1:
            // Switch to GraphScreen when EVENT_BUTTON1 is triggered
            currentScreen = GraphScreen;
            break;
        case EVENT_BUTTON2:
            // Switch to MapsScreen when EVENT_BUTTON2 is triggered
            currentScreen = MapsScreen;
            break;
        case EVENT_BUTTON3:
            // Switch to LogScreen when EVENT_BUTTON3 is triggered
            currentScreen = LogScreen;
            break;
        case EVENT_BUTTON4:
            // Switch to HomeScreen when EVENT_BUTTON4 is triggered
            currentScreen = HomeScreen;
            break;
        case EVENT_BUTTON5:
            currentScreen = screen5;
            break;
    }

    // Detect clicks within a dropdown area, but only when on the GraphScreen
    if (mouseX > 100 + 3 * 800 / 4 && mouseX < 100 + 3 * 800 / 4 + 800 / 4 &&
        mouseY > 160 && mouseY < 160 + 30 && currentScreen == GraphScreen) {
        clickedDropDown(); // Call clickedDropDown method if the dropdown area is clicked
    }
    // Retrieve the positions for the right arrow click detection
    int startX = 820; // Right-pointing arrow starts at X=820
    int endX = 870;
    int startY = 395; // Assuming a small margin around the shaft for click detection
    int endY = 405;
    int leftStartX = 135; // The leftmost point of the arrowhead,   Left-pointing arrow starts at X=135
    int leftEndX = 200; // The rightmost point of the arrow shaft
    int leftStartY = 395; // Assuming a small margin around the shaft for click detection
    int leftEndY = 405;
    // Click detection logic
    if (mouseX >= startX && mouseX <= endX && mouseY >= startY && mouseY <= endY) {
        if (arrowClicked < 3) {
            arrowClicked++; // Increment arrowClicked if the right arrow is clicked and not at max
        } else {
            arrowClicked = 0; // Reset arrowClicked to 0 if it reaches the maximum count
        }
    }
    // Click detection logic for the left arrow
    if (mouseX >= leftStartX && mouseX <= leftEndX && mouseY >= leftStartY && mouseY <= leftEndY) {
        if (arrowClicked > 0) {
            arrowClicked--; // Decrease the arrowClicked counter if the left arrow is clicked
        } else {
            arrowClicked = 3; // Reset arrowClicked to the maximum if it reaches zero
        }
    }
}
/**
 * Handles user interaction with the dropdown on the GraphScreen.
 *
 * - Analyzes the selected option ("Cancelled", "Delayed", "All", or "Diverted").
 * - Calculates relevant flight data (count of cancelled/delayed/diverted/all flights) based on the selection and dropdown choices for origin airports (dropdown2 and dropdown3).
 * - Updates arrays storing origin airports (airportOrign) and corresponding flight counts (airportCancelled).
 * - Calls `createCharts` to generate graphs and sets `chartLoaded` to true.
 */
void clickedDropDown() {
switch(GraphScreen.dropdown1.getSelectedOption()) {
case "Cancelled":
dataLoadFuture.thenAcceptAsync(dataPoint -> {
CompletableFuture<Integer> cancelledFlightsFuture = dataPoint.getCancelledFlightsCount(GraphScreen.dropdown2.getSelectedOption());
CompletableFuture<Integer> cancelledFlightsFuture1 = dataPoint.getCancelledFlightsCount(GraphScreen.dropdown3.getSelectedOption());


  CompletableFuture.allOf(cancelledFlightsFuture, cancelledFlightsFuture1).thenRun(() -> {
    if (GraphScreen.dropdown2.getSelectedOption() != "Select an option" && !airportOrign.contains(GraphScreen.dropdown2.getSelectedOption())) {
      airportOrign.add(GraphScreen.dropdown2.getSelectedOption());
      airportCancelled.add(cancelledFlightsFuture.join());
    }
    if (GraphScreen.dropdown3.getSelectedOption() != "Select an option" && !airportOrign.contains(GraphScreen.dropdown3.getSelectedOption())) {
      airportOrign.add(GraphScreen.dropdown3.getSelectedOption());
      airportCancelled.add(cancelledFlightsFuture1.join());
    }
    createCharts();
    chartLoaded = true;
  }
  );
}
);
break;



case "Delayed":
int countDelayed = data.countDelayed(GraphScreen.dropdown2.getSelectedOption());
int countDelayed1 = data.countDelayed(GraphScreen.dropdown3.getSelectedOption());


if (!GraphScreen.dropdown2.getSelectedOption().equals("Select an option") && !airportOrign.contains(GraphScreen.dropdown2.getSelectedOption())) {
  airportOrign.add(GraphScreen.dropdown2.getSelectedOption());
  airportCancelled.add(countDelayed);
}

if (!GraphScreen.dropdown3.getSelectedOption().equals("Select an option") && !airportOrign.contains(GraphScreen.dropdown3.getSelectedOption())) {
  airportOrign.add(GraphScreen.dropdown3.getSelectedOption());
  airportCancelled.add(countDelayed1);
}

createCharts();
chartLoaded = true;

break;



case "All":
int countAll = data.countFlightsFromOrigin(GraphScreen.dropdown2.getSelectedOption());
int countAll1 = data.countFlightsFromOrigin(GraphScreen.dropdown3.getSelectedOption());


if (!GraphScreen.dropdown2.getSelectedOption().equals("Select an option") && !airportOrign.contains(GraphScreen.dropdown2.getSelectedOption()) ) {
  airportOrign.add(GraphScreen.dropdown2.getSelectedOption());
  airportCancelled.add(countAll);
}

if (!GraphScreen.dropdown3.getSelectedOption().equals("Select an option") && !airportOrign.contains(GraphScreen.dropdown3.getSelectedOption())) {
  airportOrign.add(GraphScreen.dropdown3.getSelectedOption());
  airportCancelled.add(countAll1);
}

createCharts();
chartLoaded = true;

break;



case "Diverted":
int divertedCount = data.countDiverted(GraphScreen.dropdown2.getSelectedOption());
int divertedCount1 = data.countDiverted(GraphScreen.dropdown3.getSelectedOption());


if (!GraphScreen.dropdown2.getSelectedOption().equals("Select an option") && !airportOrign.contains(GraphScreen.dropdown2.getSelectedOption())) {
  airportOrign.add(GraphScreen.dropdown2.getSelectedOption());
  airportCancelled.add(divertedCount);
}

if (!GraphScreen.dropdown3.getSelectedOption().equals("Select an option") && !airportOrign.contains(GraphScreen.dropdown3.getSelectedOption())) {
  airportOrign.add(GraphScreen.dropdown3.getSelectedOption());
  airportCancelled.add(divertedCount1);
}

createCharts();
chartLoaded = true;

break;



}
}
void mouseMoved() {
  currentScreen.mouseMoved();
}

void mouseWheel(MouseEvent event) {
  currentScreen.mouseWheel(event);
}

/**
 * Creates or updates the search bar element on the screen.
 *
 * - Checks if a textfield controller named "SEARCH" already exists in the searchbar element (assuming ControlP5 library is used).
 *   - If it doesn't exist, creates a new textfield element with specified properties (position, size, font, color, etc.) and adds it to the searchbar.
 */

void searchBar() {
    // Check if the search bar already exists
    if (searchbar.getController("SEARCH") == null) {
        searchbar.addTextfield("SEARCH")
            .setPosition(370, 300)
            .setSize(250, 30)
            .setFont(stdFont)
            .setColor(color(255))
            .setLabel("")
            .setColorBackground(color(30))
            .setColorForeground(color(30));
    }
}
void mouseDragged() {
    currentScreen.mouseDragged();
}
void createCharts() {
    barchart = new Chart(mainApplet, airportOrign, airportCancelled, "Bar");
    linegraph = new Chart(mainApplet, airportOrign, airportCancelled, "Line");
    scatterplot = new Chart(mainApplet, airportOrign, airportCancelled, "Scatter");
    piechart = new Chart(mainApplet, airportOrign, airportCancelled, "Pie");
    chartLoaded = true;
}

/**
 * Updates the text area in the LogScreen with filtered and potentially sorted flight data.
 *
 * - Checks if data is loaded and a search option is selected.
 * - Filters flight data based on the selected search option ("Origin Airport", "Destination Airport", etc.) and the search query entered by the user.
 * - Sorts the filtered data (implementation not shown, likely uses `data.sortByDistance`).
 * - Converts the filtered and potentially sorted data into a single String for display.
 * - Updates the text area element:
 *   - If it exists, sets the text content with the filtered data string.
 *   - If it doesn't exist, creates a new text area element using ControlP5 library and sets its properties (position, size, font, etc.) before setting the text content.
 */
void textArea() {
    ArrayList < String[] > tempFilteredDataList = new ArrayList < > ();
    StringBuilder filteredData = new StringBuilder();
    String selectedOption = LogScreen.dropdownSearch.getSelectedOption();
    String dataType = LogScreen.dropdownSort.getSelectedOption();

    if (dataLoadFuture.isDone() && selectedOption != null) {
        switch (selectedOption) {
            case "Origin Airport":
                for (String[] flightInfo: data.arrayData) {
                    if (flightInfo[2].equalsIgnoreCase(search)) {
                        tempFilteredDataList.add(flightInfo);
                    }
                }
                break;
            case "Destination Airport":
                for (String[] flightInfo: data.arrayData) {
                    if (flightInfo[4].equalsIgnoreCase(search)) {
                        tempFilteredDataList.add(flightInfo);
                    }
                }
                break;
            case "Origin City":
                for (String[] flightInfo: data.arrayData) {
                    if (flightInfo[1].equalsIgnoreCase(search)) {
                        tempFilteredDataList.add(flightInfo);
                    }
                }
                break;
            case "Destination City":
                for (String[] flightInfo: data.arrayData) {
                    if (flightInfo[3].equalsIgnoreCase(search)) {
                        tempFilteredDataList.add(flightInfo);
                    }
                }
                break;
            case "Carrier":
                for (String[] flightInfo: data.arrayData) {
                    if (flightInfo[7].equalsIgnoreCase(search)) {
                        tempFilteredDataList.add(flightInfo);
                    }
                }
                break;
        }


        // Sort the filtered data if necessary, you can include your sorting method here
        data.sortByDistance(dataType, tempFilteredDataList);

        // Convert the filtered and possibly sorted list into a string
        for (String[] flightInfo: tempFilteredDataList) {
            for (String flightDetail: flightInfo) {
                filteredData.append(flightDetail).append(" ");
            }
            filteredData.append("\n");
        }
    }

    // Update the TextArea with the filtered data
    if (textArea != null) {
        textArea.setText(filteredData.toString());
    } else {
        cp5 = new ControlP5(this);
        textArea = cp5.addTextarea("txt")
            .setPosition(100, 400)
            .setSize(800, 260)
            .setFont(stdFont)
            .setLineHeight(20)
            .setColor(0)
            .setColorBackground(color(255))
            .setColorForeground(color(255, 100));
        textArea.setText(filteredData.toString());
    }
}
