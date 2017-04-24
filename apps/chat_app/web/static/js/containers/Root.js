import React, { Component } from 'react';
import { connect } from 'react-redux';
import { Route } from 'react-router-dom';
import { ConnectedRouter } from 'react-router-redux';
import createHistory from 'history/createBrowserHistory';
import Home from './Home';
import Signup from './Signup';
import AuthenticationRoute from '../components/AuthenticationRoute';

class Root extends Component {

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
            component={Home}
            {...authenticated}
          />

          <AuthenticationRoute
            path="/signup"
            component={Signup}
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
