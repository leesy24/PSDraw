int GRID_OFFSET_X = 0;
int GRID_OFFSET_Y = 0;

void grid_draw_rotate_0()
{
  String string;
  int x, y;
  int ix, iy;
  
  // Sets the color used to draw lines and borders around shapes.
  stroke(64);
  for (iy = -1; iy <= SCREEN_HEIGHT / 100; iy ++) {
    // if even number.
    if ((SCREEN_HEIGHT / 100) % 2 == 0) {
      line(0,            iy * 100 + (SCREEN_HEIGHT % 100) / 2 + (GRID_OFFSET_Y % 100),
           SCREEN_WIDTH, iy * 100 + (SCREEN_HEIGHT % 100) / 2 + (GRID_OFFSET_Y % 100));
    }
    // else odd number
    else {
      line(0,            iy * 100 + (SCREEN_HEIGHT % 100) / 2 + 50 + (GRID_OFFSET_Y % 100),
           SCREEN_WIDTH, iy * 100 + (SCREEN_HEIGHT % 100) / 2 + 50 + (GRID_OFFSET_Y % 100));
    }
  }
  for (ix = 0; ix <= SCREEN_WIDTH / 100 + 1; ix ++) {
    line(ix * 100 + TEXT_MARGIN + FONT_HEIGHT / 2 + (GRID_OFFSET_X % 100), 0,
         ix * 100 + TEXT_MARGIN + FONT_HEIGHT / 2 + (GRID_OFFSET_X % 100), SCREEN_HEIGHT);
  }

  // Sets the color used to draw text and borders around shapes.
  stroke(128);
  for (iy = -1; iy <= SCREEN_HEIGHT / 100; iy ++) {
    if (MIRROR_ENABLE) {
      string =
        (
          float(
            int(
              ZOOM_FACTOR / 100.0 * float((iy - SCREEN_HEIGHT / 100 / 2) * 100)
            )
            -
            int(
              ZOOM_FACTOR / 100.0 * float(GRID_OFFSET_Y / 100 * 100)
            )
          )
          /
          100.0
        )
        +
        "m";
    }
    else {
      string =
        (
          float(
            int(
              ZOOM_FACTOR / 100.0 * float((SCREEN_HEIGHT / 100 / 2 - iy) * 100)
            )
            +
            int(
              ZOOM_FACTOR / 100.0 * float(GRID_OFFSET_Y / 100 * 100)
            )
          )
          /
          100.0
        )
        +
        "m";
    }
    // if even number.
    if ((SCREEN_HEIGHT / 100) % 2 == 0) {
      y = iy * 100 + (SCREEN_HEIGHT % 100) / 2 + FONT_HEIGHT / 2 + (GRID_OFFSET_Y % 100);
    }
    // else odd number
    else {
      y = iy * 100 + (SCREEN_HEIGHT % 100) / 2 + 50 + FONT_HEIGHT / 2 + (GRID_OFFSET_Y % 100);
    }
    x = TEXT_MARGIN + FONT_HEIGHT / 2 - int(textWidth(string) / 2.0) + GRID_OFFSET_X;
    if (x < TEXT_MARGIN) x = TEXT_MARGIN;
    if (x > SCREEN_WIDTH - int(textWidth(string)) - TEXT_MARGIN) x = SCREEN_WIDTH - int(textWidth(string)) - TEXT_MARGIN;
    text(string, x, y);
    //println("iy=" + iy + ", string=" + string + ", x=" + x + ", y=" + y);
  }
  for (ix = 0; ix <= SCREEN_WIDTH / 100 + 1; ix ++) {
    if (
      int(
        ZOOM_FACTOR / 100.0 * float(ix * 100)
      )
      -
      int(
        ZOOM_FACTOR / 100.0 * float(GRID_OFFSET_X / 100 * 100)
      )
      >=
      0
    ) {
      string =
        (
          float(
            int(
              ZOOM_FACTOR / 100.0 * float(ix * 100)
            )
            -
            int(
              ZOOM_FACTOR / 100.0 * float(GRID_OFFSET_X / 100 * 100)
            )
          )
          / 100.0
        )
        +
        "m";
      y = SCREEN_HEIGHT / 2 + FONT_HEIGHT / 2 + GRID_OFFSET_Y;
      if (y < TEXT_MARGIN + FONT_HEIGHT) y = TEXT_MARGIN + FONT_HEIGHT;
      if (y > SCREEN_HEIGHT - TEXT_MARGIN) y = SCREEN_HEIGHT - TEXT_MARGIN;
      x = ix * 100 + TEXT_MARGIN + FONT_HEIGHT / 2 - int(textWidth(string) / 2.0) + (GRID_OFFSET_X % 100);
      text(string, x, y);
    }
  }
}

