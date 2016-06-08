Authors:
Sahit Bollineni
Juan Orozco


This files provides brief instructions on how to run the different algorithms that we implemented.



SKIN-COLOR BLOB DETECTOR:

In Matlab, set your current folder to be the SkinColorBlobDetector folder included with this file.

To run the Skin-Color Blob Detector, go into the imageTest.m file.

You may then uncomment the classroom picture you would like to run the program on. After doing so, run the imageTest program.

The program will output the output figures as well as some intermediary figures which led up to the final result.




VIOLA JONES:

In Matlab, set your current folder to be the ViolaJones folder included with this file.

To run Viola-Jones with a specified number of stages and specified number of weak classifiers, execute "ViolaJones_Attentional_Cascade_NonAdaptive.m"

to run Viola-Jones with adaptive number of weak classifiers based on desired detection and false positive rate, run "ViolaJones_AttenCascade_Adaptive.m"

Note: Both of these files have descriptive comments to understand what is going on in the code.




EIGENFACES:

In Matlab, set your current folder to be Eigenfaces folder included with this file.

To run our eigenface algorithm implementation, execute "EigenFaces_MainCode.m" 



NEURAL NETWORKS:

In Matlab, set your current folder to be the NeuralNetworks folder included with this file.

This program uses the University of Washington database (faces, background folders) for stage 1

This program uses the AT&T Laboratories Cambridge database (databases folder) for stage 2

To run stage 1 (Face or Non-Face), run the faceornot.m file.

To run stage 2 (Face Identification), run the faceIdentify.m file.