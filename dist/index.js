/** @typedef {{load: (Promise<unknown>); flags: (unknown)}} ElmPagesInit */

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
