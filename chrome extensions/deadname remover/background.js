
var doReplacement;

// CONSTATNS
const chStorage = chrome.storage.sync;
const replacementStorageKey = 'replacement';
const doReplacementStorageKey = 'do-replacement';


// FUNCTIONS

function save_replacement(trp, rpw, rto, drp) {
    chStorage.set({[replacementStorageKey] : [trp, rpw, rto]}).then(() => {
        console.log('replacement saved')
    }, () => {alert('Chrome storage read promise rejected')});
    chStorage.set({[doReplacementStorageKey] : drp}).then(() => {
        console.log('do-replacement saved')
    }, () => {alert('Chrome storage read promise rejected')});
}


// ciao :)
// EVENT LISTENERS

chrome.runtime.onInstalled.addListener(() => {
    save_replacement(["", ""], ["", ""], 1000, true);
})

chrome.runtime.onMessage.addListener(
    function (request, _sender, sendResponse) {
        if (request.messagetype=="requireReplacementData") {
            console.log('received request, loading replacement');

            chStorage.get([doReplacementStorageKey]).then((value) => {

                doReplacement = value[doReplacementStorageKey];

            }, () => {alert('Chrome storage read promise rejected')});

            chStorage.get([replacementStorageKey]).then((value) => {
                let toReplace = value[replacementStorageKey][0];
                let replaceWith = value[replacementStorageKey][1];
                let repTimeout = value[replacementStorageKey][2];
                console.log(`background loading replacement with ${value[replacementStorageKey].length} items`);

                if (doReplacement) {
                    sendResponse({messagetype: 'replacementList', data: [toReplace, replaceWith, repTimeout]});
                }
                console.log('sent response data: ', [toReplace, replaceWith, repTimeout]);

            }, () => {alert('Chrome storage read promise rejected')});

            /* I am so very fucking dumb
            so you see the `return true;` line down there? (52)
            well,,,
            it basically makes the whole thing work.
            The function was closing the message port
            before calling sendResponse(), returning
            a `undefined` value.
            five hours.
            I have been troubleshooting it for five hours.
            I finally asked chatgpt to get a specific
            solution for my case, and turns out i had just
            forgotten to keep the port open with that line.
            ✨I want to kill myself.✨ */
            return true;
        }
    }
)
