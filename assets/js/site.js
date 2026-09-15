// The language menu works without JavaScript; add conventional dismissal controls.
const languageMenu = document.querySelector('.language-switcher');
if (languageMenu) {
  document.addEventListener('click', (event) => {
    if (!languageMenu.contains(event.target)) languageMenu.open = false;
  });
  document.addEventListener('keydown', (event) => {
    if (event.key === 'Escape' && languageMenu.open) {
      languageMenu.open = false;
      languageMenu.querySelector('summary').focus();
    }
  });
  languageMenu.addEventListener('focusout', (event) => {
    if (!languageMenu.contains(event.relatedTarget)) languageMenu.open = false;
  });
}