void grid_draw_rotate_90()
{
  String string;
  int x, y;
  int ix, iy;

  // Sets the color used to draw lines and borders around shapes.
  stroke(64);
  for (ix = -1; ix <= SCREEN_WIDTH / 100; ix ++) {
    // if even number.
    if ((SCREEN_WIDTH / 100) % 2 == 0) {
      line(ix * 100 + (SCREEN_WIDTH % 100) / 2 + (GRID_OFFSET_X % 100), 0,
           ix * 100 + (SCREEN_WIDTH % 100) / 2 + (GRID_OFFSET_X % 100), SCREEN_HEIGHT);
    }
    // else odd number
    else {
      line(ix * 100 + (SCREEN_WIDTH % 100) / 2 + 50 + (GRID_OFFSET_X % 100), 0,
           ix * 100 + (SCREEN_WIDTH % 100) / 2 + 50 + (GRID_OFFSET_X % 100), SCREEN_HEIGHT);
    }
  }
  for (iy = 0; iy <= SCREEN_HEIGHT / 100 + 1; iy ++) {
    line(0,            iy * 100 + TEXT_MARGIN + FONT_HEIGHT / 2 + (GRID_OFFSET_Y % 100),
         SCREEN_WIDTH, iy * 100 + TEXT_MARGIN + FONT_HEIGHT / 2 + (GRID_OFFSET_Y % 100));
  }

  // Sets the color used to draw text and borders around shapes.
  stroke(128);
  for (ix = -1; ix <= SCREEN_WIDTH / 100 ; ix ++) {
    if (MIRROR_ENABLE) {
      string =
        (
          float(
            int(
              ZOOM_FACTOR / 100.0 * float((SCREEN_WIDTH / 100 / 2 - ix) * 100)
            )
            +
            int(
              ZOOM_FACTOR / 100.0 * float(GRID_OFFSET_X / 100 * 100)
            )
          )
          /
          100.0
        )
        +
        "m";
    }
    else {
      string =
        (
          float(
            int(
              ZOOM_FACTOR / 100.0 * float((ix - SCREEN_WIDTH / 100 / 2) * 100)
            )
            -
            int(
              ZOOM_FACTOR / 100.0 * float(GRID_OFFSET_X / 100 * 100)
            )
          )
          /
          100.0
        )
        +
        "m";
    }
    // if even number.
    if ((SCREEN_WIDTH / 100) % 2 == 0) {
      x = ix * 100 + (SCREEN_WIDTH % 100) / 2 - int(textWidth(string) / 2.0) + (GRID_OFFSET_X % 100);
    }
    // else odd number
    else {
      x = ix * 100 + (SCREEN_WIDTH % 100) / 2 + 50 - int(textWidth(string) / 2.0) + (GRID_OFFSET_X % 100);
    }
    y = TEXT_MARGIN + FONT_HEIGHT + GRID_OFFSET_Y;
    if (y < TEXT_MARGIN + FONT_HEIGHT) y = TEXT_MARGIN + FONT_HEIGHT;
    if (y > SCREEN_HEIGHT - TEXT_MARGIN) y = SCREEN_HEIGHT - TEXT_MARGIN;
    text(string, x, y);
  }
  for (iy = 0; iy <= SCREEN_HEIGHT / 100 + 1; iy ++) {
    if (
      int(
        ZOOM_FACTOR / 100.0 * float(iy * 100)
      )
      -
      int(
        ZOOM_FACTOR / 100.0 * float(GRID_OFFSET_Y / 100 * 100)
      )
      >=
      0
    ) {
      string =
        (
          float(
            int(
              ZOOM_FACTOR / 100.0 * float(iy * 100)
            )
            -
            int(
              ZOOM_FACTOR / 100.0 * float(GRID_OFFSET_Y / 100 * 100)
            )
          )
          / 100.0
        )
        +
        "m";
      x = SCREEN_WIDTH / 2 - int(textWidth(string)/2) + GRID_OFFSET_X;
      if (x < TEXT_MARGIN) x = TEXT_MARGIN;
      if (x > SCREEN_WIDTH - int(textWidth(string)) - TEXT_MARGIN) x = SCREEN_WIDTH - int(textWidth(string)) - TEXT_MARGIN;
      y = iy * 100 + TEXT_MARGIN + FONT_HEIGHT + (GRID_OFFSET_Y % 100);
      text(string, x, y);
    }
  }
}

