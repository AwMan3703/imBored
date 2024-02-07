
import PIL.Image

ld = "@#$%?*+;:,."
hd = "$@B%8&WM#*oahkbdpqwmZO0QLCJUYXzcvunxrjft/\|()1{}[]?-_+~<>i!lI;:,\"^`'."

CHARACTER_MAP = ld[::-1]

def resize(image, new_width = 100):
    width, height = image.size
    new_height = new_width * height / width
    return image.resize((int(new_width), int(new_height)))

def to_greyscale(image):
    return image.convert("L")

def pixel_to_ascii(image, enhance_contrast:bool = False, join_string:str = '-'):
    pixels = image.getdata()
    ascii_str = ""
    for pixel in pixels:
        ch = CHARACTER_MAP[int(pixel//25)]
        js = join_string
        # SUPA CLEVER TACTIC FUNCTION TO ADD CONTRAST
        if CHARACTER_MAP.index(ch) < int(len(CHARACTER_MAP)/2) and enhance_contrast: js = '-'
        ascii_str += ch+js
    return ascii_str

def translateImage(path, resizeTo, joinString, enhanceContrast):
    try:
        image = PIL.Image.open(path)
    except:
        print('{'+path+'}', "Unable to open image")
        return False
    #resize image
    image = resize(image, resizeTo)
    #convert image to greyscale image
    greyscale_image = to_greyscale(image)
    # convert greyscale image to ascii characters
    ascii_str = pixel_to_ascii(greyscale_image, enhanceContrast, joinString)
    img_width = greyscale_image.width*2
    ascii_img = ""
    #Split the string based on width  of the image
    for i in range(0, len(ascii_str), img_width):
        ascii_img += ascii_str[i:i+img_width] + "\n"

    return ascii_img

path = input('image path: ')
crsz = input('set width (100): ')
if crsz == '': crsz = 100
crsz = int(crsz)
jstr = input('join string: ')
if jstr == '': jstr = '-'
ec = input('enhance contrast (y/n)? ')
if ec == 'y': ec = True
else: ec = False
print(translateImage(path, crsz, jstr, ec))
