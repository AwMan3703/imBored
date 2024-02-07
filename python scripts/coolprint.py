#all code by db dev studios

#---libraries---#
import keyboard
import time

#---classes owo---#
class Banner:
    def __init__(self, text, cagewidth, stepwidth):
        self.m_text = text
        self.text = text
        self.cagewidth = cagewidth
        self.ws = " " * stepwidth
        self.whitespace = []

    def toscreen(self):
        print("".join(self.whitespace) + self.text + "\r", end = "")

    def update(self, steps):
        if len(self.whitespace) >= self.cagewidth:
            self.whitespace = []
            self.text = self.m_text
        if len(self.whitespace) + len(self.text) >= self.cagewidth:
            for i in range(steps):
                self.whitespace.insert(0, self.text[-1:])
                self.text = self.text[0:len(self.text)-1]
        else:
            for i in range(steps):
                self.whitespace.append(self.ws)
        self.toscreen()

#---functions---#
def normalprint(ptext, plines = 100, palign = "l", pdirection = "", plinecount = False, limit = 0):
    printed = "".join(ptext)
    globalws = 0
    count = 0
    if pdirection == "s":
        globalws = len(ptext)
    for i in range(plines):
        count = count + 1
        if plinecount == True:
            print(str(count) + " ", end = " ")
        if count > limit and limit != 0:
            return
        if palign == "d":
            ws = len(ptext) - len(printed)
            whitespace = " " * ws
            if pdirection == "s":
                globalws = globalws - 1
            else:
                globalws = globalws + 1
            whitespace = " " * globalws
            print(whitespace + printed)
        else:
            print(printed)
                
def progressiveprint(ptext, palign = "l", pdirection = "", progress = True, plinecount = False, limit = 0):
    printed = ""
    if progress == False:
        printed = "".join(ptext)
    globalws = 0
    count = 0
    if pdirection == "s":
        globalws = len(ptext)
    for i in ptext:
        count = count + 1
        if plinecount == True:
            print(str(count) + " ", end = " ")
        if count > limit and limit != 0:
            return
        if progress:
            printed = printed + i
        else:
            printed = printed[0:len(printed)-1]
        if palign == "l":
            print(printed)
        else:
            ws = len(ptext) - len(printed)
            whitespace = " " * ws
            if palign == "r":
                print(whitespace + printed)
            elif palign == "m":
                ws = ws / 2
                whitespace = " " * int(ws)
                print(whitespace + printed + whitespace)
            elif palign == "d":
                if pdirection == "s":
                    globalws = globalws - 1
                else:
                    globalws = globalws + 1
                whitespace = " " * globalws
                print(whitespace + printed)

def bounceprint(ptext, plines = 200, pcagewidth = 20, pbounceinterval = 1, plinecount = False):
    plines = int(plines)
    pcagewidth = int(pcagewidth)
    pbounceinterval = int(pbounceinterval)
    if pbounceinterval < 1:
        pbounceinterval = 1
    printed = "".join(ptext)
    forward = True
    whitespace = []
    ws = " " * pbounceinterval
    counter = 0
    for i in range(plines):
        if plinecount == True:
            counter = counter + 1
            print(str(counter) + " ", end = " ")
        if len(whitespace) >= pcagewidth:
            forward = False
        elif len(whitespace) == 0:
            forward = True
        if forward:
            whitespace.insert(0, ws)
        else:
            whitespace.pop(0)
        print("".join(whitespace) + printed)

def diamondprint(ptext, plines = 200, pcagewidth = 10, pbounceinterval = 1, plinecount = False):
    plines = int(plines)
    pcagewidth = int(pcagewidth)
    pbounceinterval = int(pbounceinterval)
    half1 = "".join(ptext[0:int(len(ptext)/2)])
    half2 = "".join(ptext[int(len(ptext)/2):len(ptext)])
    holder = ""
    if pbounceinterval < 1:
        pbounceinterval = 1
    forward = True
    whitespace = []
    ws = " " * pbounceinterval
    counter = 0
    for i in range(plines):
        if plinecount == True:
            counter = counter + 1
            print(str(counter) + " ", end = " ")
        if len(whitespace) >= pcagewidth:
            forward = False
        elif len(whitespace) == 0:
            forward = True
            holder = half1
            half1 = half2
            half2 = holder
        if forward:
            whitespace.insert(0, ws)
        else:
            whitespace.pop(0)
        boundwidth = pcagewidth - int(len(whitespace)/2)
        print(ws * boundwidth + half1 + "".join(whitespace) + half2)

def bannerprint(ptext, pcagewidth = 30, pstepwidth = 1, pdelay = 0.25):
    pcagewidth = int(pcagewidth)
    pstepwidth = int(pstepwidth)
    pdelay = float(pdelay)
    ptext = "".join(ptext)
    counter = 0
    currentbanner = Banner(ptext, pcagewidth, pstepwidth)
    print("press ESC to quit\n")
    while True:
        if keyboard.is_pressed('ESC'):
            break
        counter += 1
        currentbanner.update(1)
        time.sleep(pdelay)

