import React, { Component } from 'react';
import { connect } from 'react-redux';
import { ConnectedRouter } from 'react-router-redux';
import createHistory from 'history/createBrowserHistory';
import ChatRoom from './ChatRoom';
import Signup from './Signup';
import Login from './Login';
import AuthenticationRoute from '../components/AuthenticationRoute';
import { Socket } from 'phoenix';

class Root extends Component {

  componentDidMount() {

    // Connect to Phoenix web socket.
    const { dispatch } = this.props;
    const socket = new Socket('/socket');
    socket.connect();

    dispatch({ type: 'SOCKET_CONNECTED', socket });
  }

  render() {
    const { currentUser } = this.props;
    const history = createHistory();

    const authenticated = { visibility: 'AUTHENTICATED', currentUser };
    const unauthenticated = { visibility: 'UNAUTHENTICATED', currentUser };

    return (
      <ConnectedRouter history={history}>
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
    currentUser: state.session.currentUser
  };
};

export default connect(mapStateToProps)(Root);
