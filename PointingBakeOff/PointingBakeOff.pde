import java.awt.Rectangle;
import java.util.ArrayList;
import java.util.Collections;
import processing.core.PApplet;


// you SHOULD NOT need to edit any of these variables
int lastX = 0;
int lastY = 0;
int margin = 300; // margin from sides of window
final int padding = 35; // padding between buttons and also their width/height
ArrayList trials = new ArrayList(); //contains the order of buttons that activate in the test
int trialNum = 0; //the current trial number (indexes into trials array above)
int startTime = 0; // time starts when the first click is captured.
int userX = mouseX; //stores the X position of the user's cursor
int userY = mouseY; //stores the Y position of the user's cursor
int finishTime = 0; //records the time of the final click
int hits = 0; //number of succesful clicks
int misses = 0; //number of missed clicks
int best = Integer.MAX_VALUE;

// You can edit variables below here and also add new ones as you see fit
int numRepeats = 3; //sets the number of times each button repeats in the test (you can edit this)


void draw()
{
  noCursor();
  margin = width/3; //scale the padding with the size of the window
  background(0); //set background to black

  if (trialNum >= trials.size()) //check to see if test is over
  {
    fill(255); //set fill color to white
    //write to screen
    text("Finished!", width / 2, height / 2); 
    text("Hits: " + hits, width / 2, height / 2 + 20);
    text("Misses: " + misses, width / 2, height / 2 + 40);
    text("Accuracy: " + (float)hits*100f/(float)(hits+misses) +"%", width / 2, height / 2 + 60);
    text("Total time taken: " + (finishTime-startTime) / 1000f + " sec", width / 2, height / 2 + 80);
    text("Average time for each button: " + ((finishTime-startTime) / 1000f)/(float)(hits+misses) + " sec", width / 2, height / 2 + 100);

    return; //return, nothing else to do now test is over
  }

  fill(255); //set fill color to white
  text((trialNum + 1) + " of " + trials.size(), 40, 20); //display what trial the user is on

  for (int i = 0; i < 16; i++) {
    // for all button
    stroke(0, 0, 0);
    drawButton(i); //draw button
  }

  // you shouldn't need to edit anything above this line! You can edit below this line as you see fit

  if (lastX != 0 && lastY != 0) {
    stroke(0, 255, 0);
    line(lastX, lastY, ((int) trials.get(trialNum) % 4) * padding * 2 + margin  + padding/2, ((int) trials.get(trialNum) / 4) * padding * 2 + margin + padding/2);
  }

  fill(255, 255, 255); // set fill color to red
  stroke(255, 255, 255);
  ellipse(userX, userY, 12, 12); //draw user cursor as a circle with a diameter of 20

  if (trialNum > 0 && trials.get(trialNum) == trials.get(trialNum - 1)) {
    fill(255);
    text("CLICK SAME!", mouseX, mouseY - 10);
  }
}

void mousePressed() // test to see if hit was in target!
{
  if (trialNum >= trials.size())
    return;

  if (trialNum == 0) //check if first click
    startTime = millis();

  if (trialNum == trials.size() - 1) //check if final click
  {
    finishTime = millis();
    //write to terminal
    System.out.println("Hits: " + hits);
    System.out.println("Misses: " + misses);
    System.out.println("Accuracy: " + (float)hits*100f/(float)(hits+misses) +"%");
    System.out.println("Total time taken: " + (finishTime-startTime) / 1000f + " sec");
    System.out.println("Average time for each button: " + ((finishTime-startTime) / 1000f)/(float)(hits+misses) + " sec");
  }

  Rectangle bounds = getButtonLocation((Integer)trials.get(trialNum));

  // YOU CAN EDIT BELOW HERE IF YOUR METHOD REQUIRES IT (shouldn't need to edit above this line)

  if ((userX > bounds.x && userX < bounds.x + bounds.width) && (userY > bounds.y && userY < bounds.y + bounds.height)) // test to see if hit was within bounds
  {
    System.out.println("HIT! " + trialNum + " " + (millis() - startTime)); // success
    hits++;
  } else
  {
    System.out.println("MISSED! " + trialNum + " " + (millis() - startTime)); // fail
    misses++;
  }

  //can manipulate cursor at the end of a trial if you wish
  //userX = width/2; //example manipulation
  //userY = height/2; //example manipulation

  lastX = getButtonLocation((int) trials.get(trialNum)).x + padding/2;
  lastY = getButtonLocation((int) trials.get(trialNum)).y + padding/2;

  trialNum++; // Increment trial number
}


void updateUserMouse() // YOU CAN EDIT THIS
{
  // you can do whatever you want to userX and userY (you shouldn't touch mouseX and mouseY)
  userX += mouseX - pmouseX; //add to userX the difference between the current mouseX and the previous mouseX
  userY += mouseY - pmouseY; //add to userY the difference between the current mouseY and the previous mouseY
}









// ===========================================================================
// =========SHOULDN'T NEED TO EDIT ANYTHING BELOW THIS LINE===================
// ===========================================================================

void setup()
{
  size(900, 900, P2D); // set the size of the window
  // noCursor(); // hides the system cursor (can turn on for debug, but should be off otherwise!)
  noStroke(); //turn off all strokes, we're just using fills here (can change this if you want)
  noSmooth();
  textFont(createFont("Arial", 16));
  textAlign(CENTER);
  frameRate(100);
  ellipseMode(CENTER); //ellipses are drawn from the center (BUT RECTANGLES ARE NOT!)
  // ====create trial order======
  for (int i = 0; i < 16; i++)
    // number of buttons in 4x4 grid
    for (int k = 0; k < numRepeats; k++)
      // number of times each button repeats
      trials.add(i);

  Collections.shuffle(trials); // randomize the order of the buttons
  System.out.println("trial order: " + trials);
}

Rectangle getButtonLocation(int i)
{
  double x = (i % 4) * padding * 2 + margin;
  double y = (i / 4) * padding * 2 + margin;

  return new Rectangle((int)x, (int)y, padding, padding);
}

void drawButton(int i)
{
  Rectangle bounds = getButtonLocation(i);

  if ((Integer)trials.get(trialNum) == i) {// see if current button is the target
    stroke(0, 255, 0);
    if(trialNum > 0 && trials.get(trialNum) == trials.get(trialNum - 1)) {
      fill(255, 0, 255);
    } else if ((userX > bounds.x && userX < bounds.x + bounds.width) && (userY > bounds.y && userY < bounds.y + bounds.height)) {
      fill(0, 255, 0);
    } else {
      fill(255, 0, 0); // if so, fill cyan
    }
  } else if (trialNum < trials.size() - 1 && (Integer) trials.get(trialNum + 1) == i) {
    fill(0, 0, 255);
  } else {
    fill(150); // if not, fill gray
  }

  rect(bounds.x, bounds.y, bounds.width, bounds.height);
}

void keyPressed() {
  System.out.println("HI");
  if (key == 32) {
    mousePressed();
  }
}

void mouseMoved() // Don't edit this
{
  updateUserMouse();
}

void mouseDragged() // Don't edit this
{
  updateUserMouse();
}