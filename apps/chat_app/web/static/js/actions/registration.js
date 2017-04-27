import { push } from 'react-router-redux';

export function signup(data) {
  return (dispatch, getState) => {
    const socket = getState().session.socket;
    const channel = socket.channel('registrations:new');

    channel
      .join()
      .receive('ok', () => {

        console.log('Joined channel!');
        channel
          .push('signup', data)
          .receive('ok', (response) => {

            // Redirect to login page after successful signup.
            dispatch(push('/login'));
          })
          .receive('error', (response) => { console.log(response) });
      });
  };
}