void grid_draw_rotate_180()
{
  String string;
  int x, y;
  int ix, iy;

  // Sets the color used to draw lines and borders around shapes.
  stroke(64);
  for (iy = -1; iy <= SCREEN_HEIGHT / 100; iy ++) {
    // if even number.
    if ((SCREEN_HEIGHT / 100) % 2 == 0) {
      line(0,            iy * 100 + (SCREEN_HEIGHT % 100) / 2 + (GRID_OFFSET_Y % 100),
           SCREEN_WIDTH, iy * 100 + (SCREEN_HEIGHT % 100) / 2 + (GRID_OFFSET_Y % 100));
    }
    // else odd number
    else {
      line(0,            iy * 100 + (SCREEN_HEIGHT % 100) / 2 + 50 + (GRID_OFFSET_Y % 100),
           SCREEN_WIDTH, iy * 100 + (SCREEN_HEIGHT % 100) / 2 + 50 + (GRID_OFFSET_Y % 100));
    }
  }
  for (ix = 0; ix <= SCREEN_WIDTH / 100 + 1; ix ++) {
    line(SCREEN_WIDTH - ix * 100 - (TEXT_MARGIN + FONT_HEIGHT / 2) + (GRID_OFFSET_X % 100), 0,
         SCREEN_WIDTH - ix * 100 - (TEXT_MARGIN + FONT_HEIGHT / 2) + (GRID_OFFSET_X % 100), SCREEN_HEIGHT);
  }

  // Sets the color used to draw text and borders around shapes.
  stroke(128);
  for (iy = -1; iy <= SCREEN_HEIGHT / 100; iy ++) {
    if (MIRROR_ENABLE) {
      string =
        (
          float(
            int(
              ZOOM_FACTOR / 100.0 * float((SCREEN_HEIGHT / 100 / 2 - iy) * 100)
            )
            +
            int(
              ZOOM_FACTOR / 100.0 * float(GRID_OFFSET_Y / 100 * 100)
            )
          )
          /
          100.0
        )
        +
        "m";
    }
    else {
      string =
        (
          float(
            int(
              ZOOM_FACTOR / 100.0 * float((iy - SCREEN_HEIGHT / 100 / 2) * 100)
            )
            -
            int(
              ZOOM_FACTOR / 100.0 * float(GRID_OFFSET_Y / 100 * 100)
            )
          )
          /
          100.0
        )
        +
        "m";
    }
    // if even number.
    if ((SCREEN_HEIGHT / 100) % 2 == 0) {
      y = iy * 100 + (SCREEN_HEIGHT % 100) / 2 + FONT_HEIGHT / 2 + (GRID_OFFSET_Y % 100);
    }
    // else odd number
    else {
      y = iy * 100 + (SCREEN_HEIGHT % 100) / 2 + 50 + FONT_HEIGHT / 2 + (GRID_OFFSET_Y % 100);
    }
    x = SCREEN_WIDTH - (TEXT_MARGIN + FONT_HEIGHT / 2) - int(textWidth(string) / 2.0) + GRID_OFFSET_X;
    if (x < TEXT_MARGIN) x = TEXT_MARGIN;
    if (x > SCREEN_WIDTH - int(textWidth(string)) - TEXT_MARGIN) x = SCREEN_WIDTH - int(textWidth(string)) - TEXT_MARGIN;
    text(string, x, y);
    //println("iy=" + iy + ", string=" + string + ", x=" + x + ", y=" + y);
  }
  for (ix = 0; ix <= SCREEN_WIDTH / 100 + 1; ix ++) {
    if (
      int(
        ZOOM_FACTOR / 100.0 * float(ix * 100)
      )
      +
      int(
        ZOOM_FACTOR / 100.0 * float(GRID_OFFSET_X / 100 * 100)
      )
      >=
      0
    ) {
      string =
        (
          float(
            int(
              ZOOM_FACTOR / 100.0 * float(ix * 100)
            )
            +
            int(
              ZOOM_FACTOR / 100.0 * float(GRID_OFFSET_X / 100 * 100)
            )
          )
          / 100.0
        )
        +
        "m";
      y = SCREEN_HEIGHT / 2 + FONT_HEIGHT / 2 + GRID_OFFSET_Y;
      if (y < TEXT_MARGIN + FONT_HEIGHT) y = TEXT_MARGIN + FONT_HEIGHT;
      if (y > SCREEN_HEIGHT - TEXT_MARGIN) y = SCREEN_HEIGHT - TEXT_MARGIN;
      x = SCREEN_WIDTH - ix * 100 - (TEXT_MARGIN + FONT_HEIGHT / 2) - int(textWidth(string) / 2.0) + (GRID_OFFSET_X % 100);
      text(string, x, y);
    }
  }
}

