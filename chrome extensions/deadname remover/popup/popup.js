
var toReplace;
var replaceWith;
var repTimeout;
var doReplacement;
var deadnameVisible = true;

const chStorage = chrome.storage.sync;
const replacementStorageKey = 'replacement';
const doReplacementStorageKey = 'do-replacement';

// chrome storage management DON'T YOU FUCKING TOUCH IT BITCH
function load_replacement() {
    chStorage.get([replacementStorageKey]).then((value) => {
        toReplace = value[replacementStorageKey][0];
        replaceWith = value[replacementStorageKey][1];
        repTimeout = value[replacementStorageKey][2];
        doReplacement = value[doReplacementStorageKey];

        document.getElementById('frontend-toreplace').value = toReplace[0];
        document.getElementById('frontend-replacewith').value = replaceWith[0];
        document.getElementById('frontend-toreplace2').value = toReplace[1];
        document.getElementById('frontend-replacewith2').value = replaceWith[1];
        document.getElementById('frontend-reptimeout').value = repTimeout;

        console.log(`loaded replacement with ${value[replacementStorageKey].length} items`);
    }, () => {alert('Chrome storage read promise rejected')});
    chStorage.get([doReplacementStorageKey]).then((value) => {

        doReplacement = value[doReplacementStorageKey];
        document.getElementById('replacement-switch').checked = doReplacement;

        console.log(`loaded do-replacement as ${doReplacement}`);
    }, () => {alert('Chrome storage read promise rejected')});
}
function save_replacement() {

    toReplace = [document.getElementById('frontend-toreplace').value, document.getElementById('frontend-toreplace2').value];
    replaceWith = [document.getElementById('frontend-replacewith').value, document.getElementById('frontend-replacewith2').value];
    repTimeout = parseInt(document.getElementById('frontend-reptimeout').value);
    doReplacement = document.getElementById('replacement-switch').checked;

    chStorage.set({[replacementStorageKey] : [toReplace, replaceWith, repTimeout]}).then(() => {
        console.log('replacement saved')
    }, () => {alert('Chrome storage read promise rejected')});
    chStorage.set({[doReplacementStorageKey] : doReplacement}).then(() => {
        console.log('do-replacement saved')
    }, () => {alert('Chrome storage read promise rejected')});
}
function show_data() {
    chStorage.get([replacementStorageKey]).then((value) => {
        console.log('saved -', value[replacementStorageKey]);
    }, () => {alert('Chrome storage read promise rejected')});
    console.log('local -', [toReplace, replaceWith]);
    console.log('do-replacement [local]:', doReplacement);
}

// popup stuff
function credits_window() {
    window.open('https://twitter.com/Aw_Man3703');
}

function cat_window() {
    window.open('cat/cat.html');
}

function toggleDeadnameVisibility() {
    let input1 = document.getElementById('frontend-toreplace');
    let input2 = document.getElementById('frontend-toreplace2');
    let button = document.getElementById('hide-deadname');
    deadnameVisible = !deadnameVisible;
    if (deadnameVisible) {
        input1.classList.remove('blurry');
        input2.classList.remove('blurry');
        button.innerText = '[HIDE]';
    } else {
        input1.classList.add('blurry');
        input2.classList.add('blurry');
        button.innerText = '[SHOW]';
    }
}

//load replacement data
load_replacement();

//setup event listener for saving
document.getElementById('savebtn').addEventListener('click', save_replacement);
document.getElementById('replacement-switch').addEventListener('click', save_replacement);
document.getElementById('catbtn').addEventListener('click', cat_window);
//document.getElementById('credits-link').addEventListener('click', credits_window);
document.getElementById('hide-deadname').addEventListener('click', toggleDeadnameVisibility);

toggleDeadnameVisibility();

console.log('popup.js started');