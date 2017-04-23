import React, { Component } from 'react';
import { connect } from 'react-redux';
import { signup } from '../actions/registration';
import SignupForm from '../components/SignupForm';

const mapDispatchToProps = (dispatch) => {
  return {
    onSubmit: (data) => { signup(data)(dispatch) }
  };
};

const Signup = connect(
  mapDispatchToProps
)(SignupForm);

export default Signup;
