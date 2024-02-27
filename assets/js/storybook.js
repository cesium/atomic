// If your components require any hooks or custom uploaders, or if your pages
// require connect parameters, uncomment the following lines and declare them as
// such:
//
// import * as Hooks from "./hooks";
// import * as Params from "./params";
// import * as Uploaders from "./uploaders";

// (function () {
//   window.storybook = { Hooks, Params, Uploaders };
// })();

import "../vendor/alpine.js";

(function () {
  window.storybook = {
    LiveSocketOptions: {
      dom: {
        onBeforeElUpdated(from, to) {
          if (from._x_dataStack) {
            window.Alpine.clone(from, to)
          }
        }
      }
    }
  };
})();
