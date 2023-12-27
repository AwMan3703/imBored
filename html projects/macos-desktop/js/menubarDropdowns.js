
const el = document.getElementById('menu-bar-options');
const toggle_class = 'dropdowns-open';

el.addEventListener('click', () => {

    if (el.classList.contains(toggle_class)) {
        el.classList.remove(toggle_class);

    } else {
        el.classList.add(toggle_class);
    }
});
document.addEventListener('click', () => {
    if (document.activeElement != el) { // if dropdown options are not focused
        el.classList.remove(toggle_class);
    }
});
