export function signup(data) {
  return (dispatch, getState) => {
    const socket = getState().channels.socket;
    const channel = socket.channel('registrations:new');

    channel
      .join()
      .receive('ok', () => {

        console.log('Joined channel!');
        channel
          .push('signup', data)
          .receive('ok', (response) => { console.log(response);  })
          .receive('error', (response) => { console.log(response) });
      });
  };
}
