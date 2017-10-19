var renderer;
var scene;
var camera;
var cube;
var mouseX = 0, mouseY = 0;
var target;

var earth, sun;
var controls;

function main() {
    //document.addEventListener( 'mousemove', onDocumentMouseMove, false );
    scene = new THREE.Scene();

    camera = new THREE.PerspectiveCamera(60, 1, 0.1, 10000);


    controls = new THREE.OrbitControls( camera );
    var geoscene = new THREE.CubeTextureLoader()
        .setPath( 'textures/' )
        .load( [ 'solar.png', 'solar.png', 'solar.png', 'solar.png', 'solar.png', 'solar.png' ], function(texture) {
            texture.magFilter = THREE.LinearFilter;
            texture.minFilter = THREE.LinearFilter;
        });
    //var material = new THREE.MeshDepthMaterial
    var light = new THREE.PointLight({color : new THREE.Color( 1.0,1.0,0.0) });
    var geometry = new THREE.SphereGeometry(50,32,32);
    var texture = new THREE.TextureLoader().load("textures/sunmap.jpg");
    var material = new THREE.MeshBasicMaterial({map: texture});
    sun = new THREE.Mesh(geometry, material);

    var geometryEarth = new THREE.SphereGeometry(10, 32, 32);

    var textureEarth = new THREE.TextureLoader().load("textures/earthmap.jpg", function ( texture ) {
        texture.magFilter = THREE.LinearFilter;
        texture.minFilter = THREE.LinearFilter;
        texture.mapping = THREE.CubeReflectionMapping;
        materialEarth.needsUpdate = true;
    } );
    var materialEarth = new THREE.MeshPhongMaterial({map : textureEarth});
    earth = new THREE.Mesh(geometryEarth, materialEarth);
    earth.position.x -= 200;

    var geometryOrbit = new THREE.RingGeometry(198, 200, 64, 64, Math.PI/2);
    var materialOrbit =  new THREE.MeshBasicMaterial( {color : new THREE.Color(1.0,1.0,1.0)} );
    var orbit = new THREE.Mesh(geometryOrbit, materialOrbit);
    orbit.rotation.x = -Math.PI/2.;

    sun.add(earth);
    scene.add(sun);
    scene.add(light);
    scene.add(orbit);

    camera.position.z = 500;
    renderer = new THREE.WebGLRenderer();
    renderer.setSize(800, 800);
    renderer.setClearColor(new THREE.Color(0.0,0.0,0.0),1.0);
    renderer.clear();
    scene.background = geoscene;

    document.body.appendChild( renderer.domElement );

    render();
}

function render() {
    requestAnimationFrame( render );
    // var tmp = ( mouseX - camera.position.x ) ;
    // console.log(tmp);
    // camera.position.x += tmp;
    // camera.position.y += ( - mouseY - camera.position.y ) ;
    // //console.log(camera.position.x + " " + camera.position.y);
    earth.rotation.y += 0.01;
    earth.rotation.z = -0.5;
    sun.rotation.y += 0.01;
    camera.lookAt( scene.position );
    renderer.render( scene, camera );
}
