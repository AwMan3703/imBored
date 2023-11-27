
import pygame
from pygame import Rect
from pygame import Color

from time import sleep
from random import randint
from random import choice

from usefulStuff import getLongestArray
from usefulStuff import Mat2
from usefulStuff import StopWatch
from usefulStuff import truncate
from usefulStuff import zeroifnegative
from usefulStuff import difference

import sys


# Flags

f_DebugMode = True # Enable debug mode

# Globals

CURRENT_FPS = 0

SCREEN = None
GRID = None

STYLE = {
    'bgcolor' : Color(50, 50, 80),
    'gridcolor' : Color(35, 35, 60)
}

FALLING_PIECE = None # The controllable piece
DEBRIS = None # A piece that maps all of the ones that have reached the ground and can no longer be controlled

# Grid coordinates : the position of a cell in the grid
# - (5, 9) is the 5th cell on the 9th row
# Screenspace (ss) coordinates : the position of an element relative to the top left of the window
# - (5, 9) is 5 pixels from the left border and 9 from the top

piece_maps = {
    "T" : [
        [1, 1, 1],
        [0, 1]
    ],
    "L" : [
        [1],
        [1],
        [1, 1]
    ],
    "REVERSEL" : [
        [0, 1],
        [0, 1],
        [1, 1]
    ],
    "SQUIGGLE" : [
        [1, 1, 0],
        [0, 1, 1]
    ],
    "REVERSESQUIGGLE" : [
        [0, 1, 1],
        [1, 1, 0]
    ],
    "LINE" : [
        [1],
        [1],
        [1],
        [1]
    ]
}

class Piece:
    def __init__(self, map, x, y, color) -> None:
        self.map = map
        self.x = x
        self.y = y
        self.color = color
        _, self.w, _ = getLongestArray(map)
        self.h = len(map)

class Grid:
    map = []

    def __init__(self, x: int, y: int, cellsize: int, columns: int, rows: int):
        self.x = x
        self.y = y
        self.columns_count = columns
        self.rows_count = rows
        self.cellsize = cellsize
        self.ssw = columns * cellsize
        self.ssh = rows * cellsize

    def getCell(self, x, y):
        return self.map[y][x]

    def toScreenCoordinates(self, x, y):
        return x * self.cellsize, y * self.cellsize


def populateGrid(grid:Grid):
    for r in range(grid.rows_count):
        row = []
        for c in range(grid.columns_count):
            row.append(0)
        grid.map.append(row)
    return grid


# Utility
def renderText(x, y, text, size = 24):
    font = pygame.font.Font(None, size)
    img = font.render(text, True, Color(255, 255, 255))
    SCREEN.blit(img, (x, y))

def renderRect(x, y, w, h, fill=False, fillColor=Color(240,240,240), stroke=False, strokeColor=Color(0,0,0), strokeWidth=0, borderRadius=-1):
    if fill: pygame.draw.rect(SCREEN, fillColor, Rect(x, y, w, h), border_radius=borderRadius)
    if stroke: pygame.draw.rect(SCREEN, strokeColor, Rect(x, y, w, h), strokeWidth, borderRadius)



def renderGrid():
    pygame.draw.rect(SCREEN, Color(0, 0, 0), Rect(GRID.x, GRID.y, GRID.ssw, GRID.ssh), 2)
    for r in range(GRID.rows_count):
        for c in range(GRID.columns_count):
            renderRect(c * GRID.cellsize + GRID.x, r * GRID.cellsize + GRID.y, GRID.cellsize, GRID.cellsize, stroke=True, strokeWidth=1, strokeColor=STYLE['gridcolor'], borderRadius=2)

def renderGridSquare(x, y, color):
    renderRect(x, y, GRID.cellsize, GRID.cellsize, fill=True, fillColor=color)

def renderPiece(x, y, piece:Piece):
    cx = cy = 0
    for l in piece.map:
        for c in l:
            ssx, ssy = GRID.toScreenCoordinates(x+cx, y+cy)
            if c: renderGridSquare(ssx, ssy, piece.color)
            cx += 1
        cx = 0
        cy += 1
    if f_DebugMode: renderRect(x*GRID.cellsize, y*GRID.cellsize, piece.w*GRID.cellsize, piece.h*GRID.cellsize, stroke=True, strokeWidth=2, strokeColor=Color(255, 0, 0))

