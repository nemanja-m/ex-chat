const initialState = {
  currentUser: null,
  socket: null
};

const reduce = (state = initialState, action) => {

  switch (action.type) {

    case 'SOCKET_CONNECTED':
      return {
        ...state,
        socket: action.socket
      };

    case 'USER_LOGGED_IN':
      return {
        ...state,
        currentUser: action.user
      };

    default:
      return state;
  }
};

export default reduce;
