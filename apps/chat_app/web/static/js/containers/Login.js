import React, { Component } from 'react';
import { connect } from 'react-redux';
import { login } from '../actions/session';
import LoginForm from '../components/LoginForm';

const mapDispatchToProps = (dispatch) => {
  return {
    onSubmit: (data) => { dispatch(login(data)); }
  };
};

const Login = connect(
  null,
  mapDispatchToProps
)(LoginForm);

export default Login;
