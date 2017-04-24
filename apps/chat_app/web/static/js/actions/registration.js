import { Socket } from 'phoenix';
import { push } from 'react-router-redux';

export function signup(data) {
  return (dispatch) => {
    dispatch(push('/signup'));

    console.log(data);

    const socket = new Socket('/socket');
    socket.connect();

    const channel = socket.channel('registrations:new');

    channel.join().receive('ok', () => {
      console.log('Joined channel!');
    });

    channel
      .push('signup', data)
      .receive('ok', (response) => { console.log(response);  })
      .receive('error', (response) => { console.log(response) });
  };
}
