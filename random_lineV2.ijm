// This macro creates random lines in an user created ROI or in the whole image. 
// The user gets the option in the macro to create the ROI and to set the number of random lines required.
// If the user creates an ROI this is added to the ROI manager. 
// All random lines are added to the ROI manager.

// Part of the randomization is obtained from https://imagej.nih.gov/ij/macros/examples/RandomizeArray.txt but further optimized with a time factor.

// Dr Kees Straatman, University of Leicester, 4 July 2022


var x1,y1,x2,y2;

macro random_line{

	w = getWidth();
	h = getHeight();
	RM = 0; //Precense of a ROI created by the user
	primes = newArray(2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97); // used for randimisation
	
	
	// The user can add a ROI to the image in which the random line will be created
	// Check if ROI manager is open and empty
	if (isOpen("ROI Manager")&&(roiManager("count")>0)) {
		roiManager("deselect");
		roiManager("delete");
	}
	run("Select None");
	setTool("freehand");
	
		// Create ROI, check if there is a ROI and add it to the ROI manager
	waitForUser("if you require a ROI please create the ROI and select \"OK\".\nIf you want to use the whole image just select \"OK\".");
	if (getValue("selection.size")!=0){
		roiManager("add");
		RM = 1; // A selection has been created by the user and added to ROI manager
	}
	

	
	// Check wiht user how many random lines are required
	Dialog.create("Line repeats")
		Dialog.addNumber("How many random lines do you want to create?", 1);
	Dialog.show(); 
	repeats = Dialog.getNumber();
	
	
	for (i = 0; i < repeats; i++) {
		x2=-1; y2=-1;
		Tx = true;
		Ty = true;
		X1 = -1; X2 = -1; Y1 = -1; Y2 = -1; // to check that x,y are not on the edge of the ROI

		
		getDimensions(xd,yd,z,c,t); // Size of the image 
		do { // Run till the line is within the selection if there is a selection
			
			// Seed the random number generator 
			shuffle(primes);
			random('seed', getTime()*primes[1]); 
			
			// Create point in XY 
			x = round(random()*xd); 
       		y = round(random()*yd); 

			//Check if there is a ROI and if point is within the ROI
			if (RM==1){
				roiManager("select", 0);
				if (selectionContains(x, y)) answer = true;
				else answer = false;
			}else answer = true; // If there is no ROI 
		} while (answer==false)


		// Create random angle
		g = random("gaussian");
		t = Math.atan2(random(), random());
		a = t*180/PI*g;

		dx=(x2-x1); dy=(y2-y1);
		d=sqrt(dx*dx+dy*dy);

		while ((Tx ==true)||(Ty==true)){ // x and y are not on the edge of a ROI or the border of the image
	
			// Check if there is a ROI and if the point falls in the ROI
			if (RM==1){
				roiManager("select",0);
		
				if (Roi.contains(x-d*cos(a), y-d*sin(a))){
					X1 = x-d*cos(a);
					Y1 = y-d*sin(a);
				}else{
					Tx = false; 
				}
		
				if (Roi.contains(x+d*cos(a), y+d*sin(a))){
					X2 = x+d*cos(a);
					Y2 = y+d*sin(a);
				}else{
					Ty=false;
				}

				//print(X1,Y1,X2,Y2);
			
			// if there is no ROI
			}else{ 

				if (((x-d*cos(a)) < 0)||((y-d*sin(a)) < 0)||((x-d*cos(a)) > w)||((y-d*sin(a)) > h)){
					Tx = false; 
				}else{
					X1 = x-d*cos(a);
					Y1 = y-d*sin(a);
				}

				if (((x+d*cos(a)) > w)||((y+d*sin(a)) > h)||((x+d*cos(a)) < 0)||((y+d*sin(a)) < 0)){
					Ty=false;

				}else{
					X2 = x+d*cos(a);
					Y2 = y+d*sin(a);
				}
	
			}

			// Check that x,y are not on the edge of the ROI (there is no Xn,Yn) and if correct draw line 
			if ((X1 > -1)&&(X2 > -1)&&(Y1 > -1)&&(Y2 > -1)) makeLine(X1,Y1,X2,Y2); 

			// next point on the line
			x2 = x2+1;
			y2= y2+1;
			dx=(x2-x1); dy=(y2-y1);
 			d=sqrt(dx*dx+dy*dy);

	
		}
		// Add line to the ROI manager
		roiManager("add");
		
	}
}


function shuffle(array) {
   n = array.length;		// The number of items left to shuffle (loop invariant).
   while (n > 1) {
      k = randomInt(n);		// 0 <= k < n.
      n--;                 	// n is now the last pertinent index;
      temp = array[n];		// swap array[n] with array[k] (does nothing if k==n).
      array[n] = array[k];
      array[k] = temp;
   }
}

// returns a random number, 0 <= k < n
function randomInt(n) {
   return n * random();
}