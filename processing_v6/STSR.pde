class STSR {
  int xs, ys;
  PImage bc;
  boolean selection = true;

  STSR(int xpos, int ypos) {
    xs = xpos;
    ys = ypos;
    u = l = r = d = #FFFFFF;
    bc = loadImage("british-columbia-map.gif");
  }

  void display(int x, int y) {
    stroke(0);
    imageMode(CORNERS);
    image(bc, x-bc.width/2, y-bc.height/2);
    //text(mouseY-y, 500, 530);
    //text(mouseX-x, 500, 500);
    textSize(20);
    fill(255);
    int tx = 100;
    int ty = 100;
    for (int j = -10; j<10; j++) {
      for (int i = -10; i<10;i++) {
        point(i*100+x, j*100+y);
      }
    }
    if (selection) {
      fill(#0000DD, 100);
      rectMode(CENTER);
      rect(xref+x, yref+y, 100, 100);
    }
    arrows();
  }

  void arrows() {
    fill(u);
    beginShape();
    vertex(400, 10);
    vertex(410, 20);
    vertex(390, 20);
    endShape(CLOSE);
    fill(d);
    beginShape();
    vertex(400, 590);
    vertex(410, 580);
    vertex(390, 580);
    endShape(CLOSE);
    fill(l);
    beginShape();
    vertex(10, 300);
    vertex(20, 310);
    vertex(20, 290);
    endShape(CLOSE);
    fill(r);
    beginShape();
    vertex(790, 300);
    vertex(780, 310);
    vertex(780, 290);
    endShape(CLOSE);
  }
}

