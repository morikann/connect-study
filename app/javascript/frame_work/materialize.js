const { Modal } = require("materialize-css");

// materializeの初期化
document.addEventListener('turbolinks:load', function() {
  const elems = document.querySelectorAll('.sidenav');
  const instancs = M.Sidenav.init(elems, [])
});

document.addEventListener('turbolinks:load', function() {
  const elems = document.querySelectorAll('select');
  const instances = M.FormSelect.init(elems, []);
});

document.addEventListener('turbolinks:load', function() {
  const elems = document.querySelectorAll('.modal');
  const instances = M.Modal.init(elems, []);
});

document.addEventListener('turbolinks:load', function() {
  var elems = document.querySelectorAll('.tooltipped');
  var instances = M.Tooltip.init(elems, []);
});

document.addEventListener('DOMContentLoaded', function() {
  var elems = document.querySelectorAll('.tap-target');
  var instances = M.TapTarget.init(elems, []);
});

$(document).on('turbolinks:load', function(){
  $('.tabs').tabs();
});