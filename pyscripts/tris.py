# @Aw_Man3703 (twitter, instagram)

# <setup>
from usefulStuff import StopWatch, Mat2, maxinstringlist, avg, areAllFalse
from time import sleep
from generalDictionary import tris as dct
dct.setLang('it_IT')
d = lambda k : dct.translate(k)

USER_WON = 'user_won'
SELF_WON = 'self_won'
TIE = 'tie'
turn_durations = []
turns_count = 0

USERMARK = 'X'
SELFMARK = 'O'
EMPTYMARK = ' '

#""AI"" parameters
emptymarkweight = 0.5
selfmarkweight = 1.0
usermarkweight = 1.5

grid = Mat2(3, 3, EMPTYMARK)

#debug groups: play, place, pathfinder, tris checker
debug_mode = ['tris checker']
longestdbg, longestdbgn = maxinstringlist(debug_mode)

orientation_v = "vertical |"   # vertical
orientation_d1 = "diagonal \\" # diagonal backslash
orientation_d2 = "diagonal /" # diagonal slash
orientation_h = "hrzontal -"   # horizontal
direction_fw = "forwards"   # forwards
direction_bw = "backwards"   # backwards
# </setup> 

# INPUT MANUALE
#grid[0] = list(input('row 1: '))
#grid[1] = list(input('row 2: '))
#grid[2] = list(input('row 3: '))

# <utility>
#points to a cell in a 2d matrix and can retrieve its content
class Coord:
    def __init__(self, x:int, y:int):
        self.tostring = '@x'+str(x)+'y'+str(y)
        self.X = x
        self.Y = y
        self.content = lambda : grid.get(self.X, self.Y)

#describes a path in a 2d matrix and calculates a few attributes
class Path:
    def __init__(self, c1:Coord, c2:Coord, c3:Coord):
        self.c1 = c1
        self.c2 = c2
        self.c3 = c3
        self.tostring = c1.tostring+'-'+c2.tostring+'-'+c3.tostring
        self.tolist = [c1, c2, c3]
        self.orientation = getPathOrientation(c1, c3)
        self.direction = getPathDirection(c1, c1, c3)

#function for debug output management
def debug(group, text, level:int = 0, debuglabel:bool = True, end:str = '\n'):
    tab = 0
    if group in debug_mode:
        textind:str = ' '*(longestdbgn - len(group))
        msgind:str = '. '*(tab+(level))
        if debuglabel:
            print('[DEBUG '+group+']', textind, msgind, end = '')
        else:
            textind += ' '*(len(group)+8)
            print(textind, end='')
        print(text, end = end)

#determine the orientation of a path from c1 to c3
def getPathOrientation(c1:Coord, c3:Coord):
        dx = c1.X != c3.X
        dy = c1.Y != c3.Y
        ex = c1.X == c3.X
        ey = c1.Y == c3.Y
        horizontal = ey
        vertical = ex
        diagonal = dx and dy
        if diagonal:
            if c1.X < c3.X:
                return orientation_d1
            else:
                return orientation_d2
        elif horizontal:
            return orientation_h
        elif vertical:
            return orientation_v
        else:
            return None, "invalid path"

#determine the direction of a path from c1 to c3
def getPathDirection(cell_from:Coord, c1:Coord, c3:Coord):

    if cell_from.tostring == c1.tostring:
        return direction_fw
    elif cell_from.tostring == c3.tostring:
        return direction_bw
    else:
        return None, "invalid coords"

#convert a path object into a list of the contents of its cells
def pathToStrings(path:Path):
    result = []
    for c in path.tolist:
        result.append(c.content())
    return result

#check if the coordinate object is valid in the given matrix
def coordsExist(c:Coord, matrix:Mat2) -> bool:
    x = c.X
    y = c.Y
    mx:int = matrix.height
    my:int = matrix.width
    inx:bool = x>=0 and x<mx
    iny:bool = y>=0 and y<my
    return inx and iny

#check if all the coordinates in a path are valid in the given matrix
def pathExist(path:Path, matrix:Mat2):
    for c in path.tolist:
        if not coordsExist(c, matrix):
            return False
    return True

#check if two paths correspond
def isSamePath(path1:Path, path2:Path):
    for c1 in path1.tolist:
        if c1 not in path2:
            return False
    return True

