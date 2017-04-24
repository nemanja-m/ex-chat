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

    default:
      return state;
  }
};

export default reduce;

