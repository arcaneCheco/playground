import * as THREE from "three";
import Experience from "./Experience";
import vertexShader from "./shaders/play5/vertex.glsl";
import fragmentShader from "./shaders/play5/fragment.glsl";

export default class Play5 {
  constructor() {
    this.experience = new Experience();
    this.resources = this.experience.resources;
    this.scene = this.experience.scene;
    this.time = this.experience.time;
    this.debug = this.experience.debug;
    this.renderer = this.experience.renderer.instance;

    this.renderer.setClearColor(0x888888);

    if (this.debug) {
      this.debugFolder = this.debug.addFolder({
        title: "Play5",
      });
    }

    this.setGeometry();
    this.setMaterial();
    this.setMesh();
    this.setMouse();
    // this.setLights();
  }

  setGeometry() {
    this.geometry = new THREE.PlaneGeometry(1, 1, 1, 1);
    // this.geometry = new THREE.SphereGeometry(2, 40, 40);
    // this.geometry = new THREE.BoxGeometry(2, 2, 2);
  }
  setMaterial() {
    this.material = new THREE.ShaderMaterial({
      vertexShader,
      fragmentShader,
      transparent: true,
      depthWrite: false,
      depthTest: false,
      side: THREE.DoubleSide,
      uniforms: {
        uTime: { value: 0 },
        uTexture: { value: this.resources.items.owlTexture },
        uMouse: { value: new THREE.Vector2() },
        uSpeed: { value: 0.86 },
        uSpeed2: { value: 0.457 },
        uGrid: { value: 5 },
        uAmplitude: { value: 10 },
        uRadSmall: { value: 0.3 },
        uRadBig: { value: 1.05 },
        uRotation: { value: 0.125 },
        uMod: { value: 1.52 },
      },
    });
    if (this.debug) {
      this.debugFolder.addInput(this.material.uniforms.uSpeed, "value", {
        label: "uSpeed",
        min: 0,
        max: 10,
        step: 0.001,
      });
      this.debugFolder.addInput(this.material.uniforms.uSpeed2, "value", {
        label: "uSpeed2",
        min: 0,
        max: 2,
        step: 0.001,
      });
      this.debugFolder.addInput(this.material.uniforms.uGrid, "value", {
        label: "uGrid",
        min: 0,
        max: 20,
        step: 0.01,
      });
      this.debugFolder.addInput(this.material.uniforms.uAmplitude, "value", {
        label: "uAmplitude",
        min: 0,
        max: 20,
        step: 0.001,
      });
      this.debugFolder.addInput(this.material.uniforms.uRadSmall, "value", {
        label: "uRadSmall",
        min: 0,
        max: 0.6,
        step: 0.001,
      });
      this.debugFolder.addInput(this.material.uniforms.uRadBig, "value", {
        label: "uRadBig",
        min: 0.3,
        max: 1.5,
        step: 0.001,
      });
      this.debugFolder.addInput(this.material.uniforms.uRotation, "value", {
        label: "uRotation",
        min: 0,
        max: 1,
        step: 0.001,
      });
      this.debugFolder.addInput(this.material.uniforms.uMod, "value", {
        label: "uMod",
        min: 0,
        max: 4,
        step: 0.001,
      });
    }
  }
  setMesh() {
    this.mesh = new THREE.Mesh(this.geometry, this.material);
    this.scene.add(this.mesh);
  }
  setMouse() {
    this.mouse = new THREE.Vector2();
    window.addEventListener("mousemove", (e) => {
      this.mouse.x = (e.clientX / window.innerWidth) * 2 - 1;
      this.mouse.y = -(e.clientY / window.innerHeight) * 2 + 1;
    });
  }
  update() {
    if (this.material) {
      this.material.uniforms.uTime.value = this.time.elapsed * 0.001;
      this.material.uniforms.uMouse.value = this.mouse;
    }
  }
}
