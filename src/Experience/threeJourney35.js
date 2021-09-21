import * as THREE from "three";
import Experience from "./Experience";
import fireflyVertexShader from "./shaders/threeJourney35/fireflies/vertex.glsl";
import fireflyFragmentShader from "./shaders/threeJourney35/fireflies/fragment.glsl";
import portalVertexShader from "./shaders/threeJourney35/portal/vertex.glsl";
import portalFragmentShader from "./shaders/threeJourney35/portal/fragment.glsl";

export default class ThreeJourney35 {
  constructor() {
    this.experience = new Experience();
    this.resources = this.experience.resources;
    this.scene = this.experience.scene;
    this.time = this.experience.time;
    this.debug = this.experience.debug;
    this.renderer = this.experience.renderer;

    this.renderer.instance.outputEncoding = THREE.sRGBEncoding;

    if (this.debug) {
      this.debugFolder = this.debug.addFolder({
        title: "ThreeJourney35",
      });
    }
    // this.setLights();
    this.setMaterial();
    this.setModel();
    this.setClearColor();
    this.setFireflyGeometry();
    this.setFireflyMaterial();
    this.setFireflies();
  }

  setLights() {
    const ambientLight = new THREE.AmbientLight({ intensity: 3 });
    this.scene.add(ambientLight);
  }

  setClearColor() {
    this.clearColor = "#201919";
    this.renderer.instance.setClearColor(this.clearColor);
    if (this.debug) {
      this.debugFolder
        .addInput(this, "clearColor", { view: "color" })
        .on("change", () => {
          this.renderer.instance.setClearColor(this.clearColor);
        });
    }
  }

  setGeometry() {
    this.geometry = new THREE.BoxGeometry(1, 1, 1);
  }
  setMaterial() {
    const texture = this.resources.items.uvTexture;
    texture.flipY = false;
    texture.encoding = THREE.sRGBEncoding;
    this.bakedMeshMaterial = new THREE.MeshBasicMaterial({
      map: texture,
      //   side: THREE.DoubleSide,
    });
    // this.material = new THREE.MeshStandardMaterial();
    this.poleLightMaterial = new THREE.MeshBasicMaterial({ color: 0xffffe5 });

    this.portalStartColor = "#000000";
    this.portalEndColor = "#ffffff";
    this.portalMaterial = new THREE.ShaderMaterial({
      vertexShader: portalVertexShader,
      fragmentShader: portalFragmentShader,
      uniforms: {
        uTime: { value: 0 },
        uStartColor: { value: new THREE.Color(this.portalStartColor) },
        uEndColor: { value: new THREE.Color(this.portalEndColor) },
      },
    });

    if (this.debug) {
      this.debugFolder
        .addInput(this, "portalStartColor", {
          view: "color",
          label: "portalInnerColor",
        })
        .on("change", () => {
          this.portalMaterial.uniforms.uStartColor.value.set(
            this.portalStartColor
          );
        });
      this.debugFolder
        .addInput(this, "portalEndColor", {
          view: "color",
          label: "portalOuterColor",
        })
        .on("change", () => {
          this.portalMaterial.uniforms.uEndColor.value.set(this.portalEndColor);
        });
    }
  }

  setMesh() {
    this.mesh = new THREE.Mesh(this.geometry, this.material);
    this.scene.add(this.mesh);
  }

  setModel() {
    this.model = this.resources.items.portal;
    const bakedMesh = this.model.scene.children.find(
      (child) => child.name === "baked"
    );
    bakedMesh.material = this.bakedMeshMaterial;
    const poleLightAmesh = this.model.scene.children.find(
      (child) => child.name === "poleLightA"
    );
    poleLightAmesh.material = this.poleLightMaterial;
    const poleLightBmesh = this.model.scene.children.find(
      (child) => child.name === "poleLightB"
    );
    poleLightBmesh.material = this.poleLightMaterial;
    const portalMesh = this.model.scene.children.find(
      (child) => child.name === "portalLight"
    );
    portalMesh.material = this.portalMaterial;
    this.scene.add(this.model.scene);
  }

  setFireflyGeometry() {
    this.fireflyGeometry = new THREE.BufferGeometry();
    this.firefliesCount = 30;
    const positionArray = new Float32Array(this.firefliesCount * 3);
    const scaleArray = new Float32Array(this.firefliesCount);
    for (let i = 0; i < this.firefliesCount; i++) {
      positionArray[i * 3] = (Math.random() - 0.5) * 4;
      positionArray[i * 3 + 1] = Math.random() * 1.5;
      positionArray[i * 3 + 2] = (Math.random() - 0.5) * 4;

      scaleArray[i] = Math.random();
    }
    this.fireflyGeometry.setAttribute(
      "position",
      new THREE.BufferAttribute(positionArray, 3)
    );
    this.fireflyGeometry.setAttribute(
      "aScale",
      new THREE.BufferAttribute(scaleArray, 1)
    );
  }

  setFireflyMaterial() {
    this.fireflyMaterial = new THREE.ShaderMaterial({
      transparent: true,
      blending: THREE.AdditiveBlending,
      depthWrite: false,
      vertexShader: fireflyVertexShader,
      fragmentShader: fireflyFragmentShader,
      uniforms: {
        uTime: { value: 0 },
        uPixelRatio: { value: this.renderer.instance.getPixelRatio() },
        uSize: { value: 80 },
      },
    });
    if (this.debug) {
      this.debugFolder.addInput(this.fireflyMaterial.uniforms.uSize, "value", {
        label: "firefliesSize",
        min: 0,
        max: 200,
        step: 1,
      });
    }
  }

  setFireflies() {
    this.fireflies = new THREE.Points(
      this.fireflyGeometry,
      this.fireflyMaterial
    );
    this.scene.add(this.fireflies);
  }

  update() {
    this.fireflyMaterial.uniforms.uTime.value = this.time.elapsed;
    this.portalMaterial.uniforms.uTime.value = this.time.elapsed;
  }
}
