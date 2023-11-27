#find repeating patterns, encode them


# depression.py

import re

def get_data(path) -> str:
    print("obtaining the data to compress...")

    file = open(path, "r")
    lines = file.read().splitlines()
    file.close()
    return "".join(lines)

def get_pattern_occurrencies(data:str, pattern:str) -> list[int]: #where the pattern is repeated
    indexes = [_.start() for _ in re.finditer(pattern, data)] 
    return indexes

def get_valid_patterns_amount(data:str, pattern_length:int) -> int:
    # total number of valid patterns found with current parameters
    total = 0

    # for every character in data, check how many times the pattern
    # made from the next [pattern_length] characters is repeated
    for i in range(int(len(data) / pattern_length)):

        # construct the pattern we are looking for
        pattern = str(data[i*pattern_length:i*pattern_length+pattern_length])

        # find how many times it is repeated
        repetitions = data.count(pattern)

        # if it makes sense to compress it, increment total
        if repetitions >= 2: total += 1

    return total

def find_optimal_parameters(data:str, max_pattern_length:int):
    print("determining optimal pattern length for compression...")

    optimal_pattern_length = None
    pl_top = 0

    for pl in range(3, max_pattern_length):
        vp = get_valid_patterns_amount(data, pl)
        if vp > pl_top: pl_top = vp; optimal_pattern_length = pl; print("new pl top:", vp, "optimal:", optimal_pattern_length)

    return optimal_pattern_length

def find_frequent_patterns(data:str, pattern_length:int) -> dict:
    # initialize patterns dictionary
    patterns = dict()

    # split list by pattern length
    chunks = [data[i:i+pattern_length] for i in range(0, len(data), pattern_length)]

    # for every character in data, check how many times the pattern
    # made from the next [pattern_length] characters is repeated
    for pattern in chunks:

        # find WHERE the pattern is repeated
        occurrences = data.count(pattern) #get_pattern_occurrencies(data, pattern)

        # if it makes sense to compress it (A.K.A. if it's found more than once), index it
        if len(occurrences) >= 2: patterns[pattern] = occurrences

    # return the dictionary
    return patterns

def generate_compression_table(frequent_patterns:dict[str, list[int]]):
    # compression table item: "[pattern]:[number]", e.g.: "aString:038" means the pattern "aString" is replaced with "038"
    # this also means that for a pattern to be worth compressing, pattern_length + repetition_amount = length
    for k, v in frequent_patterns.items():
        pass



def test():
    data = get_data("genshinCodeGuesser/tried.txt")
    #opt_pl = find_optimal_parameters("1234567812345678123456789", int(len(data) / 2))
    freqP = find_frequent_patterns("1234567812345678123456789", 3)
    for k, v in freqP.items():
        print(k, ":", v)

    print("\n// DATA")
    print("patterns found:", len(freqP))
    #print("optimal pattern length:", opt_pl)
test()
