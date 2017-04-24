import React from 'react';
import { Redirect, Route } from 'react-router-dom';

// For our app, we want the home page to only be visible to logged in users,
// and the login/signup pages to only be visible to unauthenticated users.
//
// With 'AuthenticationRoute` stateless component we redirect to '/login' or to home page
// depending on current page and current user's authentication status.

// 'visibility' defines whether we render desired component or redirect user.
//
// AUTHENTICATED   - User have to be logged in to see requested page.
// UNAUTHENTICATED - User does not have to be logged in to se requested page.

const renderRoute = (visibility, currentUser, Component) => {

  return (props) => {

    // Decide where we want to redirect user.
    const pathname = (visibility === 'AUTHENTICATED' ? 'login' : '/');

    const redirectPage = {
      pathname,
      state: { from: props.location }
    };

    if (visibility === 'AUTHENTICATED') {
      return currentUser ? (<Component {...props} />) : (<Redirect to={redirectPage} />)
    } else {
      return currentUser ? (<Redirect to={redirectPage} />) : (<Component {...props} />)
    }
  };
};

const AuthenticationRoute = ({ component: Component, currentUser, visibility, ...params }) => (
  <Route {...params} render={renderRoute(visibility, currentUser, Component)} />
);

export default AuthenticationRoute;
