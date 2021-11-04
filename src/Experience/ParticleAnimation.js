import * as THREE from "three";
import Experience from "./Experience";
import vertexShader from "./shaders/particleAnimation/vertex.glsl";
import fragmentShader from "./shaders/particleAnimation/fragment.glsl";
import gsap from "gsap";

export default class ParticleAnimation {
  constructor() {
    this.experience = new Experience();
    this.resources = this.experience.resources;
    this.scene = this.experience.scene;
    this.time = this.experience.time;
    this.debug = this.experience.debug;

    this.setGeometry();
    this.setMaterial();
    this.setMesh();

    if (this.debug) {
      this.debugFolder = this.debug.addFolder({
        title: "ParticleAnimation",
      });
    }
  }

  setGeometry() {
    this.geometry = new THREE.BufferGeometry();
    this.count = 400;
    const positionArray = new Float32Array(this.count * this.count * 3);
    // for (let i = 0; i < this.count; i++) {
    //   positionArray[i] = Math.random();
    //   positionArray[i * 3 + 1] = Math.random();
    //   positionArray[i * 3 + 2] = Math.random();
    // }
    for (let i = 0; i < this.count; i++) {
      for (let j = 0; j < this.count; j++) {
        const index = 3 * (i * this.count + j);

        // egg equation
        let u = Math.random() * Math.PI * 2;
        let v = Math.random() * Math.PI;
        let x = Math.cos(u) * Math.sin(v) * (0.2 * v + 0.9);
        let y = Math.cos(v) * 1.5;
        let z = Math.sin(u) * Math.sin(v) * (0.2 * v + 0.9);
        positionArray[index] = x;
        positionArray[index + 1] = y;
        positionArray[index + 2] = z;
        //
        // egg equation mod
        // let u = Math.random() * Math.PI * 2;
        // let v = Math.random() * Math.PI * 2;
        // let x = Math.cos(u) * Math.cos(v) * (0.2 * v + 0.9);
        // let y = Math.cos(v) * 3.5;
        // let z = Math.sin(u) * Math.cos(v) * (0.2 * v + 0.9);
        // positionArray[index] = x;
        // positionArray[index + 1] = y;
        // positionArray[index + 2] = z;
        //

        // positionArray[index] = (i / this.count - 0.5) * 20;
        // positionArray[index + 1] = (j / this.count - 0.5) * 20;
        // positionArray[index + 2] = 0;
      }
    }
    this.geometry.setAttribute(
      "position",
      new THREE.BufferAttribute(positionArray, 3)
    );
  }
  setMaterial() {
    this.material = new THREE.ShaderMaterial({
      vertexShader,
      fragmentShader,
      transparent: true,
      depthWrite: false,
      depthTest: false,
      blending: THREE.AdditiveBlending,
      uniforms: {
        uTime: { value: 0 },
        uSpeed: { value: 0 },
      },
    });
    if (this.debug) {
      this.debug.addInput(this.material.uniforms.uSpeed, "value", {
        label: "speed",
        min: 0,
        max: 1,
        step: 0.01,
      });
    }
  }
  setMesh() {
    this.mesh = new THREE.Points(this.geometry, this.material);
    this.scene.add(this.mesh);
    gsap.to(this.material.uniforms.uSpeed, {
      duration: 30,
      value: 8.1,
      delay: 15,
    });
  }
  update() {
    if (this.material) {
      this.material.uniforms.uTime.value = this.time.elapsed * 0.001;
    }
  }
}
