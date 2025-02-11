import{r as d,_ as re,R as u,a as H,P as t,y as v,c as $,j as a}from"./index-JP7vHK7p.js";import"./index.esm-2WuAEctV.js";import{a5 as mt,a7 as bt,a6 as vt,$ as Pe,Q as ht,R as qe}from"./ProBadge-BSKes2oQ.js";import{C as ne,a as D}from"./CRow-DiOC5DSN.js";import{C as He,a as Ke}from"./CCardBody-DWGribh8.js";import{C as Fe}from"./CCardHeader-crhIskI5.js";import{C as Be}from"./CFormControlWrapper-BwCbgVGS.js";import{C as gt}from"./CElementCover-CaWRpCTo.js";import{C as yt}from"./CVirtualScroller-BL85aaRm.js";import"./cil-user-Dlmw-Gem.js";import"./CFormControlValidation-DMsp6aWR.js";var We=function(e){return e&&e.map(function(l,r){return l.options?u.createElement("optgroup",{label:l.label,key:r},We(l.options)):u.createElement("option",{value:l.value,key:r,disabled:l.disabled},l.label)})},le=d.forwardRef(function(e,l){var r=e.id,s=e.name,o=e.options,i=re(e,["id","name","options"]);return u.createElement("select",H({id:r},r&&!s&&{name:"".concat(r,"-multi-select")},s&&{name:s},{tabIndex:-1,style:{display:"none"}},i,{ref:l}),o&&We(o))});le.propTypes={id:t.string,name:t.string,options:t.array,value:t.oneOfType([t.number,t.string,t.arrayOf(t.string.isRequired)])};le.displayName="CMultiSelectNativeSelect";var xt=function(e,l){for(var r=e.toLowerCase().replace(/\s/g,"-"),s=r,o=1;l.some(function(i){return String(i.value)===s});)s="".concat(r,"-").concat(o),o++;return[{value:s,label:e,custom:!0}]},Ge=function(e,l){if(e.length>0&&l){for(var r=[],s=0,o=l;s<o.length;s++){var i=o[s],p=i.options&&i.options.filter(function(m){return m.label&&m.label.toLowerCase().includes(e.toLowerCase())});(i.label&&i.label.toLowerCase().includes(e.toLowerCase())||p&&p.length>0)&&r.push(Object.assign({},i,p&&p.length>0&&{options:p}))}return r}return l},Ve=function(e,l){for(var r=[],s=0,o=e;s<o.length;s++){var i=o[s];if(Array.isArray(i.options)){var p=i.options,m=re(i,["options"]);l&&r.push(m),r.push.apply(r,p)}else r.push(i)}return r},wt=function(e,l){for(var r=e.nextElementSibling;r;){if(r.matches(l))return r;r=r.nextElementSibling}},Ue=function(e){return Array.from(e.querySelectorAll(".form-multi-select-option:not(.disabled):not(:disabled)"))},Ct=function(e,l){for(var r=e.previousElementSibling;r;){if(r.matches(l))return r;r=r.previousElementSibling}},St=function(e){return typeof e=="string"&&e==="external"||typeof e=="object"&&e.external===!0},Et=function(e){return typeof e=="string"&&e==="global"||typeof e=="object"&&e.global===!0},ze=function(e,l,r,s){if(!e)return[l[0]];var o=v(v([],r,!0),l,!0);s&&(o=o.filter(function(g){return!s.some(function(b){return b.value===g.value})}));for(var i=[],p=function(g){i.some(function(b){return b.value===g.value})||i.push(g)},m=0,E=o;m<E.length;m++){var h=E[m];p(h)}return i},oe=d.forwardRef(function(e,l){var r=e.loading,s=e.onKeyDown,o=e.onOptionOnClick,i=e.options,p=e.optionsMaxHeight,m=e.optionsStyle,E=e.optionsTemplate,h=e.optionsGroupsTemplate,g=e.searchNoResultsLabel,b=e.selected,w=e.virtualScroller,O=e.visibleItems,F=O===void 0?10:O,M=function(f,C){if((f.code==="Space"||f.key==="Enter")&&(f.preventDefault(),o&&o(C)),f.key==="Down"||f.key==="ArrowDown"){f.preventDefault();var R=f.target,x=wt(R,".form-multi-select-option");x&&x.focus()}if(f.key==="Up"||f.key==="ArrowUp"){f.preventDefault();var R=f.target,J=Ct(R,".form-multi-select-option");J&&J.focus()}},N=function(f){return f.length>0?f.map(function(C,R){return"value"in C?u.createElement("div",{className:$("form-multi-select-option",{"form-multi-select-option-with-checkbox":m==="checkbox","form-multi-selected":b.some(function(x){return x.value===C.value}),disabled:C.disabled}),key:R,onClick:function(){return o&&o(C)},onKeyDown:function(x){return M(x,C)},tabIndex:0},E?E(C):C.label):u.createElement("div",{className:"form-multi-select-optgroup-label",key:R},h?h(C):C.label)}):u.createElement("div",{className:"form-multi-select-options-empty"},g)};return u.createElement(u.Fragment,null,w?u.createElement(yt,{className:"form-multi-select-options",onKeyDown:s,visibleItems:F,ref:l},N(i)):u.createElement("div",H({className:"form-multi-select-options",onKeyDown:s},p!=="auto"&&{style:{maxHeight:p,overflow:"scroll"}},{ref:l}),N(i)),r&&u.createElement(gt,null))});oe.propTypes={loading:t.bool,onOptionOnClick:t.func,options:t.array.isRequired,optionsMaxHeight:t.oneOfType([t.number,t.string]),optionsStyle:t.oneOf(["checkbox","text"]),optionsTemplate:t.func,optionsGroupsTemplate:t.func,searchNoResultsLabel:t.oneOfType([t.string,t.node]),virtualScroller:t.bool,visibleItems:t.number};oe.displayName="CMultiSelectOptions";var ae=d.forwardRef(function(e,l){var r=e.children,s=e.disabled,o=e.multiple,i=e.placeholder,p=e.onRemove,m=e.search,E=e.selected,h=E===void 0?[]:E,g=e.selectionType,b=e.selectionTypeCounterText;return u.createElement("span",{className:$("form-multi-select-selection",{"form-multi-select-selection-tags":o&&g==="tags"}),ref:l},o&&g==="counter"&&!m&&h.length===0&&i,o&&g==="counter"&&!m&&h.length>0&&"".concat(h.length," ").concat(b),o&&g==="tags"&&h.map(function(w,O){if(g==="tags")return u.createElement("span",{className:"form-multi-select-tag",key:O},w.label,!s&&!w.disabled&&u.createElement("button",{className:"form-multi-select-tag-delete",type:"button","aria-label":"Close",onClick:function(){return p&&p(w)}}))}),o&&g==="text"&&h.map(function(w,O){return u.createElement("span",{key:O},w.label,O===h.length-1?"":","," ")}),!o&&!m&&h.map(function(w){return w.label})[0],r)});ae.propTypes={children:t.node,disabled:t.bool,multiple:t.bool,onRemove:t.func,placeholder:t.string,search:t.oneOfType([t.bool,t.oneOf(["external","global"]),t.shape({external:t.bool.isRequired,global:t.bool.isRequired})]),selected:t.array,selectionType:t.oneOf(["counter","tags","text"]),selectionTypeCounterText:t.string};ae.displayName="CMultiSelectSelection";var kt=function(e){var l=d.useRef(null),r=d.useRef(null),s=d.useState(!1),o=s[0],i=s[1],p=mt(),m=p.popper,E=p.initPopper,h=p.destroyPopper,g=H({placement:bt(l.current)?"bottom-end":"bottom-start",modifiers:[{name:"preventOverflow",options:{boundary:"clippingParents"}},{name:"offset",options:{offset:[0,2]}}]},e),b=function(){i(!1)},w=function(){i(!0)},O=function(){i(function(f){return!f})},F=function(){m&&m.update()},M=function(f){if(f.key==="Escape"){i(!1);return}if(f.key==="Tab"){if(l.current&&l.current.contains(document.activeElement)||r.current&&r.current.contains(document.activeElement))return;i(!1)}},N=function(f){r.current&&r.current.contains(f.target)||l.current&&l.current.contains(f.target)||i(!1)};return d.useEffect(function(){return o?(window.addEventListener("mouseup",N),window.addEventListener("keyup",M),l.current&&r.current&&E(l.current,r.current,g)):(window.removeEventListener("mouseup",N),window.removeEventListener("keyup",M),h()),function(){window.removeEventListener("mouseup",N),window.removeEventListener("keyup",M),h()}},[o]),{dropdownMenuElement:r,dropdownRefElement:l,isOpen:o,closeDropdown:b,openDropdown:w,toggleDropdown:O,updatePopper:F}},j=d.forwardRef(function(e,l){var r,s=e.allowCreateOptions,o=e.ariaCleanerLabel,i=o===void 0?"Clear all selections":o,p=e.className,m=e.cleaner,E=m===void 0?!0:m,h=e.clearSearchOnSelect,g=e.container,b=e.disabled,w=e.feedback,O=e.feedbackInvalid,F=e.feedbackValid,M=e.id,N=e.invalid,f=e.label,C=e.loading,R=e.multiple,x=R===void 0?!0:R,J=e.name,ie=e.onChange,se=e.onFilterChange,ue=e.onHide,ce=e.onShow,G=e.options,fe=e.optionsMaxHeight,Je=fe===void 0?"auto":fe,de=e.optionsStyle,Qe=de===void 0?"checkbox":de,$e=e.optionsTemplate,Xe=e.optionsGroupsTemplate,pe=e.placeholder,X=pe===void 0?"Select...":pe,me=e.portal,Y=me===void 0?!1:me,Ye=e.required,be=e.resetSelectionOnOptionsChange,Ze=be===void 0?!1:be,ve=e.search,K=ve===void 0?!0:ve,he=e.searchNoResultsLabel,_e=he===void 0?"No results found":he,ge=e.selectAll,et=ge===void 0?!0:ge,ye=e.selectAllLabel,tt=ye===void 0?"Select all options":ye,xe=e.selectionType,Z=xe===void 0?"tags":xe,we=e.selectionTypeCounterText,Ce=we===void 0?"item(s) selected":we,Se=e.size,nt=e.text,rt=e.tooltipFeedback,Ee=e.valid,lt=e.virtualScroller,ke=e.visible,Oe=ke===void 0?!1:ke,Te=e.visibleItems,ot=Te===void 0?10:Te,at=re(e,["allowCreateOptions","ariaCleanerLabel","className","cleaner","clearSearchOnSelect","container","disabled","feedback","feedbackInvalid","feedbackValid","id","invalid","label","loading","multiple","name","onChange","onFilterChange","onHide","onShow","options","optionsMaxHeight","optionsStyle","optionsTemplate","optionsGroupsTemplate","placeholder","portal","required","resetSelectionOnOptionsChange","search","searchNoResultsLabel","selectAll","selectAllLabel","selectionType","selectionTypeCounterText","size","text","tooltipFeedback","valid","virtualScroller","visible","visibleItems"]),I=kt(),P=I.dropdownMenuElement,_=I.dropdownRefElement,A=I.isOpen,De=I.closeDropdown,Q=I.openDropdown,it=I.toggleDropdown,st=I.updatePopper,ee=d.useRef(null),y=d.useRef(null),te=d.useRef(!0),je=d.useState(""),k=je[0],V=je[1],Ne=d.useState([]),c=Ne[0],T=Ne[1],Re=d.useState([]),q=Re[0],Le=Re[1],U=d.useMemo(function(){return Ve(St(K)?v(v([],G,!0),Ge(k,q),!0):Ge(k,v(v([],G,!0),q,!0)),!0)},[G,k,q]),z=d.useMemo(function(){return Ve(G)},[G]),B=d.useMemo(function(){return s&&U.some(function(n){return n.label&&n.label.toLowerCase()===k.toLowerCase()})?!1:y.current&&xt(String(k),z)},[U,k]);d.useEffect(function(){if(Ze)return T([]);var n=z.filter(function(L){return L.selected===!0}),S=z.filter(function(L){return L.selected===!1});n.length>0&&T(ze(x,n,c,S))},[z]),d.useEffect(function(){!te.current&&se&&se(k)},[k]),d.useEffect(function(){!te.current&&ee.current&&ee.current.dispatchEvent(new Event("change",{bubbles:!0})),st()},[JSON.stringify(c)]),d.useEffect(function(){Oe?Q():De()},[Oe]),d.useEffect(function(){var n;return A&&(ce&&ce(),Y&&P.current&&_.current&&(P.current.style.minWidth="".concat(_.current.offsetWidth,"px")),(n=y.current)===null||n===void 0||n.focus()),function(){ue&&ue(),V(""),y.current&&(y.current.value="")}},[A]),d.useEffect(function(){te.current=!1},[]);var ut=function(n){V(n.target.value)},ct=function(n){if(A||Q(),n.key==="ArrowDown"&&P.current&&y.current&&y.current.value.length===y.current.selectionStart){n.preventDefault();var S=Ue(P.current),L=n.target;Pe(S,L,n.key==="ArrowDown",!S.includes(L)).focus();return}if(n.key==="Enter"&&k&&s){n.preventDefault(),B&&(T(v(v([],c,!0),B,!0)),Le(v(v([],q,!0),B,!0))),B||T(v(v([],c,!0),[U.find(function(W){return String(W.label).toLowerCase()===k.toLowerCase()})],!1)),V(""),y.current&&(y.current.value="");return}if(!(k.length>0)&&(n.key==="Backspace"||n.key==="Delete")){var Ie=c.filter(function(W){return!W.disabled}).pop();Ie&&T(c.filter(function(W){return W.value!==Ie.value}))}},ft=function(n){if(!A&&(n.key==="Enter"||n.key==="ArrowDown")){n.preventDefault(),Q();return}if(A&&P.current&&n.key==="ArrowDown"){n.preventDefault();var S=Ue(P.current),L=n.target;Pe(S,L,n.key==="ArrowDown",!S.includes(L)).focus()}},Me=function(n){Et(K)&&y.current&&(n.key.length===1||n.key==="Backspace"||n.key==="Delete")&&y.current.focus()},Ae=function(n){if(!x){T([n]),De(),V(""),y.current&&(y.current.value="");return}n.custom&&!q.some(function(S){return S.value===n.value})&&Le(v(v([],q,!0),[n],!1)),(h||n.custom)&&(V(""),y.current&&(y.current.value="",y.current.focus())),c.some(function(S){return S.value===n.value})?T(c.filter(function(S){return S.value!==n.value})):T(v(v([],c,!0),[n],!1))},dt=function(){T(ze(x,v(v([],z.filter(function(n){return!n.disabled}),!0),q,!0),c))},pt=function(){T(c.filter(function(n){return n.disabled}))};return u.createElement(Be,{describedby:at["aria-describedby"],feedback:w,feedbackInvalid:O,feedbackValid:F,id:M,invalid:N,label:f,text:nt,tooltipFeedback:rt,valid:Ee},u.createElement(le,{id:M,multiple:x,name:J,options:c,required:Ye,value:x?c.map(function(n){return n.value.toString()}):c.map(function(n){return n.value})[0],onChange:function(){return ie&&ie(c)},ref:ee}),u.createElement("div",{className:$("form-multi-select",(r={},r["form-multi-select-".concat(Se)]=Se,r.disabled=b,r["is-invalid"]=N,r["is-valid"]=Ee,r.show=A,r),p),onKeyDown:Me,"aria-expanded":A,ref:l},u.createElement("div",H({className:"form-multi-select-input-group"},!K&&!b&&{tabIndex:0},{onClick:function(){return!b&&Q()},onKeyDown:ft,ref:_}),u.createElement(ae,{disabled:b,multiple:x,onRemove:function(n){return!b&&Ae(n)},placeholder:X,search:K,selected:c,selectionType:Z,selectionTypeCounterText:Ce},K&&u.createElement("input",H({type:"text",className:"form-multi-select-search",disabled:b,autoComplete:"off",onChange:ut,onKeyDown:ct},c.length===0&&{placeholder:X},c.length>0&&Z==="counter"&&{placeholder:"".concat(c.length," ").concat(Ce)},c.length>0&&!x&&{placeholder:c.map(function(n){return n.label})[0]},x&&c.length>0&&Z!=="counter"&&{size:k.length+2},{ref:y})),!K&&c.length===0&&u.createElement("span",{className:"form-multi-select-placeholder"},X)),u.createElement("div",{className:"form-multi-select-buttons"},!b&&E&&c.length>0&&u.createElement("button",{type:"button",className:"form-multi-select-cleaner",onClick:function(){return pt()},"aria-label":i}),u.createElement("button",H({type:"button",className:"form-multi-select-indicator",onClick:function(n){n.preventDefault(),n.stopPropagation(),b||it()}},b&&{tabIndex:-1})))),u.createElement(vt,{container:g,portal:Y},u.createElement("div",{className:$("form-multi-select-dropdown",{show:Y&&A}),onKeyDown:Me,role:"menu",ref:P},x&&et&&u.createElement("button",{type:"button",className:"form-multi-select-all",onClick:function(){return dt()}},tt),u.createElement(oe,{loading:C,onOptionOnClick:function(n){return!b&&Ae(n)},options:U.length===0&&s?B||[]:U,optionsMaxHeight:Je,optionsStyle:Qe,optionsTemplate:$e,optionsGroupsTemplate:Xe,searchNoResultsLabel:_e,selected:c,virtualScroller:lt,visibleItems:ot})))))});j.propTypes=H({allowCreateOptions:t.bool,ariaCleanerLabel:t.string,className:t.string,cleaner:t.bool,clearSearchOnSelect:t.bool,container:t.any,disabled:t.bool,loading:t.bool,multiple:t.bool,name:t.string,onChange:t.func,onFilterChange:t.func,onHide:t.func,onShow:t.func,options:t.array.isRequired,optionsMaxHeight:t.oneOfType([t.number,t.string]),optionsStyle:t.oneOf(["checkbox","text"]),optionsTemplate:t.func,optionsGroupsTemplate:t.func,placeholder:t.string,portal:t.bool,required:t.bool,resetSelectionOnOptionsChange:t.bool,search:t.oneOfType([t.bool,t.oneOf(["external","global"]),t.shape({external:t.bool.isRequired,global:t.bool.isRequired})]),searchNoResultsLabel:t.oneOfType([t.string,t.node]),selectAll:t.bool,selectAllLabel:t.oneOfType([t.string,t.node]),selectionType:t.oneOf(["counter","tags","text"]),selectionTypeCounterText:t.string,size:t.oneOf(["sm","lg"]),virtualScroller:t.bool,visible:t.bool,visibleItems:t.number},Be.propTypes);j.displayName="CMultiSelect";const qt=()=>{const e=[{value:0,label:"Angular"},{value:1,label:"Bootstrap"},{value:2,label:"React.js",selected:!0},{value:3,label:"Vue.js"},{label:"backend",options:[{value:4,label:"Django"},{value:5,label:"Laravel"},{value:6,label:"Node.js"}]}];return a.jsxs(ne,{children:[a.jsxs(D,{xs:12,children:[a.jsx(ht,{href:"forms/multi-select/"}),a.jsxs(He,{className:"mb-4",children:[a.jsxs(Fe,{children:[a.jsx("strong",{children:"CoreUI React Multi Select"})," ",a.jsx("small",{children:"with Checkbox (Default Style)"})]}),a.jsx(Ke,{children:a.jsx(qe,{href:"forms/multi-select",children:a.jsxs(ne,{children:[a.jsx(D,{md:3,children:a.jsx(j,{options:e,multiple:!1})}),a.jsx(D,{md:3,children:a.jsx(j,{options:e,selectionType:"text"})}),a.jsx(D,{md:3,children:a.jsx(j,{options:e,selectionType:"tags"})}),a.jsx(D,{md:3,children:a.jsx(j,{options:e,selectionType:"counter"})})]})})})]})]}),a.jsx(D,{xs:12,children:a.jsxs(He,{className:"mb-4",children:[a.jsxs(Fe,{children:[a.jsx("strong",{children:"CoreUI React Multi Select"})," ",a.jsx("small",{children:"with Text"})]}),a.jsx(Ke,{children:a.jsx(qe,{href:"forms/multi-select",children:a.jsxs(ne,{children:[a.jsx(D,{md:3,children:a.jsx(j,{options:e,optionsStyle:"text",multiple:!1})}),a.jsx(D,{md:3,children:a.jsx(j,{options:e,optionsStyle:"text",selectionType:"text"})}),a.jsx(D,{md:3,children:a.jsx(j,{options:e,optionsStyle:"text",selectionType:"tags"})}),a.jsx(D,{md:3,children:a.jsx(j,{options:e,optionsStyle:"text",selectionType:"counter"})})]})})})]})})]})};export{qt as default};
