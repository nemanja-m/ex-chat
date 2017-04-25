import thunk from 'redux-thunk';
import reducers from '../reducers';
import { createStore, applyMiddleware } from 'redux';
import { routerMiddleware } from 'react-router-redux';

const configureStore = (history) => {
  var middleware = [routerMiddleware(history), thunk];

  return createStore(
    reducers,
    applyMiddleware(...middleware)
  );
};

export default configureStore;
