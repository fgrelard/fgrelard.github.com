var renderer;
var scene;
var camera;
var cube;
var mouseX = 0, mouseY = 0;
var target;


function main() {

    scene = new THREE.Scene();

    var geoscene = new THREE.CubeTextureLoader()
        .setPath( 'textures/' )
        .load( [ 'px.jpg', 'nx.jpg', 'py.jpg', 'ny.jpg', 'pz.jpg', 'nz.jpg' ] );
    //var material = new THREE.MeshDepthMaterial
    scene.background = geoscene;
    camera = new THREE.PerspectiveCamera(60, 1, 0.1, 10000);
    renderer = new THREE.WebGLRenderer();
    renderer.setSize(1000, 1000);
    renderer.setClearColor(new THREE.Color(0.2,0.2,0.2),1.0);
    renderer.clear();
    document.body.appendChild( renderer.domElement );
    renderer.domElement.addEventListener( 'mousemove', onDocumentMouseMove, false );

    //scene.add(cube);

    camera.position.z = 2000;
    //camera.position.x = 0;


    render();
}

function render() {
    requestAnimationFrame( render );
    var tmp = ( mouseX - camera.position.x ) ;
    console.log(tmp);
    camera.position.x += tmp;
    camera.position.y += ( - mouseY - camera.position.y ) ;
    //console.log(camera.position.x + " " + camera.position.y);

    camera.lookAt( scene.position );
    renderer.render( scene, camera );
}


function onDocumentMouseMove( event ) {
    mouseX = ( event.clientX - 500 ) ;
    mouseY = ( event.clientY - 500 ) ;
}
