// "P3_Human_Body"
// ATLS 3519: Code
// Ian Smith - 11/30/2016


class Visualizer {

  /* ========================== */
  // Class variables
  
  PVector[] pos; // store the position of all
  float[] xSpeed, ySpeed, size; // store the speed and size of all
  String element, symbol; // get the element name and symbol from data
  float maxR, maxG, maxB; // store the maximum RGB values for each data entry
  float percent, floor, ceiling, diff;
  float degStart, degEnd, degDiff; // get the percent and use to calc lowest and highest point
  int count, sMin, sMax; // calc number of chemicals based on percent; store z-axis and size ranges
  color c; // the base color of this data entry

  
  /* ========================== */
  // Constructor
  
  Visualizer(String _element, String _symbol, float _percent, color _c) {
    element = _element;
    symbol = _symbol;
    percent = _percent;
    

    floor = height * accumulation; // lowest y-position for this entry
    ceiling = floor + (height * percent); // the highest y-position for this entry
    diff = constrain(ceiling - floor, 1, height);
    
    degStart = 360.0 * accumulation;
    degEnd = degStart + (360.0 * percent);
    degDiff = constrain(degEnd - degStart, 1.0, 360.0);
    
    count = int(numChems*percent); // number of chemicals to be drawn for this entry
    count = constrain(count, 1, numChems); // always display at least one particle
    sMin = 8; 
    sMax = 12; // minimum and maximum ellipse diameter

    pos = new PVector[count];
    for (int i = 0; i < pos.length; i++) {
      pos[i] = new PVector(); // make a vector for this chemical 

      pos[i].x = random(width); // set x-position
      pos[i].y = random(floor, ceiling); // set y-position

      int zone;
      if (i == 0) { // on the first pass only...
        zone = 0; // ...set at least one vector at closest point...
        pos[i].z = int(map(zone, 0, 10, zMax, zMin)); // ...set the zone
      } else {
        zone = int(random(10)); // 10 randomly populated total zones of depth (vectors are locked to a zone)...
        pos[i].z = int(map(zone, 0, 10, zMax, zMin)); // ...set the zone
      }
    }

    xSpeed = new float[count];
    for (int i = 0; i < pos.length; i++) { 
      xSpeed[i] = random(-1, 1);
    } // set x-speed
    ySpeed = new float[count];
    for (int i = 0; i < pos.length; i++) { 
      ySpeed[i] = random(-1, 1);
    } // set y-speed
    size = new float[count];
    for (int i = 0; i < size.length; i++) { 
      size[i] = random(sMin, sMax);
    } // set size

    c = _c; // pass the base color from data
    maxR = red(c); // use base color to the maximum RGB values...
    maxG = green(c); // ...
    maxB = blue(c); // ...
  }


  /* ========================== */
  // Display data in array of particles
  
  void display() {
    for (int i = 0; i < count; i++) {
      updatePos(i); // update vector positions and size
      updateCol(i); // update color

      pushMatrix();
      translate(pos[i].x, pos[i].y, pos[i].z); // set position
      fill(c); // set color
      noStroke(); // no strokes on ellipses
      ellipse(0, 0, size[i], size[i]); // draw the "chemical"
      popMatrix();

      for (int j = i+1; j < count; j++) {
        neighbors(pos[i], pos[j]); // find nearest neighbors and draw connecting lines
      }
    }

    translate(0, gui.getGAP(), 0);
  }


  /* ========================== */
  // Update positions for all particles
  
  void updatePos(int i) {
    size[i] += random(-1, 1); 
    size[i] = constrain(size[i], sMin, sMax); // only slightly change size
    pos[i].x += xSpeed[i] + vibrate(random(-1, 1)); 
    pos[i].x = constrain(pos[i].x, 0, width);
    pos[i].y += ySpeed[i] + vibrate(random(-1, 1)); 
    pos[i].y = constrain(pos[i].y, floor, ceiling);

    // reverse polarity on the x-axis
    if (pos[i].x >= width) { 
      xSpeed[i] *= -1;
    } // reverse polarity if vector is outside boundaries on width
    else if (pos[i].x <= 0) { 
      xSpeed[i] *= -1;
    } // ...

    // reverse polarity on the y-axis
    if (pos[i].y >= ceiling) { 
      ySpeed[i] *= -1;
    } // reverse polarity if vector is outside boundaries on height
    else if (pos[i].y <= floor) { 
      ySpeed[i] *= -1;
    } // ...
  }
  
  // return a vibration value for all particles
  float vibrate(float value) {
    return value; // return the value input and use it to simulate vibration
  }


  /* ========================== */
  // Update color values for all particles based on z-position
  
  void updateCol(int i) {
    float r, g, b; // store color values
    int pass_bg = int(red(bg)); // bg is grayscale, so any color extraction will do

    // map RGB to vector z-position between B.G. color and maxR/G/B value
    r = map(pos[i].z, zMin, zMax, pass_bg, maxR);
    g = map(pos[i].z, zMin, zMax, pass_bg, maxG);
    b = map(pos[i].z, zMin, zMax, pass_bg, maxB);

    c = color(r, g, b); // set color
  }


  /* ========================== */
  // Draw a connecting line between neighboring particles on the same z-plane
  
  void neighbors(PVector one, PVector two) { // compare two vectors
    float dist = dist(two.x, two.y, two.z, one.x, one.y, one.z); // get distance between centerpoints
    float threshold = map(z3d, wide, cu, 0, 35); // the closer the camera, the more neighboring lines to be drawn

    if (dist < threshold && one.z == two.z) { // if distance is within threshold and z-positions are equal...
      stroke(c);
      strokeWeight(map(z3d, wide, cu, 0, 3) * map(one.z, zMin, zMax, 0.25, 1));
      line(one.x, one.y, one.z, two.x, two.y, two.z); // ...draw a line between the two vectors
    }
  }


  /* ========================== */
  // Display a bar-version of the data for 2D GUI
  
  void showBar() {    
    pushMatrix();
      translate(40, floor, 0);
      
      fill(maxR, maxG, maxB, map(gui.getBAR(), 0, gui.getMAXBAR(), 255, 0));
      noStroke();
      rect(gui.getBAR(), 0, 25, diff);

      fill(maxR, maxG, maxB, map(gui.getBAR() + (gui.getBAR() * 0.75), 0, gui.getMAXBAR(), 255, 0));
      textFont(font);
      textSize(adjustHeightIn3D(fontSize, wide));
      textAlign(LEFT, CENTER);
      text((percent * 100) + "% " + element + " (" + symbol + ")", 
        gui.getBAR() + 50, 
        (diff) * 0.5);
        
    popMatrix();
    
    translate(0, gui.getGAP(), 0);
  }
  
  
  /* ========================== */
  // Display a pie-version of the data for 2D GUI
  
  void showPie() {
    float radius = adjustHeightIn3D(pctW(15), wide);
    float offset = (width - (width / calcScreenWidth(wide))) / 2;
    pushMatrix();
      translate(-offset, 0, 0);
      
      scale(gui.getPIESCALE());
      fill(maxR, maxG, maxB, map(gui.getBAR(), 0, gui.getMAXBAR(), 255, 0));
      arc(-gui.getBAR(), 0, radius, radius, radians(degStart), radians(degStart + degDiff));
    popMatrix();
  }
}