public class LineData {

  float[] XPos = new float[data[1].length];
  float[] YPosStart = new float[data[1].length];
  float[] YPosEnd = new float[data[1].length];

  color col;

  void bar() {
    for(int i = 0; i < XPos.length; i++) {
      print ( XPos[i] + " " + YPosStart[i] + " " + YPosEnd[i] + "\n");
    }
  }

  /*
  Draws a bezier curve shape between the left side and the right side.
  Additionally fills in rects on each side as start and end points
  */
  void draw(float barWidth) {
     //.3333 & .6666 used to calculate bezier control vertexes
    float lowValue = 1.0/3.0;
    float highValue = 2.0/3.0;

    // size of stuff
    int s = XPos.length - 1;

    // begin a filled shape
    beginShape();

    // vertexes for the left side rect
    vertex(XPos[0], height-YPosEnd[0]); // bottom left
    vertex(XPos[0], height-YPosStart[0]); // top left

    //print("\n\n");

    for(int i = 2; i < XPos.length; i++) {
      if(i >= XPos.length - 1)
        break;

      // top edge of the bezier from left to right
      //noFill();
      //ellipse(XPos[i] * highValue + XPos[i+1] * lowValue, YPosStart[i], 3, 3);
      //ellipse(XPos[i] * lowValue + XPos[i+1] * highValue, YPosStart[i+1], 3, 3);
      //fill(this.col, 255* opacity);
      //ellipse(XPos[i+1], YPosStart[i+1], 3, 3);
      //text(i, XPos[i+1], YPosStart[i+1] - 5);
      bezierVertex(XPos[i] * highValue + XPos[i+1] * lowValue, YPosStart[i], XPos[i] * lowValue + XPos[i+1] * highValue, YPosStart[i+1], XPos[i+1], YPosStart[i+1]);

      // parameters
      // bezierVertex(cpx1, cpy1, cpx2, cpy2, x, y);

    }

    // vertices for the right side rect
    vertex(XPos[s], YPosStart[s]); // top right
    vertex(XPos[s], YPosEnd[s]); // bottom right

    for(int i = XPos.length - 1; i > 0; i--) {
      if(i <= 0)
        break;
      //bottom edge of the bezier from right to left
      bezierVertex(XPos[i] * highValue + XPos[i-1] * lowValue, YPosEnd[i], XPos[i] * lowValue + XPos[i-1] * highValue, YPosEnd[i-1], XPos[i-1], YPosEnd[i-1]);
    }

    endShape(CLOSE);
  }
}

