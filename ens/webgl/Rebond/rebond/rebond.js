// Variables globales
var renderer;
var scene;
var camera;
var controls;
var meshSphere;
var radius = 10;
var altitudeMax = 100;
var t = 0; // materialisation du temps
var g = 9.8; // pesanteur
var n = 0; // nombre de rebonds
var pasDeTemps = 0.1;


function main() {
    scene = new THREE.Scene();
    camera = new THREE.PerspectiveCamera(60, 1, 0.1, 10000);

    //Permet de zoomer, tourner la camera avec la souris
    controls = new THREE.OrbitControls( camera );

    // TODO Partie 1
    // Creation de la sphere, couleur rouge
    // Creation du sol, couleur verte

    // TODO Partie 3
    // Modelisation d'un sol plus realiste par l'utilisation de texture
    // Ajout de la lumiere + ombres sur les objets de la scène

    camera.position.z = 200;
    renderer = new THREE.WebGLRenderer();

    renderer.setSize(800, 800);
    renderer.setClearColor(0xcce0ff);
    renderer.clear();
    document.body.appendChild( renderer.domElement );

    render();
}


function chuteLibre(temps, altitude) {
    // TODO
    // Modelisation de la chute libre de la balle
    // NB : on ne prend pas en compte les frottements de l'air
    // Params : temps = temps actuel
    //          altitude = altitude initiale
}

function rebondBalle(temps, number) {
    // TODO
    // Modelisation du rebond de la balle
    // Params: temps = temps actuel
    //         number = nombre de rebonds que la balle a deja effectue
}

function deformation(temps, number) {
    // TODO
    // Modelisation de la deformation de la balle
    // au moment du rebond
    // Params : temps = temps actuel
    //          number = nombre de rebonds que la balle a deja effectue
    // NB : il est possible de changer la signature de la fonction
}

function animationRebond() {
    // TODO
    // Fonction permettant de changer la position de la sphere
    // au cours du temps
    // Gestion des appels aux fonctions rebondBalle(), chuteLibre()
    // et deformation()
    // en fonction de la position de la sphere

    t+= pasDeTemps;
}

function render() {
    requestAnimationFrame( render );
    animationRebond();
    renderer.render( scene, camera );
}
