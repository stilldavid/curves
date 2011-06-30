/**
 * Curves - Visualizing trends in data
 *
 * Created by David Stillman
 *
 * Inspired by and partly stolen from Wes Grubbs (@pitchinteractiv)
*/

ArrayList lineData = new ArrayList();; //array of LineData objects. These contain the positions of the (left & right) boxes for a given dept
float opacity = 0.7; //opacity for our sketch, 90%

/* Colors! curColor is determined by interpolating between c1 & c2 */
color curColor;
color c1 = color(0, 102, 153);
color c2 = color(204, 102, 0);

String[] lines;
int recordCount;
float[][] data;

void setup() {
  size(3200,980);
  smooth();
  colorMode(HSB);

  lines = loadStrings("data.csv");
  String[] counter = split(lines[1], ","); // Load data into array
  data = new float[lines.length][counter.length];

  for (int i = 0; i < lines.length - 1; i++) {
    String[] pieces = split(lines[i], ","); // Load data into array
    for (int j = 0; j < pieces.length - 1; j++) {
      data[i][j] = float(pieces[j]);
      recordCount++;
    }
  }

}
void draw() {

  background(255);

  //grab the max # sold ever
  float max = 0;
  float[] runningTot = new float[data[1].length];
  float[] columnTot = new float[data[1].length];

  for(int i = 0; i < runningTot.length; i++)
    runningTot[i] = 0; // init all the totals

  // set max column val and set column totals
  for(int i = 0; i < data[0].length; i++) {
    int tot = 0;
    for(int j = 0; j < data.length; j++) {
      tot += data[j][i];
      columnTot[i] += data[j][i];
    }
    if ( tot > max )
      max = tot;
  }

  // scale totals accordingly
  for(int i = 0; i < columnTot.length; i++)
    columnTot[i] = map(columnTot[i], 0, max, 0, height);

  float barWidth = width / (data[1].length - 1); // how big each bar should be

  // Loop for each product
  for(int i = 0; i < data.length; i++) {
    float yPos = 0;
    float xPos = 0;
    // loop for each number
    LineData ld = new LineData();

    for(int j = 0; j < data[i].length; j++) {
      float spent = data[i][j];

      // determine color by interpolating between c1,c2
      color c = lerpColor(c1,c2,(float)i/(float)data[i].length);

      // determine bar height
      float barHeight = map(spent, 0, max, 0, height);

      // update yPos for next SpendingData obj
      yPos = runningTot[j];

      yPos = map(yPos/columnTot[j], 0, 1, (height/2) - (columnTot[j]/2), (height/2) + (columnTot[j]/2));

      ld.XPos[j] = j * barWidth;
      ld.YPosStart[j] = yPos; // top
      ld.YPosEnd[j] = yPos + barHeight; // bottom
      ld.col = c;

      // update fraction
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
    //ld.bar();
  }

  //save it out! 
  saveFrame("output.png");
  noLoop();
};

