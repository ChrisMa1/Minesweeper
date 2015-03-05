import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Minesweeper extends PApplet {

public static final int numBombs=20;
public static final int rows= 25;
public static final int columns=20;
public int squaresCovered=rows*columns;
public boolean gameOver=false;
public Button [][] buttons;
public void setup() {
  buttons=new Button[rows][columns];
  for (int i=0; i<rows; i++) {
    for (int j=0; j<columns; j++) {
      buttons[i][j]=new Button(i, j);
    }
  }
  size(columns*25+100, rows*25+100);
  createBoard();
}
public void draw() {
  if(squaresCovered==numBombs){
    gameOver=true; 
    text("You Win!",width/2-50,height/2-50);
  }
  if (!gameOver)
    showBoard(); 
}
public void createBoard() {
  for (int i=0; i<numBombs; i++) { 
    int r= (int)(Math.random()*rows);
    int c= (int)(Math.random()*columns);
    if (buttons[r][c].value != 13) {
      buttons[r][c].value=13;
      fill(0);
    } else {
      i--;
    }
  }
  for (int i=0; i<rows; i++) { //create values of non-bombs
    for (int j=0; j<columns; j++) {
      if (buttons[i][j].value==13) {
        for (int k=i-1; k<i+2; k++) {
          for (int l=j-1; l<j+2; l++) {
            if (l<0 || l>columns-1 || k<0 ||k>rows-1) {
            } else {
              buttons[k][l].value++;
              if (buttons[k][l].value>13)
                buttons[k][l].value=13;
            }
          }
        }
      }
    }
  }
}

public void showBoard() {
  background(255);
  strokeWeight(1);
  stroke(0);
  for (int i=0; i<=height; i+=25) {   //draw grid lines
    line(0, i, width, i);
  }
  for (int i=0; i<=width; i+=25) {
    line(i, 0, i, height);
  }
  for (int i=0; i<rows; i++) { //SHOW VALUES
    for (int j=0; j<columns; j++) {
      if (buttons[i][j].value==13) {
        fill(0);
        noStroke();
        ellipse(i*25+12.5f, j*25+12.5f, 10, 10);
      } else {
        if (buttons[i][j].value==0) {
        } else {
          fill(0);
          text(buttons[i][j].value, i*25+10, j*25+18.75f);
        }
      }
    }
    /////////////////////////
  }
  for (int i=0; i<rows; i++) {
    for (int j=0; j<columns; j++) {
      buttons[i][j].show();
    }
  }
}

public class Button {
  private boolean shown;
  private boolean flagged;
  int xPos;
  int yPos;
  int value;
  Button(int x, int y) {
    shown=true;
    flagged=false;
    xPos=x; 
    yPos=y;
    value=0;
  }
  public void show() {
    stroke(0);
    if (shown) {
      if (mouseX>xPos*25 && mouseX<xPos*25+25 && mouseY>yPos*25 && mouseY< yPos*25+25) {
        fill(150, 150, 150);
      } else {
        fill(200, 200, 200);
      }      
      if(flagged)fill(255,0,0);
      rect(xPos*25, yPos*25, 25, 25);
    } else {
      if (this.value==13)gameOver=true;
    }
  }
  public void clear() {
    if (this.shown==true) {
      if (this.value==0) {
        for (int i=-1; i<2; i++) {
          for (int j=-1; j<2; j++) {
            if (xPos+i>=0 && xPos+i<rows && yPos+j>=0 && yPos+j<columns) {
              shown=false;
              buttons[xPos+i][yPos+j].clear();
              squaresCovered--;
            }
          }
        }
      } else {
        this.shown=false;
      }
    }
  }
}
public void mouseReleased() {
  if (mouseButton== LEFT) {
    buttons[(int)(mouseX/25)][(int)(mouseY/25)].clear();
  }
  if (mouseButton== RIGHT) {
    buttons[(int)(mouseX/25)][(int)(mouseY/25)].flagged=true;
  }
}

  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Minesweeper" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
