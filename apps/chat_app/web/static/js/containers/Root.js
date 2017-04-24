import React, { Component } from 'react';
import { connect } from 'react-redux';
import { Route } from 'react-router-dom';
import { ConnectedRouter } from 'react-router-redux';
import createHistory from 'history/createBrowserHistory';
import Home from './Home';
import Signup from './Signup';
import AuthenticatedRoute from '../components/AuthenticatedRoute';

class Root extends Component {

  render() {
    const { currentUser } = this.props;
    const history = createHistory();

    return (
      <ConnectedRouter history={history}>
        <div>
          <AuthenticatedRoute exact path="/" component={Home} />
          <Route path="/signup" component={Signup} />
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
