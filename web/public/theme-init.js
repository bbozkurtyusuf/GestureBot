(function () {
  var stored = null;
  try {
    stored = localStorage.getItem("gesturebot-theme");
  } catch (e) {}
  var dark =
    stored === "dark" ||
    (stored !== "light" && window.matchMedia("(prefers-color-scheme: dark)").matches);
  document.documentElement.classList.toggle("dark", dark);
  var icon = document.getElementById("favicon");
  if (icon) {
    icon.setAttribute("href", dark ? "/brand/gesturebot-dark.png" : "/brand/gesturebot-light.png");
  }
})();
