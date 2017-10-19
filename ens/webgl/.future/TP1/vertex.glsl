attribute vec4 position;
void main() {
     gl_Position = position;
     gl_PointSize = (position[0] + 1.0) * 30.0;
}