

//run on load
function setup(listOutput, projectdataElements) {
    for (data of projectdataElements) {
        const li = document.createElement("li");
        li.innerHTML = `<h3>${data.innerText}</h3><a href=\"${data.getAttribute("path")}\">open</a> or <button onclick=\"incorporate(\'${data.getAttribute("path")}\')\">incorporate</button>`;
        // Uncomment line 9 to automatically incorporate projects when menu item is hovered
        //li.setAttribute("onmouseenter", `incorporate(\"${data.getAttribute("path")}\");`)
        listOutput.appendChild(li);
    }
}

function incorporate(path) {
    const prevbox = document.getElementById('preview-box')
    prevbox.innerHTML = '';
    const preview = document.createElement('iframe');
    preview.src = path;
    preview.style.width = 'inherit';
    preview.style.height = 'inherit';
    prevbox.appendChild(preview);
}