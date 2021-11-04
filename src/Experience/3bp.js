import * as THREE from "three";
import Experience from "./Experience";
import { GLTFExporter } from "three/examples/jsm/exporters/GLTFExporter";
import manFont from "../manifold.json";

export default class ThreeBP {
  constructor() {
    this.experience = new Experience();
    this.resources = this.experience.resources;
    this.scene = this.experience.scene;
    this.time = this.experience.time;
    this.debug = this.experience.debug;

    this.setGeometry();
    this.setMaterial();
    this.setMesh();
    this.setModel();
    this.setText();
  }

  setGeometry() {}
  setMaterial() {}
  setMesh() {}
  setModel() {
    this.light = new THREE.AmbientLight();
    this.scene.add(this.light);
    this.model = this.resources.items.dna;
    // console.log(this.model);
    this.meshes =
      this.model.scene.children[0].children[0].children[0].children[0].children;
    // console.log(this.meshes);
    this.outer = this.meshes[0];
    this.inner = this.meshes[1];
    console.log(this.outer);
    console.log(this.inner);
    this.inner2 = this.inner.children[0];
    this.inner2.scale.set(0.5, 0.5, 0.5);
    this.inner2.material = new THREE.MeshBasicMaterial({ color: 0xe7b36b });
    this.inner2.name = "outer";
    // this.scene.add(this.inner2); //this is actually outer
    this.outer2 = this.outer.children[0];
    // this.outer2.position.y = -2.5;
    this.outer2.scale.set(
      0.4000000059604645,
      0.025000005960464478,
      0.050000011920928955
    );
    this.outer2.material = new THREE.MeshBasicMaterial({ color: 0xe7e7e7 });
    this.outer2.name = "inner";
    // this.scene.add(this.outer2); //this is actually inner
    this.group = new THREE.Group();
    this.group.add(this.inner2);
    this.group.add(this.outer2);
    // this.scene.add(this.group);
    console.log(this.group);

    const link = document.createElement("a");
    link.style.display = "none";
    document.body.appendChild(link); // Firefox workaround, see #6594

    // Instantiate a exporter
    const exporter = new GLTFExporter();

    // Parse the input and generate the glTF output
    exporter.parse(this.group, function (gltf) {
      //   console.log(gltf);
      //   downloadJSON(gltf);
      const output = JSON.stringify(gltf, null, 2);
      saveString(output, "scene.gltf");
    });

    function saveString(text, filename) {
      save(new Blob([text], { type: "text/plain" }), filename);
    }

    function save(blob, filename) {
      link.href = URL.createObjectURL(blob);
      link.download = filename;
      //   link.click();

      // URL.revokeObjectURL( url ); breaks Firefox...
    }

    this.dna2 = this.resources.items.dna2;
    console.log(this.dna2);
    this.scene.add(this.dna2.scene);

    // this.outer3 = this.outer.children[1];
    // this.outer3.material = new THREE.MeshBasicMaterial();
    // this.scene.add(this.outer3);
  }
  setText() {
    const loader = new THREE.FontLoader();

    // loader.load(manFont, function (font) {
    this.geometry = new THREE.TextGeometry("Hello three.js!", {
      font: manFont,
      size: 80,
      height: 5,
      curveSegments: 12,
      bevelEnabled: true,
      bevelThickness: 10,
      bevelSize: 8,
      bevelOffset: 0,
      bevelSegments: 5,
    });
    this.material = new THREE.MeshBasicMaterial();
    this.mesh = new THREE.Mesh(this.geometry, this.material);
    this.scene.add(this.mesh);
    // });
  }
  update() {
    // if (this.material) {
    //   this.material.uniforms.uTime.value = this.time.elapsed * 0.001;
    // }
  }
}
