import React from "react";
import { Link } from "gatsby";

import headerStyles from "../styles/header.module.css";
import Container from "./container";

import avi from "../images/avi.jpg";

export default () => (
  <div className={ headerStyles.header }>
    <Container className={ headerStyles.container }>
      <div className={ headerStyles.brand }>
        <h1>
          <Link to="/">
            <img src={ avi} alt="Avatar of Alex Blackie" width="64" height="64" />
            Alex Blackie
          </Link>
        </h1>
      </div>

      <nav role="navigation" className={ headerStyles.nav }>
        <Link to="/">Articles</Link>
        <Link to="/projects">Projects</Link>
      </nav>
    </Container>
  </div>
);
