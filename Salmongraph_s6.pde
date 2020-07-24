/*

 Salmongraph program version 6.
 Written and developed by Nathan Pankowsky.
 Sources for various design choices are listed
 at the bottom of the program if applicable.
 
 Allows spacial region selection and temporal entry/view of data (SpaceTime or ST)
 Allows temporal region selection and spacial entry/view of data (TimeSpace or TS)
 
 The mode of the system is controlled by a hideable box on
 the top left of the screen. 
 The modes of the system are kept as classes, with inputs of
 the location (ST) and date (TS).
 Each mode has individual mouse, keyboard, display functions,
 and data loading functions.
 Shared functions are mouse selection of mode, the navigator() function.
 Amongst the functions with map functionality, the MMF, or map moving class or function
 is shared.
 
 Classes are as follows:
 
 ST:
 STSR - Select of a spacial region for temporal entry
 STE - Enter Data, by calendar for indicated region
 STVS - View Data, Pictograph display of data for varying time 
 scales for indicated region
 STVL - View Data, Line graph display of data for varying time
 scales for indicated region
 
 TS:
 Note: The select of temporal region is done
 in the Navigator.
 TSVS - View Data, Static in heatmap format
 TSVD - View Data, Dynamic in heatmap format
 TSE - Enter Data, in map grid format
 
 Misc:
 MMF - Displays desired region, allows for moving & zoom of map
 
 General Functions, general information:
 Buttons general information:
 All buttons rely on the concept of color mapping. 
 This means that every button can be in any shape, and each has a unique
 color identification that is set in some functions described below.
 
 Keyboard:
 keyReleased() - In Map functionality, used to reset button colors
 keyPressed() - In Map functionality, used to move the view of map. Also used to call entry(int i, int j).
 entry(int i, int j) - used to determine which text box, if any, is selected and ready to be entered into.
 This function sets a string in an array to the value of that entered and can deselect a text box. 
 
 Mouse:
 mouseReleased() - Used in each mode and in the Navigator function as a means of resetting 
 the color of a button.
 mousePressed() - Functions called: bselect(), tselect(int i, int j), selectcolor(). 
 Each has a switch(get pixel color at mouse position) with cases pertaining to specific functionality.
 
 Button functions:
 Each is stored under a name such as arrows(), returnandback(), arrowsnbuttons(), or carrows().
 These are seperated or grouped by functionality. Each button has three shared purposes: 
 1. To set the color of a button
 2. To draw said button
 3. To place text in box as necessary. 
 This is assisted by the shared function nbox(int xpos, int ypos, int width, int height, color of the button, and the String contained - "" if no string)
 and arrow(int xpos, int ypos, color of the arrow, int direction - 0 - left, 1 - right, 2 - up, 3 - down).
 
 Data functions:
 datawriteallst(int startmonth, int endmonth, int startyear, int endyear, int x, int y) - a function that writes the data from a specified time period to the database for a spacial region.
 datawriteallts(int day, int month, int year) - a function that writes one data point per date for entire map.
 dataloadmonthst(int m or indicated month, int yr or indicated year) - loads data for a month, year in a particular spacial region.
 int mxist(int startmonth, int endmonth, int startyear, int endyear) - loads data for a large amount of data, used primarily in functions where time periods larger than one month are displayed.
 dataloaddayts(int day, int month, int year) - a function that loads data points for use in map - based view or edit of data.
 
 Functions as used by individual classes will be described as used.
 
 Enjoy, and attribute all uses of functions to Nathan Pankowsky unless otherwise stated!
 
 */

//Shared spacial
int x = 200;
int y = 200;

//Shared temporal
int day = 0;  //Day
int mg = 0; //Month 
int year = 1989; //Year

//Navigator specific
int mode = 0; //0 = STSR, 1 = STE, 2 = STVL, 3 = STVS; 4 = TSE, 5 = TSVS, 6 = TSVD
boolean stbool = (mode == 0 || mode == 1 || mode == 2 || mode == 3);
boolean visible = true;

//Mode classes
STSR STSR;
STE STE;
STVL STVL;

//STSR Specific
color u, d, l, r;
int xref = 0;
int yref = 0;

