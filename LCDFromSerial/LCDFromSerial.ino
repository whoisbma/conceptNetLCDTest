
#include <LiquidCrystal.h>

#define CHARACTERSPERLINE 16
#define LCDLINES 2
#define MAXLINES 10

String heldText = "";//String(CHARACTERSPERLINE*MAXLINES);

int received = 0;


LiquidCrystal lcd(32, 30, 28, 26, 24, 22);
LiquidCrystal lcd1(2, 3, 4, 5, 6, 7);
LiquidCrystal lcd2(42, 44, 46, 48, 50, 52);
LiquidCrystal lcd3(33, 31, 29, 27, 25, 23);

LiquidCrystal lcds[4] = {lcd, lcd1, lcd2, lcd3};

//int buzzerPin = 3;
int stepper = 0;

void setup() {
  // start serial port at 9600 bps:
  Serial.begin(9600);
  //pinMode(2, INPUT);   // digital sensor is on digital pin 2
  lcds[0].begin(16, 2);
  lcds[1].begin(16, 2);
  lcds[2].begin(16, 2);
  lcds[3].begin(16, 2);
  //lcd.autoscroll();
  establishContact();  // send a byte to establish contact until receiver responds
  delay(1000);
  //heldText = "returns a new string that is a part of the original string. When using the endIndex parameter, the string between beginIndex and endIndex -1 is returned.";
  //heldTextToLCD();
}

void loop()
{
  // if we get a valid byte, read analog ins:
  if (Serial.available() > 0)
  {
    // get incoming byte:
    handleIncomingChars(stepper);

    // delay 10ms to let the ADC recover:
    delay(10);
  }
}

void establishContact() {
  while (Serial.available() <= 0) {
    Serial.println("0,0,0");   // send an initial string
    delay(300);
  }
}

void handleIncomingChars(int whichLCD) {
  // read the incoming data as a char:
  char inChar = Serial.read();

  if (inChar == '\n' || inChar == '\r') {
    lcds[whichLCD].clear();
    lcds[whichLCD].home();
    heldTextToLCD(whichLCD);
    heldText = "";//String(CHARACTERSPERLINE * MAXLINES);
    if (stepper < 3) {
      stepper++;
    } else {
      stepper = 0;
    }
  } else {
    // if you're not at the end of the string, append
    // the incoming character:
    if (heldText.length() < (CHARACTERSPERLINE * MAXLINES)) {
      heldText.concat(inChar);
      //heldText.append(inChar);
    } else {
      // empty the string by setting it equal to the inoming char:
      heldText = String(inChar);
    }
  }
}

void heldTextToLCD(int whichLCD)
{
  Serial.println(heldText);
//  lcd.begin(16, 2);
//  lcd.print(heldText);
  
  int numLines = heldText.length() / CHARACTERSPERLINE;
  //String lastFragment = "";
  int remainingLength = heldText.length();
  lcds[whichLCD].clear();
  int currentIndex = 0;
  int i = 0;
  while (remainingLength > 0 || i > MAXLINES) {
    if (i % LCDLINES == 0) {
      lcds[whichLCD].clear();
    } else {
      lcds[whichLCD].setCursor(0, i % LCDLINES);
    }

    String line = "";//String(32);//lastFragment;
    int lengthToTake = CHARACTERSPERLINE;

    if (remainingLength < CHARACTERSPERLINE) {
      lengthToTake = remainingLength;
    }
    line.concat(heldText.substring(currentIndex, currentIndex + lengthToTake));
    delay(10);
    currentIndex += lengthToTake;
    delay(100);
    lcds[whichLCD].print(line);
    delay(200);
    i++;


    remainingLength = heldText.length() - currentIndex;
  }
  Serial.println("done");
}
