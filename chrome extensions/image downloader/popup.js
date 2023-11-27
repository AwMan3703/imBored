
function scan_page() {
    let images = document.getElementsByTagName('img');

    let btn = document.createElement('button')
    btn.innerText = 'lmao';
    images[0].appendChild(btn)
}

document.getElementById('run-scan-button').addEventListener('click', scan_page);