import { push } from 'react-router-redux';
import { reset } from 'redux-form';

function setCurrentUser(dispatch, response) {
  const { token, user } = response.data;
  sessionStorage.setItem('ex-chat-token', token);

  dispatch({ type: 'USER_LOGGED_IN', user });
}

export function login(data) {
  return (dispatch, getState) => {
    const socket = getState().channels.socket;
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
