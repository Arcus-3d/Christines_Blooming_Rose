// Blooming rose Arduino source
//
// Project home: https://hackaday.io/project/163866
//
// Original code by Morning.Star -> https://hackaday.io/Jez.Boxall
// Some minor mucking about by Daren Schwenke ->  https://hackaday.io/daren

// Creative Commons License exists for this work. You may copy and alter the content
// of this file for private use only, and distribute it only with the associated
// Blooming Rose content. This license must be included with the file and content.

// This work is licensed under the Creative Commons Attribution 2.0 Generic License. To view a copy of this license
// visit http://creativecommons.org/licenses/by/2.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.

#include <CapacitiveSensor.h>

#include <Servo.h>

#include <Adafruit_DotStar.h> // dotstars only.  Dotstars use SPI pins (11,13 on Nano and Mini Pro)
#include <SPI.h> // dotstars only

//#include <Adafruit_NeoPixel.h>  // neopixels only
// Output pin for Neopixels.  
#define NEO_PIN 6



#define NUMPIXELS 10

// Touch capsense pins and thresholds
#define THRESHOLD 3.1 // multiple of baseline required to trigger touch.
#define THRESHOLD_DELTA 2.0 // how quickly the baseline adapts to change
#define CAPS_CTRL  3
#define CAPS_SENSE1 2
#define CAPS_SENSE2 4
#define DEBOUNCE 180


// Servo pins, travel, and speed.
#define SRV_PIN 9
#define SRV_MIN -125
#define SRV_MAX 150
#define SRV_SPEED 1.8   // between 1 and 28 (90 degrees of phase * 7 colour cycles)



// Brightness min/max.  (unless you ensure you don't roll over the bitwise operations, I wouldn't mess with these..)
#define LED_MAX 230
#define LED_MIN 24
#define LED_COMP 0 // increase to cycle complement colors instead of breathing.
#define RETRACT_RATIO 10

// Switch to trigger touch instead of capsense for testing
#define TEST_PIN 8


Adafruit_DotStar strip = Adafruit_DotStar(NUMPIXELS, DOTSTAR_BGR); // dotstars only

//Adafruit_NeoPixel strip = Adafruit_NeoPixel(30, NEO_PIN, NEO_GRB + NEO_KHZ800);  // neopixels only

CapacitiveSensor leaf_cap = CapacitiveSensor(CAPS_CTRL,CAPS_SENSE1);
CapacitiveSensor rose_cap = CapacitiveSensor(CAPS_CTRL,CAPS_SENSE2);

Servo servo;

uint32_t color = 0x000000;
  
bool blooming=true;
float pos=0;
bool leaf_touched=true;
bool rose_touched=false;
long leaf_threshold=0,rose_threshold=0;

struct dotrgb {
  int r;
  int g;
  int b;  
} ;

int counter=0, rootcol=0, retract=0;

dotrgb dot[NUMPIXELS];

double d2r=(atan(1)*4)/180;

//==============================================================================================================

void setup() {

  Serial.begin(115200);

  strip.begin();
  // strip.setBrightness(50); //neopixels only
  strip.show();
  
  leaf_cap.set_CS_AutocaL_Millis(0xFFFFFFFF);
  rose_cap.set_CS_AutocaL_Millis(0xFFFFFFFF);
  
  servo.attach(SRV_PIN);
  servo.write(pos);
  for (int n=0; n<10; n++) {
    dot[n].g=0;dot[0].r=0; dot[0].b=0;
  }

  dot[9].r=LED_MAX/4; dot[8].r=LED_MAX/2; dot[7].r=LED_MAX; dot[7].r=LED_MAX/2; dot[6].r=LED_MAX/4;
  
  pinMode(TEST_PIN,INPUT);
      
  }

//==============================================================================================================

void setpix(int p, int r, int g, int b) {

  color=r;
  color=(color<<8)+g;
  color=(color<<8)+b;
  strip.setPixelColor(p,color);
  
}

//==============================================================================================================

