// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import css from "../css/app.scss";

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import "phoenix_html";

// Import local files
//
// Local files can be imported directly using relative paths, for example:
// import socket from "./socket"

document.addEventListener("DOMContentLoaded", () => {
  const addProfileEl = document.getElementById("add-profile");

  if (addProfileEl !== null) {
    addProfileEl.addEventListener("click", e => {
      e.preventDefault();

      const profileForm = document.getElementById("profile-form");
      const inputRows = document.querySelectorAll(".profile-input-row");
      const newInputRow = inputRows[inputRows.length - 1].cloneNode(true);
      profileForm.appendChild(newInputRow);

      const inputs = newInputRow.querySelectorAll("input");
      for (var i = 0; i <= inputs.length; i++) {
        if (typeof inputs[i] !== "undefined") {
          inputs[i].id = inputs[i].id.replace(
            /_(\d+)_/,
            `_${inputRows.length}_`
          );
          inputs[i].name = inputs[i].name.replace(
            /\[(\d+)\]/,
            `[${inputRows.length}]`
          );
          inputs[i].value = null;
        }
      }
    });

    const profileForm = addProfileEl.closest("form");

    profileForm.addEventListener("submit", e => {
      e.preventDefault();

      const inputRows = profileForm.querySelectorAll(".profile-input-row");
      var emptyRows = Array.prototype.filter.call(inputRows, row =>
        Array.prototype.some.call(
          row.querySelectorAll("input"),
          input => input.value === null || input.value === ""
        )
      );
      Array.prototype.forEach.call(emptyRows, row =>
        row.parentNode.removeChild(row)
      );

      profileForm.submit();
    });
  }
});
