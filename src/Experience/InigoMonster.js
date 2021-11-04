import * as THREE from "three";
import Experience from "./Experience";
import vertexShader from "./shaders/inigoMonster/vertex.glsl";
import fragmentShader from "./shaders/inigoMonster/fragment.glsl";

export default class InigoMonster {
  constructor() {
    this.experience = new Experience();
    this.resources = this.experience.resources;
    this.scene = this.experience.scene;
    this.time = this.experience.time;
    this.debug = this.experience.debug;
    this.renderer = this.experience.renderer.instance;
    this.renderer.setClearColor(0x333333);

    this.setGeometry();
    this.setMaterial();
    this.setMesh();
    this.setMouse();
  }

  setGeometry() {
    this.geometry = new THREE.PlaneGeometry(2, 2, 10, 10);
  }
  setMaterial() {
    this.material = new THREE.ShaderMaterial({
      side: THREE.DoubleSide,
      vertexShader,
      fragmentShader,
      uniforms: {
        uTime: { value: 0 },
        // uMatcap: { value: this.resources.items.matcap1 },
        uMouse: { value: new THREE.Vector2(0, 0) },
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
      this.mouse.y = (e.clientY / window.innerHeight) * 2 - 1;
    });
  }

  update() {
    if (this.material) {
      this.material.uniforms.uTime.value = this.time.elapsed * 0.001;
      this.material.uniforms.uMouse.value = this.mouse;
    }
  }
}
