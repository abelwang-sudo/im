/**
 * localStorage工具类
 * 用于处理localStorage中所有字段的存储和获取
 * 确保在存储前检查值是否为null或undefined
 */

export default {
  /**
   * 保存数据到localStorage
   * @param {string} key - 键名
   * @param {any} value - 要保存的值
   * @param {string} defaultValue - 当值为null或undefined时使用的默认值
   */
  set(key, value, defaultValue = '') {
    // 检查值是否为null或undefined，如果是则使用默认值
    const valueToStore = value === null || value === undefined ? defaultValue : value;
    localStorage.setItem(key, valueToStore);
  },

  /**
   * 从localStorage获取数据
   * @param {string} key - 键名
   * @param {string} defaultValue - 当值不存在时返回的默认值
   * @returns {string} 存储的值或默认值
   */
  get(key, defaultValue = '') {
    const value = localStorage.getItem(key);
    return value === null ? defaultValue : value;
  },

  /**
   * 从localStorage删除数据
   * @param {string} key - 键名
   */
  remove(key) {
    localStorage.removeItem(key);
  },

  /**
   * 清除所有localStorage数据
   */
  clear() {
    localStorage.clear();
  },

  /**
   * 批量保存数据到localStorage
   * @param {Object} data - 键值对对象
   * @param {string} defaultValue - 当值为null或undefined时使用的默认值
   */
  setMultiple(data, defaultValue = '') {
    if (data && typeof data === 'object') {
      Object.keys(data).forEach(key => {
        this.set(key, data[key], defaultValue);
      });
    }
  },

  /**
   * 批量从localStorage删除数据
   * @param {Array} keys - 键名数组
   */
  removeMultiple(keys) {
    if (Array.isArray(keys)) {
      keys.forEach(key => {
        this.remove(key);
      });
    }
  }
};