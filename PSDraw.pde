// Open a file and read its binary data 
byte b[] = loadBytes("data.bin"); 
println("b.length = ", b.length);

// Print each value, from 0 to 255 
for (int i = 0; i < b.length - 4; i++) { 
  // Every tenth number, start a new line 
/*
  if ((i % 10) == 0) { 
    println(); 
  }
*/
  String s = str(char(b[i])) + str(char(b[i+1])) + str(char(b[i+2])) + str(char(b[i+3]));
  //String s2 = "GSCN";
  //println("s.length() = ", s.length(), s);
  //println("s2.length() = ", s2.length(), s2);
  if (s.equals("GSCN") == true) {
    println("index=" + i + " (" + s + ")");
    
  }
} 
// Print a blank line at the end 
println(); 
