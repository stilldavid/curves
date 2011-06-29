/**
Eyeo Data Viz class 201 - Curves and Colors
Wes Grubbs (@pitchinteractiv)

Created on: June 28, 2011

NYT vs Contract Spending - Barred
This piece compares Federal contract spending in various departments with the media attention
for similarly related keywords in the New York Times.
Once the data is loaded, we do some calculating to determine the positions of the left and
right sides of our curves.

*/

ArrayList lineData = new ArrayList();; //array of LineData objects. These contain the positions of the (left & right) boxes for a given dept
float opacity = 0.9; //opacity for our sketch, 90%

/* Colors! curColor is determined by interpolating between c1 & c2 */
color curColor;
color c1 = color(0, 102, 153);
color c2 = color(204, 102, 0);

float data[][] = {
  { 32, 45, 0, 37, 160, 33, 31, 55, 48, 37, 57, 57 },
  { 380, 349, 0, 380, 416, 416, 630, 560, 630, 574, 524, 524 },
  { 127, 164, 0, 153, 263, 157, 154, 202, 241, 62, 400, 400 },
  { 15, 59, 0, 28, 30, 31, 22, 34, 41, 69, 34, 34 },
  { 231, 533, 0, 489, 322, 237, 156, 132, 229, 185, 266, 266 },
  { 3, 0, 0, 3, 3, 5, 0, 0, 1, 1, 0, 0 },
  { 60, 118, 0, 93, 101, 382, 96, 152, 226, 174, 327, 327 },
  { 56, 44, 0, 51, 29, 61, 110, 67, 40, 68, 12, 12 },
  { 42, 29, 0, 8, 18, 31, 12, 19, 24, 15, 16, 16 },
  { 35, 38, 0, 56, 13, 47, 59, 55, 69, 42, 36, 36 },
  { 145, 67, 0, 0, 86, 182, 121, 217, 219, 423, 139, 139 },
  { 78, 136, 0, 94, 112, 127, 218, 234, 478, 156, 230, 230 }
};

void setup() {
  size(1200,1000);
  smooth();
  colorMode(HSB);
}
void draw() {

  background(255);

  //grab the max # sold ever
  float max = 0;
  float[] runningTot = new float[12];

  for(int i = 0; i < runningTot.length; i++)
    runningTot[i] = 0; // init all the totals

  // set all the max vals
  for(int i = 0; i < data.length; i++) {
    int tot = 0;
    for(int j = 0; j < data[1].length; j++) {
      tot += data[i][j];
      //runningTot[i] = data[i][j];
    }
    if ( tot > max )
      max = tot;
  }

  float barWidth = width / (data[1].length - 1); // how big each bar should be

  // Loop for each product
  for(int i = 0; i < data.length; i++) {
    float yPos = 0;
    float xPos = 0;
    // loop for each number
    LineData ld = new LineData();
    //print ("\n");
    for(int j = 0; j < data[i].length; j++) {
      float spent = data[i][j];

      // determine color by interpolating between c1,c2
      color c = lerpColor(c1,c2,(float)i/(float)data[i].length);

      // determine bar height
      float barHeight = map(spent, 0, max, 0, height);

      // update yPos for next SpendingData obj
      yPos = runningTot[j];
      ld.XPos[j] = j * barWidth;
      ld.YPosStart[j] = yPos; // top
      ld.YPosEnd[j] = yPos + barHeight; // bottom
      ld.col = c;

      // update fraction
      //print(j + ": " + runningTot[j] + "\n");
      runningTot[j] += barHeight;
    }
    //add LineData to array, draw later
    lineData.add(ld);
  }

  /**
  Now that all the LineData is setup properly,
  We can draw everything!
  */
  for(int i = 0; i < lineData.size(); i++) {
    noFill();
    LineData ld = (LineData) lineData.get(i);
    //set colors
    stroke(ld.col,255*opacity);
    fill(ld.col, 255* opacity);
    //call draw on LineData object
    ld.draw(barWidth);
    ld.bar();
  }

  //save it out! 
  saveFrame("output.png");
};

