// Template for 2D projects
// Author: Jarek ROSSIGNAC
import processing.pdf.*;    // to save screen shots as PDFs, does not always work: accuracy problems, stops drawing or messes up some curves !!!

//**************************** global variables ****************************
pts P = new pts(); // class containing array of points, used to standardize GUI
Spirals S = new Spirals();
float t=0, f=0;
boolean animate=true, fill=false, timing=false;
boolean lerp=true, slerp=true, spiral=true; // toggles to display vector interpoations
int ms=0, me=0; // milli seconds start and end for timing
int npts=20000; // number of points

//**************************** initialization ****************************
void setup()               // executed once at the begining 
{
  size(800, 800);            // window size
  frameRate(60);             // render 30 frames per second
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
  pt A=P.G[0], B=P.G[1], C=P.G[2], D=P.G[3];
  pt E=P.G[8], F=P.G[9], G=P.G[10], H=P.G[11];
  pt Z=P.G[4], Y=P.G[5], X=P.G[6], W=P.G[7];
  pt I=P.G[12], J=P.G[13], K=P.G[14], L=P.G[15];
  SpiralObj spiral1 = new SpiralObj(A, B, C, D);
  SpiralObj spiral2 = new SpiralObj(Z, Y, X, W);
  SpiralObj spiral3 = new SpiralObj(E, F, G, H);
  SpiralObj spiral4 = new SpiralObj(I, J, K, L);

  spiral1.setColor(white);
  spiral2.setColor(white);
  spiral3.setColor(white);
  spiral4.setColor(white);

  S.spi[0] = spiral1;
  S.spi[1] = spiral2;
  S.spi[2] = spiral3;
  S.spi[3] = spiral4;

  background(white); // clear screen and paints white background
  // crates points with more convenient names

  if (keyPressed && key=='s') {
    spiral1.setColor(black);
    spiral1.drawLines();
    spiral1.drawPoints("A", "B", "C", "D", "F");
    spiral1.drawSpiralThrough3Points();

    spiral2.setColor(black);
    spiral2.drawLines();
    spiral2.drawPoints("Z", "Y", "X", "W", "G");
    spiral2.drawSpiralThrough3Points();

    spiral3.setColor(black);
    spiral3.drawLines();
    spiral3.drawPoints("E", "F", "G", "H", "cc");
    spiral3.drawSpiralThrough3Points();

    spiral4.setColor(black);
    spiral4.drawLines();
    spiral4.drawPoints("I", "J", "K", "L", "cc");
    spiral4.drawSpiralThrough3Points();
  } 





  pt[] startB = spiral1.drawSpiralPattern(250);  

  pt[] startA = spiral2.drawSpiralPattern(430);   

  pt[]  endB = spiral3.drawSpiralPattern(360);  

  pt[] endA = spiral4.drawSpiralPattern(500);
  
    SpiralObj betweenSO2AndSO4 = new SpiralObj(startA[0], startA[1], endA[0], endA[1]);
    SpiralObj betweenSO1AndSO3 = new SpiralObj(startB[0], startB[1], endB[0], endB[1]);
     betweenSO1AndSO3.setColor(white);
    betweenSO2AndSO4.setColor(white);
    if (keyPressed && key=='s') {
      betweenSO1AndSO3.setColor(black);
      betweenSO2AndSO4.setColor(black);
  } 

  pt[] sideA = betweenSO2AndSO4.drawStaticSpiralPattern(.1);
  pt[] sideB = betweenSO1AndSO3.drawStaticSpiralPattern(.1);

  SpiralObj[] spirals = new SpiralObj[sideA.length/2];
  pt[][] points = new pt[sideA.length/2][0];

  for (int i = 0; i< sideA.length; i+=2) {
    spirals[i/2] = new SpiralObj(sideA[i], sideA[i+1], sideB[i+1], sideB[i]);
    points[i/2] = spirals[i/2].drawStaticSpiralPattern(.3, cyan);
    //spirals[i].drawLines();
    //spirals[i].drawSpiralThrough3Points();
  }
  beginShape();
  pen(cyan, 2);
  for (int i = 0; i<points.length; i++) {

    for (int j = 0; j<points[0].length; j++) {
      if (i+1 != points.length) {
        edge(points[i][j], points[i+1][j]);
        if (j + 2 < points[i].length) {
          edge(points[i][j], points[i+1][j+2]);
        }
      }
    }
  }
  endShape();




  //SpiralObj spiral3 = new SpiralObj(x[0], x[1], y[0], y[1]);
  //spiral3.drawPoints("aa","bb","cc","dd","ee");
  //spiral3.drawSpiralPattern(440);
  //spiral3.drawStaticSpiralPattern(0.08);
  //spiral3.drawSpiralThrough3Points();

  if (recordingPDF) endRecordingPDF();  // end saving a .pdf file with the image of the canvas

  fill(black); 
  displayHeader(); // displays header
  if (scribeText && !filming) displayFooter(); // shows title, menu, and my face & name 

  if (filming && (animating || change)) snapFrameToTIF(); // saves image on canvas as movie frame 
  if (snapTIF) snapPictureToTIF();   
  if (snapJPG) snapPictureToJPG();   
  change=false; // to avoid capturing movie frames when nothing happens
}  // end of draw end of draw