void grid_draw_rotate_270()
{
  String string;
  int x, y;
  int ix, iy;

  // Sets the color used to draw lines and borders around shapes.
  stroke(64);
  for (ix = -1; ix <= SCREEN_WIDTH / 100; ix ++) {
    // if even number.
    if ((SCREEN_WIDTH / 100) % 2 == 0) {
      line(ix * 100 + (SCREEN_WIDTH % 100) / 2 + (GRID_OFFSET_X % 100), 0,
           ix * 100 + (SCREEN_WIDTH % 100) / 2 + (GRID_OFFSET_X % 100), SCREEN_HEIGHT);
    }
    // else odd number
    else {
      line(ix * 100 + (SCREEN_WIDTH % 100) / 2 + 50 + (GRID_OFFSET_X % 100), 0,
           ix * 100 + (SCREEN_WIDTH % 100) / 2 + 50 + (GRID_OFFSET_X % 100), SCREEN_HEIGHT);
    }
  }
  for (iy = 0; iy <= SCREEN_HEIGHT / 100 + 1; iy ++) {
    line(0,            SCREEN_HEIGHT - iy * 100 - (TEXT_MARGIN + FONT_HEIGHT / 2) + (GRID_OFFSET_Y % 100),
         SCREEN_WIDTH, SCREEN_HEIGHT - iy * 100 - (TEXT_MARGIN + FONT_HEIGHT / 2) + (GRID_OFFSET_Y % 100));
  }

  // Sets the color used to draw text and borders around shapes.
  stroke(128);
  for (ix = -1; ix <= SCREEN_WIDTH / 100 ; ix ++) {
    if (MIRROR_ENABLE) {
      string =
        (
          float(
            int(
              ZOOM_FACTOR / 100.0 * float((ix - SCREEN_WIDTH / 100 / 2) * 100)
            )
            -
            int(
              ZOOM_FACTOR / 100.0 * float(GRID_OFFSET_X / 100 * 100)
            )
          )
          /
          100.0
        )
        +
        "m";
    }
    else {
      string =
        (
          float(
            int(
              ZOOM_FACTOR / 100.0 * float((SCREEN_WIDTH / 100 / 2 - ix) * 100)
            )
            +
            int(
              ZOOM_FACTOR / 100.0 * float(GRID_OFFSET_X / 100 * 100)
            )
          )
          /
          100.0
        )
        +
        "m";
    }
    // if even number.
    if ((SCREEN_WIDTH / 100) % 2 == 0) {
      x = ix * 100 + (SCREEN_WIDTH % 100) / 2 - int(textWidth(string) / 2.0) + (GRID_OFFSET_X % 100);
    }
    // else odd number
    else {
      x = ix * 100 + (SCREEN_WIDTH % 100) / 2 + 50 - int(textWidth(string) / 2.0) + (GRID_OFFSET_X % 100);
    }
    y = SCREEN_HEIGHT - TEXT_MARGIN + GRID_OFFSET_Y;
    if (y < TEXT_MARGIN + FONT_HEIGHT) y = TEXT_MARGIN + FONT_HEIGHT;
    if (y > SCREEN_HEIGHT - TEXT_MARGIN) y = SCREEN_HEIGHT - TEXT_MARGIN;
    text(string, x, y);
  }
  for (iy = 0; iy <= SCREEN_HEIGHT / 100 + 1; iy ++) {
    if (
      int(
        ZOOM_FACTOR / 100.0 * float(iy * 100)
      )
      +
      int(
        ZOOM_FACTOR / 100.0 * float(GRID_OFFSET_Y / 100 * 100)
      )
      >=
      0
    ) {
      string =
        (
          float(
            int(
              ZOOM_FACTOR / 100.0 * float(iy * 100)
            )
            +
            int(
              ZOOM_FACTOR / 100.0 * float(GRID_OFFSET_Y / 100 * 100)
            )
          )
          / 100.0
        )
        +
        "m";
      x = SCREEN_WIDTH / 2 - int(textWidth(string)/2) + GRID_OFFSET_X;
      if (x < TEXT_MARGIN) x = TEXT_MARGIN;
      if (x > SCREEN_WIDTH - int(textWidth(string)) - TEXT_MARGIN) x = SCREEN_WIDTH - int(textWidth(string)) - TEXT_MARGIN;
      y = SCREEN_HEIGHT - iy * 100 - TEXT_MARGIN + (GRID_OFFSET_Y % 100);
      text(string, x, y);
    }
  }
}

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