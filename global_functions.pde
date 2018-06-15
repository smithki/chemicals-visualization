// "P3_Human_Body"
// ATLS 3519: Code
// Ian Smith - 11/30/2016


/* ========================== */
// These are related to visualization and GUI, they are called in draw()

void scene3D() {
  beginCamera();
    camera(x3d, y3d, z3d, x3d, y3d, 0, 0, 1, 0); // Interactive 3D camera responds to mouse input
    
    pushMatrix();
      translate(0, -gui.getGAP() * (data.chems.size() / 2), 0); // keep data vis in center of screen
      data.run(); // run the visualization
    popMatrix();
    
  endCamera();
}

void scene2D() {
  hint(DISABLE_DEPTH_TEST); // disable z-buffer so we can draw 2D user interface on top
  
  beginCamera();
    camera(x3d, y3d, wide, x3d, y3d, 0, 0, 1, 0); // expanded info lives on same plane (relatively) as widest z-plane...
    gui.expandedInfo(); // draw bar data right and pie data left
  endCamera();
  
  beginCamera();
    camera(); // ...the rest lives at z = 0 and on top of all other graphical elements
    gui.instructions(); // draw instructions for user interactivity
    gui.customCursor(); // draw a custom-designed cursor
    gui.showFrameRate(); // show the current framerate at bottom left corner
  endCamera();

  hint(ENABLE_DEPTH_TEST); // re-enable z-buffer so we can start drawing 3D shapes on next loop
}


/* ========================== */
// Interactive functions

void mousePressed() {
  gui.setCursorPos(); // get cursor position at this point (and draw a line between current and previous mouse positions)
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount(); // get the change in mouse scroll
  z3d += (e*-1) * 0.5; // increment the inverse (dampened by 50%)
  z3d = constrain(z3d, cu, wide); // make it so you can't scroll too close or too far
  gui.setGAP(); // use z3d to assign gap...
  gui.setBAR(); // ...and bar
  gui.setPIESCALE();
}

void keyPressed(KeyEvent event) {
  if ((event.isMetaDown() || event.isControlDown()) && key == 's') { // if COMMAND or CONTROL is held and 's' is pressed...
    saveFrame("screenshots/P3_Human_Body--Screenshot--######.jpg"); // ...save a screenshot in the sketch folder
  }
  
  if (key == 'i') {
    gui.toggleInstr(); // hide or show instructions
  }
}


/* ========================== */
// Useful calculations

float pctW(float percent) { // Get percent of width...
  return width*(percent/100); // ...just a prettier way of doing this in my opinion...
}

float pctH(float percent) { // ...ditto pctW()
  return height*(percent/100);
}

float calcScreenHeight(float distFromCamera) {
  return (2 * tan(yFOV / 2) * distFromCamera) / height; // factor of 2D height in 3D space
}

float calcScreenWidth(float distFromCamera) {
  return calcScreenHeight(distFromCamera) * aspect; // factor of 2D width in 3D space
}

float adjustHeightIn3D(float desiredHeight, float distFromCamera) {
  return (desiredHeight * calcScreenHeight(distFromCamera)); // calc actual 3D height needed to produce a specific relative height in 2D space
}

float adjustWidthIn3D(float desiredWidth, float distFromCamera) {
  return (desiredWidth * calcScreenWidth(distFromCamera)); // calc actual 3D width needed to produce a specific relative width in 2D space
}