
import cv2
from cv2 import imread
from cv2 import imshow
from pyscreenshot import grab
import numpy


#Potential classes: Table, Card, Player,

#Defining constants
global HEARTS = 0
global DIAMONDS = 1
global SPADES = 2
global CLUBS = 3

global ERROR = -1

#global TWO = 2
#global THREE = 3

#TODO: Finish
def getCardColor(card,  tblSize):
    if 1:
        return HEARTS
    elif 0:
        return DIAMONDS
    elif 0:
        return SPADES
    elif 0:
        return CLUBS
    else:
        return ERROR

#TODO:
#Assuming I can precisely determine size of window
#I could find key-points that would indicate/exclude some number,
#making for uber-fast processing. SIFT-algorithm may not be necessary
def getCardNum(card,  tblSize):
    if match > thresh:
        return 3
    
    #sift = cv2.SIFT()
    #kp = sift.detect(card,mask) #card needs to be gray-scale
    #kp,des = sift.compute(card,kp)
    
    if 1:
        return ACE
    elif 0:
        return TWO
    elif 0:
        return THREE
    else:
        return ERROR 
    
#TODO: Finish function    
def currentHand(table,  tblSize):
    return 1
    
#screenshot = grab(bbox=(100, 100, 500, 500), childprocess=None,  backend='imagemagick')
#screenshot.show()
#im = numpy.array(screenshot)

CV_LOAD_IMAGE_GRAYSCALE = 0
filename = '../../../img/table.png'
im =  imread(filename,  CV_LOAD_IMAGE_GRAYSCALE)
imshow('image',  im)
cv2.waitKey(1000) & 0xFF
cv2.destroyAllWindows()

tblSize = im.shape

getCardNum(im, tblSize)

#Split screen into flop
flop1 = im[0:100,  0:100]
flop2 = im[0:100,  0:100]
flop3 = im[0:100,  0:100]

#Split screen into turn
turn = im[0:100,  0:100]

#Split screen into river
river = im[0:100,  0:100]

#Split screen into player 1
player1 = im[0:100,  0:100]

#
board = numpy.zeros()





print('Done!')
