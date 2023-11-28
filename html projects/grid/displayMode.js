
export function toggleDisplayMode() {
    alert('ran');
    if (document.body.classList.contains('darkmode')) {
        document.body.classList.remove('darkmode');
        document.body.classList.add('lightmode');
    } else {
        document.body.classList.remove('lightmode');
        document.body.classList.add('darkmode');
    }
}
