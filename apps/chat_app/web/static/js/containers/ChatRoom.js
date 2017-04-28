import React, { Component } from 'react';
import { connect } from 'react-redux';
import UserList from '../components/UserList';
import MessageForm from '../components/MessageForm';
import MessageList from '../components/MessageList';
import {
  connectToRoomChannel,
  createMessage
} from '../actions/room';
import { logout } from '../actions/session';

class ChatRoom extends Component {

  componentDidMount() {
    const { currentUser, connectToRoomChannel } = this.props;

    connectToRoomChannel(currentUser.id);
  }

  handleMessageCreate(data) {
    this.props.createMessage(this.props.channel, data);
    this.messageList._scrollToBottom();
  }

  render() {
    const { currentUser, presentUsers, messages, onLogoutClick } = this.props;

    return (
      <div style={{ display: 'flex', height: '100vh', flex: '1' }}>
        <UserList
          currentUser={currentUser}
          presentUsers={presentUsers}
          onLogoutClick={onLogoutClick}
        />

        <div style={{ display: 'flex', flexDirection: 'column', flex: '1' }}>
          <MessageList
            messages={messages}
            currentUser={currentUser}
            ref={(c) => { this.messageList = c; }}
          />

          <MessageForm onSubmit={(data) => this.handleMessageCreate(data)} />
        </div>
      </div>
    );
  }
}

const mapStateToProps = (state) => {
  return {
    currentUser:  state.session.currentUser,
    presentUsers: state.room.presentUsers,
    messages:     state.room.messages,
    channel:      state.room.channel
  };
};

const mapDispatchToProps = (dispatch) => {
  return {
    connectToRoomChannel: (userID) => { dispatch(connectToRoomChannel(userID)); },
    createMessage: (channel, data) => { dispatch(createMessage(channel, data)); },
    onLogoutClick: () => { dispatch(logout()); }
  };
};

export default connect(
  mapStateToProps,
  mapDispatchToProps
)(ChatRoom);
