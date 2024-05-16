import controlP5.*;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.Map;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import org.gicentre.utils.stat.*;

/**
 * This class represents a DataPoint containing flight information.
 * It holds the data in a two-dimensional ArrayList of strings (arrayData).
 * It also has an AirportLocations object (location) for potential location-related functionalities (not shown here).- Brian
 */
public class DataPoint {
  private ArrayList<String[]> arrayData;
  private AirportLocations location;
  public DataPoint(ArrayList<String[]> arrayData) {
    this.arrayData = arrayData;
    location = new AirportLocations();
  }
  /**
   * This defines a constant array of options for filtering data (Cancelled, Delayed, Diverted, All). - Brian
   */
  String[] selectData = {"Cancelled", "Delayed", "Diverted", "All"};
  
/**
 * This function retrieves all flight data from the class and returns it as a single string, sorted alphabetically by city and airport. - Brian
 */
  public String getAllDataSortedAlphabetically() {
    sortDataByCityAndAirport(); 

    StringBuilder result = new StringBuilder();
    for (String[] flightInfo : arrayData) {
      String flightDetails = String.join(" ", flightInfo);
      result.append(flightDetails).append("\n");
    }
    return result.toString();
  }

  /**
 * This function extracts the date information from each flight record and returns them as a list of strings. - Brian
 */
  public ArrayList<String>  dateData() {
    ArrayList<String> dateData = new ArrayList<String>();
    for (String[] data : arrayData) {
      dateData.add(data[0]); //origin index
    }
    return dateData;
  }

/**
 * This function extracts a list of unique origin airports from the flight data. - Brian
 */
  public ArrayList<String>  airportOrigin() {
    ArrayList<String> originData = new ArrayList<String>();
    for (String[] data : arrayData) {
      if (!originData.contains(data[2])) {
        originData.add(data[2]); //origin index
      }
    }
    return originData;
  }

/**
 * This function extracts the distance information for each flight record and returns them as a list of strings. - Brian
 */
  public ArrayList<String>  distanceData() {
    ArrayList<String> distData = new ArrayList<String>();
    for (String[] data : arrayData) {
      distData.add(data[10]); //distance index from the main functions
    }
    return distData;
  }
/**
 * This function extracts the cancellation status for each flight record and returns them as a list of strings. - Brian
 */
  public ArrayList<String>  canceledData() {
    ArrayList<String> cnclData = new ArrayList<String>();
    for (String[] data : arrayData) {
      cnclData.add(data[9]); //cancel index
    }
    return cnclData;
  }

/**
 * This function extracts the airline information for each flight record and returns them as a list of strings. - Brian
 */
  public ArrayList<String>  airlineData() {
    ArrayList<String> arlnData = new ArrayList<String>();
    for (String[] data : arrayData) {
      arlnData.add(data[11]); // airline index
    }
    return arlnData;
  }

/**
 * This function extracts the destination airport code for each flight record and returns them as a list of strings. - Brian
 */
  public ArrayList<String> destinationAirportData() {
    ArrayList<String> airData = new ArrayList<String>();
    for (String[] data : arrayData) {
      airData.add(data[6]); // destination airport index
    }
    return airData;
  }

/**
 * This function counts the number of flights originating from a specific airport.
 *
 * @param originAirportCode The code of the airport to consider as the origin.
 * @return The number of flights in the data that originate from the specified airport. - Brian
 */
  public int countFlightsFromOrigin(String originAirportCode) {
    int flightsFromOrigin = 0;
    for (String[] data : arrayData) {
      if (data[2].equals(originAirportCode)) {
        flightsFromOrigin++;
      }
    }
    return flightsFromOrigin;
  }
  
 /**
 * This function asynchronously retrieves the number of cancelled flights from a specified airport.
 *
 * @param airportName The name of the airport to check for cancelled flights.
 * @return A CompletableFuture object that will eventually hold the count of cancelled flights. - Brian
 */
  public CompletableFuture<Integer> getCancelledFlightsCount(String airportName) {
    CompletableFuture<Integer> future = CompletableFuture.supplyAsync(() -> {
      int cancelledFlightsCount = 0;
      for (String[] data : arrayData) {
        if (data[2].equals(airportName) && data[6].equals("1")) {
          cancelledFlightsCount++;
        }
      }
      return cancelledFlightsCount;
    }
    );
    return future;
  }

/**
 * This function finds the flight with the longest distance among all flights in the data.
 *
 * @return The origin code (data[2]) of the flight with the longest distance, or null if no data is available. - Brian
 */
  public String getFlightWithLongestDistance() {
    float maxDistance = 0;
    String flightWithLongestDistance = null;

    for (String[] data : arrayData) {
      float distance = Float.parseFloat(data[5]); // assuming distance index is 10
      if (distance > maxDistance) {
        maxDistance = distance;
        flightWithLongestDistance = data[2];
      }
    }

    return flightWithLongestDistance;
  }
  /**
 * This function counts the number of flights operated by a specific airline.
 *
 * @param airline The name of the airline to consider for counting flights.
 * @return The number of flights in the data that are operated by the specified airline. - Brian
 */
  public int countFlightsForAirline(String airline) {
    int count = 0;
    for (String[] data : arrayData) {
      if (data[11].equals(airline)) { // Assuming airline index is 11
        count++;
      }
    }
    return count;
  }
  
