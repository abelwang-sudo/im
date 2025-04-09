/**
 * WebSocketService - 基于原生WebSocket的服务
 * 提供连接管理、消息发送和接收、自动重连以及心跳检测功能
 */
import { useUserStore } from '@/stores/user';

class WebSocketService {
  constructor(url) {
    this.url = url;
    this.socket = null;
    this.isConnected = false;
    this.reconnectAttempts = 0;
    this.maxReconnectAttempts = 5;
    this.reconnectInterval = 3000; // 重连间隔，单位毫秒
    this.heartbeatInterval = 30000; // 心跳间隔，单位毫秒（30秒）
    this.heartbeatTimer = null;
    this.reconnectTimer = null;
    this.messageListeners = {}; // 消息监听器
    this.connectionListeners = []; // 连接状态监听器
    this.reconnectFailureListeners = []; // 重连失败监听器
    this.isManualDisconnect = false; // 是否是主动断开连接
  }

  /**
   * 连接WebSocket服务器
   */
  connect() {
    if (this.socket && (this.socket.readyState === WebSocket.CONNECTING || this.socket.readyState === WebSocket.OPEN)) {
      console.log('WebSocket已连接或正在连接中');
      return;
    }

    try {
      const token = localStorage.getItem('token');

      // 连接成功后创建WebSocket
      this.socket = new WebSocket(this.url + '?token=' + token);

      this.socket.onopen = () => {
        console.log('WebSocket连接已建立');
        this.isConnected = true;
        this.reconnectAttempts = 0;
        this._startHeartbeat();
        this._notifyConnectionListeners(true);
      };

      this.socket.onmessage = (event) => {
        try {
          const message = JSON.parse(event.data);
          this._handleMessage(message);
        } catch (error) {
          console.error('解析消息失败:', error);
        }
      };

      this.socket.onclose = (event) => {
        console.log(`WebSocket连接已关闭: ${event.code} ${event.reason}`);
        this.isConnected = false;
        this._stopHeartbeat();
        this._notifyConnectionListeners(false);
        if (!this.isManualDisconnect) {
          this._reconnect();
        }
        this.isManualDisconnect = false; // 重置标志位
      };

      this.socket.onerror = (error) => {
        console.error('WebSocket错误:', error);
      };

    } catch (error) {
      console.error('创建WebSocket连接失败:', error);
      this._reconnect();
    }
  }

  /**
   * 断开WebSocket连接
   */
  disconnect() {
    this._stopHeartbeat();
    if (this.reconnectTimer) {
      clearTimeout(this.reconnectTimer);
      this.reconnectTimer = null;
    }

    if (this.socket) {
      this.isManualDisconnect = true; // 标记为主动断开连接
      this.socket.close();
      this.socket = null;
    }
    this.isConnected = false;
    this._notifyConnectionListeners(false);
  }

  /**
   * 发送消息到服务器
   * @param {string} type - 消息类型
   * @param {object} payload - 消息内容
   * @returns {boolean} - 发送是否成功
   */
  send(type, payload,conversationId) {
    if (!this.isConnected) {
      console.warn('WebSocket未连接，无法发送消息');
      return false;
    }

    const userStore = useUserStore();

    const messageMap = {
      type,
      sender: Number(userStore.id),
      senderNickname: userStore.nickname,
      timestamp: new Date().getTime(),
    };

    if (userStore.avatar) {
      messageMap['senderAvatar'] = userStore.avatar;
    }

    if(payload!=null){
      messageMap['content'] = payload
    }
    messageMap['conversationId'] = conversationId

    const message = JSON.stringify(messageMap);
    this.socket.send(message);
    return messageMap;
  }

  /**
   * 添加连接状态监听器
   * @param {function} callback - 回调函数，参数为连接状态(boolean)
   */
  addConnectionListener(callback) {
    this.connectionListeners.push(callback);
    // 立即通知当前状态
    callback(this.isConnected);
  }

  /**
   * 移除连接状态监听器
   * @param {function} callback - 回调函数
   */
  removeConnectionListener(callback) {
    this.connectionListeners = this.connectionListeners.filter(cb => cb !== callback);
  }

  /**
   * 处理接收到的消息
   * @private
   * @param {object} message - 消息对象
   */
  _handleMessage(message) {

    // 处理心跳响应
    if (message.type === 'pong') {
      console.log('收到心跳响应');
      return;
    }

    // 处理NOTICE类型的消息
    if (message.type === 'NOTICE') {
      if (message.content?.type === 'CONTACT') {
        const action = message.content.action;
        // 根据action类型触发不同的刷新操作
        if (this.messageListeners['CONTACT_UPDATE']) {
          this.messageListeners['CONTACT_UPDATE'].forEach(callback => {
            try {
              callback({ action, data: message.content });
            } catch (error) {
              console.error('执行联系人更新回调出错:', error);
            }
          });
        }
      } else if (message.content?.type === 'CONVERSATION') {
        // 处理会话更新消息
        if (this.messageListeners['CONVERSATION']) {
          this.messageListeners['CONVERSATION'].forEach(callback => {
            try {
              callback(message);
            } catch (error) {
              console.error('执行会话更新回调出错:', error);
            }
          });
        }
      }
    }

    // 分发消息给订阅者
    const { type } = message;

    if (type && this.messageListeners[type]) {
      this.messageListeners[type].forEach(callback => {
        try {
          callback(message);
        } catch (error) {
          console.error(`执行消息回调出错 (type: ${type}):`, error);
        }
      });
    }

    // 全局消息监听
    if (this.messageListeners['*']) {
      this.messageListeners['*'].forEach(callback => {
        try {
          callback(message);
        } catch (error) {
          console.error('执行全局消息回调出错:', error);
        }
      });
    }
  }

