// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import Rails from '@rails/ujs';
import { Turbo } from '@hotwired/turbo-rails';
import TurboPower from 'turbo_power'; // https://github.com/marcoroth/turbo_power-rails

TurboPower.initialize(Turbo.StreamActions)

// Extending Turbo
Turbo.setProgressBarDelay(50);

// Make accessible for Electron and Mobile adapters
window.Rails = Rails;
window.Turbo = Turbo;
Rails.start();

import '@rails/actiontext';
import 'trix';
import 'chartkick/chart.js';
import './src/**/*';
import './controllers';
import LocalTime from 'local-time';
LocalTime.start();

import * as ActiveStorage from '@rails/activestorage';
ActiveStorage.start();

TurboPower.initialize(Turbo.StreamActions);


















