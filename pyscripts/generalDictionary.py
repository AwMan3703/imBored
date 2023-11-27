# general Dictionary for imBored scripts
# please do not remove or change directory

isValidLang = lambda l : l in [
    'it_IT',
    'en_US'
]

class Dictionary:
    def __init__(self, data:dict[str, dict[str, str]], lang:str = 'en_US', ignoreNullKeys = False) -> None:
        self.data = data
        self.lang = lang
        self.ignoreNullKeys = ignoreNullKeys

    def setLang(self, new_lang:str):
        if not isValidLang(new_lang): raise NameError(new_lang)
        self.lang = new_lang
        return True

    def translate(self, key:str):
        r = None
        try: r = self.data[key]
        except: 
            if self.ignoreNullKeys: return f"[dictionary:{key}]"
            else: raise KeyError(key+': key is not in dictionary')
        try: r = r[self.lang]
        except:
            if self.ignoreNullKeys: return f"[dictionary:{key}]"
            else: raise KeyError(key+': key has no translation for language "'+self.lang+'"')
        return r

hangman = Dictionary({
    "dictionary_not_found" : {
        'it_IT' : '\nERRORE - impossibile accedere ai vocaboli.\nLo script deve essere avviato nella stessa directory di "hangmanWords.txt"\n',
        'en_US' : '\nERROR - cannot access the word list.\nThe script must be run in the same directory as "hangmanWords.txt"\n'
    },
    "guess_prompt" : {
        'it_IT' : 'indovina una lettera: ',
        'en_US' : 'guess a letter: '
    },
    "remaining_attempts" : {
        'it_IT' : ' tentativo/i rimasto/i\n',
        'en_US' : ' attempt(s) remaining\n'
    },
    "min_word_length_prompt" : {
        'it_IT' : 'lunghezza minima della parola: ',
        'en_US' : 'minimum length of the word: '
    },
    "max_word_length_prompt" : {
        'it_IT' : 'lunghezza massima della parola: ',
        'en_US' : 'maximum length of the word: '
    },
    "error_limit_prompt" : {
        'it_IT' : 'numero di errori prima del game over: ',
        'en_US' : 'max errors before game over: '
    },
    "you_won" : {
        'it_IT' : 'Hai vinto!\n',
        'en_US' : 'You won!\n'
    },
    "you_lost" : {
        'it_IT' : 'Hai perso!\n',
        'en_US' : 'You lost!\n'
    },
    "the_word_was" : {
        'it_IT' : 'la parola era',
        'en_US' : 'the word was'
    }
})

rockPaperScissors = Dictionary({
    "moves" : {
        'it_IT' : ['sasso','carta','forbice'],
        'en_US' : ['rock','paper','scissors']
    },
    "m" : {
        'it_IT' : ['s','c','f'],
        'en_US' : ['r','p','s']
    },
    "move_prompt" : {
        'it_IT' : 'scegli la tua mossa\n([s]asso, [c]arta o [f]orbici): ',
        'en_US' : 'make your move\n([r]ock, [p]aper or [s]cissors): '
    },
    "invalid_move_error" : {
        'it_IT' : '[ERRORE] mossa non valida',
        'en_US' : '[ERROR] invalid move'
    },
    "your_move_is" : {
        'it_IT' : '\nla tua mossa è ',
        'en_US' : '\nyour move is '
    },
    "my_move_is" : {
        'it_IT' : 'la mia mossa è ',
        'en_US' : 'my move is '
    },
    "you_won" : {
        'it_IT' : 'Hai vinto!',
        'en_US' : 'You won!'
    },
    "tie" : {
        'it_IT' : 'Pareggio!',
        'en_US' : 'Tie!'
    },
    "you_lost" : {
        'it_IT' : 'Hai perso!',
        'en_US' : 'You lost!'
    }
})

codegenerator = Dictionary({
    "code_prompt" : {
        'it_IT' : 'inserisci il codice da eseguire: ',
        'en_US' : 'type the code to run: '
    }
})

tris = Dictionary({
    "place_prompt" : {
        'it_IT' : 'Scegli una casella',
        'en_US' : 'Place your mark on the grid'
    },
    "row" : {
        'it_IT' : 'riga',
        'en_US' : 'row'
    },
    "column" : {
        'it_IT' : 'colonna',
        'en_US' : 'column'
    },
    "inexistent_cell" : {
        'it_IT' : 'la casella selezionata non esiste.',
        'en_US' : 'that cell does not exist.'
    },
    "occupied_cell" : {
        'it_IT' : 'la casella selezionata è occupata.',
        'en_US' : 'that cell is occupied.'
    },
    "thinking" : {
        'it_IT' : 'sto pensando',
        'en_US' : 'thinking'
    },
    "done" : {
        'it_IT' : 'fatto!',
        'en_US' : 'done!'
    },
    "turn_header" : {
        'it_IT' : '-----turno di: {}-----',
        'en_US' : '-----{}\'s turn-----'
    },
    "player" : {
        'it_IT' : 'giocatore',
        'en_US' : 'player'
    },
    "computer" : {
        'it_IT' : 'computer',
        'en_US' : 'computer'
    }
})



