import processing.serial.*;
import ddf.minim.*;
Minim minim;
AudioPlayer player; 

StoredObj object;
JSONObject json;
final String path = "http://conceptnet5.media.mit.edu/data/5.2";
final int edgeLimit = 10; 
String userString = "";
boolean start = true;

//static final long serialVersionUID = 1L;
Serial port;
int stepper = 0;

String textToSend = "";

public void setup() {
  size(500, 500);
  println(Serial.list());
  port = new Serial(this, Serial.list()[7], 9600);
  port.bufferUntil('\n');

  minim = new Minim(this);
  player = minim.loadFile("rim.wav");
}

public void draw() {
  background(#EEEEEE);
  textAlign(CENTER); 
  textSize(50);
  fill(0);
  if (start) {
    text(userString, width/2, height/2);
  } else {
    if (frameCount % 30 == 0) {
      doTheThing();
    }
    text(object.thisName, width/2, height/2); 
  }
  
  
}


void keyPressed() {
  if (start) {
    if (key == '\n') {
      if (userString.length() > 1) {
        start = false;
        object = new StoredObj("c/en/"+userString, userString);
        //totalString += userString;
      }
    } else if (int(key) == 8) {
      if (userString != "") {
        String newString = userString.substring(0, max(0, userString.length()-1));
        userString = newString;
      }
    } else if (key != CODED && key != ESC) {
      userString = userString + key;
    }
  }
} 



public void serialEvent(Serial myPort) {
  String receivedString = myPort.readStringUntil('\n');
  println("received: "+receivedString);
}

public void doTheThing() {
  if (object != null) {
    textToSend = object.thisName;//"hey how are you?";
    char[] characters = textToSend.toCharArray(); 

    stepper++;

    for (int i=0; i < characters.length; i++) {
      port.write(characters[i]);
      delay(10);
    }
    player.play();
    player.rewind();
    object.getNewJSON();
    port.write('\r');
  }
} 

public void mousePressed() {
  //  if (object != null) {
  //    textToSend = object.thisName;//"hey how are you?";
  //    char[] characters = textToSend.toCharArray(); 
  //
  //    stepper++;
  //
  //    for (int i=0; i < characters.length; i++) {
  //      port.write(characters[i]);
  //      delay(10);
  //    }
  //    player.play();
  //    player.rewind();
  //    object.getNewJSON();
  //    port.write('\r');
  //  }
}

