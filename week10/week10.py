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
# OK now I am not totally sure if I was supposed to do this 
# Specify directory for photos
# directory = Path("/Users/cmdb/qbb2024-answers/week10/")

# # Only use files specified in directory 
# for tif_file in directory.iterdir():
#     if tif_file.suffix == '.tif': # Only use .tif 
#         #Read image, convert to pixel data
#         img = imageio.v3.imread(tif_file)

#         #Should these be grayscale? They are ... lol

#         # if img.ndim == 2:
#         #     print("The image is grayscale.")
#         # elif img.ndim == 3 and img.shape[2] == 3:
#         #     print("The image is a 3-color (RGB) image.")
#         # else:
#         #     print("The image has an unexpected number of channels.")
        
#         #Convert to float32 data type for precise mathematical operations
#         img = img.astype(np.float32)
        
#         #Find minimum pixel value, subtract from all images, so now the minimum pixel value is set to 0
#         img -= np.amin(img)
        
#         #Normalize the image by dividing by the maximum pixel value to scale it between 0 and 1
#         img /= np.amax(img)
        
#         # Save the processed image in its own directory
#         output_dir = Path("/Users/cmdb/qbb2024-answers/week10/processed_images")
#         output_filename = output_dir / f"processed_{tif_file.name}"
#         imageio.v3.imwrite(output_filename, img)
        
#         # # Show the image
#         # plt.imshow(img, cmap='gray')
#         # plt.title(f"Processed: {tif_file.name}")
#         # plt.colorbar()
#         # plt.show()
        
#         print(f"Processed and saved: {output_filename}")

#Oh I see the issue here, the images are a single channel and I am treating them as three channels 
#So if I have an image, for example: APEX1_field0_DAPI
#Sample (knocked-down gene) = APEX1
#Field (position in the sample well) = field0
#Channel = DAPI 

#I need to put all three channels in the same array for every image
#But the separate genes and fields get their own arrays
#So one array for each gene + field combination 
#APEX1_field0_DAPI.tif
#APEX1_field0_PCNA.tif
#APEX1_field0_nascentRNA.tif

#Let's try this again

# Specify the directory where your images are stored
directory = Path("/Users/cmdb/qbb2024-answers/week10/")

# Define the genes and fields
genes = ['APEX1', 'PIM2', 'POLR2B', 'SRSF1']
fields = [0, 1]  # field0 and field1
channels = ['DAPI', 'PCNA', 'nascentRNA']

# Make an empty list to store three-channel images
separate_images = {}

# Loop through all genes and both fields
for gene in genes:
    #Make an empty array for each gene inside the separate_images dictionary
    #Each key is a gene, each value is an empty numpy array 
    # separate_images[gene] = np.array([])
    for field in fields:
        # #Look at the shape of the array for one channel for every gene + field combination
        # representative = imageio.v3.imread(directory / f"{gene}_field{field}_DAPI.tif")
        # #Print it if you want to look at it
        # # print(representative.shape)
        # Make an empty list to hold images
        channel_images = []
        # Loop through the 3 channels (DAPI, PCNA, nascentRNA) for the current field and gene
        for i, channel in enumerate(channels):
            # Cobble together the active gene + field + channel to select the right image
            channel_path = directory / f"{gene}_field{field}_{channel}.tif"
            # Read the image as a numpy array called img
            img = imageio.v3.imread(channel_path)
            # # Confirm the shape is (520, 616) and the image looks normal
            # print(img.shape)
            # plt.imshow(img, cmap = "gray")
            # plt.axis('off')
            # plt.show()
            # Add the array for each channel to the list channel_images
            channel_images.append(img)
            # Stack the third dimension of the array into a new array called merged_array
            merged_array = np.dstack(channel_images)
        separate_images[f"{gene}_field{field}"] = merged_array  
        # #Confirm that the shape of the array is (520, 616, 3) and the image looks normal
        # print(merged_array.shape)
        # plt.imshow(merged_array)
        # plt.axis('off')
        # plt.show()

    


    #Once I figure out how to structure my image, need to get mean DAPI signal and use find labels where you pass an image but only greater or equal to the mean
    #Then filter by size using filter by size
    #Filter out small objects
    #Exclude the background 
    #Mean of sizes, standard deviation, filter again 
    #Then find the signals
    