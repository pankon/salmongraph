class STVL {
  //Mode variables: lmode, 0 - month, 1 - year, 2 - 10 yr
  int lmode = 0;

  //Time Variables
  String[] months = {
    "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"
  };
  int month = mg;



  //Position variables
  int x;
  int y;

  //Data variables
  PImage load = loadImage(str(year)+"_" + str(month)+".png");
  PImage stor = loadImage(str(year)+"_" + str(month)+".png");
  int [][] a = new int[12][32]; //hour, day - saves text file in form Month_Year.txt: January_2012.txt
  int scly = 0;

  //Calendar variables
  int[] daymax = {
    31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31
  };

  int o = 0;
  float t = 0;
  float av = 0;
  int c1a = 0;
  int c2a = 0;
  int c3a = 0;
  int c4a = 0;
  
  //Graph variables
  int gx = 200;
  int gy = 50;
  int gw = 500;
  int gh = 400;

  STVL(int xp, int yp) {
    x = xp;
    y = yp;
    size(800, 600);
    background(255);
  }

  void display(int xp, int yp) {
    x = xp;
    y = yp;
    if (lmode == 0) {
      lmonth(scly = mxi(0, 11, year, year)/200);
    }
    if (lmode == 1) {
      lyear(0, 360, true, year, scly = mxi(0, 11, year, year)/200);
    }
    if (lmode == 2) {
      l10yr();
    }
    graph();
  }

  void graph() {
    stroke(0);
    line(gx, gy+gh, gx+gw, gy+gh);
    line(gx, gy, gx, gy+gh);
    fill(0);
    for (int i = gy-10; i < gy+gh; i+=20) {
      text(scly*((gh+gy-10-i)/10), gx-40, i);
    }
    for (int i = 0; i < 1; i+=12) {
      for (int j = 0; j < 12; j++) {
        text(months[j].charAt(0), (i*12+j)*gw/12+gx+50, gy+gh+20);  //change this.
      }
    }
  }


  void dataloadmonth(int m, int yr) {
    load = loadImage(str(yr)+"_" + str(m)+".png");
    load.loadPixels();    
    for (int i = 0; i < 32; i++) {
      int c1 = int(red(load.pixels[(x+400)/10*load.width+(y+400)/10+i*80]));
      int c2 = int(green(load.pixels[(x+400)/10*load.width+(y+400)/10+i*80]));
      int c3 = int(blue(load.pixels[(x+400)/10*load.width+(y+400)/10+i*80]));
      int c4 = int(alpha(load.pixels[(x+400)/10*load.width+(y+400)/10+i*80]));
      int value = c1 + c2*int(pow(10, 1))+ c3*int(pow(10, 2)) + c4*int(pow(10, 4));
      a[m][i] = value;
    }
    load.updatePixels();
  }

  int mxi(int startmonth, int endmonth, int startyear, int endyear) {
    int currentmax = 0;
    for (int j = startyear; j < endyear+1; j++) {
      for (int k = startmonth; k < endmonth; k++) {
        load = loadImage(str(j)+"_" + str(k)+".png");
        load.loadPixels();
        for (int i = 0; i < 31; i++) {
          c1a = int(red(load.pixels[(x+400)/10*load.width+(y+400)/10+i*80]));
          c2a = int(green(load.pixels[(x+400)/10*load.width+(y+400)/10+i*80]));
          c3a = int(blue(load.pixels[(x+400)/10*load.width+(y+400)/10+i*80]));
          c4a = int(alpha(load.pixels[(x+400)/10*load.width+(y+400)/10+i*80]));
          int value = c1a + c2a*int(pow(10, 1))+ c3a*int(pow(10, 2)) + c4a*int(pow(10, 4));
          if (value > currentmax) {
            currentmax = value;
          }
        }
        load.updatePixels();
      }
    }
    return currentmax;
  }

  void lmonth(int scy) {
    dataloadmonth(mg, year);
    for (int i = 1; i < daymax[mg]; i++) {
      stroke(100);
      line(gw/daymax[mg]*i+gx, a[mg][i]/scy, gw/daymax[mg]*(i-1)+gx, a[mg][i-1]/scy);
    }
    stroke(0);
  }

  void lyear(int ofs, float sc, boolean li, int yer, int scy) {
    int d = 0;
    for (int j = 0; j < 12; j++) {
      dataloadmonth(j, yer);
    }
    stroke(100);
    for (int i = 1; i < daymax[0]; i++) {
      d++;
      if (li)line(gw/sc*(d+ofs)+gx, a[0][i]/scy, gw/sc*(d-1+ofs)+gx, a[0][i-1]/scy);
      else point(gw/sc*(d+ofs)+gx, a[0][i]/scy);
    }
    for (int j = 1; j< 12; j++) {
      // println(a[j-1][daymax[j-1]] + " " + j);
      if (li)line(gw/sc*(d-1+ofs)+gx, a[j-1][daymax[j-1]-1]/scy, gw/sc*(d+ofs)+gx, a[j][0]/scy);
      for (int i = 1; i < daymax[j]; i++) {
        d++;
        if (li)line(gw/sc*(d+ofs)+gx, a[j][i]/scy, gw/sc*(d-1+ofs)+gx, a[j][i-1]/scy);
        else point(gw/sc*(d+ofs)+gx, a[j][i]/scy);
      }
    }
    stroke(0);
  }

  void l10yr() {
    int max = mxi(0, 11, year, year+10);
    scly = max;
    for (int yr = year; yr < year+10; yr++) {
      lyear((yr-year)*365, 365*10, true, yr, max/200);  //Do breaks add readability?
    }
  }
}

