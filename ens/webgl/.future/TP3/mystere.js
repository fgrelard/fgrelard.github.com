
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

var gl;
var canvas;
var program;
var attribPos, attribColor;
var buffer, bufferColor, bufferLines, bufferLColor;
var tx=0, tz=0;
var scale = 1.0;
var coordBefore, rot = [0, 0];
var uTranslation, uPerspective, uModel, uView;
var projMatrix = mat4.create();
var modelMatrix = mat4.create();

function initShaders() {
    var vertSource = loadText('vertex.glsl');
    var fragSource = loadText('fragment.glsl');

    var vertex = gl.createShader(gl.VERTEX_SHADER);
    gl.shaderSource(vertex, vertSource);
    gl.compileShader(vertex);

    if(!gl.getShaderParameter(vertex, gl.COMPILE_STATUS))
        console.log("Erreur lors de la compilation du vertex shader:\n"+gl.getShaderInfoLog(vertex));

    var fragment = gl.createShader(gl.FRAGMENT_SHADER);
    gl.shaderSource(fragment, fragSource);
    gl.compileShader(fragment);

    if(!gl.getShaderParameter(fragment, gl.COMPILE_STATUS))
        console.log("Erreur lors de la compilation du fragment shader:\n"+gl.getShaderInfoLog(fragment));

    program = gl.createProgram();
    gl.attachShader(program, vertex);
    gl.attachShader(program, fragment);
    gl.linkProgram(program);

    if(!gl.getProgramParameter(program, gl.LINK_STATUS))
        console.log("Erreur lors du linkage du program:\n"+gl.getProgramInfoLog(program));

    gl.useProgram(program);

    attribPos = gl.getAttribLocation(program, "vertex_position");
    attribColor = gl.getAttribLocation(program, "color");
    uPerspective = gl.getUniformLocation(program, 'PMatrix')
    uModel = gl.getUniformLocation(program, "MMatrix")
    uView = gl.getUniformLocation(program, 'VMatrix');
    //gl.enableVertexAttribArray(attribColor);
}

function initBuffers() {

    var coordsCube = [
        //face avant
            -1,1,1,  -1,-1,1,  1,1,1,  1,1,1,  -1,-1,1,  1,-1,1,
        //face arriere
            -1,1,-1,  -1,-1,-1,  1,1,-1,  1,1,-1,  -1,-1,-1,  1,-1,-1,
        //face gauche
            -1,1,-1,  -1,-1,-1,  -1,1,1,  -1,1,1,  -1,-1,-1,  -1,-1,1,
        //face droite
        1,1,-1,  1,-1,-1,  1,1,1,  1,1,1,  1,-1,-1,  1,-1,1,
        //face haut
            -1,1,-1,  -1,1,1,  1,1,-1,  1,1,-1, -1,1,1,  1,1,1,
        //face bas
            -1,-1,-1,  -1,-1,1,  1,-1,-1,  1,-1,-1,  -1,-1,1,  1,-1,1
    ];

    buffer = gl.createBuffer();
    gl.bindBuffer(gl.ARRAY_BUFFER, buffer);
    gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(coordsCube), gl.STATIC_DRAW);
    gl.bindBuffer(gl.ARRAY_BUFFER, null);


    var colors = [
        [1.0, 0.0, 0.0],
        [0.0, 1.0, 0.0],
        [0.0, 0.0, 1.0],
        [1.0, 1.0, 0.0],
        [0.0, 1.0, 1.0],
        [1.0, 0.0, 1.0]
    ];

    var cubeColors = []
    for(var i=0 ; i<colors.length ; ++i) {
        var currentColor = colors[i]
        for(var j=0 ; j<6 ; ++j) {
            cubeColors = cubeColors.concat(currentColor)
        }
    }

    bufferColor = gl.createBuffer();
    gl.bindBuffer(gl.ARRAY_BUFFER, bufferColor)
    gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(cubeColors), gl.STATIC_DRAW)
    gl.bindBuffer(gl.ARRAY_BUFFER, null);

    var coordLines = [-10, 0, 0,
                       10, 0, 0,
                       0, -10, 0,
                       0, 10, 0,
                       0, 0, -10,
                       0, 0, 10];

    bufferLines = gl.createBuffer();
    gl.bindBuffer(gl.ARRAY_BUFFER, bufferLines);
    gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(coordLines), gl.STATIC_DRAW);
    gl.bindBuffer(gl.ARRAY_BUFFER, null);

    var colorLines = [1.0,0.0,0.0,1.0,0.0,0.0,
                      0.0,1.0,0.0,0.0,1.0,0.0,
                      0.0,0.0,1.0,0.0,0.0,1.0];


    bufferLColor = gl.createBuffer();
    gl.bindBuffer(gl.ARRAY_BUFFER, bufferLColor);
    gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(colorLines), gl.STATIC_DRAW);

    gl.bindBuffer(gl.ARRAY_BUFFER, null);
    bufferColor.vertexSize = 3
    bufferColor.numVertices = 36

    bufferLines.vertexSize = 3;
    bufferLines.numVertices = 6;

    bufferLColor.vertexSize = 3;
    bufferLColor.numVertices = 6;

    buffer.vertexSize = 3;
    buffer.numVertices = 36;
}

