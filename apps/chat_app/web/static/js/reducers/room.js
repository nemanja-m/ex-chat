const initialState = {
  presentUsers: [],
  channel: null
};

const reduce = (state = initialState, action) => {

  switch (action.type) {

    case 'SET_ACTIVE_USERS':
      return {
        ...state,
        presentUsers: action.users
      };

    case 'SET_ROOM_CHANNEL':
      return {
        ...state,
        channel: action.channel
      };

    default:
      return state;
  }
};

export default reduce;

