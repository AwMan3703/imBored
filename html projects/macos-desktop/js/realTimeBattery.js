
let batteryPc = 100;
function updateBatteries() {
    if (batteryPc == 1) {
        batteryPc = 100;
    }

    const batteries = document.getElementsByClassName('real-time-battery');
    const batteryStr = batteryPc + '% 🀰›';

    for (let i = 0; i < batteries.length; i++) {
        const b = batteries[i];

        b.innerText = batteryStr;
    }

    batteryPc -= 1;
}

updateBatteries();
setInterval(function(){ 
    updateBatteries();
}, 10000);
