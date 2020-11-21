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

// document.addEventListener('turbolink:load', function() {
//   document.querySelectorAll('.modal').addEventListener('click', function() {
//     modal();
//   });
// })
$(document).ready(function(){
  // the "href" attribute of the modal trigger must specify the modal ID that wants to be triggered
  $('.modal').modal();
});