import java.util.ArrayList;
import java.util.Collections;
import java.util.concurrent.*;
import processing.core.PApplet;

/**
 * Chart class provides a versatile tool for creating and displaying various chart types.
 * 
 * This class can handle different chart visualizations based on the provided data and user selection. - Patrick/ Abdul 
*/
class Chart {
  PApplet applet;
  BarChart barChart;
  XYChart scatterplot;
  XYChart lineChart;
  ArrayList<String> arrayNames;
  ArrayList<Integer> dataValues;
  String chartType;
  
ArrowWidget rightArrow = new ArrowWidget(150, 185, 65, 30, "Right Arrow", color(255), stdFont, EVENT_RIGHT_ARROW, "right");
ArrowWidget leftArrow = new ArrowWidget(150, 215, 65, 30, "Left Arrow", color(255), stdFont, EVENT_LEFT_ARROW, "left");

/**
 * Chart constructor that initializes the chart object with provided data and settings.
 *
 * @param applet The PApplet instance used for drawing on the screen.
 * @param arrayNames An ArrayList containing labels or categories for the data points.
 * @param dataValues An ArrayList containing numerical data values to be plotted.
 * @param chartType A String specifying the initially selected chart type ("bar", "scatter", or "line").
 */
  Chart(PApplet applet, ArrayList<String> arrayNames, ArrayList<Integer> dataValues, String chartType) {
    this.applet = applet;
    this.arrayNames = arrayNames;
    this.dataValues = dataValues;
    this.chartType = chartType;
    this.lineChart = new XYChart(applet);
    this.scatterplot = new XYChart(applet);
    this.barChart = new BarChart(applet);
    setupLineChart();
    setupBarChart();
    setupChart();
  }

/**
 * Sets up common visual elements for the chart, likely used by all chart types (bar, scatter, line).    - Abdul
 * 
 * This method performs the following tasks:
 *  - Sets the chart font and size.
 *  - Converts `arrayNames`  to a float array `xValues` for plotting on the X-axis (assuming even spacing for categories).
 *  - Converts `dataValues` (containing numerical data) to a float array `yValues` for plotting on the Y-axis.
 *  - Sets the chart data for the scatter plot object (assuming scatter plot is used as a base for all chart types). 
 *  - Enables X and Y axes for the scatter plot.
 *  - Formats the X-axis labels to display numbers without decimals.
 *  - Sets labels for the X-axis ("Airports:") and Y-axis ("Number of Flights\n").
 *  - Defines visual styles for the data points (scatter plot symbols):
 *      - Color: blue (using `color(0, 71, 171)`)
 *      - Size: 15 pixels 
 */
  private void setupChart()
  {
    applet.textFont(applet.createFont("Arial", 11), 11);

    float[] xValues = new float[arrayNames.size()];
    for (int i = 0; i < arrayNames.size(); i++) {
      xValues[i] = i + 1;
    }

    float[] yValues = new float[dataValues.size()];
    for (int i = 0; i < dataValues.size(); i++) {
      yValues[i] = dataValues.get(i);
    }

    scatterplot.setData(xValues, yValues);
    scatterplot.showXAxis(true);
    scatterplot.showYAxis(true);
    scatterplot.setXFormat("###");
    scatterplot.setXAxisLabel("\nAirports:");
    scatterplot.setYAxisLabel("Number of Flights\n");

    // Symbol styles
    scatterplot.setPointColour(applet.color(0, 71, 171));
    scatterplot.setPointSize(15);

  }

 /**
 * Sets up data and visual properties specific to the bar chart. - Abdul
 *
 * This method likely performs the following tasks:
 *  - Converts `dataValues` to a float array `values` for the bar chart.
 *  - Converts `arrayNames` to a String array `labels` for the bar labels on the X-axis.
 *  - Sets the chart data (`values`) for the bar chart object.
 *  - Sets minimum and maximum values for the Y-axis (likely based on data).
 *  - Assigns labels (`labels`) to the bars on the X-axis.
 *  - Defines visual styles for the bars:
 *      - Color: blue (using `color(0, 71, 171)`)
 *      - Gap between bars: 4 pixels
 *  - Transposes the axes (likely swaps X and Y for horizontal bars).
 *  - Enables and formats the value axis (Y-axis) to display integer values.
 *  - Enables and shows the category axis (X-axis) for labels.
 */
  private void setupBarChart() {
    float[] values = new float[dataValues.size()];
    for (int i = 0; i < dataValues.size(); i++) {
      values[i] = dataValues.get(i);
    }

    String[] labels = new String[arrayNames.size()];
    for (int i = 0; i < arrayNames.size(); i++) {
      labels[i] = arrayNames.get(i);
    }
    
    barChart.setData(values);
    barChart.setMinValue(0);
    barChart.setMaxValue(Collections.max(dataValues)); 
    barChart.setBarLabels(labels);
    barChart.setBarColour(applet.color(0, 71, 171));
    barChart.setBarGap(4);
    barChart.transposeAxes(true);
    barChart.showValueAxis(true);
    barChart.setValueFormat("#");
    barChart.showCategoryAxis(true);
  }

