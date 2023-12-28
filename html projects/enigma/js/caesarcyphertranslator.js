
const caesarCypher = (text, key) => {
    const allchars = [
        '»','a','à','b','c','d','e','è','é','f','g','h','i','ì','j','k','l','m','n','o','ò','p','q','r','s','t','u','ù','v','w','x','y','z',
        '1','2','3','4','5','6','7','8','9','0',' ',
        '\\','|','!','¡','"','£','$','%','&','/','(',')','=','\'','?','¿','^','<','>','≤','≥','[',']','+','*','ç','Ç','@','°','#','§','¶',
        ',',';','…','.',':','•','·','-','_','–','—','«','“','‘','¥','~','‹','÷','´','`','≠',
        '∞','◊','{','}','ˆ','≈','','⁄','›','‰','¢','’','”','»'
    ];
    let result = '';

    /* Just a simple Caesar cypher */
    const chars = Array.from(text);
    chars.forEach(c => {
        result += allchars[allchars.indexOf(c) + key]
    });

    return result;
}

const translator_translateCC = () => {
    const input = document.getElementById('translator-input').value;
    const key = parseInt(document.getElementById('translator-key').value);

    const output = document.getElementById('translator-output');

    output.value = caesarCypher(input, 0 - key)
}
