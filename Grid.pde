//static color C_GRID_LINE = #808080; // Black + 0x80
static color C_GRID_LINE = #C0C0C0; // Black + 0xC0
static color C_GRID_TEXT = #404040; // Black + 0x40
//static color C_GRID_TEXT = #808080; //Black + 0x80

int GRID_OFFSET_X = 0;
int GRID_OFFSET_Y = 0;
PImage PS_image;

void grid_draw()
{
  if (ROTATE_FACTOR == 0) {
    grid_draw_rotate_0();
  } else if (ROTATE_FACTOR == 90) {
    grid_draw_rotate_90();
  } else if (ROTATE_FACTOR == 180) {
    grid_draw_rotate_180();
  } else /*if (ROTATE_FACTOR == 270)*/ {
    grid_draw_rotate_270();
  }
}