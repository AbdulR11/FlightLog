/**
 * Planet class represents a celestial body visualized in 3D space.
 *
 * This class likely creates a 3D sphere representing a planet with an Earth texture.
 *
 * - Ayush
 */
class Planet {
  // Radius of the planet
  // Rotation angle (potentially for animation)
  // Distance from the origin (0, 0, 0) in 3D space
  // 3D vector representing the planet's location
  // Processing shape representing the planet's geometry
  float radius, angle, distance;
  PVector vectorCoord;
  PShape globe;
  /**
   * Planet constructor: Initializes planet properties with a given radius.
   *
   * @param radius Radius of the planet
   */
  Planet (float radius) {
    // create variable with placeholder values
    vectorCoord = PVector.random3D();
    this.radius = radius;
    noStroke();
    noFill();
    //draw Prcoessing geometry 
    globe = createShape(SPHERE, this.radius);
    globe.setTexture(imgEarth);
  }
  /**
   * Draws the planet on the screen.
   */
  void draw() {
    pushMatrix();
    //define x, y and z values
    float x = distance * sin(radians(45));
    float y = distance * cos(radians(45));
    float z = 0;
    
    vectorCoord.set(x, y, z);
    //place it in 3d universe
     // Translate the shape to its 3D position
    translate(vectorCoord.x, vectorCoord.y, vectorCoord.z);
    shape(globe);
    popMatrix();
  }
}
