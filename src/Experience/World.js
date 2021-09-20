import Experience from "./Experience.js";
import Gradient from "./Gradient.js";
import Smoke from "./Smoke.js";
import Particles from "./Particles.js";
import Vignette from "./Vignette.js";
import Ripple from "./Ripple.js";
import ExplodingParticles from "./explodingParticles.js";
import * as THREE from "three";

export default class World {
  constructor(_options) {
    this.experience = new Experience();
    this.config = this.experience.config;
    this.scene = this.experience.scene;
    this.resources = this.experience.resources;

    this.resources.on("groupEnd", (_group) => {
      if (_group.name === "base") {
        // this.setGradient();
        // this.setSmoke();
        // this.setVignette();
        // this.setParticles();
        // this.setRipple();
        this.setExplodingParticles();
        // this.setDummy();
      }
    });
  }

  setDummy() {
    const cube = new THREE.Mesh(
      new THREE.BoxGeometry(1, 1, 1),
      new THREE.MeshBasicMaterial({
        map: this.resources.items.lennaTexture,
        depthWrite: false,
        depthTest: false,
      })
    );
    this.scene.add(cube);
  }

  setGradient() {
    this.gradient = new Gradient();
  }

  setSmoke() {
    this.smoke = new Smoke();
  }

  setParticles() {
    this.particles = new Particles();
  }

  setRipple() {
    this.ripple = new Ripple();
  }

  setVignette() {
    this.vignette = new Vignette();
  }

  setExplodingParticles() {
    this.explodingParticles = new ExplodingParticles();
  }

  resize() {
    if (this.smoke) {
      this.smoke.resize();
    }
  }

  update() {
    if (this.gradient) {
      this.gradient.update();
    }
    if (this.smoke) {
      this.smoke.update();
    }
    if (this.particles) {
      this.particles.update();
    }
    if (this.ripple) {
      this.ripple.update();
    }
    if (this.explodingParticles) {
      this.explodingParticles.update();
    }
  }

  destroy() {}
}
