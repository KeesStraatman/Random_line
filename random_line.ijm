
var x1,y1,x2,y2;

macro random_line{

	x2=-1; y2=-1;
	Tx = true;
	Ty = true;
	w = getWidth();
	h = getHeight();
	X1 = -1; X2 = -1; Y1 = -1; Y2 = -1; // to check that x,y are not on the edge of the ROI
	
	getDimensions(xd,yd,z,c,t); // Size of the image 
	do { 
		// Seed the random number generator 
		random('seed', getTime()); 

		// Create point in XY 
	
		x = round(random()*xd); 
       	y = round(random()*yd); 

		//Check if there is a ROI and if point is within the ROI
		if (roiManager("count")> 0){
			roiManager("select", 0);
			if (selectionContains(x, y)) answer = true;
			else answer = false;
		}else answer = true; // If there is no ROI 
	} while (answer==false)
	//print(x, y);
	//makePoint(x, y, "small red hybrid");


	// Create random angle
	g = random("gaussian");
	t = Math.atan2(random(), random());
	a = t*180/PI*g;

	dx=(x2-x1); dy=(y2-y1);
	d=sqrt(dx*dx+dy*dy);

	while ((Tx ==true)||(Ty==true)){ // x and y are not on the edge of a ROI or the border of the image
	
		// Check if there is a ROI and if the point falls in the ROI
		if (roiManager("count")> 0){
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
	
		//print(X1,Y1,X2,Y2);
		}

		// Check that x,y are not on the edge of the ROI (there is no Xn,Yn) and if correct draw line 
		if ((X1 > -1)&&(X2 > -1)&&(Y1 > -1)&&(Y2 > -1)) makeLine(X1,Y1,X2,Y2); 

		// next point on the line
		x2 = x2+1;
		y2= y2+1;
		dx=(x2-x1); dy=(y2-y1);
 		d=sqrt(dx*dx+dy*dy);

	
	}
	//makeLine(X1,Y1,X2,Y2);
	//makePoint(x, y, "small red hybrid");
}