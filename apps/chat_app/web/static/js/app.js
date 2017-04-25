import React from 'react';
import { render } from 'react-dom';
import { Provider } from 'react-redux';
import createHistory from 'history/createBrowserHistory';
import configureStore from './store';
import Root from './containers/Root';

const store = configureStore(history);
const history = createHistory();

render(
  <Provider store={store}>
    <Root history={history} />
  </Provider>,
  document.getElementById('root')
);
