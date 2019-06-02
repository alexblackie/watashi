import React from "react";

import cardStyles from "../styles/projectCard.module.css";

export default ({ children, name, url }) => (
  <div className={ cardStyles.projectCard }>
    <a href={ `https://${ url }` }>
      <div>
        <h2 className={ cardStyles.projectName }>
          { name }
          <div className={ cardStyles.domain }>{ url }</div>
        </h2>

        <div className={ cardStyles.content }>
          { children }
        </div>
      </div>
    </a>
  </div>
)