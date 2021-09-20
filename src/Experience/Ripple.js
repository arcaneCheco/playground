import * as THREE from "three";
import Experience from "./Experience";
import vertexShader from "./shaders/ripple/vertex.glsl";
import fragmentShader from "./shaders/ripple/fragment.glsl";
import gsap from "gsap";
export default class Ripple {
  constructor() {
    this.experience = new Experience();
    this.config = this.experience.config;
    this.resources = this.experience.resources;
    this.scene = this.experience.scene;
    this.time = this.experience.time;
    this.debug = this.experience.debug;

    if (this.debug) {
      this.debugFolder = this.debug.addFolder({
        title: "ripple",
      });
    }

    this.setGeometry();
    this.setMaterial();
    this.setMesh();
    window.addEventListener("keydown", () => {
      gsap.to(this.material.uniforms.uFrequency, { value: 70, duration: 0.5 });
      gsap.to(this.material.uniforms.uFrequency, {
        value: 0,
        duration: 5,
        delay: 0.5,
      });
    });
  }
  setGeometry() {
    this.geometry = new THREE.PlaneGeometry(2, 2, 128, 128);
  }
  setMaterial() {
    this.material = new THREE.ShaderMaterial({
      vertexShader,
      fragmentShader,
      uniforms: {
        uTime: { value: 0 },
        uTexture: { value: this.resources.items.lennaTexture },
        uResolution: {
          value: new THREE.Vector2(this.config.width, this.config.height),
        },
        uFrequency: { value: 2 },
        uSpeed: { value: 0.001 },
        uAmplitude: { value: 0.03 },
      },
    });

    if (this.debug) {
      this.debugFolder.addInput(this.material.uniforms.uFrequency, "value", {
        label: "uFrequency",
        min: 0,
        max: 60,
        step: 0.001,
      });
      this.debugFolder.addInput(this.material.uniforms.uSpeed, "value", {
        label: "uSpeed",
        min: 0,
        max: 0.025,
        step: 0.00001,
      });
      this.debugFolder.addInput(this.material.uniforms.uAmplitude, "value", {
        label: "uAmplitude",
        min: 0,
        max: 0.1,
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
  }
}
