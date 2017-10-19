attribute vec4 position;
attribute vec4 color;
varying vec4 vColor;


//Transformation
uniform float translation;
uniform float angle;

void main() {
     vColor = color;
     float x = position[0];
     float y = position[1];
     float xRotated = x * cos(angle) - y * sin(angle);
     float yRotated = y * cos(angle) + x * sin(angle);
     float xTranslated = xRotated + translation;
     gl_Position = vec4(xTranslated, yRotated, 0.0, 1.0);
}