int petals(int phase) {
  float b = 0.0;
  if (phase<90*SRV_SPEED and retract==0 and leaf_touched) {
    if (phase == 0) { servo.attach(SRV_PIN); }
    pos=(((sin((phase/SRV_SPEED)*d2r)+1)/2)*(SRV_MAX-SRV_MIN))+SRV_MIN;
    servo.write(pos);
    //Serial.println("Servo pos: ");
    //Serial.println(pos);
    b = phase/(90*SRV_SPEED);
  } else if (phase == 90*SRV_SPEED) {
    servo.detach();
    b = 1.0;
  } else {
    b = 1.0;
  }

  if (retract>0) { 
    pos=((SRV_MAX-SRV_MIN)/RETRACT_RATIO)*retract;
    
    //servo.write(pos);
  }

  if (counter>2456) { strip.setBrightness(2520-counter); }
  if (counter<65) { strip.setBrightness(counter); }
  
  
  float c[6] = { (((sin((phase)*d2r)+1)/2)*LED_MAX)+LED_MIN,(((sin((phase+30)*d2r)+1)/2)*LED_MAX)+LED_MIN,(((sin((phase+60)*d2r)+1)/2)*LED_MAX)+LED_MIN,(((sin((phase+90)*d2r)+1)/2)*LED_MAX)+LED_MIN,(((sin((phase+120)*d2r)+1)/2)*LED_MAX)+LED_MIN,(((sin((phase+150)*d2r)+1)/2)*LED_MAX)+LED_MIN };
  float d[4] = { (((sin((phase)*d2r)+1)/2)*LED_MAX)+LED_MIN,(((sin((phase+45)*d2r)+1)/2)*LED_MAX)+LED_MIN,(((sin((phase+90)*d2r)+1)/2)*LED_MAX)+LED_MIN,(((sin((phase+135)*d2r)+1)/2)*LED_MAX)+LED_MIN };
  for (int n=0; n<10; n++) {
    if (n<4) {
      setpix(n,d[n]*(1-b),d[n]*b,d[n]*(1-b));
    } else {
      if (rootcol==0) { setpix(n,c[n-4]*b,LED_COMP*b,LED_COMP*b); }
      if (rootcol==1) { setpix(n,c[n-4]*b,c[n-4]*b/2,LED_COMP*b); }
      if (rootcol==2) { setpix(n,LED_COMP*b,LED_COMP*b,c[n-4]*b); }
      if (rootcol==3) { setpix(n,c[n-4]*b,c[n-4]*b,LED_COMP*b); }
      if (rootcol==4) { setpix(n,c[n-4]*b,LED_COMP*b,c[n-4]*b); }
      if (rootcol==5) { setpix(n,LED_COMP*b,c[n-4]*b,c[n-4]*b); }
      if (rootcol==6) { setpix(n,c[n-4]*b,c[n-4]*b/2,LED_COMP*b); }
    }
  }
  strip.show();
  phase++;
  if (phase>DEBOUNCE) { leaf_touched=false; rose_touched=false;}
  return phase;

}

//==============================================================================================================

