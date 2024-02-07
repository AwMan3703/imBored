import array
import random
from time import sleep
import turtle

def step_width(steps:int, box:float):
    return box/steps

color_bg = '#000000'
color_fg = '#4AF626'
color_ln = '#043927'
class Graph:
    def __init__(self, rng:float, ref_rate:float, points:int) -> None:
        self.setup()
        self.rng = rng
        vls = []
        while True:
            vls.append(random.randint(int(-rng), int(rng)))
            self.draw_frame(vls[::-1][0:points])
            sleep(ref_rate)

    def setup(self):
        self._s = turtle.getscreen()
        self._s.bgcolor(color_bg)
        self._s.tracer(0)

        self.t = turtle.Turtle()
        self.t.speed(0)
        self.t.isvisible = False
        self.t.pencolor(color_fg)

    def draw_graph(self, x:float, y:float, width:float, values:array):
        self.t.penup()
        step = step_width(len(values), width)
        self.t.goto(x, y+values[0])
        its = 0
        self.t.pendown()
        self.draw_lines(7, x, width)
        self.t.penup()
        self.t.goto(x, y)
        self.t.pendown()
        for i in values:
            its+=1
            self.t.goto(x+(step*its), y+i)
    
    def renderline(self, start_x:float, end_x:float, y:float):
        self.t.penup()
        self.t.goto(start_x, y)
        self.t.pendown()
        self.t.goto(end_x, y)
        self.t.penup()

    def draw_lines(self, n:int, start_x:float, end_x:float):
        xp = self.t.pencolor()
        self.t.pencolor(color_ln)
        s = step_width(n, self.rng*2)
        for i in range(n+1):
            self.renderline(start_x, end_x, self.rng-(s*i))
        self.t.pencolor(xp)


    def draw_frame(self, values):
        self.t.clear()
        self.draw_graph(-(self._s.window_width()/2), 0, self._s.window_width(), values)
        self._s.update()


g = Graph(300, .25, 50)