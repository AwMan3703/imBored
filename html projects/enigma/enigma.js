
const decryptables = document.getElementsByTagName('enigmajs-decrypt');

let decrypt = (text, key) => {
    let result = '';

    /* This is where the decryption script goes */
    result = '[decrypted]->' + text;

    return result;
}

for (let i = 0; i < decryptables.length; i++) {
    const e = decryptables[i];
    const d = decrypt(e.innerText);

    e.append(d);
    e.remove();
}