var time=0;

function draw() {
    requestAnimationFrame(draw);

    gl.enable(gl.DEPTH_TEST);
    gl.clearColor(0.0,0.0,1.0,0.5);
    gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);

    mat4.perspective(projMatrix, Math.PI/4, 1, 0.1, 100)

    var view = mat4.create();
    mat4.identity(view);
    mat4.lookAt(view, [tx, -1, tz], [0, 0, -7], [rot[0], 1+rot[1], 0]);
    // mat4.translate(view, view, [tx,-1,tz]);
    // mat4.rotateX(view, view, rot[0]);
    // mat4.rotateY(view, view, rot[1]);
    gl.uniformMatrix4fv(uPerspective,false, projMatrix)
    gl.uniformMatrix4fv(uView, false, view);
    drawCube();
    drawLines();
    gl.bindBuffer(gl.ARRAY_BUFFER, null);

    time += 0.01;
}

function drawCube() {
    mat4.identity(modelMatrix);
    mat4.translate(modelMatrix, modelMatrix, [0,0,-7]);
    mat4.rotateY(modelMatrix, modelMatrix, time);
    mat4.rotateX(modelMatrix, modelMatrix, time);


    gl.uniformMatrix4fv(uModel, false, modelMatrix);

    gl.bindBuffer(gl.ARRAY_BUFFER, buffer);
    gl.vertexAttribPointer(attribPos, buffer.vertexSize, gl.FLOAT, false, 0, 0);
    gl.enableVertexAttribArray(attribPos);
    gl.bindBuffer(gl.ARRAY_BUFFER, bufferColor);
    gl.vertexAttribPointer(attribColor, bufferColor.vertexSize, gl.FLOAT, false, 0, 0);
    gl.enableVertexAttribArray(attribColor);

    gl.drawArrays(gl.TRIANGLES, 0, buffer.numVertices);
    //gl.bindBuffer(gl.ARRAY_BUFFER, null);
}

function drawLines() {
    mat4.identity(modelMatrix);
    mat4.translate(modelMatrix, modelMatrix, [0,0,-7]);
    gl.uniformMatrix4fv(uModel, false, modelMatrix);
    gl.bindBuffer(gl.ARRAY_BUFFER, bufferLines);
    gl.vertexAttribPointer(attribPos, bufferLines.vertexSize, gl.FLOAT, false, 0, 0);
    gl.enableVertexAttribArray(attribPos);
    gl.bindBuffer(gl.ARRAY_BUFFER, bufferLColor);
    gl.vertexAttribPointer(attribColor, bufferLColor.vertexSize, gl.FLOAT, false, 0, 0);
    gl.enableVertexAttribArray(attribColor);

    gl.drawArrays(gl.LINES, 0, bufferLines.numVertices);

}

function initEvents() {
    document.onkeydown = function(e) {
        var k = e.keyCode;
        if(k == 37) // left
            tx -= 0.1;
        if(k == 38) // up
            tz += 0.1;
        if(k == 39) // right
            tx += 0.1;
        if(k == 40) // down
            tz -= 0.1;
        if(k == 107) // +
            scale += 0.2;
        if(k == 109) // -
            scale -= 0.2;
    }

    canvas.onmousedown = function(e) {
        var x = e.clientX * 2.0 / canvas.width - 1.0;
        var y = -(e.clientY * 2.0 / canvas.height - 1.0);
        coordBefore = [x,y];
    }

    canvas.onmouseup = function(e) {
        var x = e.clientX * 2.0 / canvas.width - 1.0;
        var y = -(e.clientY * 2.0 / canvas.height - 1.0);

        var rotX = y - coordBefore[1];
        var rotY = x - coordBefore[0];

        rot = [rot[0]+rotX, rot[1]+rotY];
    }
}

function main() {
    canvas = document.getElementById('dawin-webgl');
    gl = canvas.getContext('webgl');
    if (!gl) {
        console.log('ERREUR : Echec du chargement du contexte !');
        return;
    }

    initShaders();
    initBuffers();
    initEvents();
    draw();
}
