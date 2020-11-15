// materializeの初期化
document.addEventListener('turbolinks:load', function() {
  const elems = document.querySelectorAll('.sidenav');
  const instancs = M.Sidenav.init(elems, [])
});

document.addEventListener('turbolinks:load', function() {
  const elems = document.querySelectorAll('select');
  const instances = M.FormSelect.init(elems, []);
});