//STE Specific
color yac = #000100;
color yamc = #000200;
color mu = #000300;
color md = #000400;
color[] amxc = new color[7*12];
boolean[] amxb = new boolean[7*12];
boolean[] ychol = new boolean[7*12]; //can the cells indeed be filled? 
String[] amxs = new String[7*12];
int amxx = 90;
int amxy = 80;
int amxw = 90;
int amxh = 40;

//Misc.
PFont font;


void setup() {
  size(800, 600);
  background(255);
  font = loadFont("Arial-BoldMT-48.vlw");
  STSR = new STSR(x, y);
  STE = new STE(x, y, year);
  STVL = new STVL(x, y);
  textFont(font, 12);
  navigator();
}

void draw() {
  background(255);
  if (mode == 0) {
    STSR.display(x, y);
  }
  if (mode == 1) {
    STE.display(xref, yref, year);
  }
  if (mode == 2) {
    STVL.display(xref, yref);
  }
  textSize(12);
  navigator();
}

void mousePressed() {
  modesel();
  if (mode == 0) {
    STSRmouseP();
  }
  if (mode == 1) {
    STEmouseP();
  }
}

void keyPressed() {
  if (mode == 0) {
    STSRkeyP();
  }
  if (mode == 1) {
    STEkeyP();
  }
}

void mouseReleased() {
  if (mode == 0) {
    STSRcolreset();
  }
  else if (mode == 1) {
    STEcolreset();
  }
}

void keyReleased() {
  STSRcolreset();
}

void modesel() {
  color select;
  select = get(mouseX, mouseY);
  if (visible) {
    int xp = 10;
    int yp = 10;
    int wp = 200;
    int hp = 80;
    if (stbool) {
      if (mouseX > xp+8 && mouseX < xp+8+textWidth("Select Region")*1.1 && mouseY > yp+50-textAscent() && mouseY < yp+50+textAscent()*0.1) {
        mode = 0;
      }
      if (mouseX > xp+8 && mouseX < xp+8+textWidth("Enter")*1.1 && mouseY > yp+70-textAscent() && mouseY < yp+70+textAscent()*0.1) {
        mode = 1;
      }
      if (mouseX > xp+8+textWidth("Enter")*1.2 && mouseX < xp+8+textWidth("Enter")*1.2+textWidth("View")*1.05 && mouseY > yp+70-textAscent() && mouseY < yp+70+textAscent()*0.1) {
        mode = 2;
      }
      if (mouseX > xp+153 && mouseX < xp+153+40 && mouseY > yp+50-textAscent() && mouseY < yp+50+textAscent()*0.2+20) {
        stbool = false;
        mode = 4;
      }
    }
    else {
      if (mouseX > xp+8 && mouseX < xp+8+textWidth("Enter")*1.1 && mouseY > yp+70-textAscent() && mouseY < yp+70+textAscent()*0.1) {
        mode = 4;
      }
      if (mouseX > xp+8+textWidth("Enter")*1.2 && mouseX < xp+8+textWidth("Enter")*1.2+textWidth("View")*1.05 && mouseY > yp+70-textAscent() && mouseY < yp+70+textAscent()*0.1) {
        mode = 5;
      }
      if (mouseX > xp+108 && mouseX < xp+108+40 && mouseY > yp+50-textAscent() && mouseY < yp+50+textAscent()*0.2+20) {
        stbool = false;
        mode = 0;
      }
    }
  }
  if (select == #333333) {
    visible = false;
  }
  if (select == #313131) {
    visible = true;
  }
}

