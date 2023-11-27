
from termcolor import colored

def getFiles():
    p1 = 'f1.txt'
    p2 = 'f2.txt'

    f1 = open(p1, 'r')
    f2 = open(p2, 'r')

    f1l = f1.readlines()
    f2l = f2.readlines()

    return f1l, f2l

def compare(l1:list[str], l2:list[str]):
    output = []
    anchor = 0

    #ugly ass logic check
    for i1 in range(len(l1)):
        old_line = l1[i1]
        print('\ncomparing', old_line.strip('\n'))

        #check all the l2 lines starting from anchor index

        if old_line in l2[anchor:len(l2)]:
            t = l2.index(old_line)
            newpack = l2[i1:t]
            for n in newpack:
                output.append(colored(n, 'green'))
                print(n.strip('\n'), 'is new')
            output.append(colored(old_line, 'yellow'))
            print('result = equals')
            anchor = t
        else:
            output.append(colored(old_line, 'red'))
            print('result = deleted')
    
    return output






def main():
    a, b = getFiles()
    o = compare(a, b)
    for i in o:
        print(i)

main()