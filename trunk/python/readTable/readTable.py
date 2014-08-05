
import cv2
from cv2 import imread
from cv2 import imshow
from pyscreenshot import grab
import numpy


#Potential classes: Table, Card, Player, ...

#Defining constants
global HEARTS = 0
global DIAMONDS = 1
global SPADES = 2
global CLUBS = 3

global ERROR = -1

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
    mask = numpy.ones(tblSize) #Should only include where the number is
    hessThresh = 400
    surf = cv2.SURF(hessThresh)
    surf.upright = True #Not rotation-invariant
    surf.extended = False #Dunno what, but faster, not as accurate
    #kp = surf.detect(card, mask)
    kp, des = surf.detectAndCompute(card,mask)
    
    #sift = cv2.SIFT()
    #kp = sift.detect(card,mask) #card needs to be gray-scale
    #kp,des = sift.compute(card,kp)
    
    if 1:
        return ACE
    elif 0:
        return TWO
    else:
        return ERROR
    
def currentHand(table,  tblSize):
    



filename = '../../../img/table2.png'
CV_LOAD_IMAGE_GRAYSCALE = 0
im =  imread(filename,  CV_LOAD_IMAGE_GRAYSCALE)
imshow('image',  im)
cv2.waitKey(1000) & 0xFF
cv2.destroyAllWindows()

size = im.shape

#screenshot = grab(bbox=(100, 100, 500, 500), childprocess=None,  backend='imagemagick')
#screenshot.show()
#im = numpy.array(screenshot)

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
