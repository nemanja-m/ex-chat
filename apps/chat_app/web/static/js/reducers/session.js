const initialState = {
  currentUser: null
};

const reduce = (state = initialState, action) => {

  switch (action.type) {

    case 'USER_LOGGED_IN':
      return {
        currentUser: action.user
      };

    default:
      return state;
  }
};

export default reduce;
