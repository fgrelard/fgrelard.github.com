attribute vec3 vertex_position;
uniform mat4 PMatrix;
uniform mat4 MMatrix;
uniform mat4 VMatrix;
varying vec3 vColor;

attribute vec3 color;
void main() {
    gl_Position = PMatrix * VMatrix * MMatrix * vec4(vertex_position,  1.0);
    vColor = color;
}
