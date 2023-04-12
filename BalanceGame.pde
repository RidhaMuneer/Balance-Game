import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;
import processing.serial.*;

Serial port;
int sensorValue;

int gameCount;
int playerCount = 1;
boolean gameStarted = false;
boolean nextScreen = false;
PImage backgroundImage;
int startTime; 
int elapsed; 
boolean isRunning = false;
boolean timerStarted = false;
int startTimeCount = 0;

Minim minim;
AudioPlayer player;
AudioPlayer backgroundd;
Minim background;

void setup() {
  port = new Serial(this, "/dev/ttyACM0", 9600);
  minim = new Minim(this);
  background = new Minim(this);
  backgroundd = minim.loadFile("/home/ridha/BalanceGame/backgroundd.wav");
  //player = minim.loadFile("/home/ridha/BalanceGame/click.wav");
  
  backgroundImage = loadImage("/home/ridha/BalanceGame/Untitled-1.jpg");
  
  size(1920, 1080);
  textAlign(CENTER, CENTER);
  backgroundd.play();
}

void draw() {
  background(backgroundImage);
  if (gameStarted && !nextScreen) {
    if (port.available() > 0) {
  String data = port.readStringUntil('\n');
  if (data != null) {
    println(data);
    try{
      sensorValue = Integer.parseInt(data.trim());
    } catch(NumberFormatException e){
      println("Error: " + e.getMessage());
    }
  }
  if (isRunning) { 
    elapsed = millis() - startTime; 
  }
  textAlign(CENTER);
  fill(255);
  text("Elapsed time: " + elapsed/1000 + " seconds", width/2, height/2 - 120); 
  if (sensorValue >= 50 && sensorValue <= 120) { 
    if (!isRunning) {
      isRunning = true;
      startTime = millis() - elapsed;
    }
  } else {
    if (isRunning) {
      isRunning = false;
      elapsed = millis() - startTime;
      gameCount++;
      if(gameCount == 3){
        size(1920, 1080);
        background(backgroundImage);
        noStroke();
        fill(255, 0, 0); // set the fill color to red
        ellipse(width/2, height/2, 500, 500);
        fill(255);
        text("Your score is " + elapsed/1000 + " seconds", width/2, height/2 - 100);
        noLoop();
      }
    }
  }
  textAlign(CENTER);
  textSize(34);
  if(sensorValue >= 0 && sensorValue <= 50){
      fill(255, 0, 0);
      try{
      text(data + "cm", width/2, height/2);
      }catch(NullPointerException e){
       println("Unable to print the distance");
      }
      text("Too close, get back...", width/2, height/2 + 120);
  }else if(sensorValue > 50 && sensorValue <= 120){
      fill(0, 255, 0);
      try{
      text(data + "cm", width/2, height/2);
      }catch(NullPointerException e){
       println("Unable to print the distance");
      }
      text("Perfect, keep it up champ!!!", width/2, height/2 + 120);
  }else{
      fill(255, 0, 0);
      try{
      text(data + "cm", width/2, height/2);
      }catch(NullPointerException e){
       println("Unable to print the distance");
      }
      text("Too far, come closer!!!", width/2, height/2 + 120);
  }
  delay(500);
  }// end of if

  } else if (!gameStarted) {
    // Draw the "start game" button
    noStroke(); 
    fill(255, 100);
    rect(width/2 - 125, height/2 - 15, 250, 50);
    fill(255);
    text("Start game", width/2, height/2);
        
    // Draw the game name above the button
    textSize(44);
    text("Balance Game", width/2, height/2 - 100);
  } else if (nextScreen) {
    // Draw the "next page" text
    
}
}
void mousePressed() {
  if (!gameStarted && mouseX > width/2 - 50 && mouseX < width/2 + 50 && mouseY > height/2 - 15 && mouseY < height/2 + 15) {
    gameStarted = true;
    
  }
  else if (gameStarted && mouseX > width/2 - 50 && mouseX < width/2 - 20 && mouseY > height/2 && mouseY < height/2 + 30) {
    playerCount++;

  }
  else if (gameStarted && mouseX > width/2 + 20 && mouseX < width/2 + 50 && mouseY > height/2 && mouseY < height/2 + 30) {
    playerCount--;
    if (playerCount < 1) {
      playerCount = 1;
    }
  }
  else if (gameStarted && mouseX > width/2 - 50 && mouseX < width/2 + 50 && mouseY > height/2 + 100 && mouseY < height/2 + 130) {
    nextScreen = true;
  }
}
