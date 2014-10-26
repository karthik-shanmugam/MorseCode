import processing.serial.*;
Serial myPort;
PFont f;                          // STEP 2 Declare PFont variable
String output="";
int outputVal;
long lastPress=0, lastRelease=0;
long unit=200;
boolean released=false;
String[] morseAlphabet={".-" , "-..." , "-.-." , "-.." , "." , "..-." , "--." , "...." , ".." , ".---" , "-.-" , ".-.." , "--" , "-." , "---" , ".--." , "--.-" , ".-." , "..." , "-" , "..-" , "...-" , ".--" , "-..-" , "-.--" , "--.." , ".----" , "..---" , "...--" , "....-" , "....." , "-...." , "--..." , "---.." , "----." , "-----"};
char[] alphabet   =    {'A'  , 'B'    , 'C'    , 'D'   , 'E' , 'F'    , 'G'   , 'H'    , 'I'  , 'J'    , 'K'   , 'L'    , 'M'  , 'N'  , 'O'   , 'P'    , 'Q'    , 'R'   , 'S'   ,'T'  , 'U'   , 'V'    , 'W'   , 'X'    , 'Y'    , 'Z'    , '1'     , '2'     ,'3'      , '4'     , '5'     , '6'     , '7'     , '8'     , '9'     , '0'    };
void setup() {
  size(800,800);
  f = createFont("Arial",60,true); // STEP 3 Create Font
    background(255);
      myPort = new Serial(this, Serial.list()[5], 9600);

}

void draw() {
  background(255);
  textFont(f,60);                 // STEP 4 Specify font to be used
  fill(0);       
while (myPort.available() > 0) {
    int inByte = myPort.read();
    if (inByte=='1')pressed();
    else if (inByte=='0')released();
    
    }  // STEP 5 Specify font color 
  text(translate(output)
,10,100);
  println(output);// STEP 6 Display Text
}
void keyPressed(){
output="";
lastRelease=0;
lastPress=0;
}
void pressed(){
if (lastRelease==0){
  lastPress=millis();
  return;
  }
lastPress=millis();
long gap = lastPress-lastRelease;
if (gap<3*unit)output+="";
else if (gap<7*unit) output+=" ";
else output+="/";
}

void released(){
lastRelease=millis();
long gap = lastRelease-lastPress;
if(gap<unit)output+=".";
else output+="-";
}

String translate(String s){
char[] a = s.toCharArray();
String translation="";
String word="";
for (char c:a){
if(c=='/'){
  translation+=parseWord(word);
  word="";
}
else word+=c;
}
translation+=parseWord(word);
return translation;
}

String parseWord(String s){
char[] a = s.toCharArray();
String word="";
String letter="";
for (char c:a){
if(c==' '){
  word+=parseLetter(letter);
  letter="";
}
else letter+=c;
}
  word+=parseLetter(letter);

return word+" ";
}

char parseLetter(String s){
int index=-1;
for (int i=0;i<alphabet.length;i++){
if (morseAlphabet[i].equals(s))index=i;
}
if (index==-1)return '@';
else return alphabet[index];
}