void navigator() {
  stbool = (mode == 0 || mode == 1 || mode == 2 || mode == 3);
  int xp = 10;
  int yp = 10;
  int wp = 200;
  int hp = 80;
  if (visible) {
    roundRect(xp, yp, wp, hp, 10, 200, true);
    stroke(0);
    line(xp+10, yp+25, xp+wp-10, yp+25);
    if (stbool) {
      roundRect(xp+108, yp+50-textAscent(), 40, 20+textAscent()*1.2, 3, 240, true);
    }
    else if (!stbool) {
      roundRect(xp+153, yp+50-textAscent(), 40, 20+textAscent()*1.2, 3, 240, true);
    }
    if (mode == 0) {
      roundRect(xp+8, yp+50-textAscent(), textWidth("Select Region")*1.1, textAscent()*1.2, 3, 240, true);
    }
    if (mode == 1 || mode == 4) {
      roundRect(xp+8, yp+70-textAscent(), textWidth("Enter")*1.1, textAscent()*1.2, 3, 240, true);
    }
    if (mode == 2 || mode == 3 || mode == 5 || mode == 6) {
      roundRect(xp+8+textWidth("Enter")*1.2, yp+70-textAscent(), textWidth("View")*1.05, textAscent()*1.2, 3, 240, true);
    }
    fill(0);
    text("Select Region", xp+10, yp+50);
    text("Enter  View Data", xp+10, yp+70);
    text("Space", xp+110, yp+50);
    text("Time", xp+155, yp+50);
    text("Time", xp+110, yp+70);
    text("Space", xp+155, yp+70);
    ellipseMode(CORNER);
    stroke(51);
    fill(51);
    ellipse(xp+wp-20, 18, 10, 10);
    if (mode == 1 || mode == 2 || mode == 3) {
      //show cropped spacial region from image.
    }
  }
  else {
    fill(49);
    beginShape();
    vertex(xp, yp);
    vertex(xp+wp/10, yp+hp/10);
    vertex(xp+wp/10, yp+hp/10*9);
    vertex(xp, yp+hp);
    endShape(CLOSE);
  }
}

void roundRect(float x, float y, float w, float h, float r, color co, boolean border) {
  rectMode(CORNER);
  ellipseMode(CORNER);
  if (border) {
    stroke(co-80);
    fill(co-80);
    int of = 1;
    rect(x+r, y-of, w-r*2, r+of);
    rect(x-of, y+r, r+of, h-r*2);
    ellipse(x-of, y-of, r*2, r*2);
    stroke(co-100);
    fill(co-100);
    ellipse(x+w-r*2+of, y-of, r*2, r*2);
    ellipse(x-of, y+h-r*2+of, r*2, r*2);
    stroke(co-150);
    fill(co-150);
    rect(x+r, y+h-r, w-r*2, r+of);
    rect(x+w-r, y+r, r+of, h-r*2);
    ellipse(x+w-r*2+of, y+h-r*2+of, r*2, r*2);
  }
  fill(co);
  stroke(co);
  rect(x+r, y+r, w-r*2, h-r*2);
  rect(x+r, y, w-r*2, r);
  rect(x+r, y+h-r, w-r*2, r);
  rect(x, y+r, r, h-r*2);
  rect(x+w-r, y+r, r, h-r*2);
  ellipse(x, y, r*2, r*2);
  ellipse(x+w-r*2, y, r*2, r*2);
  ellipse(x, y+h-r*2, r*2, r*2);
  ellipse(x+w-r*2, y+h-r*2, r*2, r*2);
}

