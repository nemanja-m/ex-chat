import React, { Component } from 'react';
import Message from './Message';

const styles = {
  container: {
    flex: '1',
    padding: '1rem 7rem 0 7rem',
    background: '#fff',
    overflowY: 'auto',
  },
};

class MessageList extends Component {

  _renderMessages() {
    const { messages, currentUser } = this.props;

    return messages.map((message) =>
      <Message
        key={message.id}
        message={message}
        fromCurrentUser={message.sender.username == currentUser.username}
      />
    );
  }

  render() {
    return (
      <div style={styles.container} ref={(c) => { this.container = c; }}>
        {this._renderMessages()}
      </div>
    );
  }
}

export default MessageList;
