from generalDictionary import codegenerator as dct
dct.setLang('it_IT')
d = lambda index : dct.translate(index)
import os
import importlib

class Code:
    def __init__(self, filename:str, code:str, runWhenGenerated:bool = False, deleteAfterRunning:bool = False) -> None:
        self.fname = filename
        self.code = code
        self.generate()
        if runWhenGenerated:
            self.run()
            if deleteAfterRunning:
                self.delete()

    def generate(self):
        f = open(self.fname+".py", "w")
        f.write(self.code)
        f.close()

    def run(self):
        importlib.__import__(self.fname)

    def delete(self):
        os.remove(self.fname+".py")

def runCodeFromString(string:str):
    code = Code('temporary', string, True, True)

runCodeFromString(input(d("code_prompt")))
