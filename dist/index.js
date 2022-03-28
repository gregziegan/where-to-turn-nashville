/** @typedef {{load: (Promise<unknown>); flags: (unknown)}} ElmPagesInit */

var storageKey = "store";

/** @type ElmPagesInit */
export default {
  load: async function (elmLoaded) {
    const app = await elmLoaded;
  },
  flags: function () {
    var dimensions = { 'width': window.innerWidth, 'height': window.innerHeight };

    return {
      'window': dimensions
    };
  },
};