  /**
   * 添加重连失败监听器
   * @param {function} callback - 回调函数
   */
  addReconnectFailureListener(callback) {
    this.reconnectFailureListeners.push(callback);
  }

  /**
   * 移除重连失败监听器
   * @param {function} callback - 回调函数
   */
  removeReconnectFailureListener(callback) {
    this.reconnectFailureListeners = this.reconnectFailureListeners.filter(cb => cb !== callback);
  }

  /**
   * 手动重新连接
   * 重置重连计数器并尝试重新连接
   */
  manualReconnect() {
    this.reconnectAttempts = 0;
    if (this.reconnectTimer) {
      clearTimeout(this.reconnectTimer);
      this.reconnectTimer = null;
    }
    this.connect();
  }

  /**
   * 尝试重新连接
   * @private
   */
  _reconnect() {
    if (this.reconnectTimer || this.reconnectAttempts >= this.maxReconnectAttempts) {
      if (this.reconnectAttempts >= this.maxReconnectAttempts) {
        console.log('达到最大重连次数，停止重连');
        this._handleReconnectFailureUI();
      }
      return;
    }

    this.reconnectAttempts++;
    console.log(`尝试重新连接... (${this.reconnectAttempts}/${this.maxReconnectAttempts})`);

    this.reconnectTimer = setTimeout(() => {
      this.reconnectTimer = null;
      this.connect();
    }, this.reconnectInterval);
  }

  /**
   * 开始心跳检测
   * @private
   */
  _startHeartbeat() {
    this._stopHeartbeat();
    this.heartbeatTimer = setInterval(() => {
      if (this.isConnected) {
        this.send('PING');
      }
    }, this.heartbeatInterval);
  }

  /**
   * 停止心跳检测
   * @private
   */
  _stopHeartbeat() {
    if (this.heartbeatTimer) {
      clearInterval(this.heartbeatTimer);
      this.heartbeatTimer = null;
    }
  }

  /**
   * 通知所有重连失败监听器
   * @private
   */
  _notifyReconnectFailure() {
    this.reconnectFailureListeners.forEach(callback => {
      try {
        callback();
      } catch (error) {
        console.error('执行重连失败回调出错:', error);
      }
    });
  }

  /**
   * 通知所有连接状态监听器
   * @private
   * @param {boolean} status - 连接状态
   */
  _notifyConnectionListeners(status) {
    this.connectionListeners.forEach(callback => {
      try {
        callback(status);
      } catch (error) {
        console.error('执行连接状态回调出错:', error);
      }
    });
  }


  /**
   * 处理重连失败的UI状态
   * @private
   */
  _handleReconnectFailureUI() {
    // 触发重连失败事件
    this._notifyReconnectFailure();
  }

  logOut(){
    // 清空所有消息监听器
    this.messageListeners = {};
    // 清空连接状态监听器
    this.connectionListeners = [];
    // 清空重连失败监听器
    this.reconnectFailureListeners = [];
    this.isManualDisconnect = true; // 标记为主动断开连接
    this.disconnect();
  }
}

// 导出单例实例
let instance = null;

export default {
  /**
   * 初始化WebSocket服务
   * @param {string} url - WebSocket服务器URL
   * @returns {WebSocketService} - WebSocketService实例
   */
  init(url) {
    if (!instance) {
      console.log('WebSocketService初始化');
      instance = new WebSocketService(url);
    } else {
      console.log('WebSocketService已存在，更新URL');
      instance.url = url;
    }
    return instance;
  },

  /**
   * 初始化WebSocket服务并设置用户相关的监听器
   * @param {string} url - WebSocket服务器URL
   * @param {object} stores - 包含contactsStore和conversationStore的对象
   * @param {function} onReconnectFailure - 重连失败时的回调函数
   */
  initializeForUser(url, { contactsStore, conversationStore }, onReconnectFailure) {
    const wsInstance = this.init(url);
    if (wsInstance) {
      wsInstance.connect();
      // 订阅联系人更新消息
      wsInstance.messageListeners['CONTACT_UPDATE'] = [contactsStore.handleContactUpdate];
      // 订阅会话更新消息
      wsInstance.messageListeners['CONVERSATION'] = [conversationStore.handleConversationUpdate];
      // 订阅用户状态变更消息
      wsInstance.messageListeners['JOIN'] = [contactsStore.handleUserStatusUpdate];
      wsInstance.messageListeners['LEAVE'] = [contactsStore.handleUserStatusUpdate];
      // 添加连接状态监听
      wsInstance.connectionListeners.push((connected) => {
        if (!connected) {
          console.warn('WebSocket连接断开，正在尝试重连...');
        }
      });
      // 添加重连失败监听
      wsInstance.addReconnectFailureListener(onReconnectFailure);
    }
    return wsInstance;
  },

  /**
   * 获取WebSocketService实例
   * @returns {WebSocketService|null} - WebSocketService实例
   */
  getInstance() {
    return instance;
  }
};
