
const iconNodes = document.getElementsByClassName('load-icon');

for (let i = 0; i < iconNodes.length; i++) {
    const e = iconNodes[i];
    const path =  e.getAttribute('data-icon');

    if (path!='' && path!=null) {
        e.style.backgroundImage = `url(img/icons/${path})`;
        e.style.opacity = '100%';
    }
}