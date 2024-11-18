#!/usr/bin/env python

import numpy
import scipy
import matplotlib.pyplot as plt
import imageio
import plotly.express as px
import plotly
import matplotlib

#Test image for determining dimensions later
img = imageio.v3.imread("APEX1_field0_DAPI.tif").astype(numpy.uint16)

#Make the empty list which will contain each of the 3 channel images
images = []

for gene in ["APEX1", "PIM2", "POLR2B", "SRSF1"]:
    for field in ["field0", "field1"]:
        #assemble the array from each channel
        imgArray = numpy.zeros((img.shape[0], img.shape[1], 3), numpy.uint16)

        imgArray[:, :, 0] = imageio.v3.imread(f"{gene}_{field}_DAPI.tif").astype(numpy.uint16)
        imgArray[:, :, 1] = imageio.v3.imread(f"{gene}_{field}_nascentRNA.tif").astype(numpy.uint16)
        imgArray[:, :, 2] = imageio.v3.imread(f"{gene}_{field}_PCNA.tif").astype(numpy.uint16)

        images.append(imgArray)

#Load in the segmentation function from class 

def find_labels(mask):
    # Set initial label
    l = 0
    # Create array to hold labels
    labels = numpy.zeros(mask.shape, numpy.int32)
    # Create list to keep track of label associations
    equivalence = [0]
    # Check upper-left corner
    if mask[0, 0]:
        l += 1
        equivalence.append(l)
        labels[0, 0] = l
    # For each non-zero column in row 0, check back pixel label
    for y in range(1, mask.shape[1]):
        if mask[0, y]:
            if mask[0, y - 1]:
                # If back pixel has a label, use same label
                labels[0, y] = equivalence[labels[0, y - 1]]
            else:
                # Add new label
                l += 1
                equivalence.append(l)
                labels[0, y] = l
    # For each non-zero row
    for x in range(1, mask.shape[0]):
        # Check left-most column, up  and up-right pixels
        if mask[x, 0]:
            if mask[x - 1, 0]:
                # If up pixel has label, use that label
                labels[x, 0] = equivalence[labels[x - 1, 0]]
            elif mask[x - 1, 1]:
                # If up-right pixel has label, use that label
                labels[x, 0] = equivalence[labels[x - 1, 1]]
            else:
                # Add new label
                l += 1
                equivalence.append(l)
                labels[x, 0] = l
        # For each non-zero column except last in nonzero rows, check up, up-right, up-right, up-left, left pixels
        for y in range(1, mask.shape[1] - 1):
            if mask[x, y]:
                if mask[x - 1, y]:
                    # If up pixel has label, use that label
                    labels[x, y] = equivalence[labels[x - 1, y]]
                elif mask[x - 1, y + 1]:
                    # If not up but up-right pixel has label, need to update equivalence table
                    if mask[x - 1, y - 1]:
                        # If up-left pixel has label, relabel up-right equivalence, up-left equivalence, and self with smallest label
                        labels[x, y] = min(equivalence[labels[x - 1, y - 1]], equivalence[labels[x - 1, y + 1]])
                        equivalence[labels[x - 1, y - 1]] = labels[x, y]
                        equivalence[labels[x - 1, y + 1]] = labels[x, y]
                    elif mask[x, y - 1]:
                        # If left pixel has label, relabel up-right equivalence, left equivalence, and self with smallest label
                        labels[x, y] = min(equivalence[labels[x, y - 1]], equivalence[labels[x - 1, y + 1]])
                        equivalence[labels[x, y - 1]] = labels[x, y]
                        equivalence[labels[x - 1, y + 1]] = labels[x, y]
                    else:
                        # If neither up-left or left pixels are labeled, use up-right equivalence label
                        labels[x, y] = equivalence[labels[x - 1, y + 1]]
                elif mask[x - 1, y - 1]:
                    # If not up, or up-right pixels have labels but up-left does, use that equivalence label
                    labels[x, y] = equivalence[labels[x - 1, y - 1]]
                elif mask[x, y - 1]:
                    # If not up, up-right, or up-left pixels have labels but left does, use that equivalence label
                    labels[x, y] = equivalence[labels[x, y - 1]]
                else:
                    # Otherwise, add new label
                    l += 1
                    equivalence.append(l)
                    labels[x, y] = l
        # Check last pixel in row
        if mask[x, -1]:
            if mask[x - 1, -1]:
                # if up pixel is labeled use that equivalence label 
                labels[x, -1] = equivalence[labels[x - 1, -1]]
            elif mask[x - 1, -2]:
                # if not up but up-left pixel is labeled use that equivalence label 
                labels[x, -1] = equivalence[labels[x - 1, -2]]
            elif mask[x, -2]:
                # if not up or up-left but left pixel is labeled use that equivalence label 
                labels[x, -1] = equivalence[labels[x, -2]]
            else:
                # Otherwise, add new label
                l += 1
                equivalence.append(l)
                labels[x, -1] = l
    equivalence = numpy.array(equivalence)
    # Go backwards through all labels
    for i in range(1, len(equivalence))[::-1]:
        # Convert labels to the lowest value in the set associated with a single object
        labels[numpy.where(labels == i)] = equivalence[i]
    # Get set of unique labels
    ulabels = numpy.unique(labels)
    for i, j in enumerate(ulabels):
        # Relabel so labels span 1 to # of labels
        labels[numpy.where(labels == j)] = i
    return labels

