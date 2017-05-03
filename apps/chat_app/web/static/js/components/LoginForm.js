import React, { Component } from 'react';
import { Field, reduxForm } from 'redux-form';

class LoginForm extends Component {

  render() {
    return (
      <div className="container" style={ {textAlign: 'center' } }>
        <form onSubmit={ this.props.handleSubmit } className="card">
          <h2 className="text-center">
            Welcome back to
            <strong className="text-danger"> ex |> chat </strong>
          </h2>

          <hr />

          <div className="row">
            <div className="form-group col-md-6 col-md-offset-3">
              <Field
                name="username"
                component="input"
                type="text"
                placeholder="Username"
                className="form-control"
              />
            </div>

            <div className="form-group col-md-6 col-md-offset-3">
              <Field
                name="password"
                component="input"
                type="password"
                placeholder="Password"
                className="form-control"
              />
            </div>
          </div>

          <hr />

          <button type="submit" className="btn btn-success btn-sm">
            { 'Log in' }
          </button>

          &nbsp; &nbsp; &nbsp;

          <a href="/signup" className="active">Sign up</a>

        </form>

        <h3 className="">
          Made with &nbsp;
          <span className="fa fa-lg fa-heart" style={{ color: 'red' }} />
          &nbsp; by &nbsp;
          <a
            href="https://github.com/nemanja-m"
            style={{ textDecoration: 'none' }}
            className="text-bold">@nemanja-m</a>
        </h3>
      </div>
    );
  }
}

export default reduxForm({ form: 'login' })(LoginForm);
