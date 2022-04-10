/** @typedef {{load: (Promise<unknown>); flags: (unknown)}} ElmPagesInit */

const head = document.getElementsByTagName('head')[0]

const fontAwesome = Object.assign(document.createElement('script'), {
  src: "https://use.fontawesome.com/releases/v5.15.4/js/all.js",
  'data-auto-replace-svg': "nest"
});

head.appendChild(fontAwesome)

/** @type ElmPagesInit */
export default {
  load: async function (elmLoaded) {
    const app = await elmLoaded;
    console.log("App loaded", app);
  },
  flags: function () {
    var dimensions = { 'width': window.innerWidth, 'height': window.innerHeight };

    return {
      'window': dimensions
    };
  },
};