  /**
 * This function attempts to find the distance between two airports.
 *
 * @param originAirport The code of the origin airport.
 * @param destinationAirport The code of the destination airport.
 * @return The distance between the airports in meters as a string, 
 *         or "Distance Not Found" if no match is found in the data or location lookup fails. - Brian
 */
  public String distanceBetweenTwoAirports(String originAirport, String destinationAirport){
    for(String[]data : arrayData){
      if(data[2].equals(originAirport) && data[4].equals(destinationAirport)){
        return data[5] + "m";
      }
    }
    return str((int)location.getLocation(originAirport).getDistance(location.getLocation(destinationAirport))) + "m";
  }
  /**
 * This function attempts to find the distance between two airports based on information in the data.
 *
 * @param originAirport The code of the origin airport.
 * @param destinationAirport The code of the destination airport.
 * @return The distance between the airports in units specified by data[5] (assuming it's a number), 
 *         or 0 if no match is found in the data. - Brian
 */
  public int distanceBetweenAirports(String originAirport, String destinationAirport){
    for (String[] data : arrayData) {
      if(data[1] ==  originAirport && data[3] ==  destinationAirport){
        return int(data[5]);
      }
    }
      return 0;
  }
  
 /**
 * This function counts the number of delayed flights from a specified airport.
 *
 * @param airportName The name of the airport to consider for counting delayed flights.
 * @return The number of flights originating from the specified airport that are delayed. - Brian
 */
  public int countDelayed(String airportName) {
    int count = 0;
    for (String[] data : arrayData) {
      if (data[2].equals(airportName) && data[6].equals("1")) { // Assuming airport name index is 2 and delayed status the index is 6
        count++;
      }
    }
    return count;
  }

/**
 * This function counts the number of flights occurring on a specific date.
 *
 * @param date The date in the format used by the data (assuming data[0]) to consider for counting flights.
 * @return The number of flights in the data that occur on the specified date. - Brian
 */

  public int countFlightsInOneDay(String date) {
    int count = 0;
    for (String[] data : arrayData) {
      if (data[0].equals(date)) { // Assuming date index is 0
        count++;
      }
    }
    return count;
  }
  
/**
 * Counts flights within a week of the provided start date (inclusive). - Brian
 */
  public int countFlightsInOneWeek(String startDate) {
    int count = 0;

    LocalDate start = LocalDate.parse(startDate);
    LocalDate end = start.plusDays(6); // Adding 6 days to get the data for one week after end date (one week later)

    for (String[] data : arrayData) {
      LocalDate flightDate = LocalDate.parse(data[0]); // Assuming date index if  0 is index
      if (!flightDate.isBefore(start) && !flightDate.isAfter(end)) {
        count++;
      }
    }
    return count;
  }
/**
 * Counts diverted flights from a specified airport. - Brian
 */
  public int countDiverted(String airportName) {
    int count = 0;
    for (String[] data : arrayData) {
      if (data[2].equals(airportName) && data[8].equals("1")) { // Assuming airport name index is 2 and delayed status index is 6
        count++;
      }
    }
    return count;
  }
  
 /**
 * Sorts flight data in the provided array based on the specified data type.
 *
 * @param dataType The type of data to use for sorting ("Distance" or "Alphabetical").
 * @param arraySortData The ArrayList containing flight data (String arrays) to be sorted.
 *
 * This function supports sorting by distance (ascending order) or alphabetically by city and airport. 
 * If an unsupported data type is provided, the default behavior can be defined here   - Brian 
 * (currently empty).
 */
  private void sortByDistance(String dataType, ArrayList<String[]> arraySortData) {
    if (dataType != null) {
      switch (dataType) {
      case "Distance":
        arraySortData.sort((distance1, distance2) -> {
          Float dist1 = Float.parseFloat(distance1[5]);
          Float dist2 = Float.parseFloat(distance2[5]);
          return dist1.compareTo(dist2);
        }
        );
        break;
      case "Alphabetical":
        sortDataByCityAndAirport();
        break;
      default:
        // Handle the default case or leave it empty if there's nothing to do
        break;
      }
    }
  }
  
 /**
 * Sorts flight data in the array based on city/state and then airport code (ascending order).
 *
 * This function sorts flight data assuming the first element (`[0]`) contains the city and state information 
 * and the second element (`[1]`) holds the airport code. It sorts by city/state first (ascending order) 
 * and if cities/states are the same, it uses the airport code for further sorting (also ascending order).   - Brian
 */
  private void sortDataByCityAndAirport() {
    arrayData.sort(new Comparator<String[]>() {
      @Override
        public int compare(String[] flight1, String[] flight2) {
        // First compare by city/state
        int cityStateComparison = flight1[0].compareTo(flight2[0]);
        if (cityStateComparison != 0) {
          return cityStateComparison;
        }
        // If cities/states are the same, compare by airport code
        return flight1[1].compareTo(flight2[1]);
      }
    }
    );
  }
 /**
 * Counts the number of flights traveling from a specific origin airport to a specific destination airport.
 *
 * @param originAirportCode The code of the origin airport.
 * @param destinationAirportCode The code of the destination airport.
 * @return The number of flights in the data that travel from the origin airport to the destination airport. - Brian
 */
  public int countFlightsBetweenAirports(String originAirportCode, String destinationAirportCode) {
    int count = 0;
    for (String[] data : arrayData) {
      if (data[2].equals(originAirportCode) && data[4].equals(destinationAirportCode)) {
        count++;
      }
    }
    return count;
  }

/**
 * Finds a list of destination airports reachable from a specified origin airport.
 *
 * @param originAirportCode The code of the origin airport.
 * @return An array of destination airport codes reachable from the specified origin airport,  - Brian
 *         or an empty array if no destinations are found.
 */
  public String[] getDestinations(String originAirportCode) {
    ArrayList<String> destinations = new ArrayList<>();

    for (String[] data : arrayData) {
      if (data[2].equals(originAirportCode)) {
        destinations.add(data[4]);
      }
    }

    // Convert ArrayList to String array :)
    String[] airports = destinations.toArray(new String[destinations.size()]);

    return airports;
  }
}
