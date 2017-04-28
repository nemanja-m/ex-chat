import { Socket } from 'phoenix';
import { reset } from 'redux-form';

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
    const channel = socket.channel('room:lobby');

    channel.on('user:login', (user) => {
      dispatch({ type: 'USER_ENTERED_ROOM', user });
    });

    channel.on('user:logout', (user) => {
      dispatch({ type: 'USER_LEFT_ROOM', user });
    });

    channel.on('message:new', (message) => {

      const currentUser = getState().session.currentUser;

      if (message.receiver &&
          message.receiver !== currentUser.username) {
        return;
      }

      console.log(message);

      dispatch({ type: 'NEW_MESSAGE', message })
    });

    channel
      .join()
      .receive('ok', () => {
        console.log('Joined room channel!');

        dispatch({ type: 'SET_ROOM_CHANNEL', channel });
      });
  };
}

export function createMessage(channel, payload) {
  return (dispatch, getState) => {
    const currentUser = getState().session.currentUser;
    const id = `${ (currentUser.id).toString(16) }:${ Date.now() }`;
    const text = payload.text;

    var messageType = "public";
    var message = {
      id,
      content: text,
      date: Date.now(),
      sender: currentUser,
      receiver: null
    };


    const tokens = text.split("|>");

    if (tokens.length === 2) {
      message.receiver = tokens[0].trim();
      message.content  = tokens[1].trim();

      messageType = "private";
    }

    channel
      .push(`message:${ messageType }`, message)
      .receive('ok', () => {
        dispatch(reset('messageForm'));
      })
      .receive('error', (error) => { console.log(error); })
  };
}
