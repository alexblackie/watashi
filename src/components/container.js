import React from "react";
import containerStyles from "../styles/container.module.css";

function classList(classNames) {
  return classNames.join(" ");
}

export default ({ children, className }) => (
  <div className={ classList([containerStyles.container, className]) }>
    { children }
  </div>
);