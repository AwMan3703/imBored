# all code by DB dev Studios

# > import
#import keyboard
from genericpath import exists, isfile
import time
import math
import random

# > literature
alphabet = list('abcdefghijklmnopqrstuvwxyz')
vowels = list('aeiou')
consonants = list('bcdfghjklmnpqrstvwxyz')

# > classes
class URLhandle:
    def __init__(self, string:str) -> None:
        self.length = len(string)
        pieces = string.split('/') #-> [http, " ", domain, php/other]
        pcct = len(pieces)

        self.http = ''
        if string[0:8]=='https://': self.http = 'https'
        elif string[0:7]=='http://': self.http = 'http'

        domains = pieces[0]
        if self.http!='': domains = pieces[2]
        domains = domains.split('.')
        self.TLD = domains[-1] #(Top Level Domain, like ".com", ".it", ".org", exc.)
        self.domain = domains[-2]
        try: self.SLD = domains[0:-2] #(Sub Level Domains, like "www.", "it.", "login.", exc.)
        except: self.SLD = []
        if self.SLD==[]: self.SLD = ['www']


        self.tail = ''
        if pcct>1 and self.http=='': self.tail = pieces[1:pcct]
        elif self.http!='': self.tail = pieces[3:pcct]

        #debug
        #print('pieces:', pieces)
        #print('http:', self.http)
        #print('domains:', domains)
        #print('sliced:', ".".join(self.SLD)+',', self.domain+',', self.TLD)
        #print('tail:', self.tail)

    def spit(self) -> str: #spit out a working url
        http = self.http+'://'
        if self.http=='': http='https://'

        domain = self.domain+'.'+self.TLD
        for i in self.SLD[::-1]: domain = i+'.'+domain

        tail = "/"+"/".join(self.tail)

        return http+domain+tail

class StopWatch:
    def __init__(self) -> None:
        pass

    def start(self):
        self.bgn = time.time()

    def read(self):
        return time.time() - self.bgn

class Scheme:
    def __init__(self, mask:list) -> None:
        self.mask = mask

    def format(self, list_to_format:list):
        ret:str = ''
        if type(self.mask) == str:
            it = 0
            for i in list_to_format:
                ret += i+ret
                it += 1
        elif type(self.mask) == list:
            it = 0
            for i in self.mask:
                ret += list_to_format[it][0:i+1]
                it += 1
        return ret

    def read(self, string_to_read:str):
        ret:list = []
        if type(self.mask) == str:
            ret = string_to_read.split(self.mask)
        elif type(self.mask) == list:
            it = 0
            for i in self.mask:
                ret.append(string_to_read[it:i])
                it += i
        return ret

class Vec2:
    def __init__(self, x, y):
        self.x, self.a, self.width = x  #1st dimension
        self.y, self.b, self.height = y #2nd dimension

class Vec3:
    def __init__(self, x, y, z):
        self.x, self.a, self.width, self.red = x    #1st dimension
        self.y, self.b, self.height, self.green = y  #2nd dimension
        self.z, self.c, self.depth, self.blue = z   #3rd dimension

class Vec4:
    def __init__(self, x, y, z, w):
        self.x, self.a, self.red = x    #1st dimension
        self.y, self.b, self.green = y  #2nd dimension
        self.z, self.c, self.blue = z   #3rd dimension
        self.w, self.d, self.alpha = w  #4th dimension

class Mat2:
    def __init__(self, x:int, y:int, filler = 0) -> None:
        self.matrix = []
        self.width = x  #matrix width
        self.height = y #matrix length
        for yi in range(y):
            l = []
            for xi in range(x):
                l.append(filler)
            self.matrix.append(l)
    
    def getrow(self, y:int) -> list:
        return self.matrix[y]
    
    def getcolumn(self, x:int) -> list:
        col = []
        for i in range(self.height):
            col.append(self.matrix[i][x])
        return col
    
    def get(self, x:int, y:int):
        try:
            r = self.matrix[y][x]
        except:
            r = None
        return r

    def set(self, x:int, y:int, new_val = None):
        self.matrix[y][x] = new_val
        return self.matrix[y][x]

    def contains(self, item) -> bool:
        for line in self.matrix:
            if item in line:
                return True
        return False

    def count(self, item) -> int:
        c = 0
        for line in self.matrix:
            c += line.count(item)
        return c

    def prettyMatrix(self) -> str:
        res = '{\n'
        for l in self.matrix:
            res += '  '+str(l)+'\n'
        res += '}\n'
        return res

class Mat3:
    def __init__(self, x:int, y:int, z:int, filler = 0) -> None:
        self.matrix = []
        self.width = x  #matrix width
        self.height = y #matrix length
        self.depth = z  #matrix depth
        for zi in range(z):
            l2 = []
            for yi in range(y):
                l1 = []
                for xi in range(x):
                    l1.append(filler)
                l2.append(l1)
            self.matrix.append(l2)

    def getrow(self, y:int, z:int) -> list:
        return self.matrix[z][y]
    
    def getcolumn(self, x:int, z:int) -> list:
        col = []
        for y in range(self.height):
            col.append(self.matrix[z][y][x])
        return col

    def getZrow(self, x:int, y:int) -> list:
        row = []
        for z in range(self.depth):
            row.append(self.matrix[z][y][x])
        return row
    
    def get(self, x:int, y:int, z:int):
        try:
            r = self.matrix[z][y][x]
        except:
            r = None
        return r

    def set(self, x:int, y:int, z:int, new_val = None):
        self.matrix[z][y][x] = new_val
        return self.matrix[y][x]

    def contains(self, item) -> bool:
        for row in self.matrix:
            for line in row:
                if item in line:
                    return True
        return False

    def count(self, item) -> bool:
        c = 0
        for row in self.matrix:
            for line in row:
                c += line.count(item)
        return c

