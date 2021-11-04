import * as THREE from "three";
import Experience from "./Experience";
import vertexShader from "./shaders/play2/vertex.glsl";
import fragmentShader from "./shaders/play2/fragment.glsl";

export default class Play2 {
  constructor() {
    this.experience = new Experience();
    this.resources = this.experience.resources;
    this.scene = this.experience.scene;
    this.time = this.experience.time;
    this.debug = this.experience.debug;
    this.renderer = this.experience.renderer.instance;

    this.renderer.setClearColor(0x888888);

    this.setGeometry();
    this.setMaterial();
    this.setMesh();
    this.setMouse();
    // this.setLights();

    if (this.debug) {
      this.debugFolder = this.debug.addFolder({
        title: "Play2",
      });
    }
  }

  setGeometry() {
    // this.geometry = new THREE.PlaneGeometry(2, 2, 2, 2);
    this.geometry = new THREE.SphereGeometry(2, 40, 40);
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
        uTexture: { value: this.resources.items.matcap1 },
        uMouse: { vaalue: new THREE.Vector2() },
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
      this.material.uniforms.uTime.value = this.time.elapsed * 0.0001;
      this.material.uniforms.uMouse.value = this.mouse;
    }
  }
}
