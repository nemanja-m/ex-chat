import React, { Component } from 'react';
import { connect } from 'react-redux';
import { connectToRoomChannel } from '../actions/room';
import UserList from '../components/UserList';
import MessageForm from '../components/MessageForm';
import MessageList from '../components/MessageList';

class ChatRoom extends Component {

  componentDidMount() {
    const { currentUser, connectToRoomChannel } = this.props;

    connectToRoomChannel(currentUser.id);
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
          <MessageList
            messages={this.props.messages}
            ref={(c) => { this.messageList = c; }}
          />

          <MessageForm onSubmit={() => {}} />
        </div>
      </div>
    );
  }
}

const mapStateToProps = (state) => {
  return {
    currentUser:  state.session.currentUser,
    presentUsers: state.room.presentUsers,
    messages:     state.room.messages
  };
};

const mapDispatchToProps = (dispatch) => {
  return {
    connectToRoomChannel: (userID) => { dispatch(connectToRoomChannel(userID)); }
  };
};

export default connect(
  mapStateToProps,
  mapDispatchToProps
)(ChatRoom);
