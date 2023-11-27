from generalDictionary import rockPaperScissors as dct
dct.setLang('it_IT')
d = lambda index : dct.translate(index)
import random

moves = d('moves')
m = d('m')
def main():
    usermove = moves[m.index(input(d('move_prompt')))]
    if usermove not in moves:
        print(d('invalid_move_error'))
        main()
    print(d('your_move_is')+usermove)

    selfmove = random.choice(moves)
    print(d('my_move_is')+selfmove)

    print('\n--> ', end = '')
    specialcondition = usermove == moves[len(moves)-1] and selfmove == moves[0]
    if moves.index(usermove)+1 == moves.index(selfmove) or specialcondition:
        print(d('you_lost'))
        return True
    elif selfmove == usermove:
        print(d('tie'))
        return None
    else:
        print(d('you_won'))
        return False
main()