#Load in the mask size filtering function from class 
def filter_by_size(labels, minsize, maxsize):
    # Find label sizes
    sizes = numpy.bincount(labels.ravel())
    # Iterate through labels, skipping background
    for i in range(1, sizes.shape[0]):
        # If the number of pixels falls outsize the cutoff range, relabel as background
        if sizes[i] < minsize or sizes[i] > maxsize:
            # Find all pixels for label
            where = numpy.where(labels == i)
            labels[where] = 0
    # Get set of unique labels
    ulabels = numpy.unique(labels)
    for i, j in enumerate(ulabels):
        # Relabel so labels span 1 to # of labels
        labels[numpy.where(labels == j)] = i
    return labels


#Print the header for the final data output
print("Gene", "nascentRNA", "PCNA", "log2ratio", sep = "\t")

#Do the rest of the analysis within by looping through each image
for i in range(8): 
    current_image = images[i]
    DAPI_image = current_image[:,:,0]
    nascent_image = current_image[:,:,1]
    PCNA_image = current_image[:,:,2]
    #Make the binary mask array
    mask = DAPI_image > numpy.mean(DAPI_image)
    #Create the label array using the function from class 
    label_array = find_labels(mask)
    #filter out any labels below 100 pixels (removes small noisy labels we dont want)
    label_array = filter_by_size(label_array, 100, 100000000)
    #find the sizes of each label 
    sizes = numpy.bincount(label_array.ravel())
    #Remove count of 0
    sizes = sizes[1:]
    #find mean and sd of sizes
    mean_size = numpy.mean(sizes)
    sd_size = numpy.std(sizes)
    #Get the final labels (mean +/- sd of sizes)
    label_array = filter_by_size(label_array, mean_size - sd_size, mean_size + sd_size)
    #finding PCNA and nascent RNA signal. First, find the total number of nuclei in the image
    num_nuclei = numpy.amax(label_array)
    num_nuclei = num_nuclei + 1
    #next, loop through each nuclei, and find the signal for nascent and PCNA, then log transform/ratio and print the values
    for j in range(1, num_nuclei):
        where = numpy.where(label_array == j)
        nascent_signal = numpy.mean(nascent_image[where])
        PCNA_signal = numpy.mean(PCNA_image[where])
        log2ratio = numpy.log2(nascent_signal / PCNA_signal)
        if i in [0, 1]: 
            Gene = "APEX1"
        if i in [2, 3]:
            Gene = "PIM2"
        if i in [4,5]:
            Gene = "POLR2B"
        if i in [6,7]: 
            Gene = "SRSF1"
        print(Gene, nascent_signal, PCNA_signal, log2ratio, sep = "\t")


#Saved the output of this script as nuclei_signal.txt using the following line in terminal: 
#./week10.py > nuclei_signal.txt



    







    

