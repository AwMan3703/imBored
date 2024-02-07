#code by @Aw_Man3703

import random
from termcolor import colored as col
from time import sleep
from usefulStuff import alphabet as abc
from usefulStuff import percentage_occupied as pct

def setup():
    bets = {}
    letters = list(abc)
    altc = False

    playern = int(input('# of players (26 max): '))
    if playern>26:
        print('max # of players is 26')
        return None

    for p in range(min(26, playern)):
        if altc:
            cc = ['dark']
        else:
            cc = []
        altc = not altc

        l = letters[p]
        bets[l] = int(input(col('Player {fl}, place your bet: '.format(fl = l.upper()), 'white', 'on_grey', cc)))

    if len(bets)==1:
        print('>> redirect to single player mode, Player A wins if accuracy > 90%')

    return bets

def roll(max:int):
    return random.randint(1, max)

def animate(message:str, cycles:int, duration:float, m:int = 99):
    wt = duration/cycles
    for ci in range(cycles):
        print(col(message.format(n = random.randint(1, m)), 'yellow'), end = '\r')
        sleep(wt)
        print(' '*(len(message)+1), end = '\r')

def check_winner(r, bets, m):

    ignore_me = bets[next(iter(bets))]
    cw = 'a'
    cwd = max(r, ignore_me)-min(r, ignore_me)

    for b in  bets.keys():
        diff = (max(bets[b], r)-min(bets[b], r))
        if diff < cwd:
            cw = b
            cwd = diff
    cwp = 100-pct(cwd, m)

    if len(bets) == 1:
        if cwp < 90:
            cw = 'no one'
            cwp = 'Player A\'s accuracy: '+str(cwp)

    return cw, cwp, cwd

def main(max:int = 20):
    print()
    bets = None
    while bets==None:
        bets = setup()
    print('-------------------')
    result = roll(max)
    animate('Rolling... [{n}]', 30, 3.5, max)
    print(col('RESULT: [{x}]'.format(x = result), 'grey', 'on_yellow', ['bold', 'underline']))
    w, wp, wd = check_winner(result, bets, max)
    print(col('{x1} WINS ({x2} accuracy, difference = {x3})'.format(x1 = w.upper(), x2 = str(wp)+'%', x3 = wd), 'cyan'))
    print()


main(1000)