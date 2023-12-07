
const max = Math.max;
const min = Math.min;

const minScale = document.getElementById("appicon-finder").style.minHeight.slice(0, -2);
const maxScale = 500;

const dockRect = document.getElementById('dock').getBoundingClientRect();

function updateDockZoom(mx, my) {
    let inx = dockRect.x < mx && mx < dockRect.x + dockRect.width;
    let iny = dockRect.y < my && my < dockRect.y + dockRect.height;

    const appicons = document.querySelectorAll('#dock button');
    let rect, ax, ay, dx, dy, scale; // element rect, iconx, icony, deltax, deltay, distance, scale

    for (let i = 0; i < appicons.length; i++) {
        const a = appicons[i];

        if (!(inx && iny)) {
            a.style.height = minScale + 'px';
            a.style.marginTop = '0px';
            continue;
        }

        rect = a.getBoundingClientRect();
        ax = rect.x;
        ay = rect.y;

        scale = Math.sqrt(ax - mx, ay - my);

        dx = mx - ax,
        dy = my - ay;

        scale = maxScale - Math.sqrt(dx * dx + dy * dy);
        scale /= 4;
        a.style.height = max(scale, minScale) + 'px';
        a.style.marginTop = 0-(max(scale/2, minScale/2)) + 'px';

        document.getElementById("stdout").innerText = 'stdout: ' + minScale;
    }
}

document.addEventListener('mousemove', (e) => {
    updateDockZoom(e.pageX, e.pageY);
});
