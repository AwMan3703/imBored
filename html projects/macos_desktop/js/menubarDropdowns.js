
document.getElementById('menu-bar-options').addEventListener('click', (_a, _b) => {
    const el = document.getElementById('menu-bar-options');

    if (el.classList.contains('dropdowns-open')) {
        el.classList.remove('dropdowns-open');

    } else {
        el.classList.add('dropdowns-open');
    }
});
