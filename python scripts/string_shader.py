# code by DB_dev_Studios

import usefulStuff
import random

# apply a """shader""" ('function' parameter) to a string of text
def apply(string:str, function):
    output = ''

    for i in range(len(string)):
        letter = string[i]

        if i==0: isFirstLetter = True
        else: isFirstLetter = False
        isLastLetter = i==len(string)-1
        previousLetter = string[i-1]
        if not isFirstLetter: previousLetter = string[i-1]
        else: previousLetter = ''
        if not isLastLetter: nextLetter = string[i+1]
        else: nextLetter = ''

        x = function(letter, i, previousLetter, nextLetter, isFirstLetter, isLastLetter)

        output += x

    return output


# just some utility functions
#--------------------------------------------------------
def turnInto(letter:str, old:str, new:str) -> str:
    if letter==old: return new
    else: return letter
    #e.g.
    #   let = "a"
    #   let1 = turnInto(let, "a", "b") = "b"
    #   let2 = turnInto(let, "c", "b") = "a"
#--------------------------------------------------------

# EXAMPLES
# turn the string into a username
def username(letter:str, letterindex:int, previousletter:str, nextletter:str, isfirstletter:bool, islastletter:bool):
    output = letter

    output = turnInto(letter, " ", "_") #if letter is a space, make it "_"
    if isfirstletter: #if it's the first letter, add "@" before it
        output = '@'+letter
    elif islastletter: #if it's the last letter, add a three digit number after it
        output = letter+str(random.randint(111, 999))

    return output #return the processed letter

# turn the string into an internet domain
def domain(letter:str, letterindex:int, previousletter:str, nextletter:str, isfirstletter:bool, islastletter:bool):
    output = letter

    output = turnInto(output, " ", "-") #if letter is a space, make it "-"
    if ((isfirstletter or islastletter) and letter==" "):
        output = ''
    if isfirstletter: #if it's the first letter, add "https://" before it
        output = 'https://www.' + output
    elif islastletter: #if it's the last letter, add a random TLD after it
        output = output + "." + random.choice(['com', 'net', 'io']) + "/"

    return output #return the processed letter

# highlight words with square brackets
def insquare(letter:str, letterindex:int, previousletter:str, nextletter:str, isfirstletter:bool, islastletter:bool):
    output = letter

    if isfirstletter and letter!=' ':
        output = '['+output
    if islastletter and letter!=' ':
        output = output+']'
    if previousletter==' ':
        output = '['+output
    if nextletter==' ':
        output = output+']'

    return output #return the processed letter

# random upper/lower case letters
def randcase(letter:str, letterindex:int, previousletter:str, nextletter:str, isfirstletter:bool, islastletter:bool):
    output = letter

    if usefulStuff.randbool():
        output = letter.upper()
    else:
        output = letter.lower()

    return output #return the processed letter

def l2n(letter:str, letterindex:int, previousletter:str, nextletter:str, isfirstletter:bool, islastletter:bool):
    output = letter

    output = turnInto(output, 'a', '4')
    output = turnInto(output, 'e', '3')
    output = turnInto(output, 'i', '1')
    output = turnInto(output, 'o', '0')
    output = turnInto(output, 's', '5')
    output = turnInto(output, 't', '7')
    output = turnInto(output, 'g', '9')

    return output #return the processed letter

# TEST
print(apply(input('type something... '), l2n))