def stringsprint(ptext, pcagewidth = 30, ppullinterval = 1, pstepwidth = 1, forward = False, animate = False, pdelay = 0.25, plinecount = False):
    pcagewidth = int(pcagewidth)
    ppullinterval = int(ppullinterval)
    pstepwidth = int(pstepwidth)
    pdelay = float(pdelay)
    whitespacehalf1 = []
    whitespacehalf2 = []
    fullwhitespace = []
    ws = " " * pstepwidth
    for i in range(pcagewidth):
        fullwhitespace.append(ws)
    half1 = ""
    half2 = ""
    movingletter = -1
    if animate:
        endset = ""
    else:
        endset = "\n"
    counter = 0
    if forward:
        movingletter = len(ptext)
    for i in range(len(ptext)):
        counter += 1
        whitespacehalf2 = fullwhitespace.copy()
        whitespacehalf1.clear()
        if forward:
            movingletter -= 1
            half1 = "".join(ptext[0:movingletter])
        else:
            movingletter += 1
            half2 = "".join(ptext[movingletter+1:len(ptext)+1])
        if ptext[movingletter] != " ":
            while len(whitespacehalf2) > 0:
                if animate == False and plinecount == True:
                    half1 = str(counter) + " " + half1
                if animate == True:
                    half2 = half2 + "\r"
                    time.sleep(pdelay)
                if forward:
                    print(half1 + "".join(whitespacehalf1) + ptext[movingletter] + "".join(whitespacehalf2) + half2, end = endset)
                else:
                    print(half1 + "".join(whitespacehalf2) + ptext[movingletter] + "".join(whitespacehalf1) + half2, end = endset)
                whitespacehalf1.append(ws)
                whitespacehalf2.pop(0)
            for i in range(ppullinterval):
                if forward:
                    print(half1 + "".join(whitespacehalf1) + ptext[movingletter] + "".join(whitespacehalf2) + half2, end = endset)
                else:
                    print(half1 + "".join(whitespacehalf2) + ptext[movingletter] + "".join(whitespacehalf1) + half2, end = endset)

        if forward:
            half2 = ptext[movingletter] + half2
        else:
            half1 = half1 + ptext[movingletter]
    if forward:
        print("".join(whitespacehalf1)+"".join(ptext))
    else:
        print("".join(ptext))

#---useful stuff---#

def betawarn(name):
    print("[BETA] " + name + """ is stil in development and may not be reliable.
          \ndo you want to run it anyway?
          \n[enter] run   [ctrl+c] abort""")
    input(" -> ")

def ask(message, expected_type, default = None):
    parameter = input(message)
    try:
        expected_type(parameter)
    except:
        parameter = default
    return parameter

def yorn(message, default, true = "y", false = "n"):
    print(message)
    time.sleep(0.2)
    strdefault = ""
    if default:
        strdefault = true.upper()
    else:
        strdefault = false.upper()
    key = keyboard.read_key()
    while key == "":
        "wait"
    time.sleep(0.3)
    if key == true:
        print("\b-> input: " + true.upper())
        return True
    elif key == false:
        print("\b-> input: " + false.upper())
        return False
    else:
        print("\b[X] set to default ("+strdefault+")")
        return default

#--the actual program---#

text = []
direction = ""
insertmode = 0

inpt = ask("text: ", str, "")
if inpt == "":
    inpt = "Hello World!"

print("\nselect a print mode")
print("""\n---[n]ormal---
        hello world
        hello world
        hello world
        hello world
        hello world
        """)
print("""\n---[p]rogressive---
        h
        hel
        hello
        hello w
        hello wor
        """)
print("""\n---[b]ouncing---
        hello world
           hello world
              hello world
           hello world
        hello world
        """)
print("""\n---[d]iamond---
           hello world
         hello     world
           hello world
         hello     world
           hello world
        """)
print("""\n---[f]lying text---

        hello world--->

        """)
print("""\n---[s]trings---
        hello wo    rld
        hello w o   rld
        hello w  o  rld
        hello w   o rld
        hello w    orld
        """)
printmode = ask("\n : ", str, "n")
print("\n")

if printmode == "b" or printmode == "d":
    # specific inputs for bounce/diamond mode
    bounceinterval = ask("set bounceinterval (1): ", int, 1)
    cagewidth = ask("set cagewidth (20): ", int, 20)
    lines = ask("enter the number of lines to generate (200): ", int, 200)
elif printmode == "f" or printmode == "s":
    cagewidth = ask("set cagewidth (30): ", int, 30)
    stepwidth = ask("set stepwidth (1): ", int, 1)
    delay = ask("set update delay(s) (0.25): ", float, 0.25)
    if printmode == "s":
        pullinterval = ask("set pull interval (1): ", int, 1)
        forward = yorn("progress direction ([f]orwards, [b]ackwards)", True, "f", "b")
        animate = yorn("animated (y/n)", False, "y", "n")
else:
    align = ask("set alignment\n(def:[l]eft, [m]iddle, [r]ight, [d]iagonal): ", str, "l")
    if align == "d":
        direction = ask("diagonal direction ([s]lash, [b]ackslash): ", str, "b")
    if printmode == "n":
        lines = ask("enter the number of lines to generate (100): ", int, 100)
    elif printmode == "p":
        progress = yorn("""progress mode (
    [e]volve (default)
        "hel" -> "hello"
    [d]evolve
        "hello" -> "hel"
    ): """, True, "e", "d")

readdir = ask("output read direction ([f]orwards, [b]ackwards): ", str, "f")
linecount = yorn("(non-animated) enable linecount (y/n)", False, "y", "n")

print("\n")

if readdir:
    insertmode = len(inpt)
for i in inpt:
    text.insert(insertmode, i)


if printmode == "n":
    normalprint(text, lines, align, direction, linecount)
elif printmode == "p":
    progressiveprint(text, align, direction, progress, linecount)
elif printmode == "b":
    bounceprint(text, lines, cagewidth, bounceinterval, linecount)
elif printmode == "d":
    diamondprint(text, lines, cagewidth, bounceinterval, linecount)
elif printmode == "f":
    bannerprint(text, cagewidth, stepwidth, delay)
elif printmode == "s":
    stringsprint(text, cagewidth, pullinterval, stepwidth, forward, animate, delay, linecount)
print("\n")
