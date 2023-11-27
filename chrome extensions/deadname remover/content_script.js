// Js lmaooo

// page manipulation
function correct_page(trp, rpw) {

    //REPLACEMENT STUFF
    //if page does not have the words, return
    if (
        !document.documentElement.innerHTML.includes(trp[0]) &&
        !document.documentElement.innerHTML.includes(trp[1])
        ) { return; }

    //get all the html elements in the page
    let page_elements = document.getElementsByTagName('*');

    //if it does, find and replace it
    for (var i=0, max=page_elements.length; i < max; i++) {

        var element = page_elements[i];

        //filter through whitelist
        let exclude = ['script', 'link']; //whitelist does not work yet
        if (exclude.includes(element.tagName.toLowerCase())) { continue; }

        //try and correct it
        try {
            element.innerHTML = element.innerHTML.replace(
                new RegExp(trp[0], 'i'),
                rpw[0]
            );
            element.innerHTML = element.innerHTML.replace(
                new RegExp(trp[1], 'i'),
                rpw[1]
            );
        } catch (err) {
            console.error(err);
        }
    }
}

window.onload = function(event) {
    chrome.runtime.sendMessage( chrome.runtime.id,
        {messagetype: 'requireReplacementData'},
        function(response) {
            console.log('rep-data =',response);
            let trp = response.data[0];
            let rpw = response.data[1];
            let rto = response.data[2];
            if (trp==''||trp==undefined) { return; }
            setTimeout(function () {
                console.log('\nrunning correction\n');
                correct_page(trp, rpw);
            }, rto);
        }
    );
};
