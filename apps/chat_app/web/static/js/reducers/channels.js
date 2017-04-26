import { Socket } from 'phoenix';

const initialState = {
  socket: null,
  connected: []
};

const reduce = (state = initialState, action) => {

  switch (action.type) {

    case 'SOCKET_CONNECTED':
      return {
        ...state,
        socket: action.socket
      };

    case 'CHAT_ROOM_ENTERED':

      // Disconnect from old socket.
      state.socket.disconnect();

      // And conect to new with JWT as param.
      const socket = new Socket('/socket', {params: {token: action.token}});
      socket.connect();

      // Connect to room channel.
      const channel = socket.channel('room:new');

      channel
        .join()
        .receive('ok', () => { console.log('Joined room channel!'); });

      const connected = [...state.connected, channel];

      return {
        connected,
        socket
      };

    default:
      return state;
  }
};

export default reduce;

