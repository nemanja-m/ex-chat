import React, { Component } from 'react';
import { BrowserRouter as Router, Route } from 'react-router-dom';
import Home from './Home';

class Root extends Component {
  render() {
    return (
      <Router>
        <div>
          <Route exact pattern="/" component={Home} />
        </div>
      </Router>
    );
  }
}

export default Root;
