#!/usr/bin/env python
import numpy as np
import scipy
import matplotlib.pyplot as plt
import imageio
import plotly.express as px
import plotly
import matplotlib
from pathlib import Path



# Load image into numpy array
# I will need to loop through the list of gene names
# For each gene, all the channels should be in the same array
#The format will be (X, Y, 3), meaning (width, height, n of channels)
#The data type of the image is numpy.uint16


#  Exercise 1

# #  Read image, convert to pixel data
# img = imageio.v3.imread("illum_DAPI.tif") 
# #  Convert to float32 data type for precise mathematical operations
# #  find minimum pixel value, subtract from all images, so now the minimum pixel value is set to 0
# img = img.astype(numpy.float32) - numpy.amin(img)  
# #  Find the new maximum pixel value and divide all pixels by that value
# #  now the maximum pixel value will = 1
# img /= numpy.amax(img) 

#  Now you have a numpy array with values between 0 and 1

# So let me try this as a loop
# Specify directory for photos
directory = Path("/Users/cmdb/qbb2024-answers/week10/")

# Only use files specified in directory 
for tif_file in directory.iterdir():
    if tif_file.suffix == '.tif': # Only use .tif 
        #Read image, convert to pixel data
        img = imageio.v3.imread(tif_file)
        
        #Convert to float32 data type for precise mathematical operations
        img = img.astype(np.float32)
        
        #Find minimum pixel value, subtract from all images, so now the minimum pixel value is set to 0
        img -= np.amin(img)
        
        #Normalize the image by dividing by the maximum pixel value to scale it between 0 and 1
        img /= np.amax(img)
        
        # Save the processed image in its own directory
        output_dir = Path("/Users/cmdb/qbb2024-answers/week10/processed_images")
        output_filename = output_dir / f"processed_{tif_file.name}"
        imageio.v3.imwrite(output_filename, img)
        
        # # Show the image
        # plt.imshow(img, cmap='gray')
        # plt.title(f"Processed: {tif_file.name}")
        # plt.colorbar()
        # plt.show()
        
        print(f"Processed and saved: {output_filename}")