import React, { Component } from 'react';
import { connect } from 'react-redux';

class ChatRoom extends Component {

  render() {
    const { currentUser } = this.props;

    return (<h1>Hello <strong>{currentUser.username}</strong> </h1>);
  }
}

const mapStateToProps = (state) => {
  return {
    currentUser: state.session.currentUser
  };
};

export default connect(mapStateToProps)(ChatRoom);
