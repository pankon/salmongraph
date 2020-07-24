class STE {
  //Cell specific variables


  PFont font;
  int cofs = 0;  //cell offset
  int yxc = 359;


  //Shared colors
  color h = 150; //highlight color


  //Calendar alg. variables
  int day = 1;
  int daytotal = 0;
  int month = 0;
  int initialyear = 1982;
  int year = 1982;
  int c1 = round(year/100-17);
  int c2 = (year)%100/4;            //every four years except every hundred except every thousand
  int c3 = (year)%100;
  int c4 = 0;
  int q = 0;                          //Source of calendar algorithm: http://en.wikipedia.org/wiki/Calculating_the_day_of_the_week
  String m = "April 13, 2000";
  String[] months = {
    "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"
  };
  String[] days = {
    "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"
  };
  int[] cent = {
    4, 2, 0, 6, 4, 1, 0, 6, 4, 2
  };
  int[][] tmont = {
    {
      0, 3, 3, 6, 1, 4, 6, 2, 5, 0, 3, 5
    }
    , 
    {
      6, 2, 3, 6, 1, 4, 6, 2, 5, 0, 3, 5
    }
  };
  int[] daymax = {
    31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31
  };
  int mg = 0;//global month storage
  String[] mo = split(m, " ");
  int ctx = 0;     
  int cty = 0;        
  int ctxc = 0;      
  int ctyc = 0;

  //Data variables
  PImage load;
  int [][] a = new int[12][32]; //hour, day - saves text file in form Month_Year.txt: January_2012.txt
  int x, y;

  STE (int xs, int ys, int yr) {
    x = xs;
    y = ys;
    year = yr;
    for (int j = 0; j < 12; j++) {
      for (int i = 0; i < 7; i++) {
        rect(amxx+i*amxw, amxy+j*amxh, amxw, amxh);
        amxc[i+j*7] = 255;
        amxs[i+j*7] = "";
      }
    }
    calgor();
    dataloadmonth(cofs, year);
    amsxtoa(cofs, 0);
    dataloadmonth(cofs+1, year);
    amsxtoa(cofs, 1);
  }

  void display(int xp, int yp, int yr) {
    year = yr;
    x = xp;
    y = yp;
    cells();
    calendarcells();
    carrows();
  }

  void calendarcells() {
    text(year, yxc-textWidth(str(year))/2, 45);
    textSize(10);
    for (int i = 0; i < 7; i++) {
      text(days[i], amxx+i*amxw+1, amxy+textAscent()*2.5);
    }
    textSize(12);
    for (int k = 0; k < 2; k++) { 
      if (k+cofs < 12) {
        mg = k+cofs;
      }
      mo[0] = months[mg];
      calgor();
      int d3 = 0;
      stroke(0);
      fill(0);
      text(months[mg], amxx+1, amxy+k*amxh*7+textAscent());
      for (int j = 1+k*7; j < 7+k*7 && j < 12; j++) {
        for (int i = 0; i < 7; i++) {
          fill(255);
          if (i == ctxc && j-k*7-1 == ctyc) {
            d3 = 1;
          }
          if (j == cty-k*7-1) {
            if (i == ctx) {
              fill(h);
            }
          }
          fill(0);
          if (d3 > 0) {
            if (d3<=daymax[mg]) {
              text(d3, amxx+i*amxw+1, amxy+j*amxh+textAscent());
              ychol[i+(j)*7] = true;
            }
            else {
              ychol[i+(j)*7] = false;
            }
            d3++;
          }
          else {
            ychol[i+(j)*7] = false;
          }
        }
      }
      if (cofs == 11) {
        k = 1;
        for (int j = 1+k*7; j < 7+k*7 && j < 12; j++) {
          for (int i = 0; i < 7; i++) {
            ychol[i+(j)*7] = false;
          }
        }
        k = 2;
      }
    }
  }


  void cells() {
    for (int j = 0; j < 12; j++) {
      for (int i = 0; i < 7; i++) {
        if (ychol[i+j*7]) {
          fill(amxc[i+j*7]);
          rect(amxx+i*amxw, amxy+j*amxh, amxw, amxh);
          fill(0);
          text(amxs[i+j*7], amxx+i*amxw+0.1*amxw, amxy+j*amxh+textAscent()*2);
          if (amxb[i+j*7]) {
            stroke(0, int(millis()%500>300)*255);
            line(amxx+i*amxw+0.1*amxw+textWidth(amxs[i+j*7]), amxy+j*amxh+textAscent()*2, amxx+i*amxw+0.1*amxw+textWidth(amxs[i+j*7]), amxy+j*amxh+textAscent());
            stroke(0);
          }
        }
      }
    }
  }

  void calgor() {
    mo[2] = str(year);
    mo[1] = str(day) + ",";
    m = mo[0] + " " + mo[1] + " " + mo[2];
    c1 = round(year/100-17);
    c2 = (year)%100/4;            //every four years except every hundred except every thousand
    c3 = (year)%100;
    c4 = 0;
    c1 = cent[c1];
    for (int i = 1; i < 13; i++) {
      String[] m2 = match(mo[0], months[i-1]);
      if (m2 != null) {
        q = 0;
        c4 = i;
        mg = i-1;
        if (float(year/4) == year/4) {
          q = 1;
        }
      }
    }

    c4 = tmont[q][c4-1];
    ctxc = (c1+c2+c3+c4+1)%7;    //numbered calendar
    ctyc = 1/7;
    ctx = ctxc;
    cty = ctyc;
  }


  void dataloadmonth(int m, int yr) {
    int xlax = x;
    int ylast = y;
    println(xref + " " + yref);
    x = xref;
    y = yref;
    try {
      load = loadImage(str(yr)+"_" + str(m)+".png");
      load.loadPixels();    
      for (int i = 0; i < 32; i++) {
        int c1 = int(red(load.pixels[(x)/10*load.width+(y)/10+i*80]));
        int c2 = int(green(load.pixels[(x)/10*load.width+(y)/10+i*80]));
        int c3 = int(blue(load.pixels[(x)/10*load.width+(y)/10+i*80]));
        int c4 = int(alpha(load.pixels[(x)/10*load.width+(y)/10+i*80]));
        int value = c1 + c2*int(pow(10, 1))+ c3*int(pow(10, 2)) + c4*int(pow(10, 4));
        a[m][i] = value;
      }
      load.updatePixels();
    } 
    catch (NullPointerException e) {
      for (int i = 0; i < 32; i++) {
        a[m][i] = 0;
      }
    }
    x = xlax;
    y = ylast;
  }

  void amsxtoa(int m, int of) {
    for (int i = 0; i < 31; i++) {
      amxs[(i+7+of*7*6+ctx)*int((i+7+of*7*6+ctx)<7*12)] = str(a[m][i]);
    }
  }

  void carrows() {
    int yax = yxc-2*int(textWidth(str(year)));
    int yay = 40;
    fill(yamc);
    beginShape();
    vertex(yax, yay);
    vertex(yax+10, yay-10);
    vertex(yax+10, yay+10);
    endShape(CLOSE);
    yax = yxc+2*int(textWidth(str(year)));
    yay = 40;
    fill(yac);
    beginShape();
    vertex(yax, yay);
    vertex(yax-10, yay+10);
    vertex(yax-10, yay-10);
    endShape(CLOSE);
    int mx = 750;
    int my = 100;
    fill(mu);
    beginShape();
    vertex(mx, my);
    vertex(mx-10, my+10);
    vertex(mx+10, my+10);
    endShape(CLOSE);
    mx = 750;
    my = 540;
    fill(md);
    beginShape();
    vertex(mx, my);
    vertex(mx-10, my-10);
    vertex(mx+10, my-10);
    endShape(CLOSE);
  }
}
