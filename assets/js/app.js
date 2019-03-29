import css from "../css/app.css";
import "phoenix_html";
import "blk-design-system/assets/js/blk-design-system";
import JsBarcode from "jsbarcode";
import $ from "jquery";
window.jQuery = $;
window.$ = $;
import Base64 from "base-64";

JsBarcode(".barcode-canvas").init();
JsBarcode(".barcode-svg").init();

const barcodes = document.getElementsByClassName("barcode-data");

Array.prototype.forEach.call(barcodes, function(barcode) {
  const image_link = document.getElementById(`image-link-${barcode.id}`);
  const svg_link = document.getElementById(`svg-link-${barcode.id}`);

  const dataURL = document.getElementById(`canvas-${barcode.id}`).toDataURL();
  const svg = document.getElementById(`svg-${barcode.id}`);

  const b64 = Base64.encode(svg.outerHTML);

  image_link.href = dataURL;
  svg_link.href = `data:image/svg+xml;base64,\n${b64}`;
});
