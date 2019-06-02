import React from "react";
import { Link } from "gatsby";

import heroStyles from "../styles/hero.module.css";
import Container from "../components/container";

let heroCta = (ctaLink, ctaText) => {
  return (<div className={heroStyles.cta}>
    <Link to={ctaLink}>{ctaText}</Link>
  </div>);
};

export default ({ children, lead, ctaText, ctaLink, compressed }) => {

  let containerStyles = [heroStyles.container];

  if (ctaText)
    containerStyles.push(heroStyles.withCta)

  if (compressed)
    containerStyles.push(heroStyles.compressed)

  return (
    <div className={ heroStyles.hero }>
      <Container className={ containerStyles.join(" ") }>
        <h1 className={ heroStyles.lead }>{ lead }</h1>
        <div className={ heroStyles.text }>
          { children }
        </div>
        { ctaText ? heroCta(ctaLink, ctaText) : null }
      </Container>
    </div>
  );
};