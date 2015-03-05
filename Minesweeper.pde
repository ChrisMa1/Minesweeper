public static final int numBombs=70;
public static final int rows= 25;
public static final int columns=25;
public int squaresCovered=rows*columns;
public boolean gameOver=false;
public Button [][] buttons;
void setup() {
  buttons=new Button[rows][columns];
  for (int i=0; i<rows; i++) {
    for (int j=0; j<columns; j++) {
      buttons[i][j]=new Button(i, j);
    }
  }
  size(625, 625);
  showBoard();
}
void draw() {
  showBoard(); 
  if(!gameOver){
    if (squaresCovered==numBombs) {
      fill(255);
      stroke(0);
      rectMode(CENTER);
      rect(width/2,height/2, 150,50);
      fill(255, 0, 0);
      textSize(30);
      textAlign(CENTER,CENTER);
      text("You Win!", width/2, height/2);
      gameOver=false;
    }
  }else{
      fill(255);
      stroke(0);
      rectMode(CENTER);
      rect(width/2,height/2, 150,50);
     fill(255, 0, 0);
     textSize(30);
     textAlign(CENTER,CENTER);
     text("You Lose!", width/2, height/2); 
  }
}
public void createBoard(int x, int y) {
  for (int i=0; i<numBombs; i++) { 
    int r= (int)(Math.random()*rows);
    int c= (int)(Math.random()*columns);
    if (buttons[r][c].value != 13 || !(x==c && r==y)) {
      buttons[r][c].value=13;
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
  for (int i=0; i<=rows; i++) {   //draw grid lines
    line(0, i*25, columns*25, i*25);
  }
  for (int i=0; i<=columns; i++) {
    line(i*25, 0, i*25, rows*25);
  }

  for (int i=0; i<rows; i++) { //SHOW VALUES
    for (int j=0; j<columns; j++) {
      if (buttons[i][j].value==13) {
        fill(0);
        noStroke();
        ellipse(j*25+12.5, i*25+12.5, 10, 10);
      } else {
        if (buttons[i][j].value==0) {
        } else {
          fill(0);
          textAlign(BASELINE,LEFT);
          textSize(15);
          text(buttons[i][j].value, j*25+10, i*25+18.75);
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
  Button(int r, int c) {
    shown=true;
    flagged=false;
    xPos=c; 
    yPos=r;
    value=0;
  }
  void show() {
    stroke(0);
    if (shown) {
      if (mouseX>xPos*25 && mouseX<xPos*25+25 && mouseY>yPos*25 && mouseY< yPos*25+25) {
        fill(150, 150, 150);
      } else {
        fill(200, 200, 200);
      }      
      if (flagged)fill(255, 0, 0);
        rectMode(CORNER);
        rect(xPos*25, yPos*25, 25, 25);
    } else {
      if (this.value==13) {
        gameOver=true;
      }
    }
  }
  void clear() {
    if (this.shown) {
      if (this.value==0) {
        squaresCovered--;
        for (int i=-1; i<2; i++) {
          for (int j=-1; j<2; j++) {
            if (yPos+i>=0 && yPos+i<rows && xPos+j>=0 && xPos+j<columns) {
              shown=false;
              buttons[yPos+i][xPos+j].clear();
            }
          }
        }
      } else {
        this.shown=false;
        squaresCovered--;
      }
    }
  }
}
void mouseReleased() {
  if (squaresCovered==rows*columns && mouseButton== LEFT) {
    createBoard((int)(mouseY/25), (int)(mouseX/25));
  }
  if (gameOver==false) {
    if (mouseButton== LEFT && !buttons[(int)(mouseY/25)][(int)(mouseX/25)].flagged) {
      buttons[(int)(mouseY/25)][(int)(mouseX/25)].clear();
    }
    if (mouseButton== RIGHT) {
      buttons[(int)(mouseY/25)][(int)(mouseX/25)].flagged=!buttons[(int)(mouseY/25)][(int)(mouseX/25)].flagged;
    }
  }
}

