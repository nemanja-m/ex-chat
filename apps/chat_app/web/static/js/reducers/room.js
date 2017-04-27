const initialState = {
  presentUsers: []
};

const reduce = (state = initialState, action) => {

  switch (action.type) {

    case 'SET_ACTIVE_USERS':
      return {
        presentUsers: action.users
      };

    default:
      return state;
  }
};

export default reduce;

