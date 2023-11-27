#code by DB_dev_Studios

import random
from time import sleep
import pyperclip

main_dir = ''
code_length = 12
cp:list[str] = ['a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z',
                '1','2','3','4','5','6','7','8','9','0']
full_cp:list[list[str]] = []
for i in range(code_length):
    full_cp.append(cp)

def gencode(charpool:list[list[str]] = full_cp) -> str:
    code = ''

    for i in range(code_length):
        x = random.choice(charpool[i])
        code = code+x.upper()

    return code

def derive_cp(path:str):
    fh = open(path, 'r')
    l2 = fh.readlines()
    fh.close()

    cp:list[list[str]] = []
    for i in range(code_length):
        pool = []
        for el in l2:
            if not el[i] in pool:
                pool.append(el[i])
        cp.append(pool)
    
    return cp

def generate() -> str:
    #fh = file handle
    tried_fh = open(main_dir+'tried.txt', 'r')
    expired_fh = open(main_dir+'expired.txt', 'r')
    #l2 = ll = line list
    expired_l2a = expired_fh.readlines()
    expired_l2b = []
    for line in expired_l2a:
        expired_l2b.append(line[0:11])
    tried_l2 = tried_fh.readlines()
    expired_fh.close()
    tried_fh.close()

    derived_cp = derive_cp(main_dir+'expired.txt')

    code = ''
    while True:
        code = gencode(derived_cp)
        if (code not in tried_l2) and (code not in expired_l2b):
            break
        else:
            print('code already tried/expired, retrying...')

    tried_fh = open(main_dir+'tried.txt', 'a')
    tried_fh.write('\n'+code)
    tried_fh.close()
    
    pyperclip.copy(code)
    return code

print('\ncode:', generate())
print('[copied to clipboard]')
print('redeem at https://genshin.hoyoverse.com/en/gift')