import React, { Component } from 'react';
import { Field, reduxForm } from 'redux-form';

class LoginForm extends Component {

  render() {
    return (
      <form onSubmit={ this.props.handleSubmit }>
        <h3>Enter your username and password</h3>

        <div className="form-group">
          <label htmlFor="username">Username</label> &nbsp;
          <Field name="username" component="input" type="text" />
        </div>

        <div className="form-group">
          <label htmlFor="password">Password</label> &nbsp;
          <Field name="password" component="input" type="password"/>
        </div>

        <button type="submit" className="btn btn-success">
          { 'Log in' }
        </button>

        &nbsp;
        <a href="/signup" className="active">Sign up</a>

      </form>
    );
  }
}

export default reduxForm({ form: 'login' })(LoginForm);
