#code by DB_dev_Studios

source = []
layers = []
typed = ''

def get_source_list(path:str) -> list[str]:
    global source
    f = open(path) #get the file handle
    l = f.read().split('\n') #get a list of all lines, with the \n stripped
    source = l #return the list

def suggest(typed:str, source:list[str]) -> list[str]:
    output = []
    for s in source:
        if s[0:len(typed)]==typed:
            output.append(s)
    return output

def loop():
    global typed
    global layers

    inp = input('type here: '+typed)
    typed = typed+inp
    layers.append(suggest(typed, layers[-1]))

    print(layers[-1])
    print()

    loop()

def main():
    global source
    global layers
    get_source_list('hangmanWords.txt')
    layers.append(source)
    loop()

main()