import * as THREE from "three";
import Experience from "./Experience";
import vertexShader from "./shaders/explodingParticles/vertex.glsl";
import vertexParticlesShader from "./shaders/explodingParticles/vertexParticles.glsl";
import fragmentShader from "./shaders/explodingParticles/fragment.glsl";
import { UnrealBloomPass } from "three/examples/jsm/postprocessing/UnrealBloomPass";
import gsap from "gsap";

export default class ExplodingParticles {
  constructor() {
    this.experience = new Experience();
    this.resources = this.experience.resources;
    this.scene = this.experience.scene;
    this.renderer = this.experience.renderer;
    this.camera = this.experience.camera;
    this.time = this.experience.time;
    this.debug = this.experience.debug;

    this.renderer.instance.setClearColor(0x11111, 1);

    this.distortionAmplitude = 0;
    this.bloomStrength = 0;

    if (this.debug) {
      this.debugFolder = this.debug.addFolder({
        title: "particleNoise",
      });

      this.debugFolder.addInput(
        this.camera.modes.debug.instance.position,
        "z",
        {
          label: "cameraOffset",
          min: 275,
          max: 1600,
          step: 1,
        }
      );
    }
    // this.setCamera();
    this.setGeometry();
    this.setMaterial();
    this.setPoints();
    this.setBloom();
    this.setAnimation();
  }

  setGeometry() {
    this.geometry = new THREE.PlaneGeometry(600, 397, 600, 397);
  }
  setMaterial() {
    this.material = new THREE.ShaderMaterial({
      vertexShader: vertexParticlesShader,
      fragmentShader,
      uniforms: {
        uTime: { value: 0 },
        uTexture: { value: this.resources.items.owlTexture },
        uDistortionMultiplier: { value: 0 },
        uDistortionWidth: { value: 2 },
        uDistortionHeight: { value: 1.4 },
        uDistortionDepth: { value: 50 },
        uNoiseX: { value: 0.002 },
        uNoiseY: { value: 0.008 },
        uFrequency: { value: 0.001 },
      },
    });

    if (this.debug) {
      this.debugFolder.addInput(
        this.material.uniforms.uDistortionMultiplier,
        "value",
        {
          label: "uDistortionMultiplier",
          min: 0,
          max: 3,
          step: 0.01,
        }
      );
      this.debugFolder.addInput(
        this.material.uniforms.uDistortionWidth,
        "value",
        {
          label: "uDistortionWidth",
          min: 0,
          max: 3,
          step: 0.01,
        }
      );
      this.debugFolder.addInput(
        this.material.uniforms.uDistortionHeight,
        "value",
        {
          label: "uDistortionHeight",
          min: 0,
          max: 3,
          step: 0.01,
        }
      );
      this.debugFolder.addInput(
        this.material.uniforms.uDistortionDepth,
        "value",
        {
          label: "uDistortionDepth",
          min: 0,
          max: 200,
          step: 0.01,
        }
      );
      this.debugFolder.addInput(this.material.uniforms.uNoiseX, "value", {
        label: "uNoiseX",
        min: 0,
        max: 0.02,
        step: 0.001,
      });
      this.debugFolder.addInput(this.material.uniforms.uNoiseY, "value", {
        label: "uNoiseY",
        min: 0,
        max: 0.025,
        step: 0.001,
      });
      this.debugFolder.addInput(this.material.uniforms.uFrequency, "value", {
        label: "uFrequency",
        min: 0,
        max: 0.009,
        step: 0.0001,
      });
    }
  }

  setPoints() {
    this.points = new THREE.Points(this.geometry, this.material);
    this.scene.add(this.points);
  }

  setBloom() {
    this.renderer.usePostprocess = true;
    this.unrealBloomPass = new UnrealBloomPass();
    // this.unrealBloomPass.resolution = new THREE.Vector2(window.innerWidth, window.innerHeight);
    this.unrealBloomPass.strength = this.bloomStrength;
    // this.unrealBloomPass.radius = 0;
    // this.unrealBloomPass.threshold = 0.85;
    this.renderer.postProcess.composer.addPass(this.unrealBloomPass);

    if (this.debug) {
      this.debugFolder.addInput(this, "bloomStrength", {
        label: "bloomStrength",
        min: 0,
        max: 1,
        step: 0.01,
      });
    }
  }

  setAnimation() {
    gsap.to(this.camera.modes.debug.instance.position, {
      delay: 1,
      duration: 3.5,
      z: 1600,
      ease: "power2.inout",
    });
    gsap.to(this.material.uniforms.uDistortionMultiplier, {
      delay: 1,
      duration: 3.5,
      value: 3,
      ease: "power2.inout",
    });
    gsap.to(this, {
      delay: 1,
      duration: 3.5,
      bloomStrength: 0.6,
      ease: "power2.inout",
    });
    gsap.to(this.camera.modes.debug.instance.position, {
      delay: 6,
      duration: 2,
      z: 275,
      ease: "power2.inout",
    });
    gsap.to(this.material.uniforms.uDistortionMultiplier, {
      delay: 6,
      duration: 2,
      value: 0.0001,
      ease: "power2.inout",
    });
    gsap.to(this, {
      delay: 6,
      duration: 2,
      bloomStrength: 0,
      ease: "power2.inout",
    });
  }

  update() {
    this.material.uniforms.uTime.value = this.time.elapsed;
    if (this.unrealBloomPass) {
      this.unrealBloomPass.strength = this.bloomStrength;
    }
  }
}
