import * as THREE from "three";
import Experience from "./Experience";
import vertexShader from "./shaders/spikes/vertex.glsl";
import fragmentShader from "./shaders/spikes/fragment.glsl";

export default class Spikes {
  constructor() {
    this.experience = new Experience();
    this.resources = this.experience.resources;
    this.scene = this.experience.scene;
    this.time = this.experience.time;
    this.debug = this.experience.debug;

    if (this.debug) {
      this.debugFolder = this.debug.addFolder({
        title: "Spikes",
      });
    }

    this.setGeometry();
    this.setMaterial();
    this.setMesh();
  }

  setGeometry() {
    // this.geometry = new THREE.SphereGeometry(1, 96, 96);
    this.geometry = new THREE.IcosahedronGeometry(1, 16);
  }

  setMaterial() {
    this.speed = 0.2;
    this.density = 1.5;
    this.strength = 0.2;
    this.material = new THREE.ShaderMaterial({
      wireframe: true,
      vertexShader,
      fragmentShader,
      uniforms: {
        uTime: { value: 0 },
        uSpeed: { value: this.speed },
        uNoiseDensity: { value: this.density },
        uNoiseStrength: { value: this.strength },
      },
    });
  }
  setMesh() {
    this.mesh = new THREE.Mesh(this.geometry, this.material);
    this.scene.add(this.mesh);
  }
  update() {
    this.material.uniforms.uTime.value = this.time.elapsed;
  }
}
