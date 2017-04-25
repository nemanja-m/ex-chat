import React from 'react';
import { render } from 'react-dom';
import { Provider } from 'react-redux';
import createHistory from 'history/createBrowserHistory';
import configureStore from './store';
import Root from './containers/Root';

const history = createHistory();
const store = configureStore(history);

render(
  <Provider store={store}>
    <Root history={history} />
  </Provider>,
  document.getElementById('root')
);
