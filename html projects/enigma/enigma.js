
const keyparam = 'enigmakey'; // The name of the url parameter containing the decryption key

const decryptables = document.getElementsByTagName('enigmajs-decrypt'); // Find the elements that need decryption

const searchParams = new URLSearchParams(window.location.search); // Get the url parameters
if (!(searchParams.has(keyparam))) { throw new Error("no Enigmajs key found"); } // If no key is found, abort
const key = parseInt(searchParams.get(keyparam)); // If a key is present, proceed


for (let i = 0; i < decryptables.length; i++) {
    const e = decryptables[i];
    const d = caesarCypher(e.innerText, key); // maybe don't just use a caesar cypher

    e.parentElement.append(d);
    e.remove();
}
