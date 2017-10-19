void main() {
     gl_FragColor = vec4(gl_FragCoord.x/800.0, 0.0, (800.0 - gl_FragCoord.x)/800.0,1.0);
}