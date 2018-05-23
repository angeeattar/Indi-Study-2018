import processing.pdf.*;
boolean bRecordingPDF;
PFont[] fonts;
String[] texts = {"Rejoice!", "Our times are intolerable", "23.09.2018", "The Letterbet, Montreal"};
float y;

ArrayList<Copy> allCopy;

void setup() {
  size(600, 850); // A1 aspect
  background(255);
  bRecordingPDF = false;

  allCopy = new ArrayList<Copy>();

  int s = int(random(71, 72));
  fonts = new PFont[] {
    createFont("Lyon Text Regular.otf", s), 
    createFont("Apercu Medium.otf", s), 
    createFont("EksellDisplayWeb-Medium.otf", s), 
    createFont("Akkurat-Mono.otf", s), 
    createFont("GT-Sectra-Fine-Bold-Italic.ttf", s)
  }; 

  populateCopyArray();
}

void keyPressed() {
  if (key == ' ') {
    populateCopyArray();
  } else if (key == 'p') {
    bRecordingPDF = true;
  }
}


void draw() {
  if (bRecordingPDF) {
    beginRecord(PDF, String.valueOf(hour())+String.valueOf(minute())+String.valueOf(millis())+".pdf");
  }

  //--------------------------
  background(0); 
  int nCopy = allCopy.size();

  for (int i = 0; i < nCopy; i++) {
    Copy aCopy = allCopy.get(i);
    //aCopy.load();
    aCopy.drawCopy();
  }

  //--------------------------
  if (bRecordingPDF) {
    endRecord();
    bRecordingPDF = false;
  }
}

boolean crossCheckPosition(int _j, int _s, int _currentText, float _xStart, float _xLimit, float _yStart, float _yLimit) {
  Copy jCopy = allCopy.get(_j);
  println(_j +"  "+ texts[_currentText] +"  --testing--  " +jCopy.text);

  float jxStart = jCopy.xStart;
  float jxLimit = jCopy.xLimit;
  float jyStart = jCopy.yStart;
  float jyLimit = jCopy.yLimit;

  boolean tooCloseX = false;
  boolean tooCloseY = false;


  if (((_xStart>jxStart && _xStart<jxLimit) || (_xLimit>jxStart && _xLimit<jxLimit))||((_xStart<jxStart && _xLimit>jxStart) || (_xStart<jxLimit && _xLimit>jxLimit))) {
    tooCloseX = true;
    //println("Xs!!!  " + texts[currentText]+"  ------   "+ jCopy.text);
    //println("Left  "+ " xStart= "+_xStart+ "  jxStart= "+jxStart );
    //println("Right  "+ " xLimit= "+_xLimit+ "  jxLimit= "+jxLimit );
  }
  if (((_yStart>jyStart && _yStart<jyLimit) || (_yLimit>jyStart && _yLimit<jyLimit))||((_yStart<jyStart && _yLimit>jyStart) || (_yStart<jyLimit && _yLimit>jyLimit))) {
    tooCloseY = true;
    //println("Ys!!!  " + texts[currentText]+"  ------   "+ jCopy.text);
    //println("Tops  "+ " yStart= "+_yStart+ "  jyStart= "+jyStart );
    //println("Bottoms  "+ " yLimit= "+_yLimit+ "  jyLimit= "+jyLimit );
    //println("!!!  " + texts[currentText]+"  ------   "+ jCopy.text);
  }
  if (tooCloseX && tooCloseY) {
    //println("!!!  " + texts[_currentText]+"  ------   "+ jCopy.text);
    if (jyStart>_yStart) {
      if (jyStart-_s>0) {
        y=jyStart-_s;
      } else {
        y=jyLimit+_s;
      }
    }
    if (_yStart>jyStart) {
      if (jyLimit+_s <height) {
        y=jyLimit+_s;
      } else {
        y=jyStart-_s;
      }
    }
    _yStart=y-_s;
    _yLimit=y;
    //println("!!!!! Double Check");
    return true;
  } else {
    //println("----- We good");
    return false;
  }
}


void populateCopyArray() {
  allCopy.clear(); 

  int s = int(random(12, 70));
  float x = random(0, width*.9);
  float xStart, yStart, xLimit, yLimit;
  String text; 
  y = random(s, height-s);
  int initText = int(random(0, 4));
  int initFont = int(random(0, 4));
  boolean textBox = false;
  int currentText = initText+1;
  int currentFont = initFont+1;

  for (int i=0; i<texts.length; i++) {
    s = int(random(12, 70));
    x = random(0, width*.9); 
    y = random(s, height-s);
    if (i==0) {
      currentFont =initFont;
    } else {
      currentFont = initFont+1;
    }
    if (currentText >=texts.length) currentText = 0;
    if (currentFont >=fonts.length) currentFont = 0;
    textFont(fonts[currentFont]);
    textSize(s);
    textBox = false;
    text = texts[currentText];
    xLimit = textWidth(text)+x;
    yLimit = s;
    xStart = x;
    yStart = y-s;

    ////////check if original position is on canvas
    if ((textWidth(text)+x)>=width) { //off the page
      float off = (textWidth(text)+x)-width;
      if (x-off>=0) {
        //Shifted over
        x=x-off;
        xLimit=textWidth(text)+x;
        xStart=x;
        yStart=y-s;
        yLimit=y;
      } 
      if (x-off<0) {
        //textbox
        textBox = true;
        x=10;
        xLimit=width-10;
        xStart=x;
        yStart=y-s;
        yLimit=s*1.2*2+y;
      }
    } 
    if ((textWidth(text)+x)<width) {
      //fits normally 
      xLimit=textWidth(text)+x;
      xStart=x;
      yStart=y-s;
      yLimit=y;
    }

    ///// check to see if interfering with other text posts
    for (int j=0; j<allCopy.size(); j++) {
      Copy jCopy = allCopy.get(j);
      if (jCopy.size>=s) {
        println("SIZE  "+texts[currentText]+"  "+s);
        if (s>=30) {
          if (jCopy.size<=s+20) {
            s-=20;
            println("SIZE CHANGE  "+texts[currentText]+"  "+s +"   "+jCopy.text+"   "+jCopy.size);
          }
        }
      }
      if (crossCheckPosition(j, s, currentText, xStart, xLimit, yStart, yLimit)) {
        yStart = y-s;
        yLimit = y;
        crossCheckPosition(j, s, currentText, xStart, xLimit, yStart, yLimit);
      }
    }

    Copy iCopy = new Copy(texts[currentText], fonts[currentFont], x, y, s, xLimit, yLimit, textBox);
    allCopy.add(iCopy);
    currentText+=1;
  }
}