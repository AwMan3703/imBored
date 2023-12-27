
function updateClocks() {
    const clocks = document.getElementsByClassName('real-time-clock');
    const timeStr = new Date().toLocaleString();

    for (let i = 0; i < clocks.length; i++) {
        const c = clocks[i];

        c.innerText = timeStr;
    }
}

updateClocks();
setInterval(function(){ 
    updateClocks();
}, 1000);