int bud(int phase) {
  float b = 0.0;
  if (phase<90*SRV_SPEED and leaf_touched) {
    if (phase == 0) { servo.attach(SRV_PIN); }
    pos=(((sin(((phase/SRV_SPEED)+90)*d2r)+1)/2)*(SRV_MAX-SRV_MIN))+SRV_MIN;
    servo.write(pos);
    //Serial.println("Servo pos: ");
    //Serial.println(pos);
    b = (90*SRV_SPEED-phase)/(90*SRV_SPEED);
  } else if (phase == 90*SRV_SPEED) {
    servo.detach();
    b = 0.0;
  } else {
    b = 0.0;
  }
  float c[6] = { (((sin((phase)*d2r)+1)/2)*LED_MAX)+LED_MIN,(((sin((phase+30)*d2r)+1)/2)*LED_MAX)+LED_MIN,(((sin((phase+60)*d2r)+1)/2)*LED_MAX)+LED_MIN,(((sin((phase+90)*d2r)+1)/2)*LED_MAX)+LED_MIN,(((sin((phase+120)*d2r)+1)/2)*LED_MAX)+LED_MIN,(((sin((phase+150)*d2r)+1)/2)*LED_MAX)+LED_MIN };
  float d[4] = { (((sin((phase)*d2r)+1)/2)*LED_MAX)+LED_MIN,(((sin((phase+45)*d2r)+1)/2)*LED_MAX)+LED_MIN,(((sin((phase+90)*d2r)+1)/2)*LED_MAX)+LED_MIN,(((sin((phase+135)*d2r)+1)/2)*LED_MAX)+LED_MIN };
    for (int n=0; n<10; n++) {
      if (n<4) {
        setpix(n,d[n]*(1-b),d[n]*b,d[n]*(1-b));
      } else {
        if (phase<90*SRV_SPEED and leaf_touched) {
          if (rootcol==0) { setpix(n,c[n-4]*b,LED_COMP*b,LED_COMP*b); }
          if (rootcol==1) { setpix(n,c[n-4]*b,c[n-4]*b/2,LED_COMP*b); }
          if (rootcol==2) { setpix(n,LED_COMP*b,LED_COMP*b,c[n-4]*b); }
          if (rootcol==3) { setpix(n,c[n-4]*b,c[n-4]*b,LED_COMP*b); }
          if (rootcol==4) { setpix(n,c[n-4]*b,LED_COMP*b,c[n-4]*b); }
          if (rootcol==5) { setpix(n,LED_COMP*b,c[n-4]*b,c[n-4]*b); }
          if (rootcol==6) { setpix(n,c[n-4]*b,c[n-4]*b/2,LED_COMP*b); }
        } else {
          setpix(n,0,0,0);
        }
      }
    }
  strip.show();
  phase++;
  if (phase>DEBOUNCE) { leaf_touched=false; rose_touched=false;}
  return phase;

}

//==============================================================================================================

void touchroutine() {
  long leaf_touch = leaf_cap.capacitiveSensor(60),rose_touch = rose_cap.capacitiveSensor(60);
  if ( not leaf_threshold) {
    leaf_threshold = leaf_touch*THRESHOLD*3;
  } else {
    leaf_threshold = leaf_threshold + (leaf_touch*THRESHOLD - leaf_threshold)*THRESHOLD_DELTA/100;
  }
  if ( not rose_threshold) {
    rose_threshold = rose_touch*THRESHOLD*3;
  } else {
    rose_threshold = rose_threshold + (rose_touch*THRESHOLD - rose_threshold)*THRESHOLD_DELTA/100;
  }

  bool touch = digitalRead(TEST_PIN);

  if (leaf_touch>leaf_threshold and not leaf_touched) {
    Serial.print("Leaf touch: ");
    Serial.print(leaf_touch);
    Serial.print("/");
    Serial.println(leaf_threshold);
    leaf_touched=true;
    blooming= not blooming;
    if (blooming) {
      if (++rootcol>6) { rootcol=0; } // root color for the petals
    }
    counter=0;   // reset the counter to zero. This is why the servo was jumping position
  }
  if (rose_touch>rose_threshold and not rose_touched and not leaf_touched) {
    Serial.print("Rose touch: ");
    Serial.print(rose_touch);
    Serial.print("/");
    Serial.println(rose_threshold);
    rose_touched=true;
    if (blooming) {
      if (++rootcol>6) { rootcol=0; } // root color for the petals
    }
    counter=0;   // reset the counter to zero. This is why the servo was jumping position
  } else { 
    retract=0; 
  }


}

//==============================================================================================================


void loop() {
  touchroutine();
   
  if (blooming) {
    counter=petals(counter);
  } else {
    counter=bud(counter);
  }

  if (counter>=2520) { 
    counter=0;
    if (++rootcol>6) {rootcol=0; }
  }

  strip.show();

}
