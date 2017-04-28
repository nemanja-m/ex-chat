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
          .receive('error', (response) => {
            var errorMessage = [];

            if (response.errors.password) {
              errorMessage.push(`Password ${response.errors.password}`);
            }

            if (response.errors.username) {
              errorMessage.push(`Username ${response.errors.username}`);
            }

            if (errorMessage.length > 0) {
              alert(errorMessage.join('\r\n'));
            }
          });
      });
  };
}