void STSRmouseP() {
  color select;
  select = get(mouseX, mouseY);
  if (get(mouseX, mouseY) == #FFFFFd || get(mouseX, mouseY) == #FFFFFe || get(mouseX, mouseY) == #FFFFFb || get(mouseX, mouseY) == #FFFFFc /*|| get(mouseX, mouseY) == #000003 || get(mouseX, mouseY) == #000002*/) {
    switch(get(mouseX, mouseY)) {
    case #FFFFFd:
      y -= 10;
      d = #0000FF;
      break;
    case #FFFFFe:
      y += 10;
      u = #0000FF;
      break;
    case #FFFFFb:
      x -= 10;
      r = #0000FF;
      break;
    case #FFFFFc:
      x += 10;
      l = #0000FF;
      break;
    default:
      break;
    }
    x = constrain(x, 0, width);
    y = constrain(y, 0, height);
  }
  else if (mousePressed && (get(mouseX, mouseY) != #FFFFFd || get(mouseX, mouseY) != #FFFFFe || get(mouseX, mouseY) != #FFFFFb || get(mouseX, mouseY) == #FFFFFc || get(mouseX, mouseY) != #0000FF)) {
    for (int j = -10; j<10; j++) {
      for (int i = -10; i<10;i++) {
        if ((mouseX-x > i*100-50 && mouseX-x < i*100 + 50) && (mouseY - y < j*100+50 && mouseY - y > j*100 - 50)) {
          fill(0);
          xref = (i)*100;
          yref = (j)*100;
          println(xref + " " + yref);
        }
      }
    }
  }
}

void STEmouseP() {
  color select;
  select = get(mouseX, mouseY);
  for (int j = 0; j < 12; j++) {
    for (int i = 0; i < 7; i++) {
      if (ychol[i+j*7]) {
        if (mouseX < amxx+amxw*(i+0.5)+amxw/2 && mouseX > amxx+amxw*(i-0.5)+amxw/2 && mouseY < amxy + amxh/2 + amxh*(j+0.5) && mouseY > amxy + amxh/2 + amxh*(j-0.5)) {
          amxc[i+j*7] = 200;
          amxb[i+j*7] = true;
        }
        else {
          amxc[i+j*7] = 255;
          amxb[i+j*7] = false;
        }
      }
    }
  }
  switch(select) {
    //cells scrollbar/yearselect
  case #000100:
    yac = #00FF00;
    //conditional, if no files, create
    year++;
    STE.calgor();
    STE.dataloadmonth(STE.cofs, year);
    STE.amsxtoa(STE.cofs, 0);
    STE.dataloadmonth(STE.cofs+1, year);
    STE.amsxtoa(STE.cofs, 1);
    break;
  case #000200:
    yamc = #00FF00;
    //conditional, if no files, create
    year--;
    STE.calgor();
    STE.dataloadmonth(STE.cofs, year);
    STE.amsxtoa(STE.cofs, 0);
    STE.dataloadmonth(STE.cofs+1, year);
    STE.amsxtoa(STE.cofs, 1);
    break;
  case #000300:
    mu = #00FF00;
    if (STE.cofs > 0) {
      STE.cofs--;
      STE.calgor();
    }
    STE.dataloadmonth(STE.cofs, year);
    STE.amsxtoa(STE.cofs, 0);
    STE.dataloadmonth(STE.cofs+1, year);
    STE.amsxtoa(STE.cofs, 1);
    break;
  case #000400:
    md = #00FF00;
    if (STE.cofs < 11) {
      STE.cofs++;
      STE.calgor();
    }
    STE.dataloadmonth(STE.cofs, year);
    STE.amsxtoa(STE.cofs, 0);
    if (STE.cofs+1 < 11) {
      STE.dataloadmonth(STE.cofs+1, year);
      STE.amsxtoa(STE.cofs, 1);
    }
  default: 
    break;
  }
}


void STSRkeyP() {
  if (keyCode == DOWN) {
    y -= 10;
    d = #0000FF;
  }
  else if (keyCode == UP) {
    y += 10;
    u = #0000FF;
  }
  else if (keyCode == RIGHT) {
    x -= 10;
    r = #0000FF;
  }
  else if (keyCode == LEFT) {
    x += 10;
    l = #0000FF;
  }
  x = constrain(x, 0, width);
  y = constrain(y, 0, height);
}

void STEkeyP() {
  for (int j = 0; j < 12; j++) {
    for (int i = 0; i < 7; i++) {
      String st = amxs[i+j*7];
      if (amxb[i+j*7]) {
        if (key >= '0' && key <= '9') {
          st+=char(key);
          if (abs(float(st))>float(999999)) {
            st= st.substring(0, st.length()-1);
          }
        }
        else if (key == BACKSPACE && st.length() > 0)
        {
          st = st.substring(0, st.length() - 1);    //dynamic button entry
        }
        if ((key == ENTER || key == RETURN) && st.length() > 0 && st.length() > 0) {
          amxb[i+j*7] = false;
          amxc[i+j*7] = 255;
        }
      }
      amxs[i+j*7] = st;
    }
  }
}

void STSRcolreset() {
  u = #FFFFFe;
  d = #FFFFFd;
  l = #FFFFFc;
  r = #FFFFFb;
}

void STEcolreset() {
  yac = #000100;
  yamc = #000200;
  mu = #000300;
  md = #000400;
}

