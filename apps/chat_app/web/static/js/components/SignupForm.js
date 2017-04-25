import React, { Component } from 'react';
import { Field, reduxForm } from 'redux-form';

class SignupForm extends Component {
  render() {
    return (
      <form onSubmit={ this.props.handleSubmit }>
        <h3>
          Create your
          <strong className="text-danger"> ex-chat </strong>
          account
        </h3>

        <div className="form-group">
          <label htmlFor="username">Username</label> &nbsp;
          <Field name="username" component="input" type="text" />
        </div>

        <div className="form-group">
          <label htmlFor="password">Password</label> &nbsp;
          <Field name="password" component="input" type="password"/>
        </div>

        <button type="submit" className="btn btn-primary">
          { 'Sign up' }
        </button>

        &nbsp;
        <a href="/login" className="active">Log in</a>

      </form>
    );
  }
}

export default reduxForm({ form: 'signup' })(SignupForm);
