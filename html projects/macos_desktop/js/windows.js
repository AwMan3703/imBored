
function makeDraggable(el) {
	const handle = document.getElementById(el.id + '-handle');

	let x = 0, y = 0;

	const drag = (ev) => {
		let oGCS = window.getComputedStyle(el);
		let oX = parseInt(oGCS.left.slice(0, -2));
		let oY = parseInt(oGCS.top.slice(0, -2));
		el.left = `${oX + ev.movementX}px`;
		console.log(`${oX + ev.movementX}px`);
		el.top = `${oY + ev.movementY}px`;
		console.log(`${oY + ev.movementY}px`);
	}

	const dragEnd = (ev) => {
		handle.removeEventListener('mousemove', drag)
	}

	handle.addEventListener('mousedown', () => {
		handle.addEventListener('mousemove', drag);
	});
	document.addEventListener('mouseup', dragEnd);
}

let winId = 0;

const spawnWindow = (x, y, w, h, winSrc) => {
    const windowroot = document.createElement('div');
    const windowbar = document.createElement('div');
    const iframe = document.createElement('iframe');

    winId += 1;

    windowroot.id = 'window_' + winId;
    windowroot.style.left = x + 'px';
    windowroot.style.top = y + 'px';
    windowroot.style.width = w + 'px';
    windowroot.style.height = h + 'px';
    windowroot.className = 'window';

    windowbar.id = windowroot.id + '-handle';
    windowbar.className = 'window-bar';

    iframe.src = winSrc;

    windowroot.appendChild(windowbar);
    //windowroot.appendChild(iframe);
    document.getElementById('desktop').appendChild(windowroot);
    makeDraggable(windowroot);
}


//testing
spawnWindow(50, 50, 200, 100, 'windows/testing.html');
spawnWindow(150, 150, 200, 100, 'windows/testing.html');
