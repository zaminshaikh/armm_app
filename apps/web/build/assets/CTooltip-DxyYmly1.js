import{r as n,_ as G,R as o,a as s,c as J,P as e,l as K,z as Q}from"./index-JP7vHK7p.js";import{Y as U,a5 as W,a6 as X}from"./ProBadge-BSKes2oQ.js";import{g as Z,e as $}from"./getRTLPlacement-D2xrllku.js";var x=n.forwardRef(function(t,F){var M=t.children,h=t.animation,O=h===void 0?!0:h,_=t.className,q=t.container,v=t.content,b=t.delay,l=b===void 0?0:b,g=t.fallbackPlacements,L=g===void 0?["top","right","bottom","left"]:g,P=t.offset,j=P===void 0?[0,6]:P,y=t.onHide,w=t.onShow,k=t.placement,z=k===void 0?"top":k,E=t.trigger,r=E===void 0?["hover","focus"]:E,d=t.visible,A=G(t,["children","animation","className","container","content","delay","fallbackPlacements","offset","onHide","onShow","placement","trigger","visible"]),i=n.useRef(null),a=n.useRef(null),B=U(F,i),R="tooltip".concat(n.useId()),T=n.useState(!1),f=T[0],N=T[1],C=n.useState(d),c=C[0],S=C[1],m=W(),I=m.initPopper,V=m.destroyPopper,Y=m.updatePopper,H=typeof l=="number"?{show:l,hide:l}:l,D={modifiers:[{name:"arrow",options:{element:".tooltip-arrow"}},{name:"flip",options:{fallbackPlacements:L}},{name:"offset",options:{offset:j}}],placement:Z(z,a.current)};n.useEffect(function(){if(d){u();return}p()},[d]),n.useEffect(function(){if(f&&a.current&&i.current){I(a.current,i.current,D),setTimeout(function(){S(!0)},H.show);return}!f&&a.current&&i.current&&V()},[f]),n.useEffect(function(){!c&&a.current&&i.current&&$(function(){N(!1)},i.current)},[c]);var u=function(){N(!0),w&&w()},p=function(){setTimeout(function(){S(!1),y&&y()},H.hide)};return n.useEffect(function(){Y()},[v]),o.createElement(o.Fragment,null,o.cloneElement(M,s(s(s(s(s({},c&&{"aria-describedby":R}),{ref:a}),(r==="click"||r.includes("click"))&&{onClick:function(){return c?p():u()}}),(r==="focus"||r.includes("focus"))&&{onFocus:function(){return u()},onBlur:function(){return p()}}),(r==="hover"||r.includes("hover"))&&{onMouseEnter:function(){return u()},onMouseLeave:function(){return p()}})),o.createElement(X,{container:q,portal:!0},f&&o.createElement("div",s({className:J("tooltip","bs-tooltip-auto",{fade:O,show:c},_),id:R,ref:B,role:"tooltip"},A),o.createElement("div",{className:"tooltip-arrow"}),o.createElement("div",{className:"tooltip-inner"},v))))});x.propTypes={animation:e.bool,children:e.node,container:e.any,content:e.oneOfType([e.string,e.node]),delay:e.oneOfType([e.number,e.shape({show:e.number.isRequired,hide:e.number.isRequired})]),fallbackPlacements:Q,offset:e.any,onHide:e.func,onShow:e.func,placement:e.oneOf(["auto","top","right","bottom","left"]),trigger:K,visible:e.bool};x.displayName="CTooltip";export{x as C};
