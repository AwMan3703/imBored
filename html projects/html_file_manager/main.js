const whySelectFolder = 'Select a folder to allow us to read from it and display the contents in the file manager.';

function onPageLoaded() {
    console.log('onPageLoaded function launched');

    //set the width of the background shader canvas
    //(for some reason it appears low quality if the
    //width is set through CSS or style="")
    const shbg = document.getElementById('shaderbg');
    shbg.style.width = '100%';

    const sandbox = new GlslCanvas(shbg);
    const salt = Math.random();
    console.log('salt for shader is '+salt);
    sandbox.setUniform('salt', salt);
}

function start() {
    //reduce title & header
    document.getElementById('h1title').className = 'h1small';
    document.getElementById('header').className = 'hdsmall';
    //fade out <article>
    document.getElementById('article').className = 'artsmall';
    //remove <article>
    document.getElementById('artbody').remove();
    //set <article> as visible again
    document.getElementById('article').className = 'artbig';
    //create the reload button
    let reloadButton = document.createElement('button');
    reloadButton.classList = ['visible-div'];
    reloadButton.setAttribute('onclick', 'window.location.reload();');
    reloadButton.style.fontSize = 'small';
    reloadButton.innerText = 'Reload page';
    document.getElementById('header').appendChild(reloadButton);
    //sorry this is not available lmao
    let message = document.createElement('h1');
    message.innerText = 'Sorry, the file manager is not currently available.';
    message.className = 'footer-like';
    message.style.fontWeight = '900';
    message.style.fontSize = 'xx-large';
    message.style.marginTop = '14%';
    message.style.opacity = '50%';
    document.getElementById('article').appendChild(message);
}

function onFileInput() {
    console.log('callback run');
    const root = document.getElementById('directoryAccessInput').files;
    if (root.length<1) {
        const msg = 'no files provided';
        console.log(msg);
        alert(msg);
        return null;
    } else {
        console.log('files uploaded');
        document.getElementById('startBtn').attributes.removeNamedItem('disabled');
        document.getElementById('DAIlabel').innerText = 'folder selected!';
        document.getElementById('DAIlabel').style.borderStyle = 'solid';
    }
}
