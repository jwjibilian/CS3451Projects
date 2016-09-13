// Template for 2D projects
// Author: Jarek ROSSIGNAC
import processing.pdf.*;    // to save screen shots as PDFs, does not always work: accuracy problems, stops drawing or messes up some curves !!!

//**************************** global variables ****************************
pts P = new pts(); // class containing array of points, used to standardize GUI
pts stabP = new pts();
ArrayList<Polygon> polygons = new ArrayList<Polygon>();
float t=0, f=0;
boolean animate=true, fill=false, timing=false;
boolean lerp=true, slerp=true, spiral=true; // toggles to display vector interpoations
int ms=0, me=0; // milli seconds start and end for timing
int npts=20000; // number of points
pt A=P(100,100), B=P(300,300);

//**************************** initialization ****************************
void setup()               // executed once at the begining 
  {
  size(800, 800);            // window size
  frameRate(30);             // render 30 frames per second
  smooth();                  // turn on antialiasing
  myFace = loadImage("data/pic.jpg");  // load image from file pic.jpg in folder data *** replace that file with your pic of your own face
  P.declare(); // declares all points in P. MUST BE DONE BEFORE ADDING POINTS 
  stabP.declare();
  // P.resetOnCircle(4); // sets P to have 4 points and places them in a circle on the canvas
  P.loadPts("data/pts");  // loads points form file saved with this program
  } // end of setup

//**************************** display current frame ****************************
void draw()      // executed at each frame
  {
  if(recordingPDF) startRecordingPDF(); // starts recording graphics to make a PDF
  
    background(white); // clear screen and paints white background
    pen(black,3); fill(yellow); P.drawCurve(); P.IDs(); // shows polyloop with vertex labels
    stroke(red); pt G=P.Centroid(); show(G,10); // shows centroid
    pen(green,5); arrow(A,B);            // defines line style wiht (5) and color (green) and draws starting arrow from A to B

    
    pt[] points = P.get();
    int size = P.size();

    
    for(int i =0; i < size; i++){
      pt lineStart = points[i];
      pt lineEnd = points[(i+1)%size];
      float test1 = det(V(A,B),V(A,lineStart));
      float test2 = det(V(A,B),V(A,lineEnd));
      if( (test1 < 0 && test2 >= 0) || (test1 >= 0 && test2 < 0) ){
      
        //X=P+tV with t = -AB:AP / AB:V
        float time = (-det(V(lineStart,lineEnd),V(lineStart,A)))/(det(V(lineStart,lineEnd),V(A,B)));
        //println(time);
        pt x = P(A, time, V(A,B));
        
        
        //addPt to stabP points
        stabP.addPt(x);
        
        pen(red,1);
        //if (det(V(A,x),V(A,B)) != 0) {
        show(x);
        //}
      }
      
    }


  if(recordingPDF) endRecordingPDF();  // end saving a .pdf file with the image of the canvas

  fill(black); displayHeader(); // displays header
  if(scribeText && !filming) displayFooter(); // shows title, menu, and my face & name 

  if(filming && (animating || change)) snapFrameToTIF(); // saves image on canvas as movie frame 
  if(snapTIF) snapPictureToTIF();   
  if(snapJPG) snapPictureToJPG();   
  change=false; // to avoid capturing movie frames when nothing happens
  }  // end of draw
  