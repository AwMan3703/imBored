from termcolor import colored as c
import random


# Config
class COLORS:
    correct = 'green'
    wrongplace = 'yellow'
    incorrect = 'light_grey'


# Functions
def getGuessPattern(guess, correct):
    if len(guess) != len(correct): raise ValueError("Guess length is incorrect")
    pattern = ''
    for i in range(len(correct)):
        g = guess[i]
        if g == correct[i]: pattern += '2'
        elif g in correct: pattern += '1'
        else: pattern += '0'
    won = pattern == '2' * len(correct)
    return pattern, won

def renderGuessColors(guess, pattern):
    guess = str.upper(guess)
    output = ''
    for i in range(len(guess)):
        g = guess[i] + ' '
        p = pattern[i]
        if p == '2': output += c(g, COLORS.correct)
        elif p == '1': output += c(g, COLORS.wrongplace)
        elif p == '0': output += c(g, COLORS.incorrect)
    return output

def printGuessList(renderedGuesses, printInfo=False):
    print()
    if len(renderedGuesses) <= 0: return
    if printInfo: print(c("Correct ", COLORS.correct) + c("Wrong place ", COLORS.wrongplace) + c("Incorrect", COLORS.incorrect))
    for guess in renderedGuesses:
        print(guess)
    print()

def getRemainingLetters(usedLetters):
    remaining = list('abcdefghijklmnopqrstuvwxyz')
    for l in usedLetters:
        if l in remaining: remaining.remove(l)
    return remaining

def printRemainingLetters(remainingLetters):
    for l in remainingLetters:
        print(c(str.upper(l), 'grey'), '', end='')
    print()

def getGuess(length):
    guess = ''
    while len(guess) != length:
        guess = input(f'Enter your guess ({length} letters): ')
    return guess


# Main loop
def loop(word, renderedGuesses, usedLetters):
    printGuessList(renderedGuesses)
    remainingLetters = getRemainingLetters(usedLetters)
    printRemainingLetters(remainingLetters)
    newGuess = getGuess(len(word))
    pattern, haswon = getGuessPattern(newGuess, word)
    for letter in newGuess.lower():
        if letter not in usedLetters: usedLetters.append(letter)

    renderedGuess = renderGuessColors(newGuess, pattern)
    return renderedGuess, haswon



# Show title
print(
    c("W", COLORS.correct) +
    c("O", COLORS.wrongplace) +
    c("R", COLORS.incorrect) +
    c("D", COLORS.wrongplace) +
    c("L", COLORS.correct) +
    c("E", COLORS.wrongplace)
)

# Select a random word
word_length = 6
with open("/usr/share/dict/words") as f:
    words = [w.strip() for w in f if len(w.strip()) == word_length and w.strip().isalpha()]
correct = random.choice(words)

# Run the game
attempts = 6
usedAttempts = 0
usedLetters = []
renderedGuesses = []
won = False
for i in range(attempts):
    usedAttempts += 1
    rendered, won = loop(correct, renderedGuesses, usedLetters)
    renderedGuesses.append(rendered)
    if won: break

    
printGuessList(renderedGuesses)
print("Won" if won else "Lost", "in", usedAttempts, "attempts!", f'The word was "{correct}"' if not won else '')
