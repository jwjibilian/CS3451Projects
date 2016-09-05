class Spirals {
  SpiralObj[] spi = new SpiralObj[4];
  
   SpiralObj closest;

  Spirals() {
  }
 
  void dragPicked() {
    closest.drag();
    
  }

  void pickClosest(pt point) {
    int pv =0;
    for (int i=1; i<spi.length; i++) 
      if (spi[i].distanceTo(point)<spi[pv].distanceTo(point)) pv=i;
    closest = spi[pv];
  }
  
  
}