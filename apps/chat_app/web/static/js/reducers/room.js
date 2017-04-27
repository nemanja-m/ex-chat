const initialState = {
  presentUsers: [],
  channel: null,
  messages: []
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

    case 'USER_ENTERED_ROOM':
      return {
        ...state,
        presentUsers: [...state.presentUsers, action.user]
      };

    case 'USER_LEFT_ROOM':
      const users = state.presentUsers.filter((user) => { user.id !== action.user.id });

      return {
        ...state,
        presentUsers: users
      };

    default:
      return state;
  }
};

export default reduce;

