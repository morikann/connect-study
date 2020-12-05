document.addEventListener('turbolinks:load', function() {

  const inputTags = document.getElementById('tag-input');
  const container = document.getElementById('tag-wrap');

  inputTags.addEventListener('change', (e) => {
    if(container.firstChild) {
      while(container.firstChild) {
        container.removeChild(container.firstChild);
      };
    };

    array = e.target.value.split(' ');
    if(e.target.value) {
      for(const value of array) {
        const divElement = document.createElement('div');
        divElement.classList.add('chip');
        divElement.innerHTML = value;
        container.appendChild(divElement);
      };
    };
  });
});