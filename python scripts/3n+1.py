# looping math problem.
# 1) take any integer
# 2) if even, divide by 2 / if odd multiply by 3 and add 1
# 3) repeat step 2 with its result
# any starting number ends up in this loop: 4 -> 2 -> 1 -> 4 -> 2 -> 1 -> ...


def process(n:int):
    is_even = int(n)%2 == 0
    if is_even:
        return n/2, True
    else:
        return (n*3)+1, False

startnumber = int(input("number to start with: ")) #comment to automate
loopdepth = int(input("loop check depth: "))
loopmatch = []
for i in range(loopdepth):
    loopmatch.append(1.0)
    loopmatch.append(2.0)
    loopmatch.append(4.0)
numbers = []

def checkloop(series):
    a = series[::-1]
    if a[0:loopdepth*3] == loopmatch:
        return True
    else:
        return False

def mainloop(x:int):
    if checkloop(numbers):
        print("LOOP DETECTED")
        return False
    res, isEven = process(x)
    numbers.append(res)
    print(res, isEven) #comment to automate
    mainloop(res)

print('rules:\nfor each number:\n-if even, divide by 2\n-if odd multiply by 3 and add 1\n')
mainloop(startnumber) #comment to automate


#i = 3370            uncomment to automate
#def repeat():
#    global i
#    global numbers
#    print(i, ":")
#        return True
#    if mainloop(i):
#    numbers = []
#    i += 1
#    repeat()
#repeat()