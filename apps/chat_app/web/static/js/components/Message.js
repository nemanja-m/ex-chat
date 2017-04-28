import React from 'react';
import moment from 'moment';

const showMessage = (content, sender, receiver, fromCurrentUser) => {
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
  <div style={{ display: 'flex', marginBottom: '10px' }}>
    <div>
      <div style={{ lineHeight: '1.2' }}>
        <b style={{ marginRight: '8px', fontSize: '14px' }}>
          { showMessage(content, sender, receiver, fromCurrentUser) }
        </b>
        <time style={{ fontSize: '12px', color: 'rgb(192,192,192)' }}>
          {moment(date).format('h:mm A')}
        </time>
      </div>
      <div>{content}</div>
    </div>
  </div>;

export default Message;
