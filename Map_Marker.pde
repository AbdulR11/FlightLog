/**
 * Marker class represents data points visualized on the map.
 *
 * This class likely deals with creating and managing markers for flight data visualization on the 2D map.
 *
 * -Shuban
 */
public class Marker{
  Path firstAirport;
  String location;
  String[] arrayOfAirports;
  String markerType;
  AirportLocations dataForAirport;
  Marker(String firstAirport, String[] arrayOfAirports, String markerType) {
    dataForAirport = new AirportLocations();
    this.arrayOfAirports = arrayOfAirports;
    this.location = firstAirport;
    this.markerType = markerType;
     this.firstAirport = new Path(0, dataForAirport.getLocation(firstAirport));
  }
  
  void createPath(){
    for(String airport : arrayOfAirports){
      firstAirport.drawCurve((dataForAirport.getLocation(airport)));
    }
  }
  
    //creates marker based on the type of marker...SimpleMarker for "All" flights viewed, and "ImageMarker" for "Direct" flights viewed on map - Shuban
  void unfoldingMapCreatePath(){
    switch(markerType){
      case "SimpleMarker":
      for(String airport : arrayOfAirports){
        setMarker(dataForAirport.getLocation(location), dataForAirport.getLocation(airport));
      }
      break;
      case "ImageMarker":
      for(String airport : arrayOfAirports){
        setMarkerImage(dataForAirport.getLocation(location), dataForAirport.getLocation(airport));
      }
    }
  }
}
