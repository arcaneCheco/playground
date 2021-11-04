import * as THREE from "three";
import Experience from "./Experience";
import vertexShader from "./shaders/play1/vertex.glsl";
import fragmentShader from "./shaders/play1/fragment.glsl";

export default class Play1 {
  constructor() {
    this.experience = new Experience();
    this.resources = this.experience.resources;
    this.scene = this.experience.scene;
    this.time = this.experience.time;
    this.debug = this.experience.debug;

    this.setGeometry();
    this.setMaterial();
    this.setMesh();
    // this.setLights();

    if (this.debug) {
      this.debugFolder = this.debug.addFolder({
        title: "Play1",
      });
    }
  }

  setGeometry() {
    this.geometry = new THREE.BoxGeometry(1, 1, 1, 50, 50, 50);
    // this.geometry = new THREE.SphereGeometry(1, 50, 50);
  }
  setMaterial() {
    this.material = new THREE.ShaderMaterial({
      vertexShader,
      fragmentShader,
      transparent: true,
      depthWrite: false,
      depthTest: false,
      uniforms: {
        uTime: { value: 0 },
        uTexture: { value: this.resources.items.lennaTexture },
      },
    });
  }
  setMesh() {
    this.mesh = new THREE.Mesh(this.geometry, this.material);
    this.scene.add(this.mesh);
  }
  setLights() {
    const ambientLight = new THREE.AmbientLight();
    this.scene.add(ambientLight);
  }
  //   setGlowSphere() {
  //       this.glowG = new THREE.Sp
  //   }
  update() {
    if (this.material) {
      this.material.uniforms.uTime.value = this.time.elapsed * 0.0001;
    }
  }
}
