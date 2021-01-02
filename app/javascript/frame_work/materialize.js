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
  var elems = document.querySelectorAll('.tooltipped');
  var instances = M.Tooltip.init(elems, []);
});

document.addEventListener('turbolinks:load', function() {
  var elems = document.querySelectorAll('.tap-target');
  var instances = M.TapTarget.init(elems, []);
});

$(document).on('turbolinks:load', function(){
  $('.tabs').tabs();
});

document.addEventListener('turbolinks:load', function() {
  var elems = document.querySelectorAll('.fixed-action-btn');
  var instances = M.FloatingActionButton.init(elems, {
    direction: 'left',
    hoverEnabled: false
  });
});

document.addEventListener('turbolinks:load', function() {
  var elems = document.querySelectorAll('.dropdown-trigger');
  var instances = M.Dropdown.init(elems, []);
});

$(document).on('turbolinks:load', function(){
  $('.modal').modal();
});

$(document).on('turbolinks:load', function() {
  $('input#input_text, textarea#textarea2').characterCounter();
});

document.addEventListener('turbolinks:load', function() {
  var elems = document.querySelectorAll('.chips');
  var instances = M.Chips.init(elems, []);
});