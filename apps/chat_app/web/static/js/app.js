import React from 'react';
import { render } from 'react-dom';
import { Provider } from 'react-redux';
import { Route } from 'react-router-dom';
import { ConnectedRouter } from 'react-router-redux';
import createHistory from 'history/createBrowserHistory'
import configureStore from './store';
import Home from './containers/Home';
import Signup from './containers/Signup';

const history = createHistory();
const store = configureStore(history);

render(
  <Provider store={store}>
    <ConnectedRouter history={history}>
      <div>
        <Route exact pattern="/" component={Home} />
        <Route pattern="/signup" component={Signup} />
      </div>
    </ConnectedRouter>
  </Provider>,
  document.getElementById('root')
);
