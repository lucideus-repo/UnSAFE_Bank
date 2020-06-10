// @ts-nocheck
// @ts-ignore
Object.defineProperty(exports, '__esModule', {
  value: true
});
var _createClass = (function() {
  function defineProperties(target, props) {
    for (var i = 0; i < props.length; i++) {
      var descriptor = props[i];
      descriptor.enumerable = descriptor.enumerable || false;
      descriptor.configurable = true;
      if ('value' in descriptor) descriptor.writable = true;
      Object.defineProperty(target, descriptor.key, descriptor);
    }
  }
  return function(Constructor, protoProps, staticProps) {
    if (protoProps) defineProperties(Constructor.prototype, protoProps);
    if (staticProps) defineProperties(Constructor, staticProps);
    return Constructor;
  };
})();

var _react = require('react');

var _react2 = _interopRequireDefault(_react);

var _propTypes = require('prop-types');

var _propTypes2 = _interopRequireDefault(_propTypes);

var _reactRouterDom = require('react-router-dom');

var _reactRouter = require('react-router');

var _classnames = require('classnames');

var _classnames2 = _interopRequireDefault(_classnames);

function _interopRequireDefault(obj) {
  return obj && obj.__esModule ? obj : { default: obj };
}

function _classCallCheck(instance, Constructor) {
  if (!(instance instanceof Constructor)) {
    throw new TypeError('Cannot call a class as a function');
  }
}

function _possibleConstructorReturn(self, call) {
  if (!self) {
    throw new ReferenceError(
      "this hasn't been initialised - super() hasn't been called"
    );
  }
  return call && (typeof call === 'object' || typeof call === 'function')
    ? call
    : self;
}

function _inherits(subClass, superClass) {
  if (typeof superClass !== 'function' && superClass !== null) {
    throw new TypeError(
      'Super expression must either be null or a function, not ' +
        typeof superClass
    );
  }
  subClass.prototype = Object.create(superClass && superClass.prototype, {
    constructor: {
      value: subClass,
      enumerable: false,
      writable: true,
      configurable: true
    }
  });
  if (superClass)
    Object.setPrototypeOf
      ? Object.setPrototypeOf(subClass, superClass)
      : (subClass.__proto__ = superClass);
}
/**
 * src/RouterLink.jsx
 * Author: H.Alper Tuna <halpertuna@gmail.com>
 * Date: 08.09.2016
 */

const RouterLink = (function(_React$Component) {
  _inherits(RouterLink, _React$Component);

  function RouterLink() {
    _classCallCheck(this, RouterLink);

    return _possibleConstructorReturn(
      this,
      (RouterLink.__proto__ || Object.getPrototypeOf(RouterLink)).apply(
        this,
        arguments
      )
    );
  }

  _createClass(RouterLink, [
    {
      key: 'UNSAFE_componentWillMount',
      value: function UNSAFE_componentWillMount() {
        this.to = this.props.to;
        if (this.to[0] !== '/') this.to = '/' + this.to;

        this.props.history.listen(this.onLocationChange.bind(this));
        this.onLocationChange(this.props.location);
      }
    },
    {
      key: 'onLocationChange',
      value: function onLocationChange(e) {
        if ((e.pathname || '/') === this.to) {
          this.props.activateMe();
        }
      }
    },
    {
      key: 'render',
      value: function render() {
        var _props = this.props,
          className = _props.className,
          classNameActive = _props.classNameActive,
          classNameHasActiveChild = _props.classNameHasActiveChild,
          active = _props.active,
          hasActiveChild = _props.hasActiveChild,
          to = _props.to,
          externalLink = _props.externalLink,
          hasSubMenu = _props.hasSubMenu,
          toggleSubMenu = _props.toggleSubMenu,
          children = _props.children;

        return hasSubMenu || externalLink
          ? _react2.default.createElement(
              'a',
              {
                className: (0, _classnames2.default)(
                  className,
                  hasActiveChild && classNameHasActiveChild
                ),
                target: externalLink ? '_blank' : undefined,
                href: to,
                onClick: toggleSubMenu
              },
              children
            )
          : _react2.default.createElement(
              _reactRouterDom.Link,
              {
                className: (0, _classnames2.default)(
                  className,
                  active && classNameActive
                ),
                to: to
              },
              children
            );
      }
    }
  ]);

  return RouterLink;
})(_react2.default.Component);

RouterLink.propTypes = {
  className: _propTypes2.default.string.isRequired,
  classNameActive: _propTypes2.default.string.isRequired,
  classNameHasActiveChild: _propTypes2.default.string.isRequired,
  active: _propTypes2.default.bool.isRequired,
  hasActiveChild: _propTypes2.default.bool.isRequired,
  to: _propTypes2.default.string.isRequired,
  externalLink: _propTypes2.default.bool,
  hasSubMenu: _propTypes2.default.bool.isRequired,
  toggleSubMenu: _propTypes2.default.func,
  activateMe: _propTypes2.default.func.isRequired,
  children: _propTypes2.default.oneOfType([
    _propTypes2.default.element,
    _propTypes2.default.array
  ]).isRequired,
  location: _propTypes2.default.object.isRequired,
  history: _propTypes2.default.object.isRequired
};

exports.default = (0, _reactRouter.withRouter)(RouterLink);
