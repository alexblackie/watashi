import React from "react";
import Layout from "../components/layout";
import Container from "../components/container";
import Hero from "../components/hero";
import ProjectCard from "../components/projectCard";

import projectStyles from "../styles/projects.module.css";

export default () => (
  <Layout>
    <Hero lead="Projects" compressed>
      <p>
        I am always finding new ways to exhaust my spare time. While most projects never get farther than my laptop, some make their way to the Internet. These are they.
      </p>
    </Hero>

    <Container>

      <h2 className={ projectStyles.sectionTitle }>Web Properties</h2>

      <div className={ projectStyles.cardContainer }>
        <ProjectCard name="junk dot pics" url="junk.pics">
          What started as a shared folder on the local school network, served from my laptop eventually gained a web presence. Now known as "junk dot pics", this website is a repository of random images I find on the internet.
        </ProjectCard>

        <ProjectCard name="Deploy a Website" url="deployawebsite.com">
          I think about how to get code onto servers quite a bit. It’s an ongoing problem in the web tech industry where there is no simple step between "shitty shared hosting" and "Kubernetes". This website aims to be a collection of tutorials and documentation walking you through various ways of deploy websites to the Internet.
        </ProjectCard>
      </div>

      <h2 className={ projectStyles.sectionTitle }>Software</h2>

      <div className={ projectStyles.cardContainer }>
        <ProjectCard name="roadwarrior-gateway" url="github.com/blackieops/roadwarrior-gateway">
          Networks are not to be trusted these days, and a VPN is one way to have a modicum of privacy on a network you don't control. Unfortunately, VPN providers are often sketchy or slimy, or in geographic areas you don't like. This is an Ansible playbook to deploy a tunnelling OpenVPN server on a machine you control.
        </ProjectCard>

        <ProjectCard name="deploy-app" url="github.com/blackieops/deploy-app">
          Deploying software to servers can be annoying or difficult. Sometimes all you need is a tiny bit of glue to handle versioning, rollouts, and daemon restarts. <code>deploy-app</code> aims to solve just that. The anti-Kubernetes, it focuses on small-scale deployments where you just need something basic.
        </ProjectCard>

        <ProjectCard name="NoTube" url="github.com/alexblackie/notube">
          Tired of the ever-degrading Youtube web experience, I set out to build my own web UI based around the powers of the wonderful <code>youtube-dl</code>. With some help from some friends, we got it working. It’s a bit clunky, but still somehow better than youtube.com.
        </ProjectCard>
        </div>

      <h2 className={ projectStyles.sectionTitle }>Clients &amp; Friends</h2>

      <div className={ projectStyles.cardContainer }>
        <ProjectCard name="Cultivating Local Yokals Society" url="localyokals.ca">
          Since 2009, I have been the volunteer webmaster for the Cultivating Local Yokals Society, a non-profit organization based just outside of Victoria, BC, Canada. They do some great work helping those with brain injuries and disabilities, and I’ve loved being able to apply my knowledge to help out.
        </ProjectCard>
      </div>

    </Container>
  </Layout>
);