#code by DB_dev_Studios

#the starting characters that indicate a line that should be compiled
prefixes = ['$', '~']

def getFileLines(path) -> list[str]:
    fh = open(path, 'r')
    r = fh.readlines()
    fh.close()
    return r

def writeFileLines(path, ls):
    fh = open(path, 'w')
    fh.writelines(ls)
    fh.close()

def getIndexOfItemsStartingWith(ls:list[str], seq) -> list[int]:
    indexes = []
    index = 0
    for item in ls:
        if item.startswith(seq): indexes.append(index)
        index += 1
    return indexes

def replaceItemWith(ls:list[str], index, replacement_list:list):
    ls.pop(index)
    rls = replacement_list[::-1]
    for i in rls:
        ls.insert(index, i)
    return ls

def makeCompilationTable(ls, replacement_function):
    indexes = []
    for p in prefixes:
        indexes.extend(getIndexOfItemsStartingWith(ls, p))
    replacements = []
    for i in indexes:
        replacements.append(replacement_function(i, ls[i]))
    zz = (indexes, replacements)
    return zz

def compile(ls, compilation_table:tuple[list[int], list[str]]):
    r = ls
    c = 0
    while c < len(compilation_table[0]):
        index = compilation_table[0][c]
        replace = compilation_table[1][c]
        r = replaceItemWith(r, index, replace)
        c+=1
    return r

def main(path, replacement_function):
    ls = getFileLines(path)
    ct = makeCompilationTable(ls, replacement_function)
    ls = compile(ls, ct)
    writeFileLines(path, ls)
    print('result is at "'+path+'"')

def replace(index, oldstring:str):
    prefix = oldstring.strip().split(' ')[0]

    #must return a list
    return ['replaced on line: '+str(index)+', old line = "'+oldstring.strip('\n')+'" (auto-detected prefix: '+prefix+')\n']

main('compiler/compileme.txt', replace)