// "P3_Human_Body"
// ATLS 3519: Code
// Ian Smith - 11/30/2016


class Interface {

  /* ========================== */
  // Class variables
  PVector cursorPos; // position of mouse when mouse button is pressed
  float gap, maxGap, bar, maxBar, pieScale; // spacing variables for displaying data vis
  
  float instrAlpha; // alpha value for instructions prompt
  boolean instrToggle; // hide or show instructions prompt
  
  
  /* ========================== */
  // Constructor

  Interface() {
    cursorPos = new PVector();
    gap = 0;
    bar = 0;
    maxGap = height / data.chems.size();
    maxBar = pctW(35);
    pieScale = 0;
    
    instrAlpha = 255;
    instrToggle = true;
  }


  /* ========================== */
  // Enables user to change perspective by clicking & dragging
  
  void clickNdrag() {
    if (mousePressed) {
      // changes in mouse position mapped against distance to centerpoint
      x3d -= map(mouseX - pmouseX, 0, width, 0, HALF_WIDTH);
      x3d = constrain(x3d, pctW(15), pctW(85));
      y3d -= map(mouseY - pmouseY, 0, height, 0, HALF_HEIGHT);
      y3d = constrain(y3d, 0, height);
    } else if (z3d >= pop && (x3d != HALF_WIDTH || y3d != HALF_HEIGHT)) { // if we are zoomed out enough...
      // target the centerpoint and ease the visualization there
      x3d = lerp(x3d, HALF_WIDTH, 0.1);
      y3d = lerp(y3d, HALF_HEIGHT, 0.1);
    }
  }


  /* ========================== */
  // Custom cursor functionality
  
  void customCursor() {
    int scale = 6; // cursor radius
    stroke(255);
    strokeWeight(1);
    fill(255, 0);
    ellipse(mouseX, mouseY, scale, scale); // centerpoint of cursor
    line(mouseX-scale, mouseY, mouseX+scale, mouseY); // cross on x-axis
    line(mouseX, mouseY-scale, mouseX, mouseY+scale); // cross on y-axis

    if (mousePressed && dist(mouseX, mouseY, cursorPos.x, cursorPos.y) > 0) {
      float alpha = map(dist(mouseX, mouseY, cursorPos.x, cursorPos.y),
        0, map(z3d, cu, wide, HALF_WIDTH, pctW(25)), 255, 0); // changes transparency based on distance from cursorPos vector
      stroke(255, alpha);
      strokeWeight(1);
      line (mouseX, mouseY, cursorPos.x, cursorPos.y); // line between current mouse position and stored position

      pushMatrix();
        float a = atan2(cursorPos.x - mouseX, cursorPos.y - mouseY); // angle of "arrowhead"
        translate(cursorPos.x, cursorPos.y);
        rotate(-(a - HALF_PI)); // set angle
        noStroke();
        fill(255, alpha);
        triangle(10, 0, 0, -4, 0, 4); // draw the "arrowhead"
      popMatrix();
    }
  }

  // Create a reference point vector of mouse position
  // called in mousePressed()
  void setCursorPos() {
    cursorPos = new PVector(mouseX, mouseY);
  }
  
  // Insructions on how to navigate the app -- attached to cursor
  void instructions() {
    if (instrAlpha != 0) {
      float iX = mouseX, iY = mouseY;
      pushMatrix();
        translate(iX, iY, 0);
        
        String instrText = "Click and drag to navigate the data" + "\n" +
          "Scroll to adjust zoom and see greater detail" + "\n" +
          "Toggle these instructions with [i]";
        
        float margin = 20;
        float iW = 350, iH = 70, radii = 12;
        fill(255, instrAlpha);
        noStroke();
        rect(-(iW * 0.5), -iH - margin, iW, iH, radii);
        triangle(0, -(margin * 0.5), -(margin * 0.5), -margin, margin * 0.5, -margin);
        
        fill(0, instrAlpha);
        textFont(font);
        textSize(12);
        textAlign(CENTER, TOP);
        text(instrText, 0, (-iH - margin) + 10);
      popMatrix();
    }
    
    if (!instrToggle) {
      instrAlpha = lerp(instrAlpha, 0, 0.5);
    } else {
      instrAlpha = 255;
    }
  }
  
  // Toggle the instructions popup
  void toggleInstr() {
    instrToggle = !instrToggle;
  }


  /* ========================== */
  // Set GUI spacing based on camera z-position
  
  void setGAP() {
    gap = map(z3d, pop, wide, 0, maxGap);
    gap = constrain(gap, 0, maxGap);
  }

  void setBAR() {
    bar = map(z3d, pop * 1.5, wide, maxBar, 0);
    bar = constrain(bar, 0, maxBar);
  }
  
  void setPIESCALE() {
    pieScale = map(z3d, pop, wide, 0, 1);
    pieScale = constrain(pieScale, 0, 1);
  }
  
  
  /* ========================== */
  // Display the GUI at maximum camera z-position

  void expandedInfo() {
    if (z3d != HALF_HEIGHT / tan(PI*30.0 / 180.0)) {
      float dynamicOffset = gap * (data.chems.size() / 2);
      float maxOffset = maxGap * (data.chems.size() / 2);
      
      // Show 2d visualizers for context
      pushMatrix();
        translate(width, -dynamicOffset, 0);
        
        for (int i = 0; i < data.chems.size(); i++) {
          Visualizer part = data.chems.get(i);
          part.showBar();
        }
      popMatrix();
      
      //pushMatrix();
      //  translate(0, maxOffset, 0);
        
      //  for (int i = 0; i < data.chems.size(); i++) {
      //    Visualizer part = data.chems.get(i);
      //    part.showPie();
      //  }
      //popMatrix();
      
      // "Trace elements..." text at bottom of screen
      pushMatrix();
        translate(HALF_WIDTH, (height + dynamicOffset) + gap, 0);
        
        String traceElements = "<1.0% Trace Elements (Not Represented)";
        textFont(font);
        textSize(adjustHeightIn3D(fontSize, wide));
        textAlign(CENTER, CENTER);
        fill(255, map(bar + (bar * 0.8), 0, pctW(10), 255, 0));
        text(traceElements, 0, 0);
      popMatrix();
      
      // Title text at top of screen
      pushMatrix();
        translate(HALF_WIDTH, -dynamicOffset - maxGap, 0);
        
        String title = "The Chemical Composition of the Human Body";
        textFont(font);
        textSize(adjustHeightIn3D(fontSize, wide));
        textAlign(CENTER, CENTER);
        fill(255, map(bar + (bar * 0.8), 0, pctW(10), 255, 0));
        text(title, 0, 0);
      popMatrix();
    }
  }
  
  
  /* ========================== */
  // Display the current frame rate at the bottom left corner 
  
  void showFrameRate() {
    fill(255, 60); // make it very faint (so as not to clash with the colored imagery)
    textSize(fontSize);
    textAlign(LEFT, BASELINE);
    text("FPS: " + int(frameRate), 0, height);
  }


  /* ========================== */
  // Get class variables for use in other parts of the sketch
  
  float getGAP() { return gap; }
  float getBAR() { return bar; }
  float getMAXGAP() { return maxGap; }
  float getMAXBAR() { return maxBar; }
  float getPIESCALE() { return pieScale; }
}