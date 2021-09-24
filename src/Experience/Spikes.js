import * as THREE from "three";
import Experience from "./Experience";
import vertexShader from "./shaders/spikes/vertex.glsl";
import fragmentShader from "./shaders/spikes/fragment.glsl";

export default class Spikes {
  constructor() {
    this.experience = new Experience();
    this.resources = this.experience.resources;
    this.renderer = this.experience.renderer;
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
    this.renderer.instance.setClearColor(0x555555);
  }

  setGeometry() {
    // this.geometry = new THREE.SphereGeometry(1, 96, 96);
    this.geometry = new THREE.IcosahedronGeometry(1, 300);
  }

  setMaterial() {
    this.speed = 0.15;
    this.density = 3.2;
    this.strength = 1.37;
    this.frequency = 20;
    this.amplitude = 19.2;
    this.material = new THREE.ShaderMaterial({
      // wireframe: true,
      side: THREE.DoubleSide,
      vertexShader,
      fragmentShader,
      uniforms: {
        uTime: { value: 0 },
        uSpeed: { value: this.speed },
        uNoiseDensity: { value: this.density },
        uNoiseStrength: { value: this.strength },
        uFrequency: { value: this.frequency },
        uAmplitude: { value: this.frequency },
      },
    });
    if (this.debug) {
      this.debugFolder.addInput(this.material.uniforms.uSpeed, "value", {
        label: "uSpeed",
        min: 0,
        max: 0.4,
        step: 0.001,
      });
      this.debugFolder.addInput(this.material.uniforms.uNoiseDensity, "value", {
        label: "uNoiseDensity",
        min: 0,
        max: 5,
        step: 0.001,
      });
      this.debugFolder.addInput(
        this.material.uniforms.uNoiseStrength,
        "value",
        {
          label: "uNoiseStrength",
          min: 0,
          max: 6,
          step: 0.001,
        }
      );
      this.debugFolder.addInput(this.material.uniforms.uFrequency, "value", {
        label: "uFrequency",
        min: 0,
        max: 40,
        step: 0.001,
      });
      this.debugFolder.addInput(this.material.uniforms.uAmplitude, "value", {
        label: "uAmplitude",
        min: 0,
        max: 30,
        step: 0.001,
      });
    }
  }
  setMesh() {
    this.mesh = new THREE.Mesh(this.geometry, this.material);
    this.scene.add(this.mesh);
  }
  update() {
    this.material.uniforms.uTime.value = this.time.elapsed;
    // this.mesh.rotation.set(
    //   this.time.elapsed * 0.0005,
    //   this.time.elapsed * 0.00005,
    //   0
    // );
  }
}
