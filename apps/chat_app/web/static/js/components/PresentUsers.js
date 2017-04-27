import React, { Component } from 'react';
import { connect } from 'react-redux';

class User extends Component {
  render() {
    const { username } = this.props;
    return (<li>{username}</li>);
  }
}

class PresentUsers extends Component {

  render() {
    const { users } = this.props;

    var activeUsers = [];
    users.forEach((user) => {
      activeUsers.push(<User key={user.id} username={user.username} />);
    });

    return (<ul>{activeUsers}</ul>);
  }
}

export default PresentUsers;
