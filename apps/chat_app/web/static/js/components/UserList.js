import React, { Component } from 'react';

const styles = {
  roomSidebar: {
    color: '#ab9ba9',
    background: '#4d394b',
  },

  header: {
    padding: '20px 15px',
    marginBottom: '10px',
    color: 'white',
    width: '220px',
    fontSize: '18px',
    fontWeight: 'bold',
  },

  userList: {
    paddingLeft: '15px',
    listStyle: 'none',
  },

  username: {
    position: 'relative',
    paddingLeft: '20px',
    fontSize: '16px',
    fontWeight: '300',
    color: 'white'
  },

  listHeading: {
    marginLeft: '15px',
    marginRight: '15px',
    marginBottom: '8px',
    paddingBottom: '5px',
    borderBottom: '1px solid #ab9ba9',
    fontSize: '13px',
    textTransform: 'uppercase',
  },
};

const User = ({ id, username }) =>
  <li key={id} className="online-user" style={ styles.username }>
    {username}
  </li>;

class UserList extends Component {

  _renderActiveUsers() {
    return this.props.presentUsers.map((user) => <User props={user} />);
  }

  render() {
    const { currentUser, presentUsers } = this.props;

    return (
      <div style={ styles.roomSidebar }>
        <div style={ styles.header }>
          Ex |> Chat
        </div>

        <div style={ styles.listHeading }>
          Active Users
        </div>
        <ul style={ styles.userList }>
          <User id={currentUser.id} username={currentUser.username} />

          {this._renderActiveUsers()}
        </ul>
      </div>
    );
  }
}

export default UserList;
