import React, { Component } from 'react';
import { connect } from 'react-redux';
import ChatRoom from './ChatRoom';
import Signup from './Signup';
import Login from './Login';
import AuthenticationRoute from '../components/AuthenticationRoute';
import { ConnectedRouter } from 'react-router-redux';
import { connectToSocket } from '../actions/session'

class Root extends Component {

  componentDidMount() {

    // Connect to Phoenix web socket.
    if (!this.props.socket) {
      this.props.connectToSocket();
    }
  }

  render() {
    const { currentUser } = this.props;

    const authenticated = { visibility: 'AUTHENTICATED', currentUser };
    const unauthenticated = { visibility: 'UNAUTHENTICATED', currentUser };

    return (
      <ConnectedRouter history={this.props.history}>
        <div>
          <AuthenticationRoute
            exact path="/"
            component={ChatRoom}
            {...authenticated}
          />

          <AuthenticationRoute
            path="/signup"
            component={Signup}
            {...unauthenticated}
          />

          <AuthenticationRoute
            path="/login"
            component={Login}
            {...unauthenticated}
          />
        </div>
      </ConnectedRouter>
    );
  }
}

const mapStateToProps = (state) => {
  return {
    currentUser: state.session.currentUser,
    socket:      state.session.socket
  };
};

const mapDispatchToProps = (dispatch) => {
  return {
    connectToSocket: () => { dispatch(connectToSocket()); }
  };
};

export default connect(
  mapStateToProps,
  mapDispatchToProps
)(Root);
