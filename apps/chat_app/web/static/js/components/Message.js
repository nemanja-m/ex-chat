import React from 'react';
import moment from 'moment';

const styles = {
  message: {
    display: 'flex',
    margin: '0px -5px 10px -5px'
  }
}

const showSender = (content, sender, receiver, fromCurrentUser) => {
  if (receiver) {
    return (
      <span>
        <strong className="text-success">[PRIVATE] &nbsp;</strong>
        {sender.username}
      </span>
    );
  } else {
    return fromCurrentUser ? 'me' : sender.username
  }
};

const Message = ({ message: { content, date, sender, receiver }, fromCurrentUser }) =>
  <div style={ styles.message }>
    <div>
      <div style={{ lineHeight: '1.5' }}>
        <b style={{ marginRight: '8px', fontSize: '15px' }}>
          { showSender(content, sender, receiver, fromCurrentUser) }
        </b>
        <time style={{ fontSize: '12px', color: 'rgb(192,192,192)' }}>
          {moment(date).format('h:mm A')}
        </time>
      </div>
      <p style={{ wordWrap: 'break-word' }}>{content}</p>
    </div>
  </div>;

export default Message;
