import { Controller } from '@hotwired/stimulus';
import SlimSelect from 'slim-select';
import { post } from '@rails/request.js';

let sidebar = document.querySelector('.sidebar');
let closeBtn = document.querySelector('#btn');
let searchBtn = document.querySelector('.bx-search');

function mobile() {
  if (window.innerWidth < 1000) {
    sidebar.classList.remove('open');
  }
}
mobile();

window.addEventListener('resize', () => {
  console.log(window.innerWidth);
  if (window.innerWidth > 1000) {
    sidebar.classList.add('open');
  }
  if (window.innerWidth < 1000) {
    sidebar.classList.remove('open');
  }
});

// following are the code to change sidebar button(optional)
function menuBtnChange() {
  if (sidebar.classList.contains('open')) {
    closeBtn.classList.replace('bx-menu', 'bx-menu-alt-right'); //replacing the iocns class
  } else {
    closeBtn.classList.replace('bx-menu-alt-right', 'bx-menu'); //replacing the iocns class
  }
}
