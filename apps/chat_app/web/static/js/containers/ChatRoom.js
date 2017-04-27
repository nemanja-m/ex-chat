import React, { Component } from 'react';
import { connect } from 'react-redux';
import PresentUsers from '../components/PresentUsers'

class ChatRoom extends Component {

  componentDidMount() {
    const { dispatch } = this.props;
    const token = sessionStorage.getItem('ex-chat-token', token);

    dispatch({ type: 'CHAT_ROOM_ENTERED', token });
  }

  render() {
    const { currentUser } = this.props;

    return (
      <div>
        <h1>Hello <strong>{currentUser.username}</strong> </h1>

        <PresentUsers />
      </div>
    );
  }
}

const mapStateToProps = (state) => {
  return {
    currentUser: state.session.currentUser
  };
};

export default connect(mapStateToProps)(ChatRoom);
