# All Characters to Discord Spoiler

# Turns given text into a string that, when sent in a Discord text channel, will be covered
# character-by-character by the anti-spoiler function. Kinda funny idk.

#setup
spoiler = '||'
string = input('text: ')

#main function
def to_ds_cbc_spoiler(txt:str) -> str:
    print('...')
    lxt = list(txt)
    jxt = (spoiler*2).join(lxt)
    return spoiler+jxt+spoiler

#reformat
result = to_ds_cbc_spoiler(string)

#copy result
import pyperclip
pyperclip.copy(result)
print('(result copied to clipboard)\n')

#confirm
print(result+'\n')