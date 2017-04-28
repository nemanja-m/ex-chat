import React, { Component } from 'react';
import { Field, reduxForm } from 'redux-form';

const styles = {
  form: {
    padding: '1rem 7rem',
    background: '#fff',
  },

  input: {
    borderWidth: '2px',
    borderColor: 'rgb(214,214,214)',
  }
};

class MessageForm extends Component {

  render() {
    return (
      <form onSubmit={this.props.handleSubmit} style={styles.form}>
        <div className="input-group">
          <Field
            name="text"
            type="text"
            component="input"
            className="form-control"
            style={styles.input}
          />
          <div className="input-group-btn">
            <button
              disabled={this.props.invalid}
              className="btn btn-success"
              style={styles.button}
            >
              Send
            </button>
          </div>
        </div>
      </form>
    );
  }
}

const validate = (values) => {
  const errors = {};
  if (!values.text) {
    errors.text = 'Required';
  }
  return errors;
};

export default reduxForm({
  form: 'messageForm',
  validate
})(MessageForm);
