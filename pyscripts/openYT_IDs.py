# code by DB_dev_Studios

# Tool for recreating youtube playlists/algorithm (re-like the same videos) in a new account.
#
# 1. Download your old YouTube account's data:
#    Google Takeout > [select "YouTube & YouTube Music"] > [download the zip file] (easier methods might be available)
# 2. Open zip file -> extracts a folder named "Takeout"
# 3. In the folder, go into "/YouTube and YouTube Music/playlist/"
# 4. For each file in "playlist/":
#     a) open the file, you will find some header text and a list of video IDs
#     b) delete the first 4 lines, ONLY the list should remain (anything on the same line as an ID that
#        comes after it (date/time) can stay as well, as this script dynamically separates the ID from the rest of the line
#        (takes all the characters before ","), and bulds the URL based on that)
#     c) save the file at any location with any name and extension (as long as it can be read as text, e.g. "txt")
# 5. Run this python file ("python3 [location]/openYT_IDs.py")
# 6. You will be prompted with the message "file location:", there, insert the location of the file
#    containing the list of video IDs (you can copy the script in the list's directory, for easier access)
# 7. This script will open a browser tab for each video ID, so that you can either like it or add it
#    to a playlist (recreating playlists and re-liking videos on a new account will create nearly identical YT algorithm
#    preferences and suggestions as the old one)

import webbrowser

f = open(input('file location: '))
cap = int(input('In order to avoid overloading the browser, a group of links will be opened,\nthen the program will pause and wait.\nChoose how many links to put in each group (int): '))

lines = f.readlines()
p = 0

def openlinks(cap:int):
    i = 0
    while i < cap:
        global p

        l = lines[p]
        _url = "https://www.youtube.com/watch?v=" + l.split(",")[0].strip() #l[0:11]
        print('webbrowser (' + str(p) + '): opening \"' + _url + '\"...')
        webbrowser.open(_url)

        p += 1
        i += 1

while True:
    openlinks(cap)
    conf = input('proceed with the next link group? [ENTER to proceed / Q to quit] ')
    if conf.lower()=="q": break

print('script terminated.')