# path orientations:        #path directions:                 #
#  |  vertical   ("v")         8   1   2    [X]--> forward    #
#  /  diagonal1  ("d1")         \  |  /     [X]<-- backwards  #
#  \  diagonal2  ("d2")      7 -- [X] -- 3                    #
#  -  horizontal ("h")          /  |  \                       #
#                              6   5   4                      #
#generate a path with the starting point at the side, with a certain orientation
def constructPathFromSide(start:Coord, orientation:int, matrix:Mat2) -> Path:
    sx = start.X
    sy = start.Y
    xf = 0
    yf = 0
    match orientation:
        case 1:
            yf = 1
        case 2:
            xf = 1
            yf = 1
        case 3:
            xf = 1
        case 4:
            xf = 1
            yf = -1
        case 5:
            yf = -1
        case 6:
            xf = -1
            yf = -1
        case 7:
            xf = -1
        case 8:
            xf = -1
            yf = 1
        case _:
            #(if none of the previous matched)
            return None, "invalid direction"
    c1 = Coord(sx, sy)
    c2 = Coord(sx+xf, sy+yf)
    c3 = Coord(sx+(xf*2), sy+(yf*2))
    p = Path(c1,c2,c3)
    if pathExist(p, matrix):
        return p
    else:
        return None #path cannot be constructed

#generate a path with the starting point in the center, with a certain orientation
def constructPathFromCenter(start:Coord, orientation:int, matrix:Mat2):
    sx = start.X
    sy = start.Y
    xf = 0
    yf = 0
    match orientation:
        case 1:
            yf = 1
        case 2:
            xf = 1
            yf = 1
        case 3:
            xf = 1
        case 4:
            xf = 1
            yf = -1
        case 5:
            yf = -1
        case 6:
            xf = -1
            yf = -1
        case 7:
            xf = -1
        case 8:
            xf = -1
            yf = 1
        case _:
            #(if none of the previous matched)
            return None, "invalid direction"
    c1 = Coord(sx-xf, sy-yf)
    c2 = Coord(sx, sy)
    c3 = Coord(sx+xf, sy+yf)
    p = Path(c1,c2,c3)
    if pathExist(p, matrix):
        return p
    else:
        return None #path cannot be constructed

#find all the possible paths from a starting point
def getPaths(c:Coord):
    found_paths:list[Path] = []
    str_fpaths:list[str] = []
    debug('pathfinder', 'PF -- finding trajectories from '+c.tostring)
    # find all possible paths from position (c.X, c.Y)

    for direction in range(8): #check paths in all 8 directions
        #for each direction, there are 4 possible paths:
        #e.g. [X]->direction(2) in the following grid
        # 'X' ' ' 'O'
        # 'O' 'X' ' '
        # ' ' ' ' ' '
        #possible paths:
        # - (2,2/1,3/null) ['X', 'O'] _  from side, forward
        # - (null/1,3/2,2)  _ ['O', 'X'] from side, backwards
        # - (3,1/2,2/1,3) [' ','X','O'] from center, forward
        # - (1,3/2,2/3,1) ['O','x',' '] from center, backwards
        p = constructPathFromSide(c, direction+1, grid)
        pc = constructPathFromCenter(c, direction+1, grid)
        if p!=None:
            found_paths.append(p)
            str_fpaths.append(p.tostring)
        if pc!=None:
            found_paths.append(pc)
            str_fpaths.append(pc.tostring)

    debug('pathfinder', 'as x:'+str(c.X)+', y:'+str(c.Y), 1)
    debug('pathfinder', 'paths: '+str(str_fpaths), 1)
    for fp in found_paths:
        debug('pathfinder', fp.tostring, 2)
    return found_paths
# </utility>

# <game>
#player class to interact with the game
class Player:
    def __init__(self, name:str, mark:str) -> None:
        self.name = name
        self.mark = mark
    
    def turn(self) -> Coord:
        pass

#""AI"" player interface
class AutoPlayer(Player):
    def __init__(self, name:str, mark:str) -> None:
        super().__init__(name, mark)

    def turn(self) -> Coord:
        global grid
        global EMPTYMARK
        global SELFMARK
        global USERMARK
        global emptymarkweight
        global selfmarkweight
        global usermarkweight
        if debug_mode == []: print(d('thinking')+'...', end='')

        debug('play', 'PLAY STARTED')
        cells:dict[float, Path] = {}
        # for each row
        for Nrow in range(grid.height+1):
            # for each cell
            for Ncell in range(grid.width+1):
                cell = Coord(Nrow, Ncell)
                if cell.content() == EMPTYMARK:
                    possible_paths = getPaths(cell)
                    debug('play', 'Index for cell '+cell.tostring, 2)
                    cellIndex = 0
                    for path in possible_paths:
                        pts = pathToStrings(path)
                        debug('play', 'accounting for path '+path.tostring, 3)
                        if (USERMARK in pts) and (SELFMARK in pts): 
                            debug('play', 'path contains 2 different marks, is useless', 4)
                            continue
                        elif pts==[EMPTYMARK, EMPTYMARK, EMPTYMARK]:
                            debug('play', 'path is completely empty, is useless', 4)
                            continue
                        else:
                            cellIndex += pts.count(USERMARK)*usermarkweight
                            debug('play', '> usermark: '+str(cellIndex), 4)
                            cellIndex += pts.count(SELFMARK)*selfmarkweight
                            debug('play', '> selfmark: '+str(cellIndex), 4)
                            cellIndex += pts.count(EMPTYMARK)*emptymarkweight
                            debug('play', '> empty: '+str(cellIndex), 4)
                    cells[cellIndex] = cell
                    debug('play', 'cell '+str(cell.X)+','+str(cell.Y)+' added w/ index '+str(cellIndex), 3)

        # shorthand for the first element in chosen_paths
        selected:Coord = cells.pop(list(cells.keys())[0])
        debug('play', 'targeted: '+str(selected.tostring), 1)

        if Coord(1, 1).content() == EMPTYMARK: #if the center cell is empty, override the selection
            debug('play', '(overridden by vacant [1,1])', 1)
            r = Coord(1, 1)
            return
        else: # otherwise, go for the selected cell
            debug('play', 'best cell: '+selected.tostring)
            r = selected

        sleep(.25)
        print('', d('done'))
        return r

