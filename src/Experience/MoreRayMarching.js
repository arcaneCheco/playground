import * as THREE from "three";
import Experience from "./Experience";
import vertexShader from "./shaders/moreRaymarching/vertex.glsl";
import fragmentShader from "./shaders/moreRaymarching/fragment.glsl";

export default class MoreRaymarching {
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
  }

  setGeometry() {
    this.geometry = new THREE.PlaneGeometry(2, 2, 1, 1);
  }
  setMaterial() {
    this.material = new THREE.ShaderMaterial({
      side: THREE.DoubleSide,
      vertexShader,
      fragmentShader,
      //   uniforms: {
      //     uTime: { value: 0 },
      //     uMatcap: { value: this.resources.items.matcap1 },
      //     uMouse: { value: new THREE.Vector2(0, 0) },
      //   },
    });
  }
  setMesh() {
    this.mesh = new THREE.Mesh(this.geometry, this.material);
    this.scene.add(this.mesh);
  }

  update() {
    // if (this.material) {
    //   this.material.uniforms.uTime.value = this.time.elapsed * 0.001;
    //   this.material.uniforms.uMouse.value = this.mouse;
    // }
  }
}
