import { Controller } from '@hotwired/stimulus';

document.getElementById('add-button').addEventListener('click', function () {
  document.getElementById('modal').classList.remove('hidden');
});

document.getElementById('modal').addEventListener('click', function (e) {
  if (e.target === this) {
    this.classList.add('hidden');
  }
});
