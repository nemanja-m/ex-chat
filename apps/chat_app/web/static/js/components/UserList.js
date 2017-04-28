import React, { Component } from 'react';

const styles = {
  roomSidebar: {
    color: '#ab9ba9',
    background: '#4d394b',
    border: '2px solid #2c212d'
  },

  header: {
    padding: '20px 15px',
    marginBottom: '10px',
    color: 'white',
    width: '280px',
    fontSize: '20px',
    fontWeight: 'bold',
    textAlign: 'center'
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

  logoutButton: {
    padding: '0',
    background: 'transparent',
    border: '0',
    cursor: 'pointer',
  },

  logoutContainer: {
    position: 'absolute',
    left: '15px',
    bottom: '10px'
  },

  badge: {
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
    width: '45px',
    height: '45px',
    margin: '12px auto',
    fontSize: '20px',
    background: 'rgba(255,255,255,.2)',
    borderRadius: '5px',
  }
};

const User = ({ username }) =>
  <li className="online-user" style={ styles.username }>
    {username}
  </li>;

class UserList extends Component {

  _renderActiveUsers() {
    return this.props.presentUsers.map((user) =>
      <User key={user.id} username={user.username} />);
  }

  render() {
    const { currentUser, presentUsers, onLogoutClick } = this.props;

    return (
      <div style={ styles.roomSidebar }>
        <div style={ styles.header }>
          Ex |> Chat
        </div>

        <div style={ styles.listHeading }>
          Active Users
        </div>
        <ul style={ styles.userList }>
          <User key={currentUser.id} username={`${currentUser.username} (you)`} />

          {this._renderActiveUsers()}
        </ul>

        <div style={ styles.logoutContainer }>
          <button onClick={ onLogoutClick } style={ styles.logoutButton } >
            <div style={styles.badge}>
              <span className="fa fa-sign-out" />
            </div>
          </button>
        </div>
      </div>
    );
  }
}

export default UserList;
