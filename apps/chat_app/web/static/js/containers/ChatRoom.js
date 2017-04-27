import React, { Component } from 'react';
import { connect } from 'react-redux';
import PresentUsers from '../components/PresentUsers';
import { connectToRoomChannel } from '../actions/room';

class ChatRoom extends Component {

  componentDidMount() {
    const { currentUser, connectToRoomChannel } = this.props;

    connectToRoomChannel(currentUser.id);
  }

  render() {
    const { currentUser, presentUsers } = this.props;

    return (
      <div>
        <h1>Hello <strong>{currentUser.username}</strong> </h1>

        <PresentUsers users={presentUsers}/>
      </div>
    );
  }
}

const mapStateToProps = (state) => {
  return {
    currentUser:  state.session.currentUser,
    presentUsers: state.room.presentUsers
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
