import Experience from "./Experience.js";
import Gradient from "./Gradient.js";
import Smoke from "./Smoke.js";
import Particles from "./Particles.js";
import Vignette from "./Vignette.js";
import Ripple from "./Ripple.js";
import ExplodingParticles from "./explodingParticles.js";
import ThreeJourney35 from "./threeJourney35.js";
import Godray from "./Godray.js";
import Spikes from "./Spikes.js";
import SimpleRaymarching from "./SimpleRaymarching.js";
import * as THREE from "three";

export default class World {
  constructor(_options) {
    this.experience = new Experience();
    this.config = this.experience.config;
    this.scene = this.experience.scene;
    this.resources = this.experience.resources;

    this.resources.on("groupEnd", (_group) => {
      if (_group.name === "base") {
        // this.setDummy();
        // this.setThreeJourney35();
        // this.setGodray();
        // this.setSpikes();
        this.setSimpleRaymarching();
        // this.setVignette();
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

  setThreeJourney35() {
    this.threeJourney35 = new ThreeJourney35();
  }

  setGodray() {
    this.godray = new Godray();
  }

  setSpikes() {
    this.spikes = new Spikes();
  }

  setSimpleRaymarching() {
    this.simpleRaymarching = new SimpleRaymarching();
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
    if (this.threeJourney35) {
      this.threeJourney35.update();
    }
    if (this.spikes) {
      this.spikes.update();
    }
    if (this.simpleRaymarching) {
      this.simpleRaymarching.update();
    }
  }

  destroy() {}
}
