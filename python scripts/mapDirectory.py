import os

def dirmap(path:str):
    all_directories = []
    dirlist = []
    try: 
        dirlist = os.listdir(path)
    except:
        pass
    for dir in dirlist:
        p = path+'/'+dir
        if '.' in p:
            # if dir is a file or a hidden directory
            all_directories.append(p)
        if dirlist == []:
            # if the folder is empty, we've reached the bottom.
            # add the path to all_directories and we're done here.
            all_directories.append(p)
        else:
            all_directories.append(p)
            for i in dirmap(p):
                all_directories.append(i)
        print(p)
    return all_directories

print('mapping...\n')
print('\ndone ('+str(len(dirmap(os.getcwd()))), 'total directories found).')