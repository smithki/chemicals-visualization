// "P3_Human_Body" //<>//
// ATLS 3519: Code
// Ian Smith - 11/30/2016


/* ========================== */
// Settings

// ~~~ Global variables ~~~ \\

float HALF_WIDTH, HALF_HEIGHT; // my own makeshift 'system' variables

float accumulation; // accumulated percentage from data input
int numChems, zMin, zMax; // maximum "chemicals" drawn
color bg; // background color

float x3d, y3d, z3d; // interactive camera position
float cu, wide, pop; // closest z, widest z, and centering threshold

PFont font; // font variable
float fontSize; // target font size

float yFOV; // vertical field-of-view (for calculating 2D height of 3D graphics)
float aspect; // aspect ratio (width / height; for calculating 2D width of 3D graphics)

// ~~~ Objects ~~~ \\

Data data; // data access
Interface gui; // user interface


/* ========================== */
// Main setup

void setup() { 
  // ~~~ Basic setup ~~~ \\
  
  //size(640, 480, P3D);
  //size(1280, 800, P3D);
  fullScreen(P3D); // sketch runs at full width/height of display
  noStroke(); // no stroke rendering by default
  frameRate(30); // maximum framerate
  pixelDensity(displayDensity()); // detect pixel density of display
  smooth(8); // anti-aliasing
  noCursor(); // no default cursor (custom cursor instead)

  // ~~~ Variable initialization ~~~ \\
  
  // Useful system stuff
  HALF_WIDTH = pctW(50); // width*0.5
  HALF_HEIGHT = pctH(50); // height*0.5
  
  // font variables
  if (width < 1280) { fontSize = 11; }
  else if (width >= 1280) { fontSize = 16; }
  font = createFont("Andale Mono.ttf", fontSize, true);
  
  // 3D calculation
  yFOV = PI / 3.0;
  aspect = float(width) / float(height);

  // Particles
  accumulation = 0.0; // init at 0
  numChems = int((width*height) * 0.0035); // # of "chemicals" drawn depends on resolution
  zMin = int(numChems / -5); 
  zMax = 0; // minimum and maximum z-position
  bg = color(15); // not quite black

  // 3D camera
  x3d = HALF_WIDTH;
  y3d = HALF_HEIGHT;
  z3d = HALF_HEIGHT / tan(PI*30.0 / 180.0);
  cu = z3d / 2.5;
  wide = z3d * 2.5;
  pop = lerp(cu, wide, 0.33); 

  // ~~~ Object initialization ~~~ \\
  
  data = new Data("chemicals.csv", "header"); // init data object with "chemicals.csv"
  gui = new Interface();
}


/* ========================== */
// Main draw loop

void draw() {
  // ~~~ Loop resets ~~~ \\
  
  background(bg); // re-draw background

  // ~~~ Do everything! ~~~ \\
  
  gui.clickNdrag(); // check for user mouse button input
  scene3D();
  scene2D();
}