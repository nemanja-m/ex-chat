import { combineReducers } from 'redux';
import { reducer as form } from 'redux-form';
import { routerReducer } from 'react-router-redux';
import session from './session';
import channels from './channels';

const appReducer = combineReducers({
  routing: routerReducer,
  form,
  session,
  channels
});

// When we dispatch 'LOGOUT' action we are forcing every reducer
// to return its inital state. This cleans up all redux state when a user logs out,
// so no data leaks through to the next user’s session.
const rootReducer = (state, action) => {
  if (action.type === 'LOGOUT') {

    // State is not mutated!
    // Reference of local variable 'state' is reassigned.
    state = undefined;
  }

  return appReducer(state, action);
};

export default rootReducer;
