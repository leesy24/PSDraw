color C_BUBBLEINFO_RECT_FILL = #F8F8F8; // White - 0x8
color C_BUBBLEINFO_RECT_STROKE = #000000; // White - 0x8
color C_BUBBLEINFO_TEXT = #000000; // Black

boolean BUBBLEINFO_AVAILABLE = false;
boolean BUBBLEINFO_DISPLAY = false;
int BUBBLEINFO_POINT;
float BUBBLEINFO_DISTANCE;
float BUBBLEINFO_COR_X;
float BUBBLEINFO_COR_Y;
float BUBBLEINFO_ANGLE;
int BUBBLEINFO_PULSE_WIDTH;
int BUBBLEINFO_TIMER = 0;
int BUBBLEINFO_BOX_X, BUBBLEINFO_BOX_Y;

void bubbleinfo_draw()
{
  String string1, string2, string3, string4, string5, string6;
  int x, y, w, h, tl = 5, tr = 5, br = 0, bl = 5;

  if(BUBBLEINFO_AVAILABLE || (millis() - BUBBLEINFO_TIMER) < 2000)
  {
    BUBBLEINFO_DISPLAY = true;
    if(BUBBLEINFO_AVAILABLE) {
      BUBBLEINFO_TIMER = millis();
      BUBBLEINFO_AVAILABLE = false;
      BUBBLEINFO_BOX_X = mouseX;
      BUBBLEINFO_BOX_Y = mouseY;
    }

    string1 = "Point:" + BUBBLEINFO_POINT;
    string2 = "Angle:" + BUBBLEINFO_ANGLE + "°";
    string3 = "Distance:" + BUBBLEINFO_DISTANCE + "m";
    string4 = "Coord. X:" + BUBBLEINFO_COR_X + "m";
    string5 = "Coord. Y:" + BUBBLEINFO_COR_Y + "m";
    string6 = "Pulse width:" + BUBBLEINFO_PULSE_WIDTH;
    w = int(max(textWidth(string1), textWidth(string2), textWidth(string3)));
    w = int(max(float(w), textWidth(string4), textWidth(string5)));
    w = int(max(float(w), textWidth(string6)));
    w += TEXT_MARGIN + TEXT_MARGIN;
    h = TEXT_MARGIN + FONT_HEIGHT * 6 + TEXT_MARGIN;
    x = BUBBLEINFO_BOX_X - w;
    y = BUBBLEINFO_BOX_Y - h;
    if(x < 0 && y < 0) {
      br = 5;
      tl = 0;
      x = BUBBLEINFO_BOX_X;
      y = BUBBLEINFO_BOX_Y;
    }
    else if(x < 0) {
      br = 5;
      bl = 0;
      x = BUBBLEINFO_BOX_X;
    }
    else if(y < 0) {
      br = 5;
      tr = 0;
      y = BUBBLEINFO_BOX_Y;
    }
    
    // Sets the color used to draw box and borders around shapes.
    fill(C_BUBBLEINFO_RECT_FILL);
    stroke(C_BUBBLEINFO_RECT_STROKE);
    rect(x, y, w, h, tl, tr, br, bl);
    // Sets the color used to draw text and borders around shapes.
    fill(C_BUBBLEINFO_TEXT);
    stroke(C_BUBBLEINFO_TEXT);
    text(string1, x + TEXT_MARGIN, y + TEXT_MARGIN + FONT_HEIGHT * 1);
    text(string2, x + TEXT_MARGIN, y + TEXT_MARGIN + FONT_HEIGHT * 2);
    text(string3, x + TEXT_MARGIN, y + TEXT_MARGIN + FONT_HEIGHT * 3);
    text(string4, x + TEXT_MARGIN, y + TEXT_MARGIN + FONT_HEIGHT * 4);
    text(string5, x + TEXT_MARGIN, y + TEXT_MARGIN + FONT_HEIGHT * 5);
    text(string6, x + TEXT_MARGIN, y + TEXT_MARGIN + FONT_HEIGHT * 6);
  }
  else
  {
    BUBBLEINFO_DISPLAY = false;
  }
}