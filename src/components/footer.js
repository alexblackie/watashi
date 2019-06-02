import React from "react";
import Container from "./container";

import footerStyles from "../styles/footer.module.css";

export default () => (
  <div className={ footerStyles.footer }>
    <Container>
      &copy; { (new Date()).getFullYear() } Alex Blackie. All Rights Reserved.<br/>
      This site is <a href="https://github.com/alexblackie/watashi">open source</a>!
      Powered by <a href="https://gatsbyjs.org">Gatsby</a>, <a href="https://kubernetes.io">Kubernetes</a>, and lots of coffee.
    </Container>
  </div>
)