#human player class to interface with human players (no shit??)
class HumanPlayer(Player):
    def __init__(self, name:str, mark:str) -> None:
        super().__init__(name, mark)

    def turn(self) -> Coord:
            global grid
            global turn_durations
            global turns_count
            turns_count += 1
            turn_sw = StopWatch()
            turn_sw.start()
            print(d('place_prompt'))
            ply = int(input(d('row')+': '))-1
            plx = int(input(d('column')+': '))-1
            position = Coord(plx, ply)
            if not coordsExist(position, grid):
                print(d('inexistent_cell'))
                return self.turn()
            elif grid.get(position.X, position.Y)!=EMPTYMARK:
                print(d('occupied_cell'))
                return self.turn()
            else:
                turn_durations.append(turn_sw.read())
                del turn_sw
                return position

#print the game grid
def printgrid(g:Mat2):
    for r in range(g.height):
        print('   '+str(r+1), end='')
    print('')

    for ln in range(g.width):
        line  = g.getrow(ln)
        print('', ln+1, ' | '.join(line))
        print('  ', end='')

        sep = []
        for d in range(g.height):
            sep.append('---')

        if ln < g.width-1:
            print('+'.join(sep), end='')
        print('')

#place a mark in the grid
def place(mark:str, cell:Coord):
    debug('place', 'attempting placement in cell '+cell.tostring)
    if grid.get(cell.X, cell.Y) == EMPTYMARK:
        debug('place', 'placing in cell '+str(cell.X)+'x'+str(cell.Y))
        grid.set(cell.X, cell.Y, mark)
        return True
    else:
        debug('place', 'placement failed')
        return False

#check if a tris streak is on the grid
def trischeck():
    global grid
    for Nrow in range(grid.height):
        debug('tris checker', 'operating on row '+str(Nrow), 0)
        for Ncell in range(len(grid.getrow(Nrow))):
            debug('tris checker', 'operating on cell '+str(Ncell), 1)
            cell = Coord(Nrow, Ncell)
            if cell.content() != EMPTYMARK:
                debug('tris checker', 'TC loop - Nrow: '+str(Nrow)+', Ncell: '+str(Ncell), 1)
                paths = getPaths(cell)
                for path in paths:
                    debug('tris checker', 'Tris checking on path '+path.tostring, 1)
                    if pathToStrings(path).count(USERMARK) == 3:
                        debug('tris checker', ' > user won\n', 2)
                        return USER_WON
                    elif pathToStrings(path).count(SELFMARK) == 3:
                        debug('tris checker', ' > self won\n', 2)
                        return SELF_WON
                    elif grid.count(EMPTYMARK)<2:
                        debug('tris checker', ' > tie\n', 2)
                        return TIE
                    else:
                        debug('tris checker', ' > none\n', 2)
                        return None
# </game>

# GAME SCRIPT
user1 = HumanPlayer(d('player'), USERMARK)
user2 = AutoPlayer(d('computer'), SELFMARK)

def switchturn(previous = True):
    if previous:
        print('')
        printgrid(grid)
        print(d('turn_header').format(user1.name))
        place(user1.mark, user1.turn())
    else:
        print('')
        printgrid(grid)
        print(d('turn_header').format(user2.name))
        place(user2.mark, user2.turn())
    return not turn

turn = True
game_sw = StopWatch()
game_sw.start()
print('starting game...')
outcome = None
while outcome==None:
    turn = switchturn(turn)
    outcome = trischeck()
total_elapsed = game_sw.read()
del game_sw

print('\n')
printgrid(grid)
print('\nresult:', outcome)

print('\n--------game stats--------')
print('total play time: '+str(round(total_elapsed, 2)))
print('total turns played: '+str(round(turns_count, 2)))
print('average turn duration: '+str(round(avg(turn_durations), 2)))