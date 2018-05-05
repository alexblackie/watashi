(function () {

  /**
   * Facilitate "live following" of scroll position with ToC.
   */
  var anchorEls = document.querySelectorAll(".scrollAnchor");
  var anchors = {};

  Array.prototype.forEach.call(anchorEls, function(el) {
    anchors[el.name] = el;
  });

  // Mark the first one active to start with
  anchorEls[0].classList.add("active");

  window.onscroll = function() {
    for (name in anchors) {
      var el = anchors[name];
      var rekt = el.getBoundingClientRect();

      if (rekt.top >= 0 && rekt.bottom <= window.innerHeight) {

        document
          .querySelectorAll(".article-toc-link:not(#tocLink-" + el.name + ")")
          .forEach(function(e) { e.classList.remove("active") });

        document.querySelector("#tocLink-" + el.name).classList.add("active");
      }
    }
  };


})();
