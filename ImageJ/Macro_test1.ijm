// Function to apply color thresholding
function applyColorThreshold(filePath) {
    open(filePath);
    run("Color Threshold...");
    // Color Thresholder 1.54g
    min=newArray(3);
    max=newArray(3);
    filter=newArray(3);
    a=getTitle();
    run("HSB Stack");
    run("Convert Stack to Images");
    selectWindow("Hue");
    rename("0");
    selectWindow("Saturation");
    rename("1");
    selectWindow("Brightness");
    rename("2");
    min[0]=45;
    max[0]=58;
    filter[0]="pass";
    wait(500);
    min[1]=77; // Updated to match specified value
    max[1]=255;
    filter[1]="pass";
    wait(500);
    min[2]=59;
    max[2]=120;
    filter[2]="pass";
    wait(500);
    for (i=0; i<3; i++) {
        selectWindow(""+i);
        setThreshold(min[i], max[i]);
        wait(1000);
        run("Convert to Mask");
        wait(1000);
        if (filter[i]=="stop") run("Invert");
    }
    imageCalculator("AND create", "0", "1");
    imageCalculator("AND create", "Result of 0", "2");
    for (i=0; i<3; i++) {
        selectWindow(""+i);
        close();
    }
    selectWindow("Result of 0");
    close();
    selectWindow("Result of Result of 0");
    rename(a);
    // Close the color threshold dialog
    // run("Close");
}

// Set the directory containing the images
inputDir = "/Users/alyssadaigle/Desktop/test/";

// Set the directory for results
resultsDir = inputDir + "Results/";

// Create the folder for results if it doesn't exist
File.makeDirectory(resultsDir);

// Get the list of files in the directory
fileList = getFileList(inputDir);

// Loop through each image in the directory
for (i = 0; i < fileList.length; i++) {
    // Construct the full path to the file
    filePath = inputDir + fileList[i];
    
    // Check if the item is a directory
    if (File.isDirectory(filePath)) {
        continue; // Skip directories
    }
    
    // Check if the file is an image (e.g., JPEG, PNG)
    if (endsWith(fileList[i], ".jpg") || endsWith(fileList[i], ".jpeg") || endsWith(fileList[i], ".png")) {
        


        
        // Load ROIs
        roiManager("Open", inputDir + "RoiSet.zip");
        applyColorThreshold(filePath);
        roiCount = roiManager("count");
        print(roiCount);
      
        for (j = 0; j < roiCount; j++) {

            roiManager("Select", j);
            run("Crop");
            wait(50000);
            // Apply the color thresholding
            wait(500);
            // for (k = 0; 
            run("Analyze Particles...", "size=100-Infinity circularity=0.00-Infinity display exclude clear add" ); //summarize add");
       
            // Save the results
            saveAs("Results", resultsDir + "Results_" + fileList[i] + ".csv");
         
            // Close the image after processing
            close(filePath);
 }
        

    }
}

// Final cleanup: Close any remaining open windows
close("*");
