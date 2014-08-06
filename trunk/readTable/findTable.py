

#TODO: Find table using something that identifies a SvS-table
#and surf it

import cv2
from cv2 import imshow
from cv2 import imread

mask = numpy.ones(tblSize) #Should only include where the number is
hessThresh = 400
surf = cv2.SURF(hessThresh)
surf.upright = True #Not rotation-invariant
surf.extended = False #Dunno what, but faster, not as accurate
#kp = surf.detect(card, mask)
kp, des = surf.detectAndCompute(card,mask)

#Create descriptors for numbers in cards, should be a private attribute in class
filename = '../../../img/three.png'
im = imread(filename, 0)
desNum = []
kpp, dess = surf.detectAndCompute(im,  None)
desNum.append(dess)

#Match the card with a number
bf = cv2.BFMatcher()
match = bf.knnMatch(des, desNum[0], k=1) #Return only the best result