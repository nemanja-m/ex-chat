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
          .receive('ok', (response) => { console.log(response);  })
          .receive('error', (response) => { console.log(response) });
      });
  };
}
