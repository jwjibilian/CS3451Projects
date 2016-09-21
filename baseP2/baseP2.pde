// Template for 2D projects
// Author: Jarek ROSSIGNAC
import processing.pdf.*;    // to save screen shots as PDFs, does not always work: accuracy problems, stops drawing or messes up some curves !!!

//**************************** global variables ****************************
pts P = new pts(); // class containing array of points, used to standardize GUI
pts stabP = new pts();
ArrayList<Polygon> polygons = new ArrayList<Polygon>();
ArrayList<Polygon> ghosts = new ArrayList();
float t=0, f=0;
boolean animate=true, fill=false, timing=false;
boolean lerp=true, slerp=true, spiral=true; // toggles to display vector interpoations
int ms=0, me=0; // milli seconds start and end for timing
int npts=20000; // number of points
pt A=P(100, 100), B=P(300, 300);
Polygon x = new Polygon(P);
Polygon selected, solution;
GameStates currentState = GameStates.CREATION;
String stateStr = "Please create a polygon.";






//**************************** initialization ****************************
void setup()               // executed once at the begining 
{
  polygons.add(x);
  size(1400, 800);            // window size
  frameRate(30);             // render 30 frames per second
  smooth();                  // turn on antialiasing
  myFace = loadImage("data/pic.jpg");  // load image from file pic.jpg in folder data *** replace that file with your pic of your own face

  P.declare(); // declares all points in P. MUST BE DONE BEFORE ADDING POINTS 
  // P.resetOnCircle(4); // sets P to have 4 points and places them in a circle on the canvas
  P.loadPts("data/pts");  // loads points form file saved with this program
} // end of setup

//**************************** display current frame ****************************
void draw()      // executed at each frame
{



  if (recordingPDF) startRecordingPDF(); // starts recording graphics to make a PDF

  background(white); // clear screen and paints white background

  if (currentState == GameStates.CREATION || currentState == GameStates.PUZZLE) {
    color c = red;

    if (solution != null) {
      pen(black, 3);
      fill(red);
      solution.draw();
    }
    for (Polygon thing : polygons) {
      pen(black, 3); 
      if (thing.isMouseInside()) {    //checking if mouse position is inside polygon, if so then turn blue
        fill(blue);
      } else {
        fill(yellow);
      }
      thing.draw();
      thing.showIds();
      if (currentState == GameStates.CREATION && thing.stabedPts(A, B) !=null) {
     
          c = green;
 
      }
      pen(red, 6);
      pt G=thing.getCentroid();
      show(G, 10); // shows centroid
    }

    if ( currentState == GameStates.CREATION) {
      pen(c, 6);
      arrow(A, B);
    }

    stroke(red);
  } else if (currentState == GameStates.PLAYER) {
    if (solution != null) {
      pen(black, 3);
      fill(red);
      solution.draw();
    }
    for (Polygon thing : polygons) {
      pen(black, 3); 
      if (thing.isMouseInside()) {    //checking if mouse position is inside polygon, if so then turn blue
        fill(blue);
      } else {
        fill(yellow);
      }
      thing.draw();
      thing.showIds();
      pen(red, 6);
      pt G=thing.getCentroid();
      show(G, 10); // shows centroid
    }
  }










  if (recordingPDF) endRecordingPDF();  // end saving a .pdf file with the image of the canvas

  fill(black); 
  displayHeader(); // displays header
  displayState();
  if (scribeText && !filming) displayFooter(); // shows title, menu, and my face & name 

  if (filming && (animating || change)) snapFrameToTIF(); // saves image on canvas as movie frame 
  if (snapTIF) snapPictureToTIF();   
  if (snapJPG) snapPictureToJPG();   
  change=false; // to avoid capturing movie frames when nothing happens
}  // end of draw