function loadText(url) {
    var xhr = new XMLHttpRequest();
    xhr.open('GET', url, false);
    xhr.overrideMimeType("text/plain");
    xhr.send(null);
    if(xhr.status === 200)
        return xhr.responseText;
    else {
        return null;
    }
}

// variables globales du programme;
var canvas;
var gl; //contexte
var program; //shader program
var attribPos; //attribute position
var pointSize = 10.;
var mousePositions = [ [] ];

function initContext() {
    canvas = document.getElementById('dawin-webgl');
    gl = canvas.getContext('webgl');
    if (!gl) {
        console.log('ERREUR : echec chargement du contexte');
        return;
    }
    gl.clearColor(0.2, 0.2, 0.2, 1.0);
}

//Initialisation des shaders et du program
function initShaders() {
    var fragmentSource = loadText('fragment.glsl');
    var vertexSource = loadText('vertex.glsl');

    var fragment = gl.createShader(gl.FRAGMENT_SHADER);
    gl.shaderSource(fragment, fragmentSource);
    gl.compileShader(fragment);

    var vertex = gl.createShader(gl.VERTEX_SHADER);
    gl.shaderSource(vertex, vertexSource);
    gl.compileShader(vertex);

    gl.getShaderParameter(fragment, gl.COMPILE_STATUS);
    gl.getShaderParameter(vertex, gl.COMPILE_STATUS);

    if (!gl.getShaderParameter(fragment, gl.COMPILE_STATUS)) {
        console.log(gl.getShaderInfoLog(fragment));
    }

    if (!gl.getShaderParameter(vertex, gl.COMPILE_STATUS)) {
        console.log(gl.getShaderInfoLog(vertex));
    }

    program = gl.createProgram();
    gl.attachShader(program, fragment);
    gl.attachShader(program, vertex);
    gl.linkProgram(program);
    if (!gl.getProgramParameter(program, gl.LINK_STATUS)) {
        console.log("Could not initialise shaders");
    }
    gl.useProgram(program);
}

//Fonction initialisant les attributs pour l'affichage (position et taille)
function initAttributes() {
    gl.bindAttribLocation(program, 0, "position");
}

//Evenement souris
function initEvents() {
    canvas.onclick = function(e) {
        //changement de repere pour les coordonnees de souris
        var mousePos = []
        mousePos[0] = (e.pageX/canvas.width)*2.0 - 1.0;
        mousePos[1] = ((canvas.height-e.pageY)/canvas.height)*2.0 - 1.0;
        mousePositions.push(mousePos);
        draw();
    }
}

//Fonction permettant le dessin dans le canvas
function draw() {
    gl.clear(gl.COLOR_BUFFER_BIT);
    for (var i = 0; i < mousePositions.length; i++) {
        gl.vertexAttrib2f(0, mousePositions[i][0], mousePositions[i][1]);
        gl.drawArrays(gl.POINTS, 0, 1);
    }
}




function main() {
    initContext();
    initShaders();
    initAttributes();
    initEvents();
    draw();
}