def sumPieces(pieceA:Piece, pieceB:Piece):
    print('generating:',
          '\n'+Mat2(pieceA.h + pieceB.h- difference(pieceA.x, pieceB.x), pieceA.w + pieceB.w - difference(pieceA.y, pieceB.y), 0).prettyMatrix()
          + f'@x{min(pieceA.x, pieceB.x)}:y{ min(pieceA.y, pieceB.y)}')
    result = Piece(
        Mat2(pieceA.w + pieceB.w - difference(pieceA.x, pieceB.x), pieceA.h + pieceB.h - difference(pieceA.y, pieceB.y), 0).matrix,
        min(pieceA.x, pieceB.x), min(pieceA.y, pieceB.y), Color(20,20,20)
    )



    return result


# Game
def generateFallingPiece():
    p = Piece(piece_maps[choice(list(piece_maps.keys()))], 0, 0, Color(randint(0,255),randint(0,255),randint(0,255)))
    p.x = randint(0, GRID.columns_count - p.w)
    return p

def gameOver():
    print("GAME OVER")
    sys.exit()



# --- SCRIPT FUNCTIONS ---––———––---––———––---––———––---––———––--- #


def setup():
    global GRID
    global FALLING_PIECE
    global DEBRIS

    GRID = populateGrid( Grid(0, 0, 30, 10, 20) )
    FALLING_PIECE = generateFallingPiece()
    DEBRIS = Piece([], 0, GRID.rows_count, Color(10, 10, 10))
    print(GRID.rows_count)


def update(n, sw):
    global CURRENT_FPS
    global FALLING_PIECE
    global DEBRIS

    # Check for gameover
    if len(DEBRIS.map) >= GRID.rows_count: gameOver()

    # Slow down the following operations, only run them every x frames
    if n % 300 == 0:

        # Update the FPS data
        CURRENT_FPS = zeroifnegative(1/(sw.read()+0.00000001))

        # Take key input
        if pygame.key.get_pressed()[pygame.K_LEFT] and FALLING_PIECE.x > 0: FALLING_PIECE.x -= 1
        if pygame.key.get_pressed()[pygame.K_RIGHT] and FALLING_PIECE.x + FALLING_PIECE.w < 10: FALLING_PIECE.x += 1

        # Calculate if the falling piece can go any lower.
        # If yes, increase its Y coordinate, if not deconstruct it in the GRID and spawn a new one.
        FPssx, FPssy =  GRID.toScreenCoordinates(FALLING_PIECE.x, FALLING_PIECE.y)
        can_fall = FPssy + ((FALLING_PIECE.h + 1) * GRID.cellsize) < GRID.ssh

        if can_fall:
            FALLING_PIECE.y+=1
        else:
            # Add the falling piece to the debris
            DEBRIS = sumPieces(DEBRIS, FALLING_PIECE)
            # Shift the debris so it is on the ground
            DEBRIS.y = GRID.rows_count - len(DEBRIS.map)
            FALLING_PIECE = generateFallingPiece() # Spawn a new one


def drawFrame(n):
    # Draw the background
    SCREEN.fill(STYLE['bgcolor'])

    # Draw the grid
    renderGrid()

    # Draw the falling piece
    if FALLING_PIECE is not None: renderPiece(FALLING_PIECE.x, FALLING_PIECE.y, FALLING_PIECE)
    if DEBRIS is not None: renderPiece(DEBRIS.x, DEBRIS.y, DEBRIS)

    # Display the FPS
    renderText(5, 5, 'FPS: ' + str(truncate(CURRENT_FPS, 5)), 18)




# ---––———––---––———––---––———––---––———––---––———––---––———––--- #



### SCRIPT ###

# Run the setup function to prepare the environment
setup()

pygame.init()
SCREEN = pygame.display.set_mode([GRID.ssw, GRID.ssh])

RUNNING = True
FRAMEN = 0

# Start a stopwatch for FPS calculation
sw = StopWatch()
sw.start()

while RUNNING:

    # Increment the frame counter
    FRAMEN += 1

    # Did the user click the window close button?
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            RUNNING = False

    # Run the update function to update the game
    update(FRAMEN, sw)

    # Run the draw function to draw the current frame
    drawFrame(FRAMEN)

    # Flip the display
    pygame.display.flip()


# End the Game
pygame.quit()
