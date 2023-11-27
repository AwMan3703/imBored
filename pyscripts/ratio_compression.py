# *casually reinvents data storage on a saturday night*
# Based on the "encoding with a notch on a rod" thought experiment.
# One can encode data by
#   1. turning it into a string of numbers
#   2. making it so that number is a decimal (add 0. in front of it)
#   3. find two numbers such that, when divided by each other (a fraction) they
#      return the original decimal number
#   4. all the original data is now stored as those two numbers,
#      -> to retrieve it, divide the numbers and convert the decimal back into data.

# THIS DOES NOT WORK!!! :((((


import math
from decimal import getcontext, Decimal

from fractions import Fraction


def find_ratio(data_integer) -> (int, int, dict):

    # find the number of digits in the integer
    length = int(len(str(data_integer)))

    # set the precision to avoid losing data
    getcontext().prec = length

    # find what number we would need to divide the integer by to make it a <1 float
    divider = int(10**length) #it would be a 1 followed by as many zeros as the integer's amount of digits
    print("divider =", divider)

    # find greatest common divisor 
    #gcd = math.gcd(data_integer, divider)
    #print("gcd =", gcd)

    # divide both numbers by their greatest common divisor
    #top = (Decimal(data_integer) / Decimal(gcd)) #the number at the top of the fraction
    #btm = (Decimal(divider) / Decimal(gcd)) #the number at the bottom of the fraction
    #print("result =", top, btm)

    top, btm = data_integer, divider
    while math.gcd(int(top), int(btm))!=1:
        lgcd = math.gcd(int(top), int(btm))
        top = Decimal(top) / (lgcd)
        btm = Decimal(btm) / (lgcd)
    print("ratio =", top, btm)

    # return the fraction numbers and other useful data
    return top, btm, { "divider" : divider }

def find_ratio2(data_integer) -> Fraction:

    # length of the data integer
    length = int(len(str(data_integer))) -1

    # set the precision to prevent data loss
    getcontext().prec = length

    # find what number we would need to divide the integer by to make it a <1 float
    divider = int(10**length)

    #return Fraction(Decimal(data_integer)/Decimal(divider)).limit_denominator().as_integer_ratio() # AVG PRECISION 10
    #return Fraction().from_float(float("0."+str(data_integer))).limit_denominator(max_denominator=data_integer).as_integer_ratio() # AVG PRECISION 16
    #return Fraction().from_decimal(Decimal("0."+str(data_integer))).limit_denominator(max_denominator=data_integer).as_integer_ratio() # AVG PRECISION 100%, but result is too long
    return float("0."+str(data_integer)).as_integer_ratio() # AVG PRECISION 16


#tests

def check(number):
    x, y, info = find_ratio(number)
    result = Decimal(x)/Decimal(y) * info["divider"]
    precision = -1
    a = list(str(result))
    b = list(str(number))
    for i in range(len(a)):
        x = a[i]
        y = b[i]
        if x!=y: precision = i; break

    print("result:", result)
    print("precision:", precision)

def check2(number):
    x, y = find_ratio2(number)
    print("ratio:", x, "/", y)
    # find the number of digits in the integer
    length = int(len(str(number)))
    # set the precision to avoid losing data
    getcontext().prec = length
    # find the divider
    divider = int(10**length)
    # get the original number(?)
    result = (Decimal(x)/Decimal(y)) * divider

    precision = -1
    a = list(str(result))
    b = list(str(number))
    for i in range(len(a)):
        x = a[i]
        y = b[i]
        if x!=y: precision = i; break

    print("result:", result)
    print("precision:", precision)


check(int(input("int input: ")))
