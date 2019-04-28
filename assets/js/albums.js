var loadedCallback = function () {

  var container = document.querySelector(".photo-set");
  var msnry = new Masonry(container, {});

  document.querySelector(".loading").outerHTML = "";

};

new imagesLoaded(".photo-set", {}, loadedCallback)
