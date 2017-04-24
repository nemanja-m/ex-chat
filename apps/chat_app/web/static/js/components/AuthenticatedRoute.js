import React from 'react';
import { Redirect, Route } from 'react-router-dom';

const renderRoute = (currentUser) => {
  return (props) => {
    const loginPage = {
      pathname: 'login',
      state: { from: props.location }
    };

    return currentUser ? (<Component {...props} />) : (<Redirect to={loginPage} />)
  };
};

const AuthenticatedRoute = ({ component: Component, currentUser, ...params }) => (
  <Route {...params} render={renderRoute(currentUser)} />
);

export default AuthenticatedRoute;
