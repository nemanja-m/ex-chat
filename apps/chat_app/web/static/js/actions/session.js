import { push } from 'react-router-redux';
import { reset } from 'redux-form';
import { Socket } from 'phoenix';

function setCurrentUser(dispatch, response) {
  const { token, user, users } = response.data;
  sessionStorage.setItem('ex-chat-token', token);

  dispatch({ type: 'USER_LOGGED_IN', user });
  dispatch({ type: 'SET_ACTIVE_USERS', users });
}

export function connectToSocket() {
  return (dispatch) => {
    const socket = new Socket('/socket');
    socket.connect();

    dispatch({ type: 'SOCKET_CONNECTED', socket });
  };
}

export function login(data) {
  return (dispatch, getState) => {
    const socket = getState().session.socket;
    const channel = socket.channel('sessions:new');

    channel
      .join()
      .receive('ok', () => {
        console.log('Joined sessions channel!');

        channel
          .push('login', data)
          .receive('ok', (response) => {

            setCurrentUser(dispatch, response);

            dispatch(reset('login'));
            dispatch(push('/'));
          })
          .receive('error', (response) => { console.log(response) });
      });
  };
}
