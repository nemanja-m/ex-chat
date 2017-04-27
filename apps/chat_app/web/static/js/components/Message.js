import React from 'react';

const Message = ({ message: { content, date, user } }) =>
  <div style={{ display: 'flex', marginBottom: '10px' }}>
    <div>
      <div style={{ lineHeight: '1.2' }}>
        <b style={{ marginRight: '8px', fontSize: '14px' }}>{user.username}</b>
      </div>
      <div>{content}</div>
    </div>
  </div>;

export default Message;
