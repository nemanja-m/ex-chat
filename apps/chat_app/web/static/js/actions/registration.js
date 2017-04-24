import { Socket } from 'phoenix';

export function signup(data) {
  return (dispatch) => {
    console.log(data);

    const socket = new Socket('/socket');
    socket.connect();

    const channel = socket.channel('registrations:new');

    channel.join().receive('ok', () => {
      console.log('Joined channel!');
    });

    channel
      .push('signup', data)
      .receive('ok', (response) => { console.log(response) })
      .receive('error', (response) => { console.log(response) });
  };
}
