
function makeDraggable(el) {
	const handle = document.getElementById(el.id + '-handle');

	let dX = 0, dY = 0;

	const onDrag = (ev) => {
		if (ev.buttons==0) { document.removeEventListener('mousemove', onDrag); }
		let mX = ev.clientX, mY = ev.clientY;
		el.style.left = `${mX - dX + ev.movementX}px`;
		el.style.top = `${mY - dY + ev.movementY}px`;
	}

	handle.addEventListener('mousedown', (ev) => {
		let oGCS = window.getComputedStyle(el);
		dX = ev.clientX - parseInt(oGCS.left); //record the X delta between mouse and window's top-left corner
		dY = ev.clientY - parseInt(oGCS.top); //record the Y delta between mouse and window's top-left corner
		document.addEventListener('mousemove', onDrag);
	});
}

let winId = 0;

const spawnWindow = (x, y, w, h, winSrc) => {
    const windowroot = document.createElement('div');
    const windowbar = document.createElement('div');
    const closeBtn = document.createElement('button');
    const iframe = document.createElement('iframe');

    winId += 1;

    windowroot.id = `window_${winId}`;
    windowroot.className = 'window';
    windowroot.style.left = x + 'px';
    windowroot.style.top = y + 'px';
    windowroot.style.width = w + 'px';
    windowroot.style.height = h + 'px';

    windowbar.id = `${windowroot.id}-handle`;
    windowbar.className = 'window-bar';

    closeBtn.classList = 'closewindow-button round';
    closeBtn.style.backgroundColor = 'red';
    closeBtn.addEventListener('click', () => {
        windowroot.style.opacity = '0';
        setTimeout(() => {
            document.getElementById(windowroot.id).remove();
        }, 500);
    });

    iframe.src = winSrc;

    windowbar.appendChild(closeBtn);
    windowroot.appendChild(windowbar);
    windowroot.appendChild(iframe);
    document.getElementById('desktop').appendChild(windowroot);
    makeDraggable(windowroot);
}


//testing
spawnWindow(50, 50, 1000, 500, 'windows/testing.html');
spawnWindow(150, 70, 700, 300, 'windows/testing.html');
spawnWindow(70, 150, 300, 500, 'windows/testing.html');
