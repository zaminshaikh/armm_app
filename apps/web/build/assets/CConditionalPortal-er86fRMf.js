import{r as v,R as l,z as N,_ as g,a as k,c as O,P as c,e as _}from"./index-XZRXeKYy.js";function I(){for(var e=[],o=0;o<arguments.length;o++)e[o]=arguments[o];return v.useMemo(function(){return e.every(function(a){return a==null})?null:function(a){e.forEach(function(i){L(i,a)})}},e)}function L(e,o){if(e!=null)if(U(e))e(o);else try{e.current=o}catch{throw new Error('Cannot assign value "'.concat(o,'" to ref "').concat(e,'"'))}}function U(e){return!!(e&&{}.toString.call(e)=="[object Function]")}function F(e,o){if(e==null)return{};var a={};for(var i in e)if({}.hasOwnProperty.call(e,i)){if(o.includes(i))continue;a[i]=e[i]}return a}function C(e,o){return C=Object.setPrototypeOf?Object.setPrototypeOf.bind():function(a,i){return a.__proto__=i,a},C(e,o)}function G(e,o){e.prototype=Object.create(o.prototype),e.prototype.constructor=e,C(e,o)}var S={disabled:!1},R=l.createContext(null),j=function(o){return o.scrollTop},b="unmounted",f="exited",d="entering",m="entered",T="exiting",p=function(e){G(o,e);function o(i,n){var t;t=e.call(this,i,n)||this;var r=n,s=r&&!r.isMounting?i.enter:i.appear,u;return t.appearStatus=null,i.in?s?(u=f,t.appearStatus=d):u=m:i.unmountOnExit||i.mountOnEnter?u=b:u=f,t.state={status:u},t.nextCallback=null,t}o.getDerivedStateFromProps=function(n,t){var r=n.in;return r&&t.status===b?{status:f}:null};var a=o.prototype;return a.componentDidMount=function(){this.updateStatus(!0,this.appearStatus)},a.componentDidUpdate=function(n){var t=null;if(n!==this.props){var r=this.state.status;this.props.in?r!==d&&r!==m&&(t=d):(r===d||r===m)&&(t=T)}this.updateStatus(!1,t)},a.componentWillUnmount=function(){this.cancelNextCallback()},a.getTimeouts=function(){var n=this.props.timeout,t,r,s;return t=r=s=n,n!=null&&typeof n!="number"&&(t=n.exit,r=n.enter,s=n.appear!==void 0?n.appear:r),{exit:t,enter:r,appear:s}},a.updateStatus=function(n,t){if(n===void 0&&(n=!1),t!==null)if(this.cancelNextCallback(),t===d){if(this.props.unmountOnExit||this.props.mountOnEnter){var r=this.props.nodeRef?this.props.nodeRef.current:N.findDOMNode(this);r&&j(r)}this.performEnter(n)}else this.performExit();else this.props.unmountOnExit&&this.state.status===f&&this.setState({status:b})},a.performEnter=function(n){var t=this,r=this.props.enter,s=this.context?this.context.isMounting:n,u=this.props.nodeRef?[s]:[N.findDOMNode(this),s],h=u[0],x=u[1],y=this.getTimeouts(),M=s?y.appear:y.enter;if(!n&&!r||S.disabled){this.safeSetState({status:m},function(){t.props.onEntered(h)});return}this.props.onEnter(h,x),this.safeSetState({status:d},function(){t.props.onEntering(h,x),t.onTransitionEnd(M,function(){t.safeSetState({status:m},function(){t.props.onEntered(h,x)})})})},a.performExit=function(){var n=this,t=this.props.exit,r=this.getTimeouts(),s=this.props.nodeRef?void 0:N.findDOMNode(this);if(!t||S.disabled){this.safeSetState({status:f},function(){n.props.onExited(s)});return}this.props.onExit(s),this.safeSetState({status:T},function(){n.props.onExiting(s),n.onTransitionEnd(r.exit,function(){n.safeSetState({status:f},function(){n.props.onExited(s)})})})},a.cancelNextCallback=function(){this.nextCallback!==null&&(this.nextCallback.cancel(),this.nextCallback=null)},a.safeSetState=function(n,t){t=this.setNextCallback(t),this.setState(n,t)},a.setNextCallback=function(n){var t=this,r=!0;return this.nextCallback=function(s){r&&(r=!1,t.nextCallback=null,n(s))},this.nextCallback.cancel=function(){r=!1},this.nextCallback},a.onTransitionEnd=function(n,t){this.setNextCallback(t);var r=this.props.nodeRef?this.props.nodeRef.current:N.findDOMNode(this),s=n==null&&!this.props.addEndListener;if(!r||s){setTimeout(this.nextCallback,0);return}if(this.props.addEndListener){var u=this.props.nodeRef?[this.nextCallback]:[r,this.nextCallback],h=u[0],x=u[1];this.props.addEndListener(h,x)}n!=null&&setTimeout(this.nextCallback,n)},a.render=function(){var n=this.state.status;if(n===b)return null;var t=this.props,r=t.children;t.in,t.mountOnEnter,t.unmountOnExit,t.appear,t.enter,t.exit,t.timeout,t.addEndListener,t.onEnter,t.onEntering,t.onEntered,t.onExit,t.onExiting,t.onExited,t.nodeRef;var s=F(t,["children","in","mountOnEnter","unmountOnExit","appear","enter","exit","timeout","addEndListener","onEnter","onEntering","onEntered","onExit","onExiting","onExited","nodeRef"]);return l.createElement(R.Provider,{value:null},typeof r=="function"?r(n,s):l.cloneElement(l.Children.only(r),s))},o}(l.Component);p.contextType=R;p.propTypes={};function E(){}p.defaultProps={in:!1,mountOnEnter:!1,unmountOnExit:!1,appear:!1,enter:!0,exit:!0,onEnter:E,onEntering:E,onEntered:E,onExit:E,onExiting:E,onExited:E};p.UNMOUNTED=b;p.EXITED=f;p.ENTERING=d;p.ENTERED=m;p.EXITING=T;var D=v.forwardRef(function(e,o){var a=e.className,i=e.dark,n=e.disabled,t=e.white,r=g(e,["className","dark","disabled","white"]);return l.createElement("button",k({type:"button",className:O("btn","btn-close",{"btn-close-white":t},n,a),"aria-label":"Close",disabled:n},i&&{"data-coreui-theme":"dark"},r,{ref:o}))});D.propTypes={className:c.string,dark:c.bool,disabled:c.bool,white:c.bool};D.displayName="CCloseButton";var w=v.forwardRef(function(e,o){var a=e.className,i=a===void 0?"modal-backdrop":a,n=e.visible,t=g(e,["className","visible"]),r=v.useRef(null),s=I(o,r);return l.createElement(p,{in:n,mountOnEnter:!0,nodeRef:r,timeout:150,unmountOnExit:!0},function(u){return l.createElement("div",k({className:O(i,"fade",{show:u==="entered"})},t,{ref:s}))})});w.propTypes={className:c.string,visible:c.bool};w.displayName="CBackdrop";var B=function(e){return e?typeof e=="function"?e():e:document.body},P=function(e){var o=e.children,a=e.container,i=e.portal,n=v.useState(null),t=n[0],r=n[1];return v.useEffect(function(){i&&r(B(a)||document.body)},[a,i]),typeof window<"u"&&i&&t?_.createPortal(o,t):l.createElement(l.Fragment,null,o)};P.propTypes={children:c.node,container:c.any,portal:c.bool.isRequired};P.displayName="CConditionalPortal";export{P as C,p as T,G as _,w as a,D as b,F as c,j as f,I as u};
