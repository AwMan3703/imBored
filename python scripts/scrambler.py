
from random import shuffle

INTRO = "A theory by a psychology professor states that even if the letters in a word are scrambled, the message can be read fine as long as the first and last letters keep their place."

def scramble(word:str):
    if len(word) <= 3: return word # The word cannot be scrambled and still meet the requirements
    letters = list(word)[1:-1]
    shuffle(letters)
    return word[0] + "".join(letters) + word[-1]

def scramble_sentence(sentence:str):
    scrambled = []
    words = sentence.split(" ")
    for word in words:
        scrambled.append(scramble(word))
    return " ".join(scrambled)

if __name__ == "__main__":
    print(scramble_sentence(INTRO))

    text = input("Type a sentence: ")
    text = scramble_sentence(text)
    print(text)