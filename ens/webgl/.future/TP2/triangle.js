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
var attribColor;

//Buffer
var buffer;
var bufferColor;

//Operations sur uniforms
var tx = 0;
var ty = 0;
var scale = 1;
var angle = 0;

//Uniforms
var uTranslation;
var uAngle;

var time = 0;

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
    attribPos = gl.getAttribLocation(program, "position");
    attribColor = gl.getAttribLocation(program, "color");

    uTranslation = gl.getUniformLocation(program, "translation");
    uAngle = gl.getUniformLocation(program, "angle");
    gl.enableVertexAttribArray(attribPos);
    gl.enableVertexAttribArray(attribColor);

}



//Initialisation des buffers
function initBuffers() {

    var vertices = [-0.2, 0.2,
                    0.2, 0.2,
                    -0.2, -0.2
                    ];

    var color = [ 1.0, 0.0, 0.0, 1.0,
                  0.0, 1.0, 0.0, 1.0,
                  0.0, 0.0, 1.0, 1.0];

    buffer = gl.createBuffer();
    gl.bindBuffer(gl.ARRAY_BUFFER, buffer);
    gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(vertices), gl.STATIC_DRAW);

    bufferColor = gl.createBuffer();
    gl.bindBuffer(gl.ARRAY_BUFFER, bufferColor);
    gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(color), gl.STATIC_DRAW);
}


//Fonction permettant le dessin dans le canvas
function draw() {
    requestAnimationFrame(draw);

    time+=0.01;
    gl.clear(gl.COLOR_BUFFER_BIT);

    angle = time % (2*3.14);

    //Permet de "rebondir" sur les bords
    tx = (time%4 < 2) ? -1 +time % 4 : 1-(time%4 - 2.0);

    gl.uniform1f(uAngle, angle);
    gl.uniform1f(uTranslation, tx);

    gl.bindBuffer(gl.ARRAY_BUFFER, buffer);
    gl.vertexAttribPointer(attribPos, 2, gl.FLOAT, true, 0, 0);
    gl.bindBuffer(gl.ARRAY_BUFFER, bufferColor);
    gl.vertexAttribPointer(attribColor, 4, gl.FLOAT, false, 0, 0);
    gl.drawArrays(gl.TRIANGLES, 0, 3);

}


function main() {
    initContext();
    initBuffers();
    initShaders();
    initAttributes();
    draw();
}
