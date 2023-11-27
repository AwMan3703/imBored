#code by @Aw_Man3703

import usefulStuff as Us

test = 'never gonna give you up never gonna let you down never gonna run around and desert you'


def find_cases(text:str, start_character:str, length:int):
    #declare stuff
    found_cases = []
    cases_dictionary = {}
    cases_count = text.count(start_character)

    #find the cases in which the character appears
    for index in range(len(text)):
        char = text[index]
        if char==start_character:
            found_case = text[index:index+length]
            found_cases.append(found_case)

    #sort the found cases
    for c in found_cases:
        if c in cases_dictionary:
            cases_dictionary[c]+=1
        else:
            cases_dictionary[c]=1

    #sort cases
    cases_sorted = dict(sorted(cases_dictionary.items(), key=lambda x:x[1], reverse=True))

    #data
    accuracy = []
    for k in cases_sorted.keys():
        v = cases_sorted[k]
        accuracy.append((v/cases_count)*100)

    #return
    return cases_sorted, accuracy

def filecontent(path:str):
    fh = open(path, 'r')
    raw = fh.readlines()
    fh.close()
    lst = []
    for i in raw:
        lst.append(i.strip('\n'))
    return ''.join(lst)


predictions = {}
for l in list(Us.alphabet):
    prbb = 'none found'
    cases, accuracy = find_cases(filecontent('usefulStuff.py'), l, 2)
    output = list(cases.keys())
    if output != [] and output != None:
        prbb = [output[0], str(Us.truncate(accuracy[0], 2))+'%']
    predictions[l] = prbb

print(predictions)