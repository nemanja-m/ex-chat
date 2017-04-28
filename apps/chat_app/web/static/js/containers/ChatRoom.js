import React, { Component } from 'react';
import { connect } from 'react-redux';
import UserList from '../components/UserList';
import MessageForm from '../components/MessageForm';
import MessageList from '../components/MessageList';
import {
  connectToRoomChannel,
  createMessage
} from '../actions/room';

class ChatRoom extends Component {

  componentDidMount() {
    const { currentUser, connectToRoomChannel } = this.props;

    connectToRoomChannel(currentUser.id);
  }

  handleMessageCreate(data) {
    this.props.createMessage(this.props.channel, data);
  }

  render() {
    const { currentUser, presentUsers } = this.props;

    return (
      <div style={{ display: 'flex', height: '100vh', flex: '1' }}>
        <UserList
          currentUser={currentUser}
          presentUsers={presentUsers}
        />

        <div style={{ display: 'flex', flexDirection: 'column', flex: '1' }}>
          <MessageList messages={this.props.messages} />
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
    createMessage: (channel, data) => { dispatch(createMessage(channel, data)); }
  };
};

export default connect(
  mapStateToProps,
  mapDispatchToProps
)(ChatRoom);
