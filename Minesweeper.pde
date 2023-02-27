import de.bezier.guido.*;
final int NUM_ROWS = 20;
final int NUM_COLS = 20;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList <MSButton> (); //ArrayList of just the minesweeper buttons that are mined
public boolean firstClick = true;

void setup () {
  size(400, 400);
  textAlign(CENTER, CENTER);

  // make the manager
  Interactive.make( this );

  buttons = new MSButton[NUM_ROWS][NUM_COLS];
  for (int r = 0; r < NUM_ROWS; r++) {
    for (int c = 0; c < NUM_COLS; c++)
      buttons[r][c] = new MSButton(r, c);
  }

  setMines();
}
public void setMines() {
  for (int m = 0; m < NUM_ROWS*NUM_COLS/10.0; m++) {
    int row = (int)(Math.random()*NUM_ROWS);
    int col = (int)(Math.random()*NUM_COLS);
    if (!mines.contains(buttons[row][col]))
      mines.add(buttons[row][col]);
  }
}

public void draw () {
  background( 0 );
  if (isWon() == true)
    displayWinningMessage();
}
public boolean isWon() {
  for (int r = 0; r < NUM_ROWS; r++) {
    for (int c = 0; c < NUM_COLS; c++) {
      if (!buttons[r][c].clicked && !mines.contains(buttons[r][c]))
        return false;
      if (!buttons[r][c].flagged && mines.contains(buttons[r][c]))
        return false;
    }
  }
  return true;
}

public void displayLosingMessage() {
  for (int r = 0; r < NUM_ROWS; r++) {
    for (int c = 0; c < NUM_COLS; c++) {
      if(mines.contains(buttons[r][c])){
        //fill(255, 0, 0);
        //rect(buttons[r][c].getX(), buttons[r][c].getY(), buttons[r][c].getW(), buttons[r][c].getH());
        buttons[r][c].setClicked(true);
    }
      buttons[r][c].setLabel("L");
    }
  }
}

public void displayWinningMessage() {
  for (int r = 0; r < NUM_ROWS; r++) {
    for (int c = 0; c < NUM_COLS; c++) {
      buttons[r][c].setLabel("W");
    }
  }
}

public boolean isValid(int r, int c) {
  return r < NUM_ROWS && c < NUM_COLS && r >=0 && c >= 0;
}

public int countMines(int row, int col) {
  int numMines = 0;
  for (int r = row-1; r <= row+1; r++) {
    for (int c = col-1; c <= col+1; c++) {
      if (isValid(r, c) && mines.contains(buttons[r][c]))
        numMines++;
    }
  }
  if (mines.contains(buttons[row][col]))
    numMines-=1;
  return numMines;
}
public class MSButton {
  private int myRow, myCol;
  private float x, y, width, height;
  private boolean clicked, flagged;
  private String myLabel;
  
  public float getX(){return x;}
  public float getY(){return y;}
  public float getW(){return width;}
  public float getH(){return height;}
  
  public void setClicked(boolean cc) {clicked = cc;}

  public MSButton ( int row, int col ) {
    width = 400/NUM_COLS;
    height = 400/NUM_ROWS;
    myRow = row;
    myCol = col; 
    x = myCol*width;
    y = myRow*height;
    myLabel = "";
    flagged = clicked = false;
    Interactive.add( this ); // register it with the manager
  }

  // called by manager
  public void mousePressed () {
    if (mouseButton == RIGHT && !clicked) {
      flagged = !flagged;
    } else if (!flagged) {
      if (firstClick) {
        firstClick = false;
        for (int r = -1; r <= 1; r++) {
          for (int c = -1; c <= 1; c++) {
            if (isValid(myRow+r, myCol+c)) {
              if (mines.contains(buttons[myRow+r][myCol+c]))
                mines.remove(buttons[myRow+r][myCol+c]);
            }
          }
        }
      }
      clicked = true;
      if (mines.contains(this))
        displayLosingMessage();
      else if (countMines(myRow, myCol) > 0)
        myLabel = Integer.toString(countMines(myRow, myCol));
      else {
        for (int r = -1; r <= 1; r++) {
          for (int c = -1; c <= 1; c++) {
            if (isValid(myRow+r, myCol+c) && !buttons[myRow+r][myCol+c].clicked && (r != 0 || c != 0))
              buttons[myRow+r][myCol+c].mousePressed();
          }
        }
      }
    }
  }
  public void draw () {    
    if (flagged)
      fill(0);
    else if ( clicked && mines.contains(this) )
      fill(255, 0, 0);
    else if (clicked)
      fill( 200 );
    else 
    fill( 100 );

    rect(x, y, width, height);
    fill(0);
    text(myLabel, x+width/2, y+height/2);
  }
  public void setLabel(String newLabel) {
    myLabel = newLabel;
  }
  public void setLabel(int newLabel) {
    myLabel = ""+ newLabel;
  }
  public boolean isFlagged() {
    return flagged;
  }
}
