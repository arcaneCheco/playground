import * as THREE from "three";
import Experience from "./Experience";
import vertexShader from "./shaders/play7/vertex.glsl";
import fragmentShader from "./shaders/play7/fragment.glsl";

export default class Play7 {
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
        title: "Play",
      });
    }

    this.setGeometry();
    this.setMaterial();
    this.setMesh();
    this.setMouse();
  }

  setGeometry() {
    this.geometry = new THREE.PlaneGeometry(1, 1, 1, 1);
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
        uMouse: { value: new THREE.Vector2() },
      },
    });
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