# > functions
def avg(avglist):
    total = 0
    for element in avglist:
        total += element
    return total / len(avglist)

def wait(seconds:float):
    time.sleep(seconds)

def ask(message, expected_type, default):
    output = input(message)
    try:
        expected_type(output)
    except:
        output = default
    return output

def keyinput(message, default, expected_keys=[]):
    print(message)
#    key = keyboard.read_key()
#    while key == '':
#        pass
#    if (expected_keys == []) or (key in expected_keys):
#        return key
#    else:
#        return default

def yorn(message, true, false, default=False):
    output = input(message)
    if output == true:
        return True
    elif output == false:
        return False
    else:
        return default

def ordinal(i:int):
    lastn = list(str(i))
    lastn = str(lastn[len(lastn)-1])
    case = "th"
    if i not in [11, 12, 13]:
        if lastn == "1":
            case = "st"
        elif lastn == "2":
            case = "nd"
        elif lastn == "3":
            case = "rd"
    return str(i)+case

def percentage_value(p:float, total:float):
    return (total*p)/100

def percentage_occupied(n:float, total:float):
    return (n/total)*100

def largerlist(l1:list, l2:list):
    if len(l1) > len(l2):
        return l1
    else:
        return l2

def smallerlist(l1:list, l2:list):
    if len(l1) < len(l2):
        return l1
    else:
        return l2

def adjustStringLength(string:str, new_length:int, jolly:str, before:True):
    old_length = len(string)
    if old_length <= new_length:
        e = (jolly * (new_length - old_length))
        if before:
            res = e + string
        else:
            res = string + e
        return res
    else:
        return string[0:new_length]

def stripnls(list:list[str]):
    res = []
    for i in list:
        res.append(i.strip("\n"))
    return res

def maxinstringlist(ls:list[str]):
    ms = ''
    mn = 0
    for i in ls:
        if l:=len(i) > mn:
            ms = i
            mn = l
    return ms, mn

def zeroifnegative(n:float):
    return max(0, n)

def truncate(number:float, decimals=0):
    #Returns a value truncated to a specific number of decimal places.
    if not isinstance(decimals, int):
        raise TypeError("decimal places must be an integer.")
    elif decimals < 0:
        raise ValueError("decimal places has to be 0 or more.")
    elif decimals == 0:
        return math.trunc(number)

    factor = 10.0 ** decimals
    return math.trunc(number * factor) / factor

def getURL(raw:str) -> str:
    out = URLhandle(raw)
    return out.spit()

def randbool() -> bool:
    return bool(random.getrandbits(2))

def requestFile(message:str, mustBeFile:bool = True, returnContents:bool = True):
    p = ''
    p = input(message+' ')
    while not exists(p):
        print('> Path does not exist. Please enter a valid path.')
        p = input(message+' ')
    if mustBeFile:
        while not (isfile(p) and exists(p)):
            print('> Path must be a file. Please enter a valid path to a file.')
            p = input(message+' ')
    if returnContents:
        c = open(p).readlines()
        return p, c
    else:
        return p

def directoryFromFilePath(path:str):
    if exists(path):
        s = path.split('/')
        s.pop()
        r = '/'.join(s)+'/'
        return r
    else:
        raise FileNotFoundError()

def isSimilar_str(str_a:str, str_b:str):
    d_a = {}
    d_b = {}
    for l in str_a:
        if l in d_a.keys():
            continue
        else:
            d_a[l] = str_a.count(l)
    for l in str_b:
        if l in d_b.keys():
            continue
        else:
            d_b[l] = str_b.count(l)
    x = max([d_a, d_b], key=len)
    y = min([d_a, d_b], key=len)
    diff_points = 0
    for i in y.keys():
        entryA = d_a[i]
        entryB = d_b[i]
        diff_points += max(entryA, entryB) - min(entryA, entryB)
    diff_points += max(len(d_a), len(d_b)) - min(len(d_a), len(d_b))
    return diff_points

def sumall(*args):
    s = 0
    for a in [args]:
        s+=a
    return s

def difference(a:float, b:float):
    return max(a, b) - min(a, b)

def toCamelCase(text:str):
    newText = ''
    wasSpace = False
    for l in text:
        if l==' ': wasSpace=True
        else: newText += l if not wasSpace else l.upper(); wasSpace = False
    return newText

def fromCamelCase(text:str, keepUppercase = False):
    newText = ''
    for l in text:
        if l.isupper(): nl = l if keepUppercase else l.lower(); newText += ' '+nl
        else: newText += l
    return newText

def isAnyTrue(*args:bool):
    for i in [args]:
        if i: return True
    return False

def areAllTrue(*args:bool):
    for i in [args]:
        if not i: return False
    return True

def isAnyFalse(*args:bool):
    for i in [args]:
        if not i: return True
    return False

def areAllFalse(*args:bool):
    for i in [args]:
        if i: return False
    return True

def getLongestArray(arrays:list): # Return longest array in a list of arrays
    top = 0
    topLength = 0
    topArray = []
    for i in range(len(arrays)):
        a = arrays[i]
        if len(a) > topLength:
            top = i
            topArray = a
            topLength = len(a)
    return top, topLength, topArray # Longest array's index, length and contents
