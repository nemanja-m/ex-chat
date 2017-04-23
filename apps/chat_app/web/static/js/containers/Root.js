import React, { Component } from 'react';
import { BrowserRouter as Router, Route, Switch } from 'react-router-dom';
import Home from './Home';
import Signup from './Signup';

class Root extends Component {
  render() {
    return (
      <Router>
        <Switch>
          <Route pattern="/signup" component={Signup} />
          <Route exact pattern="/" component={Home} />
        </Switch>
      </Router>
    );
  }
}

export default Root;
