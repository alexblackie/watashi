(function () {

  var form = document.getElementById("dpiForm");

  // Automatically convert mm to in when you change the box.
  // Doesn't actually affect any of the math, just a nice UX thing.
  var unitsElem = document.getElementById("units");
  unitsElem.addEventListener("change", function () {
    var diag = document.getElementById("diag");
    if (unitsElem.value === "mm") { diag.value = diag.value * 25.4 }
    if (unitsElem.value === "in") { diag.value = diag.value / 25.4 }
  })


  form.onsubmit = function (e) {
    e.preventDefault();

    // Get everything
    var resX = parseInt(document.getElementById("resx").value);
    var resY = parseInt(document.getElementById("resy").value);
    var diag = parseFloat(document.getElementById("diag").value);
    var propX = parseInt(document.getElementById("propX").value);
    var propY = parseInt(document.getElementById("propY").value);

    // This is just for show, the calculations don't care about this.
    var units = document.getElementById("units").value;

    // ------------------------------------------------------------------------
    // BEGIN MATHS
    // ------------------------------------------------------------------------

    // Astute readers may recognize that this is actually just the Pythagorean
    // Theorem. It's actually a pretty simple calculation.

    // Currently the only known value is the diagonal length (d). Given the
    // proportion (eg., 16/9), we have the opposite: we know everything except
    // (d). This allows us to first calculate (d) for the proportion, and then
    // use that fully-solved triangle to determine a constant to use as the
    // ratio between (d) and the Y edge.
    var virtualDiag = Math.sqrt(Math.pow(propX, 2) + Math.pow(propY, 2));
    var diagYRatio = virtualDiag / propY;

    // Now that we have the ratio between diag and Y, we have the one missing
    // number we needed to be able to algebra-out Y based on the real diag. The
    // resulting "formula" is, well:
    var sizeY = diag / diagYRatio;

    // Now we have two sides of the triangle, so we can dust off our Grade 9
    // math textbook and bust out that Pythagorean Theorem.
    var sizeX = Math.sqrt(Math.pow(diag, 2) - Math.pow(sizeY, 2));

    // We now have a solved triangle, so now we can use our new-found values to
    // calculate the area of the screen.
    var screenArea = sizeX * sizeY;

    // ... and then figure out how many pixels we have.
    var pixels = resX * resY;

    // and finally, calculate how many pixels are in a single unit.
    var dpi = Math.sqrt(pixels) / Math.sqrt(screenArea);

    // We did it!

    // ------------------------------------------------------------------------
    // END MATHS
    // ------------------------------------------------------------------------

    var dpiResult = document.getElementById("dpiResult");
    dpiResult.innerHTML = dpi.toFixed(2) + " dots/" + units;

  }

})();
