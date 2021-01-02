document.addEventListener("turbolinks:load", () => {

  if (typeof gon != "undefined") {

    const tagList = [] = gon.tag_list;
    const tags = [];

    if (tagList) {
      for (let item of tagList) {
        tags.push({tag: item.name});
      }
    }

    // editの際に初期値としてタグを配置しておく
    $('.chips-initial').chips({
      data: tags,
    });
  }

  const form = document.getElementById('form-include-tag');

  form?.addEventListener('submit', () => {

    const tagsWrapper = document.getElementById('tags-wrapper');
    const tagField = document.getElementById('tag-field');

    let values = [];
    const tags = [] = tagsWrapper.getElementsByClassName('chip');
    for(let tag of tags) {
      // タグの値のみ配列に格納していく
      values.push(tag.innerHTML.replace('<i class="material-icons close">close</i>', ''));
    }

    tagField.value = values;
    tagField.style.display = 'none';

  })
});