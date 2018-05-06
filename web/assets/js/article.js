(function () {

  /**
   * Facilitate "live following" of scroll position with ToC.
   */
  var anchorEls = document.querySelectorAll(".scrollAnchor");
  var anchors = {};

  anchorEls.forEach(function(el) {
    anchors[el.name] = el;
  });

  // Mark the first one active to start with
  anchorEls[0].classList.add("active");

  window.onscroll = function() {
    for (name in anchors) {
      var rekt = anchors[name].getBoundingClientRect();

      if (rekt.top >= 0 && rekt.bottom <= (window.innerHeight / 2)) {
        document
          .querySelectorAll(".article-toc-link:not(#tocLink-" + name + ")")
          .forEach(function(e) { e.classList.remove("active") });

        document.querySelector("#tocLink-" + name).classList.add("active");
        var parentName = anchors[name].getAttribute("data-parent");
        if (parentName) {
          document.querySelector("#tocLink-" + parentName).classList.add("active");
        }
      }
    }
  };

  /**
   * Handle mobile ToC open/closing
   */

  var tocHandle = document.getElementById("tocHandle");
  var toc = document.getElementById("toc");

  tocHandle.addEventListener("click", function () {
    toc.classList.toggle("open");
  });

  document.querySelectorAll(".article-toc-link").forEach(function (el) {
    el.addEventListener("click", function () { toc.classList.remove("open"); });
  });

})();
