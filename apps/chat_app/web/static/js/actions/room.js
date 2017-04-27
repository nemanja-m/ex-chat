import { Socket } from 'phoenix';

export function connectToRoomChannel(userID) {
  return (dispatch, getState) => {
    const token = sessionStorage.getItem('ex-chat-token', token);

    // Disconnect from old stateless socket.
    getState().session.socket.disconnect();

    // And conect to new with JWT as param.
    const socket = new Socket('/socket', {params: {token}});
    socket.connect();

    // Put new socket in store.
    dispatch({ type: 'SOCKET_CONNECTED', socket });

    // Connect user to room channel.
    const channel = socket.channel(`room:${userID}`);

    channel
      .join()
      .receive('ok', () => {
        console.log('Joined room channel!');

        dispatch({ type: 'SET_ROOM_CHANNEL', channel });
      });
  };
}
