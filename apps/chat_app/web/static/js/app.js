import React from 'react';
import { render } from 'react-dom';
import { Provider } from 'react-redux';
import configureStore from './store';
import Root from './containers/Root';

const store = configureStore(history);

render(
  <Provider store={store}>
    <Root />
  </Provider>,
  document.getElementById('root')
);
