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
String stateStr = "Please create a polygon. You can drag points by clicking. You can create points by holding 'i' and dragging." 
 +"\n You can delete them by pressing 'd' and clicking. Hold 's', click and drag to cut. press 'j' when you want to start movng pieces.";

Polygon moving, moveToHere;






//**************************** initialization ****************************
void setup()               // executed once at the begining 
{
  polygons.add(x);
  size(1400, 800);            // window size
  frameRate(30);             // render 30 frames per second
  smooth();                  // turn on antialiasing
  josh = loadImage("data/josh.jpg");  // load image from file pic.jpg in folder data *** replace that file with your pic of your own face
  gabriel = loadImage("data/Gabriel.jpg");
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
      //fill(red);
      solution.draw(red);
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
      //show(G, 10); // shows centroid
    }

    if (currentState == GameStates.CREATION) {
      pen(c, 6);
      arrow(A, B);
    }

    stroke(red);
  } else if (currentState == GameStates.PLAYER) {
    if (solution != null) {
      pen(black, 3);
      //fill(red);
      solution.draw(red);
    }
    for (Polygon thing : polygons) {
      pen(black, 3); 
      if (moving != null && thing == moving) {
        fill(blue);
      } else {
        fill(yellow);
      }
      thing.draw();
      //thing.showIds();
      pen(red, 6);
      pt G=thing.getCentroid();
//show(G, 10); // shows centroid
    }

    if (moving != null) {
      for (Polygon thing : ghosts) {
        if (thing.isMouseInside() || thing == moveToHere) {
          fill(blue);
          pen(black, 3);
          thing.draw();
        }
      }
    }

    if (moving != null && moveToHere != null) {
      currentState = GameStates.MOVING;
      pt[] end = moveToHere.get();
      pt[] start = moving.get();
      moving.setSpiral(end[0].copy(), end[1].copy(), start[0].copy(), start[1].copy());
    }
  } else if (currentState == GameStates.MOVING) {
    pt[] end = moveToHere.get();
    pt[] location = moving.get();
    for (Polygon thing : polygons) {
      if (thing != moving) {
        for (pt checking : location) {
          if (thing.isPtInside(checking)) {
            println("COLLISION!!!!");
            currentState = GameStates.MOVINGBACK;
            moving.setDec(true);
          }
        }

        for (pt checking : thing.get()) {
          if (moving.isPtInside(checking)) {
            println("COLLISION!!!!");
            currentState = GameStates.MOVINGBACK;
            moving.setDec(true);
          }
        }
      }
    }
    if (abs(location[0].x - end[0].x) > 0.01 || abs(location[0].y - end[0].y) > 0.01) {

      if (solution != null) {
        pen(black, 3);
        //fill(red);
        solution.draw(red);
      }

      if (moving != null) {
        for (Polygon thing : ghosts) {
          if (thing.isMouseInside() || thing == moveToHere) {
            fill(blue);
            pen(black, 3);
            thing.draw();
          }
        }
      }


      for (Polygon thing : polygons) {
        pen(black, 3); 
        if (moving != null && thing == moving) {
          fill(blue);
        } else {
          fill(yellow);
        }
        thing.draw();
        //thing.showIds();
        pen(red, 6);
        //pt G=thing.getCentroid();
        //show(G, 10); // shows centroid
      }



      pt[] start = moving.get();
      moving.spiralMove(start[0], start[1]);
    } else {

      pt[] notGhost = moving.get();
      pt[] theGhost = moving.get();
      boolean isSolution = true;
      if (notGhost.length == theGhost.length) {
        for (int i = 0; i < theGhost.length; i++) {
          if (abs(location[i].x - end[i].x) > 0.1 || abs(location[i].y - end[i].y) > 0.1) {
            isSolution = false;
          }
        }
      }
      if (!isSolution) {
        currentState = GameStates.MOVINGBACK;
      } else {

        moving.setTime(0);
        moving = null;
        moveToHere = null;

        currentState = GameStates.PLAYER;
      }
      drawPolygons();
    }
  } else if (currentState == GameStates.MOVINGBACK) {
    pt[] end = moving.getStart();
    pt[] location = moving.get();
    if (abs(location[0].x - end[0].x) > 0.01 || abs(location[0].y - end[0].y) > 0.01) {

      if (solution != null) {
        pen(black, 3);
        //fill(red);
        solution.draw(red);
      }

      if (moving != null) {
        for (Polygon thing : ghosts) {
          if (thing.isMouseInside() || thing == moveToHere) {
            fill(blue);
            pen(black, 3);
            thing.draw();
          }
        }
      }


      for (Polygon thing : polygons) {
        pen(black, 3); 
        if (moving != null && thing == moving) {
          fill(blue);
        } else {
          fill(yellow);
        }
        thing.draw();
        //thing.showIds();
        pen(red, 6);
        //pt G=thing.getCentroid();
        //show(G, 10); // shows centroid
      }



      pt[] start = moving.get();
      moving.spiralMove(start[0], start[1]);
    } else {
      drawPolygons();
      moving.setTime(0);
      moving = null;
      moveToHere = null;

      currentState = GameStates.PLAYER;
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


void drawPolygons() {
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
   // thing.showIds();
    pen(red, 6);
    pt G=thing.getCentroid();
    //show(G, 10); // shows centroid
  }
}