  /**
 * Sets up data and visual properties specific to the line chart. - Abdul 
 *
 * This method likely performs the following tasks:
 *  - Converts `arrayNames` (likely containing category labels) to a float array `xValues` for plotting on the X-axis (assuming even spacing for categories).
 *  - Converts `dataValues` (containing numerical data) to a float array `yValues` for plotting on the Y-axis.
 *  - Sets the chart data (`xValues` and `yValues`) for the line chart object.
 *  - Enables X and Y axes for the line chart.
 *  - Sets minimum Y-axis value to 0 (likely to start the line at zero).
 *  - Formats the axes:
 *      - X-axis: display integers without decimals.
 *      - Y-axis: display numbers without decimals.
 *  - Defines visual styles for the line and data points:
 *      - Color: blue (using `color(0, 71, 171)`)
 *      - Point size: 10 pixels
 *      - Line width: 2 pixels
 *  - Sets labels for the X-axis ("Airports:") and Y-axis ("Number of Flights\n").
 */
 
  private void setupLineChart() {

    float[] xValues = new float[arrayNames.size()];
    for (int i = 0; i < arrayNames.size(); i++) {
      xValues[i] = i + 1;
    }
    float[] yValues = new float[dataValues.size()];
    for (int i = 0; i < dataValues.size(); i++) {
      yValues[i] = dataValues.get(i);
    }
    lineChart.setData(xValues, yValues);
    lineChart.showXAxis(true);
    lineChart.showYAxis(true);
    lineChart.setMinY(0);
    lineChart.setYFormat("###");
    lineChart.setXFormat("0");
    lineChart.setPointColour(applet.color(0, 71, 171));
    lineChart.setPointSize(10);
    lineChart.setLineWidth(2);
    lineChart.setXAxisLabel("\nAirports:");
    lineChart.setYAxisLabel("Number of Flights\n");
  }
  /**
 * Draws a pie chart on the screen with provided data and position. - Patrick
 *
 * This method iterates through the `dataValues` list and calculates slice angles based on their proportion to the total value.
 * It then uses Processing functions to draw colored arcs for each slice, creating a pie chart visualization.
 *
 * @param x X-coordinate of the pie chart's center.
 * @param y Y-coordinate of the pie chart's center.
 * @param w Width of the pie chart.
 * @param h Height of the pie chart.
 */
    void drawPieChart(int x, int y, int w, int h) {
    float lastAngle = 0;
    float total = 0;

 
    for (Integer value : dataValues) {
        total += value;
    }

   
    for (int i = 0; i < dataValues.size(); i++) {
        float value = dataValues.get(i);
        float angle = TWO_PI * (value / total);
        applet.fill(map(i, 0, dataValues.size(), 100, 255)); 
        applet.arc(x + w / 2, y + h / 2, w, h, lastAngle, lastAngle + angle);
        lastAngle += angle;
    }
}

 /**
 * Draws the entire chart visualization on the screen with provided position and size. - Abdul 
 *
 * This method performs the following steps:
 *  1. Sets the background color to white (`fill(255)`).
 *  2. Generates a formatted string describing the chart type and data using helper methods (likely `GraphScreen.dropdown1.getSelectedOption()` and `returnArrayPrints()`).
 *  3. Displays the chart information text on the screen using `text()`.
 *  4. Draws the appropriate chart type based on the `chartType` string:
 *      - "Bar": Calls `barChart.draw()` to draw the bar chart.
 *      - "Line": Calls `lineChart.draw()` to draw the line chart.
 *      - "Scatter": Calls `scatterplot.draw()` to draw the scatter plot.
 *      - "Pie": Calls `drawPieChart()` to draw the pie chart.
 *  5. Draws the left and right arrow icons using `rightArrow.draw()` and `leftArrow.draw()`. (These likely represent navigation controls).
 */
 void draw(int x, int y, int w, int h) {
    fill(255);
    // Simplified the text display
    String chartInfo = String.format("This is a %s chart of the %s flights of %s",
                        chartType.toLowerCase(),
                        GraphScreen.dropdown1.getSelectedOption().toLowerCase(),
                        returnArrayPrints());
    text(chartInfo, 110, 260);
    
    // Draw chart and arrows based on the chart - Abdul
    switch (chartType) {
        case "Bar":
            barChart.draw(x, y, w, h);
            break;
        case "Line":
            lineChart.draw(x, y, w, h);
            break;
        case "Scatter":
            scatterplot.draw(x, y, w, h);
            break;
        case "Pie":
             drawPieChart(x, y, w, h);
             break;
    }
      rightArrow.draw();
    leftArrow.draw();
}

// Returns a formatted string of the array names to be used in displaying chart information. - Ayush
  public String returnArrayPrints(){
    String arrayString = "";
    for(String name: arrayNames){
      arrayString += name + ", ";
    }
    return arrayString.substring(0, arrayString.length() - 2);
  }
}
