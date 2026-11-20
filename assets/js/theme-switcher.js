const themeKey = 'elianorarose.com-Theme';
const darkTheme = 'dark';
const lightTheme = 'light';

/**
 * @returns The theme from local storage, if present.
 */
function getTheme() {
  const themeValue = localStorage.getItem(themeKey);
  if (themeValue) {
    return themeValue;
  }

  if (window.matchMedia && window.matchMedia('(prefers-color-scheme: light)').matches) {
    return lightTheme;
  }

  return darkTheme;
}

/**
 * @param {*} themeValue The theme to set. Accepts 'light' or 'dark'.
 */
function setTheme(themeValue) {
  document.documentElement.setAttribute('data-theme', themeValue);
  localStorage.setItem(themeKey, themeValue);
}

/**
 * Inverts the theme to be the opposite of the currently set theme.
 */
function toggleTheme() {
  const themeValue = getTheme();
  if (themeValue == darkTheme) {
    setTheme(lightTheme);
    return;
  }

  setTheme(darkTheme);
}

(function () {
  setTheme(getTheme());
})();
