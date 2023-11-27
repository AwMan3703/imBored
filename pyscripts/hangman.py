import usefulStuff as US
from generalDictionary import hangman as dct
dct.setLang('it_IT')
d = lambda index : dct.translate(index)
import random

word = ''
output = []
wrong_guesses = 0

def choose(minlength, maxlength):
    try:
        lines = open('hangmanWords.txt', 'r').read().splitlines()
    except:
        print(d('dictionary_not_found'))
        return False
    global word
    word = random.choice(lines)
    global output
    while not (minlength <= len(word) and len(word) <= maxlength):
        word = random.choice(lines)
    for i in range(len(word)):
        output.append('_')
    return word

def guess(letter):
    global word
    global output
    if letter in word:
        for i in range(len(output)):
            if word[i] == letter:
                output[i] = letter
    else:
        global wrong_guesses
        wrong_guesses += 1

turns_duration = []
turn_sw = US.StopWatch()
def ask():
    global turns_duration
    global turn_sw
    turn_sw.start()
    g = input(d('guess_prompt'))
    turns_duration.append(turn_sw.read())
    guess(g)
    print('\n' + ''.join(output))
    print(str(wrong_limit - wrong_guesses) + d('remaining_attempts'))

def play():
    minl = int(input(d('min_word_length_prompt')))
    maxl = int(input(d('max_word_length_prompt')))
    global wrong_limit 
    wrong_limit = int(input(d('error_limit_prompt')))
    if not choose(minl, maxl):
        print('> dict error')
        return False
    game_sw = US.StopWatch()
    game_sw.start()
    print('\n'+''.join(output)+'\n')
    while (''.join(output) != word) and (wrong_guesses < wrong_limit):
        ask()
    total_time = game_sw.read()
    del game_sw
    print(''.join(output)+'\n')
    if ''.join(output) == word:
        print(d('you_won'))
    else:
        print(d('the_word_was'), '\"'+word+'\"')
        print(d('you_lost'))

    print('- GAME STATS - - - - -')
    print('total play time: '+str(round(total_time, 2)))
    print('average guess time: '+str(round(US.avg(turns_duration), 2)))
    print('wrong guesses: '+str(wrong_guesses))

play()