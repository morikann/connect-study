const { Modal } = require("materialize-css");

// materializeの初期化
document.addEventListener('turbolinks:load', function() {
  const elems = document.querySelectorAll('.sidenav');
  const instancs = M.Sidenav.init(elems, [])
});

// document.addEventListener('turbolinks:load', function() {
//   const elems = document.querySelectorAll('select');
//   const instances = M.FormSelect.init(elems, []);
// });

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

$(document).on('turbolinks:load', function() {
  $('select').material_select();
});

document.addEventListener('turbolinks:load', function() {
  var elems = document.querySelectorAll('.fixed-action-btn');
  var instances = M.FloatingActionButton.init(elems, {
    direction: 'left',
    hoverEnabled: false
  });
});

// document.addEventListener('turbolinks:load', function() {
//   var elems = document.querySelectorAll('.dropdown-trigger');
//   var instances = M.Dropdown.init(elems, []);
// });

$('.dropdown-button').dropdown({
  inDuration: 300,
  outDuration: 225,
  constrainWidth: false, // Does not change width of dropdown to that of the activator
  hover: true, // Activate on hover
  gutter: 0, // Spacing from edge
  belowOrigin: false, // Displays dropdown below the button
  alignment: 'left', // Displays dropdown with edge aligned to the left of button
  stopPropagation: false // Stops event propagation
}
);

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