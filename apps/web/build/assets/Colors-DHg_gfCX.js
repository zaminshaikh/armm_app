import{j as r,r as t,P as l}from"./index-JP7vHK7p.js";import{c as d}from"./index-DJOI3bFX.js";import{C as i,a as h}from"./CCardBody-DWGribh8.js";import{C as m}from"./CCardHeader-crhIskI5.js";import{C as x,a as j}from"./CRow-DiOC5DSN.js";import{g}from"./getStyle-D6NZA7w8.js";var p=function(s){if(typeof s>"u")throw new TypeError("Hex color is not defined");if(s==="transparent")return"#00000000";var n=s.match(/^rgba?[\s+]?\([\s+]?(\d+)[\s+]?,[\s+]?(\d+)[\s+]?,[\s+]?(\d+)[\s+]?/i);if(!n)throw new Error("".concat(s," is not a valid rgb color"));var e="0".concat(parseInt(n[1],10).toString(16)),c="0".concat(parseInt(n[2],10).toString(16)),o="0".concat(parseInt(n[3],10).toString(16));return"#".concat(e.slice(-2)).concat(c.slice(-2)).concat(o.slice(-2))};const C=()=>{const[s,n]=t.useState("rgb(255, 255, 255)"),e=t.createRef();return t.useEffect(()=>{const c=e.current&&e.current.parentNode&&e.current.parentNode.firstElementChild;if(c){const o=g("background-color",c);o&&n(o)}},[e]),r.jsx("table",{className:"table w-100",ref:e,children:r.jsxs("tbody",{children:[r.jsxs("tr",{children:[r.jsx("td",{className:"text-medium-emphasis",children:"HEX:"}),r.jsx("td",{className:"font-weight-bold",children:p(s)})]}),r.jsxs("tr",{children:[r.jsx("td",{className:"text-medium-emphasis",children:"RGB:"}),r.jsx("td",{className:"font-weight-bold",children:s})]})]})})},a=({className:s,children:n})=>{const e=d(s,"theme-color w-75 rounded mb-3");return r.jsxs(j,{xs:12,sm:6,md:4,xl:2,className:"mb-4",children:[r.jsx("div",{className:e,style:{paddingTop:"75%"}}),n,r.jsx(C,{})]})};a.propTypes={children:l.node,className:l.string};const B=()=>r.jsx(r.Fragment,{children:r.jsxs(i,{className:"mb-4",children:[r.jsx(m,{children:"Theme colors"}),r.jsx(h,{children:r.jsxs(x,{children:[r.jsx(a,{className:"bg-primary",children:r.jsx("h6",{children:"Brand Primary Color"})}),r.jsx(a,{className:"bg-secondary",children:r.jsx("h6",{children:"Brand Secondary Color"})}),r.jsx(a,{className:"bg-success",children:r.jsx("h6",{children:"Brand Success Color"})}),r.jsx(a,{className:"bg-danger",children:r.jsx("h6",{children:"Brand Danger Color"})}),r.jsx(a,{className:"bg-warning",children:r.jsx("h6",{children:"Brand Warning Color"})}),r.jsx(a,{className:"bg-info",children:r.jsx("h6",{children:"Brand Info Color"})}),r.jsx(a,{className:"bg-light",children:r.jsx("h6",{children:"Brand Light Color"})}),r.jsx(a,{className:"bg-dark",children:r.jsx("h6",{children:"Brand Dark Color"})})]})})]})});export{B as default};
