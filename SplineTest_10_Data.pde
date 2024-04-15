import processing.pdf.*;

// ***** ***** ***** ***** ***** ***** *****
void setup(){
  //size(1920,1080);
  size(2200,1100, PDF, "SplineShuffle.pdf");
  //
  noLoop();
}

// ***** ***** ***** ***** ***** ***** *****
void draw(){
  colorMode(HSB,360,100,100);
  //background(210,20,20);
  //drawBGgrid();
  //----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
  // DEFINITION OF FONTS
  PFont font1 = createFont("SourceSansPro-ExtraLight.otf",10);
  //PFont font2 = createFont("SourceSansPro-Regular.otf",10);
  //PFont font1 = createFont("MyriadPro-Cond.otf",10);
  PFont font2 = createFont("MyriadPro-Regular.otf",10);
  PFont font3 = createFont("SourceSansPro-Bold.otf",10); 
  //----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
  // DEFINITION OF COLORS
  //
  float col_base  = 120;
  float col_range = 210;
  float col_sat   = 75;
  float col_val   = 100;
  //
  Float[][] SketchColors = new Float[9][3];
  for(int i=0;i<9;i++){
    SketchColors[i][0] = (col_base + col_range*i/8)%360;
    SketchColors[i][1] = col_sat;
    SketchColors[i][2] = col_val;
    //
  }
  //SketchColors[4][0] = 40.0; SketchColors[4][1] = col_sat; SketchColors[4][2] = col_val;
  //SketchColors[5][0] = 20.0; SketchColors[5][1] = col_sat; SketchColors[5][2] = col_val;
  SketchColors[8][0] = 00.0; SketchColors[8][1] = 0.0; SketchColors[8][2] = 45.0;
  colorMode(HSB,360,100,100);
  //----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
  Table table = loadTable("Moviedata_Extended.csv");
  int N = table.getRowCount();
  int bx = 200; 
  //
  String filmname;
  float xR = width/2.0 -160;
  // Variables for control points of spline curves
  PVector P1, P2, P3, P4;
  //
  
  // Amount of movies per franchise and "others"
  float[] k = {4,8,8,24,5,11,6,13,95};
  
  int rank_franlist;

  //----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
  //LEFT SIDE: 8 FRANCHISES GROUPED + OTHERS WITH BARS FOR TOTAL GROSS
  float xL = width/2.0 - 320;
  
  //Right Side of Middle-Diagram
  float xR2 = width/2.0 + 320;
  
  // Total box office gross (adjusted) of the franchises
  float[] fran_gross = {8087.9, 5763.7, 9895.2, 16559, 5464.1, 16064, 5449.3, 6855.1, 49735};
  // Total budget (adjusted) of the franchises
  float[] fran_budget = {1472.4, 1152.9, 1785.9, 2539.4, 1602.6, 2134.6, 1276.9, 1999.2, 10359.4};
  
  // According franchise names
  String[] fran_names = {"The Avengers", "The Fast And The Furious", "Harry Potter", "James Bond", "Pirates Of The Caribbean", "Star Wars", "Transformers", "X-Men", "Others"};
  
  // Controls upper/lower distance to sketch border
  float by = 250;
  // Thickness of gross bars
  float d = 36;
  // Variable for left border of gross bars
  float xL2;
  // Varibale for y-Position of gross bars
  float yL;
  // Step Size Y for gross bars
  float ystepL = (height-2*by)/8.0;
  
  for(int i=0;i<=8;i++){
    //
    yL = by + i*ystepL;
    //
    // Colors
    fill(SketchColors[i][0],SketchColors[i][1],SketchColors[i][2]);
    //
    // Left end of Franchise gross bars
    xL2 = xL - fran_gross[i]/125;
    
    //
    // Franchise gross bars made of circles and rects
    noStroke();

    arc(xL2+d/2.0,yL,d,d,HALF_PI,PI+HALF_PI);
    
    rectMode(CORNER);
    rect(xL2+d/2.0 -1,yL-d/2, xL-xL2-d/2.0 + 1,d);
    //
    // Franchise titles and total gross as text
    fill(0,0,100);
    textAlign(RIGHT,CENTER);
    textSize(12);
    // Franchise names
    textFont(font2);
    text(fran_names[i],xL2-d/4.0,yL-8);
    // Franchise total gross
    textFont(font1);
    text(nf(fran_gross[i], 0, 1) + " Mio. $",xL2-d/4.0,yL+8);
    //
  }
  //----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
  //LEFT SIDE: STARTING POINTS OF CONNECTING SPLINE CURVES
  
  // Thickness of spline-curves
  float dL,dR,dR2;
  // Array to store beginning of spline-curves (Contains X-/Y-coordinate and thickness)
  float[][] posL = new float[174][3];
  // For the right side, the array only story y-positions and thickness values
  float[][] posR = new float[174][2];
  
  int cnt = 0;
  
  // Reduced line-thickness for splines on right side
  dR2 = (1.0/2.0)*d;
  
  for(int i=0;i<=8;i++){
    for(int j=0;j<k[i];j++){
      // Colors
        fill(SketchColors[i][0],SketchColors[i][1],SketchColors[i][2]);
        // Center-Position
        yL = by + i*ystepL;
        //
        posL[cnt][0] = xL;
        posL[cnt][1] = yL - d/2.0 + d/(2*k[i]) + j*(d/k[i]);
        // Thickness of curve
        posL[cnt][2] = d/k[i];
        
        //-----
        // Right side /
        posR[cnt][0] = yL - dR2/2.0 + dR2/(2*k[i]) + j*(dR2/k[i]);
        // Thickness of curve
        posR[cnt][1] = dR2/k[i];
        
        //
        // Increase Counter
        cnt = cnt+1;
    }
  }
  
  // Reset lower/upper border
  by = 30;
  // Step Size Y
  float ystepR = (height-2*by)/173.0;
  //
  // Set reference x-coordinate (runtime)
  float refX = xR+185;
  
  //
  // Draw Runtime mean Value
  stroke(30,75,100);
  strokeWeight(0.5);
  noFill();
  line(refX + 125.97*100/240.0, by - 1.5*ystepR, refX + 125.97*100/240.0, by + (N-1)*ystepR + 1.5*ystepR);
  //
  // Runtime mean Text
  textAlign(CENTER,CENTER);
  textFont(font1);
  textSize(3);
  fill(30,75,100);
  text("AVG. 126 min.",refX + 125.97*100/240.0, by - 2*ystepR);
  text("AVG. 126 min.",refX + 125.97*100/240.0, by + (N-1)*ystepR + 2*ystepR);
  
  //----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
  //BIG FOR-LOOP
  //----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
  //RIGHT SIDE: END POINTS OF CONNECTING SPLINE CURVES
  
  // Ranking position for box office
  int rank_boxoffice;
  
  // Ranking position for budget
  int rank_budget;
  
  // Variable for right y-Position of connecting splines
  float yR;
  
  // Variable for franchise-name;
  String fran_name;
  
  // Variable for spline curvature
  float r = 65;
  
  //Variable for current franchise chosen
  int ind_fran;
  
  //Variable to save ratio between budget and box office for line diagram
  float runtime;
  
  for(int i=1;i<N;i++){
    //
    // Get Film-names
    filmname = table.getRow(i).getString(0);
    // Get Box Office Rank
    rank_boxoffice = table.getRow(i).getInt(19);
    // Get Design Template Franchise Rank
    rank_franlist = table.getRow(i).getInt(13);
    //
    // Set Colors
    fran_name = table.getRow(i).getString(11);
    
    if (fran_name.equals("The Avengers")){
      ind_fran = 0;
    }
    else if (fran_name.equals("The Fast And The Furious")){
      ind_fran = 1;
    }
    else if (fran_name.equals("Harry Potter")){
      ind_fran = 2;
    }
    else if (fran_name.equals("James Bond")){
      ind_fran = 3;
    }
    else if (fran_name.equals("Pirates of the Caribbean")){
      ind_fran = 4;
    }
    else if (fran_name.equals("Star Wars")){
      ind_fran = 5;
    }
    else if (fran_name.equals("Transformers")){
      ind_fran = 6;
    }
    else if (fran_name.equals("X-Men")){
      ind_fran = 7;
    }
    else{
      ind_fran = 8;
    }
    
    // Set new y-Position for right end of spline-curve
    yR = by + (rank_boxoffice-1)*ystepR;
    
    // Define control points of spline-curve
    P1 = new PVector(posL[rank_franlist-1][0],posL[rank_franlist-1][1]);
    P2 = new PVector(posL[rank_franlist-1][0]+10,posL[rank_franlist-1][1]);
    P3 = new PVector(xR-10,yR);
    P4 = new PVector(xR,yR);
    
    // Define thickness of spline-curve
    dL = posL[rank_franlist-1][2]*1.05;
    dR = 1;
    
    //----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
    //MIDDLE-PART: BOX-OFFICE RANKING
    
    // SPLINE-CURVES
    color C1 = color(SketchColors[ind_fran][0],SketchColors[ind_fran][1],SketchColors[ind_fran][2]);
    color C2 = lerpColor(C1,color(SketchColors[ind_fran][0],SketchColors[ind_fran][1],50),0.35);
    drawSpline2(P1,P2,P3,P4,r,dL,dR,C1,C2);
    
    // Ranking Boxes
    rectMode(CENTER);
    noStroke();
    fill(SketchColors[ind_fran][0],SketchColors[ind_fran][1],SketchColors[ind_fran][2]);
    rect(xR+5, yR, 12, 3*ystepR/4.0);
    // Ranking Text
    textAlign(CENTER,BOTTOM);
    textFont(font2);
    textSize(5);
    fill(0,0,20);
    text(rank_boxoffice,xR+5, yR + 3*ystepR/7.0);
    
    //
    // Filmnames
    textAlign(LEFT,BOTTOM);
    textFont(font2);
    textSize(5);
    fill(SketchColors[ind_fran][0],SketchColors[ind_fran][1],SketchColors[ind_fran][2]);
    text(filmname,xR+15, yR + 3*ystepR/7.0);
    //
    // Get Box office
    float boxoffice = table.getRow(i).getFloat(10);
    textAlign(RIGHT,BOTTOM);
    textFont(font3);
    textSize(5);
    fill(0,0,100);
    text(nf(boxoffice,0,1) + " Mio. $",xR + 165,yR + 3*ystepR/7.0);
    //
    // Connecting lines for readability
    stroke(SketchColors[ind_fran][0],SketchColors[ind_fran][1],SketchColors[ind_fran][2]);
    strokeWeight(0.25);
    float lineXL, lineXR;
    lineXL = xR+30 + 1.9*filmname.length();
    lineXR = xR+132;
    if (lineXL>=lineXR){
      lineXL = lineXR;
      noStroke();
    }
    line(lineXL ,P4.y, lineXR ,P4.y);
    
    //----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
    //SECOND PART: RUNTIME
    //
    // Get runtime rank
    int rank_runtime = table.getRow(i).getInt(14);
    //
    // Ranking Boxes
    rectMode(CENTER);
    noStroke();
    fill(SketchColors[ind_fran][0],SketchColors[ind_fran][1],SketchColors[ind_fran][2]);
    rect(refX - 11, yR, 12, 3*ystepR/4.0);
    //
    // Add runtime rank Text
    textAlign(CENTER,BOTTOM);
    textFont(font2);
    textSize(5);
    fill(0,0,20);
    text(rank_runtime,refX - 11, yR + 3*ystepR/7.0);
    //
    //Get current runtime
    runtime = table.getRow(i).getFloat(2);
    //
    // Draw reference Lines horizontal
    stroke(SketchColors[ind_fran][0],SketchColors[ind_fran][1],SketchColors[ind_fran][2]);
    strokeWeight(0.25);
    line(refX,yR,refX+100,yR);
    //
    // Draw Dots
    fill(SketchColors[ind_fran][0],SketchColors[ind_fran][1],SketchColors[ind_fran][2]);
    circle(refX + (runtime/240.0)*100, yR,3);
    //
    // Add runtime Text
    textAlign(RIGHT,BOTTOM);
    textFont(font3);
    textSize(5);
    fill(0,0,100);
    text(int(runtime) + " min.",refX + 123, yR + 3*ystepR/7.0);
    
    //----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
    //RIGHT PART: SPLINES AND BUDGETS
    
    // Define control points of spline-curve
    P4 = new PVector(refX + 130 + 5,yR);
    P3 = new PVector(refX + 130 + 5 + 10,yR);
    P2 = new PVector(xR2 - 10, posR[rank_franlist-1][0]);
    P1 = new PVector(xR2, posR[rank_franlist-1][0]);
    
    // Define thickness of spline-curve
    dR = 1;
    dL = posR[rank_franlist-1][1]*1.05;
    
    // SPLINE-CURVES
    C1 = color(SketchColors[ind_fran][0],SketchColors[ind_fran][1],SketchColors[ind_fran][2]);
    C2 = lerpColor(C1,color(SketchColors[ind_fran][0],SketchColors[ind_fran][1],50),0.35);
    drawSpline2(P1,P2,P3,P4,r,dL,dR,C1,C2);
    
    // Get Budget Rank
    rank_budget = table.getRow(i).getInt(18);
    
    //
    // Ranking Budget Boxes
    rectMode(CENTER);
    noStroke();
    fill(SketchColors[ind_fran][0],SketchColors[ind_fran][1],SketchColors[ind_fran][2]);
    rect(refX + 130 + 2, yR, 12, 3*ystepR/4.0);
    // Ranking Budget Text
    textAlign(CENTER,CENTER);
    textFont(font2);
    textSize(5);
    fill(0,0,20);
    text(rank_budget,refX + 130 + 2, yR);
    
  }
  // END OF BIG LOOP
  
  
  //----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
  // FRANCHISE BARS MADE OF CIRCLES AND RECTS
  by = 250;

  // Right end of budget bars/half-circle
  float xR3;
  
  for(int i=0;i<=8;i++){
    //
    yL = by + i*ystepL;
    //
    // Colors
    fill(SketchColors[i][0],SketchColors[i][1],SketchColors[i][2]);
    
    // Right end of Franchise budget bars
    xR3 = xR2 + fran_budget[i]/125;
    
    //
    noStroke();
    arc(xR3 - dR2/2.0, yL, dR2, dR2, -HALF_PI, HALF_PI);
    
    rectMode(CORNER);
    if (xR3 - xR2 - dR2/2.0 + 1 > 0){
      rect(xR2 - 1, yL - dR2/2, xR3 - xR2 - dR2/2.0 + 1, dR2);
    }

    //
    // Franchise titles and total gross as text
    fill(0,0,100);
    textAlign(LEFT,CENTER);
    textSize(12);
    // Franchise names
    textFont(font2);
    text(fran_names[i], xR3 + d/4.0, yL-8);
    // Franchise total gross
    textFont(font1);
    text(nf(fran_budget[i], 0, 1) + " Mio. $", xR3 + d/4.0, yL + 8);
    //
  }
  
  
  //----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
  //ROTTEN TOMATOES RANKING | Rotten Tomatoes and Audience Score as Bar Graph on the right side
  
  // Reset left Align
  refX = 150;
  by = 30;
  //
  
  // LINES FOR TOMATOMARKINGS
  for(int j=0;j<5;j++){
    noStroke();
    textFont(font1);
    textSize(3);
    if(j==0){
      textAlign(LEFT,CENTER);
    }
    else if(j==4){
      textAlign(RIGHT,CENTER);
    }
    else{
      textAlign(CENTER,CENTER);
    }
    fill(0,0,100);
    text((j*25 + "%"), refX + j*25 + 9, by - 1.25*ystepR);
    text((j*25 + "%"), refX + j*25 + 9, by + (N-1)*ystepR + 1.25*ystepR);
    //
    stroke(0,0,50,20);
    strokeWeight(0.1);
    if(j<=3){
      for(int m=0;m<5;m++){
        line(refX + m*5 + 9 + j*25, by-5, refX + m*5 + 9 + j*25, by + (N-1)*ystepR);
      }
    }
    stroke(0,0,100);
    strokeWeight(0.1);
    line(refX + j*25 + 9, by-5, refX + j*25 + 9, by + (N-1)*ystepR);
   }

   //----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
   //BIG FOR-LOOP
   //----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----    
   for(int i=1;i<N;i++){
    
    // Get Box office
    int rank_tomataudience = table.getRow(i).getInt(17);
    int tomatoscore = table.getRow(i).getInt(7);
    int audiencescore = table.getRow(i).getInt(8);
    int tomataudience = (tomatoscore+audiencescore)/2;
    
    // Set Y Stepsize
    yR = by + (rank_tomataudience-1)*ystepR;
    
    // Set Franchise Colors
    switch (table.getRow(i).getString(11)){
      case "The Avengers":
        ind_fran = 0;
        break;
      case "The Fast And The Furious":
        ind_fran = 1;
        break;
      case "Harry Potter":
        ind_fran = 2;
        break;
      case "James Bond":
        ind_fran = 3;
        break;
      case "Pirates of the Caribbean":
        ind_fran = 4;
        break;
      case "Star Wars":
        ind_fran = 5;
        break;
      case "Transformers":
        ind_fran = 6;
        break;
      case "X-Men":
        ind_fran = 7;
        break;
      default:
        ind_fran = 8;
        break;
    }
    // MOVIENAMES
    textFont(font2);
    textSize(5);
    textAlign(RIGHT,CENTER);
    fill(SketchColors[ind_fran][0],SketchColors[ind_fran][1],SketchColors[ind_fran][2]);
    text(table.getRow(i).getString(0),refX - 9,yR);
    
    // MOVIE-RATINGS ANNOTATIONS
    textFont(font1);
    textSize(5);
    textAlign(RIGHT,CENTER);
    fill(0,0,100);
    text( (tomataudience),refX +100 +8 +8,yR);
    fill(SketchColors[ind_fran][0],SketchColors[ind_fran][1],SketchColors[ind_fran][2]);
    text( (tomatoscore),refX +100 +8 +8 +8,yR);
    fill(SketchColors[ind_fran][0],SketchColors[ind_fran][1]*0.66,SketchColors[ind_fran][2]);
    text( (audiencescore),refX +100 +8 +8 +8 +8,yR);
    
    // TOMATOSCORES BARS
    noStroke();
    fill(SketchColors[ind_fran][0],SketchColors[ind_fran][1],SketchColors[ind_fran][2]);
    rectMode(CENTER);
    // MARKING TOMATOMETER
    rect(refX + 9 + tomatoscore/2.0, yR-ystepR/6.0, tomatoscore ,ystepR/5.0);
    // MARKING AUDIENCESCORE
    fill(SketchColors[ind_fran][0],SketchColors[ind_fran][1]*0.66,SketchColors[ind_fran][2]);
    rect(refX + 9 + audiencescore/2.0, yR+ystepR/6.0, audiencescore ,ystepR/5.0);
    // MARKING MEAN VALUE
    fill(0,0,100);
    rect(refX + 9 + tomataudience, yR, 0.3 ,ystepR*0.9);
    
    // Ranking Boxes
    rectMode(CENTER);
    noStroke();
    fill(SketchColors[ind_fran][0],SketchColors[ind_fran][1],SketchColors[ind_fran][2]);
    rect(refX ,yR, 12,3*ystepR/4.0);
    //
    // Add mean Tomato/Audience score rank Text
    textAlign(CENTER,CENTER);
    textFont(font2);
    textSize(5);
    fill(0,0,20);
    text(rank_tomataudience,refX,yR);
    
  }
  
  // MARKING RUNTIME MEAN VALUE OVERALL
  //fill(0,0,100);
  //rect(refX + 9 + 68, yR, 0.3 , 3*ystepR);
  stroke(30,75,100);
  strokeWeight(0.5);
  noFill();
  line(refX + 9 + 68, by - 1.5*ystepR, refX + 9 + 68, by + (N-1)*ystepR + 1.5*ystepR);
  
  // MARKING RUNTIME MEAN TEXT
  textAlign(CENTER,CENTER);
  textFont(font1);
  textSize(3);
  fill(30,75,100);
  text("AVG. 68%",refX + 9 + 68, by - 2*ystepR);
  text("AVG. 68%",refX + 9 + 68, by + (N-1)*ystepR + 2*ystepR);
  
  
  //----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
  //MOVIE DATES
  
  // Reset x-coordinate reference
  refX = xR2 + 180 + 330;
  // Width of dates diagram
  float widthR = 200;
  
  // y-Stepsize
  ystepR = (height - 2*by)/61;
  
  // Gridlines horizontal
  for(int i=0;i<=61;i++){
    stroke(0,0,50,20);
    strokeWeight(0.5);
    noFill();
    line(refX, by + i*ystepR, refX + widthR, by + i*ystepR);
    //
    textAlign(LEFT,CENTER);
    textFont(font1);
    textSize(12);
    fill(0,0,100);
    if(i<=60){
      text(2020 - i, refX + widthR + 10,  by + i*ystepR + ystepR/2.0);
    }
  }
  
  String[] monthnames = {"Jan","Feb","Mar","Apr","Mai","Jun","Jul","Aug","Sep","Oct","Nov","Dez"};
  
  
  // Gridlines vertical
  for(int i=0;i<=12;i++){
    stroke(0,0,50,20);
    strokeWeight(0.5);
    noFill();
    line(refX + i*widthR/12, by, refX + i*widthR/12, height - by);
    //
    // Month markings
    if(i<12){
      textAlign(RIGHT,CENTER);
      textFont(font1);
      textSize(12);
      push();
      translate(refX + i*widthR/12.0 + widthR/24, height - by + 9);
      rotate(-PI/4);
      text((monthnames[i]), 0, 0);
      pop();
    }
  }
  // Gridlines border
  stroke(0,0,100);
  strokeWeight(1);
  // Verts
  line(refX,by, refX, height - by);
  line(refX + widthR, by, refX+widthR ,height - by);
  // Horz
  line(refX,by, refX + widthR, by);
  line(refX,height - by, refX + widthR,height -  by);
  
  String filmdate;
  String[] filmdateA;
  int month = 1;
  
  //----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
  //BIG FOR-LOOP
  //----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----    
  for(int i=1;i<N;i++){
    
    filmdate = table.getRow(i).getString(3);
    filmdateA = split(filmdate, '-');
    
    // Current month
    switch (filmdateA[1]){
      case "Jan":
        month = 1;
      break;
      case "Feb":
        month = 2;
      break;
      case "Mar":
        month = 3;
      break;
      case "Apr":
        month = 4;
      break;
      case "May":
        month = 5;
      break;
      case "Jun":
        month = 6;
      break;
      case "Jul":
        month = 7;
      break;
      case "Aug":
        month = 8;
      break;
      case "Sep":
        month = 9;
      break;
      case "Okt":
        month = 10;
      break;
      case "Nov":
        month = 11;
      break;
      case "Dez":
        month = 12;
      break;
    }
    
    // Set Franchise Colors
    switch (table.getRow(i).getString(11)){
      case "The Avengers":
        ind_fran = 0;
        break;
      case "The Fast And The Furious":
        ind_fran = 1;
        break;
      case "Harry Potter":
        ind_fran = 2;
        break;
      case "James Bond":
        ind_fran = 3;
        break;
      case "Pirates of the Caribbean":
        ind_fran = 4;
        break;
      case "Star Wars":
        ind_fran = 5;
        break;
      case "Transformers":
        ind_fran = 6;
        break;
      case "X-Men":
        ind_fran = 7;
        break;
      default:
        ind_fran = 8;
        break;
    }
    
    // Set Y Stepsize
    yR = height - by - (int(filmdateA[2]) - 1960)*ystepR;
    
    noFill();
    strokeWeight(1.5);
    stroke(SketchColors[ind_fran][0],SketchColors[ind_fran][1],SketchColors[ind_fran][2]);
    //     refX   width          stpsz. X: month current day    stepsize X: day
    circle(refX + month*(widthR/12.0) + int(filmdateA[0])*(widthR/(12.0*30)) , yR - ystepR/2, ystepR/2);
    
  }
  
  
  
  exit();
}

// ***** ***** ***** ***** ***** ***** *****
// DRAWS BACKGROUND GRID
void drawBGgrid(){
  //
  // Draw background grid
  colorMode(RGB,100);
  stroke(25);
  strokeWeight(0.1);
  //Diagonal Cross
  line(0,0,width,height);
  line(0,height,width,0);
  //
  int Nc = 10;
  float x,y;
  //
  // Draw numbers for background grid
  textSize(8);
  fill(255);
  //
  for(int i=0;i<=Nc;i++){
    x = i*(width/Nc);
    line(x,0,x,height);
    //
    text(int(x),x,10);
    //
    y = i*(height/Nc);
    line(0,y,width,y);
    //
    text(int(y),10,y);  
  }
}
