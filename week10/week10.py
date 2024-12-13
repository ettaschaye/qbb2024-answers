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

# Define functions that are needed later
    # Filter by size 
def filter_by_size(labels, minsize, maxsize):
    # Find label sizes
    sizes = np.bincount(labels.ravel())
    # Iterate through labels, skipping background
    for i in range(1, sizes.shape[0]):
        # If the number of pixels falls outsize the cutoff range, relabel as background
        if sizes[i] < minsize or sizes[i] > maxsize:
            # Find all pixels for label
            where = np.where(labels == i)
            labels[where] = 0
    # Get set of unique labels
    ulabels = np.unique(labels)
    for i, j in enumerate(ulabels):
        # Relabel so labels span 1 to # of labels
        labels[np.where(labels == j)] = i
    return labels

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

        # For Exercise 2:
        # Select just DAPI channel
        DAPI = merged_array[:, :, 0]
        # Calculate the mean value across the DAPI array
        mean_DAPI = np.mean(DAPI)
        # Produce a boolean array where TRUE = value above the mean and FALSE = value below the mean
        mask_DAPI = DAPI > mean_DAPI
        # # Display the mask 
        # plt.imshow(mask_DAPI, cmap='gray')  # 'gray' colormap for a binary mask
        # plt.title('Mask for DAPI Channel (Above Mean)')
        # plt.axis('off')  # Hide axis labels
        # plt.show()    
     # Find_labels function from live coding
        def find_labels(mask_DAPI):
            # Set initial label
            l = 0
            # Create array to hold labels
            labels = np.zeros(mask_DAPI.shape, np.int32)
            # Create list to keep track of label associations
            equivalence = [0]
            # Check upper-left corner
            if mask_DAPI[0, 0]:
                l += 1
                equivalence.append(l)
                labels[0, 0] = l
            # For each non-zero column in row 0, check back pixel label
            for y in range(1, mask_DAPI.shape[1]):
                if mask_DAPI[0, y]:
                    if mask_DAPI[0, y - 1]:
                        # If back pixel has a label, use same label
                        labels[0, y] = equivalence[labels[0, y - 1]]
                    else:
                        # Add new label
                        l += 1
                        equivalence.append(l)
                        labels[0, y] = l
            # For each non-zero row
            for x in range(1, mask_DAPI.shape[0]):
                # Check left-most column, up  and up-right pixels
                if mask_DAPI[x, 0]:
                    if mask_DAPI[x - 1, 0]:
                        # If up pixel has label, use that label
                        labels[x, 0] = equivalence[labels[x - 1, 0]]
                    elif mask_DAPI[x - 1, 1]:
                        # If up-right pixel has label, use that label
                        labels[x, 0] = equivalence[labels[x - 1, 1]]
                    else:
                        # Add new label
                        l += 1
                        equivalence.append(l)
                        labels[x, 0] = l
                # For each non-zero column except last in nonzero rows, check up, up-right, up-right, up-left, left pixels
                for y in range(1, mask_DAPI.shape[1] - 1):
                    if mask_DAPI[x, y]:
                        if mask_DAPI[x - 1, y]:
                            # If up pixel has label, use that label
                            labels[x, y] = equivalence[labels[x - 1, y]]
                        elif mask_DAPI[x - 1, y + 1]:
                            # If not up but up-right pixel has label, need to update equivalence table
                            if mask_DAPI[x - 1, y - 1]:
                                # If up-left pixel has label, relabel up-right equivalence, up-left equivalence, and self with smallest label
                                labels[x, y] = min(equivalence[labels[x - 1, y - 1]], equivalence[labels[x - 1, y + 1]])
                                equivalence[labels[x - 1, y - 1]] = labels[x, y]
                                equivalence[labels[x - 1, y + 1]] = labels[x, y]
                            elif mask_DAPI[x, y - 1]:
                                # If left pixel has label, relabel up-right equivalence, left equivalence, and self with smallest label
                                labels[x, y] = min(equivalence[labels[x, y - 1]], equivalence[labels[x - 1, y + 1]])
                                equivalence[labels[x, y - 1]] = labels[x, y]
                                equivalence[labels[x - 1, y + 1]] = labels[x, y]
                            else:
                                # If neither up-left or left pixels are labeled, use up-right equivalence label
                                labels[x, y] = equivalence[labels[x - 1, y + 1]]
                        elif mask_DAPI[x - 1, y - 1]:
                            # If not up, or up-right pixels have labels but up-left does, use that equivalence label
                            labels[x, y] = equivalence[labels[x - 1, y - 1]]
                        elif mask_DAPI[x, y - 1]:
                            # If not up, up-right, or up-left pixels have labels but left does, use that equivalence label
                            labels[x, y] = equivalence[labels[x, y - 1]]
                        else:
                            # Otherwise, add new label
                            l += 1
                            equivalence.append(l)
                            labels[x, y] = l
                # Check last pixel in row
                if mask_DAPI[x, -1]:
                    if mask_DAPI[x - 1, -1]:
                        # if up pixel is labeled use that equivalence label 
                        labels[x, -1] = equivalence[labels[x - 1, -1]]
                    elif mask_DAPI[x - 1, -2]:
                        # if not up but up-left pixel is labeled use that equivalence label 
                        labels[x, -1] = equivalence[labels[x - 1, -2]]
                    elif mask_DAPI[x, -2]:
                        # if not up or up-left but left pixel is labeled use that equivalence label 
                        labels[x, -1] = equivalence[labels[x, -2]]
                    else:
                        # Otherwise, add new label
                        l += 1
                        equivalence.append(l)
                        labels[x, -1] = l
            equivalence = np.array(equivalence)
            # Go backwards through all labels
            for i in range(1, len(equivalence))[::-1]:
                # Convert labels to the lowest value in the set associated with a single object
                labels[np.where(labels == i)] = equivalence[i]
            # Get set of unique labels
            ulabels = np.unique(labels)
            for i, j in enumerate(ulabels):
                # Relabel so labels span 1 to # of labels
                labels[np.where(labels == j)] = i
            return labels
        labels = find_labels(mask_DAPI)
        # print(labels)
        #matplotlib.pyplot.imshow(labels, cmap = "gray")
        #matplotlib.pyplot.show()
        #Filter by size
        filter_by_size(labels, 100, 1000000)
        # Find the sizes for each item
        sizes = np.bincount(labels.ravel())
        # print(sizes)
        # Filter again, using mean size +/- sd as upper and lower bounds 
        filter_by_size(sizes, (np.mean(sizes) - np.std(sizes)), (np.mean(sizes) + np.std(sizes)))
        print(sizes)
        # matplotlib.pyplot.imshow(labels, cmap = "gray")
        # matplotlib.pyplot.show()
