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

  componentWillReceiveProps(nextProps) {

    // If we get new message.
    if (nextProps.messages.length > this.props.messages.length) {

      // Don't scroll down if iser is already scrolled to top by 100
      if (this.container.scrollHeight - this.container.scrollTop <
        this.container.clientHeight + 100) {

        this._scrollToBottom();
      }
    }
  }

  _scrollToBottom() {
    // Scroll to bottom after 120 ms.
    setTimeout(() => { this.container.scrollTop = this.container.scrollHeight; }, 120);
  }

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
