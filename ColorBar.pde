void colorbar_draw_0()
{
  color c;
  int i;
  int p;

  for(i = 0; i < SCREEN_HEIGHT; i ++) {
    p = int(float(MIN_PULSE_WIDTH - MAX_PULSE_WIDTH) / float(SCREEN_HEIGHT) * float(i)) + MAX_PULSE_WIDTH;
    colorMode(HSB, MAX_PULSE_WIDTH - MIN_PULSE_WIDTH);
    c =
      color(
        (MAX_PULSE_WIDTH + int(float(MAX_PULSE_WIDTH - MIN_PULSE_WIDTH) * 5.0 / 6.0) - p) % (MAX_PULSE_WIDTH - MIN_PULSE_WIDTH + 1),
        MAX_PULSE_WIDTH - MIN_PULSE_WIDTH,
        MAX_PULSE_WIDTH - MIN_PULSE_WIDTH);
    colorMode(RGB, 255);
    
    fill(c);
    stroke(c);
    line(SCREEN_WIDTH - FONT_HEIGHT / 2, i, SCREEN_WIDTH, i);
  }
}

void colorbar_draw_90()
{
  color c;
  int i;
  int p;

  for(i = 0; i < SCREEN_WIDTH; i ++) {
    p = int(float(MAX_PULSE_WIDTH - MIN_PULSE_WIDTH) / float(SCREEN_WIDTH) * float(i)) + MIN_PULSE_WIDTH;
    colorMode(HSB, MAX_PULSE_WIDTH - MIN_PULSE_WIDTH);
    c =
      color(
        (MAX_PULSE_WIDTH + int(float(MAX_PULSE_WIDTH - MIN_PULSE_WIDTH) * 5.0 / 6.0) - p) % (MAX_PULSE_WIDTH - MIN_PULSE_WIDTH + 1),
        MAX_PULSE_WIDTH - MIN_PULSE_WIDTH,
        MAX_PULSE_WIDTH - MIN_PULSE_WIDTH);
    //print("[" + i + "]=" + p + "," + (MAX_PULSE_WIDTH + int(float(MAX_PULSE_WIDTH - MIN_PULSE_WIDTH) * 3.0 / 4.0) - p)%(MAX_PULSE_WIDTH - MIN_PULSE_WIDTH) + " ");
    //print("[" + i + "]=" + p + "," + hue(c) + " ");
    colorMode(RGB, 255);
//    print(i + "=" +
//      p + "," + 
//      int(hue(c)) + ":" +
//      (MAX_PULSE_WIDTH + int(float(MAX_PULSE_WIDTH - MIN_PULSE_WIDTH) * 5.0 / 6.0) - p) % (MAX_PULSE_WIDTH - MIN_PULSE_WIDTH + 1) + "," +
//      int(red(c)) + ":" + int(green(c)) + ":" + int(blue(c)) + " ");
    fill(c);
    stroke(c);
    line(i, SCREEN_HEIGHT - FONT_HEIGHT / 2, i, SCREEN_HEIGHT);
  }
}

void colorbar_draw_180()
{
  color c;
  int i;
  int p;

  for(i = 0; i < SCREEN_HEIGHT; i ++) {
    p = int(float(MIN_PULSE_WIDTH - MAX_PULSE_WIDTH) / float(SCREEN_HEIGHT) * float(i)) + MAX_PULSE_WIDTH;
    //print("[" + i + "]=" + p + " ");
    colorMode(HSB, MAX_PULSE_WIDTH - MIN_PULSE_WIDTH);
    c =
      color(
        (MAX_PULSE_WIDTH + int(float(MAX_PULSE_WIDTH - MIN_PULSE_WIDTH) * 5.0 / 6.0) - p) % (MAX_PULSE_WIDTH - MIN_PULSE_WIDTH + 1),
        MAX_PULSE_WIDTH - MIN_PULSE_WIDTH,
        MAX_PULSE_WIDTH - MIN_PULSE_WIDTH);
    colorMode(RGB, 255);
    
    fill(c);
    stroke(c);
    line(0, i, FONT_HEIGHT / 2, i);
  }
}

void colorbar_draw_270()
{
  color c;
  int i;
  int p;

  for(i = 0; i < SCREEN_WIDTH; i ++) {
    p = int(float(MAX_PULSE_WIDTH - MIN_PULSE_WIDTH) / float(SCREEN_WIDTH) * float(i)) + MIN_PULSE_WIDTH;
    //print("[" + i + "]=" + p + " ");
    colorMode(HSB, MAX_PULSE_WIDTH - MIN_PULSE_WIDTH);
    c =
      color(
        (MAX_PULSE_WIDTH + int(float(MAX_PULSE_WIDTH - MIN_PULSE_WIDTH) * 5.0 / 6.0) - p) % (MAX_PULSE_WIDTH - MIN_PULSE_WIDTH + 1),
        MAX_PULSE_WIDTH - MIN_PULSE_WIDTH,
        MAX_PULSE_WIDTH - MIN_PULSE_WIDTH);
    colorMode(RGB, 255);
    
    fill(c);
    stroke(c);
    line(i, 0, i, FONT_HEIGHT / 2);
  }
}

void colorbar_draw()
{
  if (ROTATE_FACTOR == 0) {
    colorbar_draw_0();
  } else if (ROTATE_FACTOR == 90) {
    colorbar_draw_90();
  } else if (ROTATE_FACTOR == 180) {
    colorbar_draw_180();
  } else /*if (ROTATE_FACTOR == 270)*/ {
    colorbar_draw_270();
  }
}