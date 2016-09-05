// Template for 2D projects
// Author: Jarek ROSSIGNAC
import processing.pdf.*;    // to save screen shots as PDFs, does not always work: accuracy problems, stops drawing or messes up some curves !!!

//**************************** global variables ****************************
pts P = new pts(); // class containing array of points, used to standardize GUI
float t=0, f=0;
boolean animate=true, fill=false, timing=false;
boolean lerp=true, slerp=true, spiral=true; // toggles to display vector interpoations
int ms=0, me=0; // milli seconds start and end for timing
int npts=20000; // number of points

//**************************** initialization ****************************
void setup()               // executed once at the begining 
  {
  size(800, 800);            // window size
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
  if(recordingPDF) startRecordingPDF(); // starts recording graphics to make a PDF
    pt A=P.G[0], B=P.G[1], C=P.G[2], D=P.G[3];
    pt Z=P.G[4], Y=P.G[5], X=P.G[6], W=P.G[7]; 
    SpiralObj spiral1 = new SpiralObj(A,B,C,D);
    SpiralObj spiral2 = new SpiralObj(Z,Y,X,W);
    
    background(white); // clear screen and paints white background
         // crates points with more convenient names
    
    spiral1.drawLines();
    spiral1.drawPoints("A","B","C","D","F");
    pt[] x = spiral1.drawSpiralPattern(120);
    spiral1.drawSpiralThrough3Points();
    
    spiral2.drawLines();
    spiral2.drawPoints("Z","Y","X","W","G");
    pt[] y = spiral2.drawSpiralPattern(440);
    spiral2.drawSpiralThrough3Points();
    
    SpiralObj spiral3 = new SpiralObj(x[0], x[1], y[0], y[1]);
    //spiral3.drawPoints("aa","bb","cc","dd","ee");
    //spiral3.drawSpiralPattern(200);
    spiral3.drawStaticSpiralPattern(0.08);
    //spiral3.drawSpiralThrough3Points();

  if(recordingPDF) endRecordingPDF();  // end saving a .pdf file with the image of the canvas

  fill(black); displayHeader(); // displays header
  if(scribeText && !filming) displayFooter(); // shows title, menu, and my face & name 

  if(filming && (animating || change)) snapFrameToTIF(); // saves image on canvas as movie frame 
  if(snapTIF) snapPictureToTIF();   
  if(snapJPG) snapPictureToJPG();   
  change=false; // to avoid capturing movie frames when nothing happens
  }  // end of draw
  