
const randomNumber=(min,max)=>Math.floor(Math.random()*(max-min))+min

const bubbleCount = (Math.random() * 10) + 3;
const bubbleColors = [
    '#ff0000',
    '#ffa600',
    '#ffee00',
    '#00ff00',
    'green',
    '#0000ff',
    '#8000ff',
    '#9500ff',
    '#bb00bb'
]

for (let i = 0; i <= bubbleCount; i++) {
    const shell = document.getElementById('bubbles-container');

    const bs = (Math.random() * 200) + 30;
    const bc = bubbleColors[Math.floor(Math.random()*bubbleColors.length)];
    const bx = randomNumber(bs, visualViewport.width) - bs;
    const by = randomNumber(bs, visualViewport.height) - bs;

    const bubble = document.createElement('div');
    bubble.className = 'circle bubble'
    bubble.style.width = `${bs}px`;
    bubble.style.backgroundColor = bc;
    bubble.style.left = `${bx}px`
    bubble.style.top = `${by}px`

    shell.appendChild(bubble)
}
