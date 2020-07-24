# salmongraph
Project for Ron Eglash : https://roneglash.org/

The idea of this project was to create a tool for visualizing salmon
caught in a region of British Columbia for the First Nations there.

This was my first programming project I ever worked on.

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
 

