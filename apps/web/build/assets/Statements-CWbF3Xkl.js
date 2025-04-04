import{r as f,_ as Ze,R as v,a as Ye,c as Je,P as $,b as Qe,E as et,G as M,H as tt,I as nt,J as st,F as rt,K as ot,L as it,M as Te,S as at,j as l,C as Oe}from"./index-XZRXeKYy.js";import{c as lt,e as ct,D as W,s as Pe,a as Ue,d as ut}from"./database-CsVTft8U.js";import{d as De,a as j,c as Ce}from"./index.esm-Btfu6nMy.js";import{C as ae,a as le,b as ce,c as ue,d as ve}from"./CModalTitle-D13ujpG6.js";import{b as ne,C as dt,a as xe}from"./CInputGroupText-DUWUW7j8.js";import{u as ht,T as ft,b as pt}from"./CConditionalPortal-er86fRMf.js";import"./DefaultLayout-BdRLv_tp.js";var de=f.forwardRef(function(e,t){var n=e.children,s=e.className,r=e.color,o=r===void 0?"primary":r,i=e.dismissible,a=e.variant,c=e.visible,d=c===void 0?!0:c,m=e.onClose,b=Ze(e,["children","className","color","dismissible","variant","visible","onClose"]),u=f.useRef(null),p=ht(t,u),h=f.useState(d),g=h[0],_=h[1];return f.useEffect(function(){_(d)},[d]),v.createElement(ft,{in:g,mountOnEnter:!0,nodeRef:u,onExit:m,timeout:150,unmountOnExit:!0},function(A){return v.createElement("div",Ye({className:Je("alert",a==="solid"?"bg-".concat(o," text-white"):"alert-".concat(o),{"alert-dismissible fade":i,show:A==="entered"},s),role:"alert"},b,{ref:p}),n,i&&v.createElement(pt,{onClick:function(){return _(!1)}}))})});de.propTypes={children:$.node,className:$.string,color:Qe.isRequired,dismissible:$.bool,onClose:$.func,variant:$.string,visible:$.bool};de.displayName="CAlert";var mt=["512 512","<path fill='var(--ci-primary-color, currentColor)' d='M479.6,399.716l-81.084-81.084-62.368-25.767A175.014,175.014,0,0,0,368,192c0-97.047-78.953-176-176-176S16,94.953,16,192,94.953,368,192,368a175.034,175.034,0,0,0,101.619-32.377l25.7,62.2L400.4,478.911a56,56,0,1,0,79.2-79.195ZM48,192c0-79.4,64.6-144,144-144s144,64.6,144,144S271.4,336,192,336,48,271.4,48,192ZM456.971,456.284a24.028,24.028,0,0,1-33.942,0l-76.572-76.572-23.894-57.835L380.4,345.771l76.573,76.572A24.028,24.028,0,0,1,456.971,456.284Z' class='ci-primary'/>"];/**
 * @license
 * Copyright 2017 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */const Le="firebasestorage.googleapis.com",je="storageBucket",gt=2*60*1e3,_t=10*60*1e3;/**
 * @license
 * Copyright 2017 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */class y extends rt{constructor(t,n,s=0){super(ee(t),`Firebase Storage: ${n} (${ee(t)})`),this.status_=s,this.customData={serverResponse:null},this._baseMessage=this.message,Object.setPrototypeOf(this,y.prototype)}get status(){return this.status_}set status(t){this.status_=t}_codeEquals(t){return ee(t)===this.code}get serverResponse(){return this.customData.serverResponse}set serverResponse(t){this.customData.serverResponse=t,this.customData.serverResponse?this.message=`${this._baseMessage}
${this.customData.serverResponse}`:this.message=this._baseMessage}}var R;(function(e){e.UNKNOWN="unknown",e.OBJECT_NOT_FOUND="object-not-found",e.BUCKET_NOT_FOUND="bucket-not-found",e.PROJECT_NOT_FOUND="project-not-found",e.QUOTA_EXCEEDED="quota-exceeded",e.UNAUTHENTICATED="unauthenticated",e.UNAUTHORIZED="unauthorized",e.UNAUTHORIZED_APP="unauthorized-app",e.RETRY_LIMIT_EXCEEDED="retry-limit-exceeded",e.INVALID_CHECKSUM="invalid-checksum",e.CANCELED="canceled",e.INVALID_EVENT_NAME="invalid-event-name",e.INVALID_URL="invalid-url",e.INVALID_DEFAULT_BUCKET="invalid-default-bucket",e.NO_DEFAULT_BUCKET="no-default-bucket",e.CANNOT_SLICE_BLOB="cannot-slice-blob",e.SERVER_FILE_WRONG_SIZE="server-file-wrong-size",e.NO_DOWNLOAD_URL="no-download-url",e.INVALID_ARGUMENT="invalid-argument",e.INVALID_ARGUMENT_COUNT="invalid-argument-count",e.APP_DELETED="app-deleted",e.INVALID_ROOT_OPERATION="invalid-root-operation",e.INVALID_FORMAT="invalid-format",e.INTERNAL_ERROR="internal-error",e.UNSUPPORTED_ENVIRONMENT="unsupported-environment"})(R||(R={}));function ee(e){return"storage/"+e}function he(){const e="An unknown error occurred, please check the error payload for server response.";return new y(R.UNKNOWN,e)}function wt(e){return new y(R.OBJECT_NOT_FOUND,"Object '"+e+"' does not exist.")}function bt(e){return new y(R.QUOTA_EXCEEDED,"Quota for bucket '"+e+"' exceeded, please view quota on https://firebase.google.com/pricing/.")}function Rt(){const e="User is not authenticated, please authenticate using Firebase Authentication and try again.";return new y(R.UNAUTHENTICATED,e)}function yt(){return new y(R.UNAUTHORIZED_APP,"This app does not have permission to access Firebase Storage on this project.")}function Tt(e){return new y(R.UNAUTHORIZED,"User does not have permission to access '"+e+"'.")}function Ct(){return new y(R.RETRY_LIMIT_EXCEEDED,"Max retry time for operation exceeded, please try again.")}function xt(){return new y(R.CANCELED,"User canceled the upload/download.")}function Et(e){return new y(R.INVALID_URL,"Invalid URL '"+e+"'.")}function kt(e){return new y(R.INVALID_DEFAULT_BUCKET,"Invalid default bucket '"+e+"'.")}function At(){return new y(R.NO_DEFAULT_BUCKET,"No default bucket found. Did you set the '"+je+"' property when initializing the app?")}function St(){return new y(R.CANNOT_SLICE_BLOB,"Cannot slice blob for upload. Please retry the upload.")}function It(){return new y(R.NO_DOWNLOAD_URL,"The given file does not have any download URLs.")}function Nt(e){return new y(R.UNSUPPORTED_ENVIRONMENT,`${e} is missing. Make sure to install the required polyfills. See https://firebase.google.com/docs/web/environments-js-sdk#polyfills for more information.`)}function se(e){return new y(R.INVALID_ARGUMENT,e)}function Be(){return new y(R.APP_DELETED,"The Firebase app was deleted.")}function Ot(e){return new y(R.INVALID_ROOT_OPERATION,"The operation '"+e+"' cannot be performed on a root reference, create a non-root reference using child, such as .child('file.png').")}function G(e,t){return new y(R.INVALID_FORMAT,"String does not match format '"+e+"': "+t)}function z(e){throw new y(R.INTERNAL_ERROR,"Internal error: "+e)}/**
 * @license
 * Copyright 2017 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */class k{constructor(t,n){this.bucket=t,this.path_=n}get path(){return this.path_}get isRoot(){return this.path.length===0}fullServerUrl(){const t=encodeURIComponent;return"/b/"+t(this.bucket)+"/o/"+t(this.path)}bucketOnlyServerUrl(){return"/b/"+encodeURIComponent(this.bucket)+"/o"}static makeFromBucketSpec(t,n){let s;try{s=k.makeFromUrl(t,n)}catch{return new k(t,"")}if(s.path==="")return s;throw kt(t)}static makeFromUrl(t,n){let s=null;const r="([A-Za-z0-9.\\-_]+)";function o(w){w.path.charAt(w.path.length-1)==="/"&&(w.path_=w.path_.slice(0,-1))}const i="(/(.*))?$",a=new RegExp("^gs://"+r+i,"i"),c={bucket:1,path:3};function d(w){w.path_=decodeURIComponent(w.path)}const m="v[A-Za-z0-9_]+",b=n.replace(/[.]/g,"\\."),u="(/([^?#]*).*)?$",p=new RegExp(`^https?://${b}/${m}/b/${r}/o${u}`,"i"),h={bucket:1,path:3},g=n===Le?"(?:storage.googleapis.com|storage.cloud.google.com)":n,_="([^?#]*)",A=new RegExp(`^https?://${g}/${r}/${_}`,"i"),T=[{regex:a,indices:c,postModify:o},{regex:p,indices:h,postModify:d},{regex:A,indices:{bucket:1,path:2},postModify:d}];for(let w=0;w<T.length;w++){const O=T[w],S=O.regex.exec(t);if(S){const D=S[O.indices.bucket];let F=S[O.indices.path];F||(F=""),s=new k(D,F),O.postModify(s);break}}if(s==null)throw Et(t);return s}}class Pt{constructor(t){this.promise_=Promise.reject(t)}getPromise(){return this.promise_}cancel(t=!1){}}/**
 * @license
 * Copyright 2017 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */function Ut(e,t,n){let s=1,r=null,o=null,i=!1,a=0;function c(){return a===2}let d=!1;function m(..._){d||(d=!0,t.apply(null,_))}function b(_){r=setTimeout(()=>{r=null,e(p,c())},_)}function u(){o&&clearTimeout(o)}function p(_,...A){if(d){u();return}if(_){u(),m.call(null,_,...A);return}if(c()||i){u(),m.call(null,_,...A);return}s<64&&(s*=2);let T;a===1?(a=2,T=0):T=(s+Math.random())*1e3,b(T)}let h=!1;function g(_){h||(h=!0,u(),!d&&(r!==null?(_||(a=2),clearTimeout(r),b(0)):_||(a=1)))}return b(0),o=setTimeout(()=>{i=!0,g(!0)},n),g}function Dt(e){e(!1)}/**
 * @license
 * Copyright 2017 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */function vt(e){return e!==void 0}function Lt(e){return typeof e=="object"&&!Array.isArray(e)}function fe(e){return typeof e=="string"||e instanceof String}function Ee(e){return pe()&&e instanceof Blob}function pe(){return typeof Blob<"u"}function re(e,t,n,s){if(s<t)throw se(`Invalid value for '${e}'. Expected ${t} or greater.`);if(s>n)throw se(`Invalid value for '${e}'. Expected ${n} or less.`)}/**
 * @license
 * Copyright 2017 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */function H(e,t,n){let s=t;return n==null&&(s=`https://${t}`),`${n}://${s}/v0${e}`}function Me(e){const t=encodeURIComponent;let n="?";for(const s in e)if(e.hasOwnProperty(s)){const r=t(s)+"="+t(e[s]);n=n+r+"&"}return n=n.slice(0,-1),n}var L;(function(e){e[e.NO_ERROR=0]="NO_ERROR",e[e.NETWORK_ERROR=1]="NETWORK_ERROR",e[e.ABORT=2]="ABORT"})(L||(L={}));/**
 * @license
 * Copyright 2022 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */function jt(e,t){const n=e>=500&&e<600,r=[408,429].indexOf(e)!==-1,o=t.indexOf(e)!==-1;return n||r||o}/**
 * @license
 * Copyright 2017 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */class Bt{constructor(t,n,s,r,o,i,a,c,d,m,b,u=!0){this.url_=t,this.method_=n,this.headers_=s,this.body_=r,this.successCodes_=o,this.additionalRetryCodes_=i,this.callback_=a,this.errorCallback_=c,this.timeout_=d,this.progressCallback_=m,this.connectionFactory_=b,this.retry=u,this.pendingConnection_=null,this.backoffId_=null,this.canceled_=!1,this.appDelete_=!1,this.promise_=new Promise((p,h)=>{this.resolve_=p,this.reject_=h,this.start_()})}start_(){const t=(s,r)=>{if(r){s(!1,new Y(!1,null,!0));return}const o=this.connectionFactory_();this.pendingConnection_=o;const i=a=>{const c=a.loaded,d=a.lengthComputable?a.total:-1;this.progressCallback_!==null&&this.progressCallback_(c,d)};this.progressCallback_!==null&&o.addUploadProgressListener(i),o.send(this.url_,this.method_,this.body_,this.headers_).then(()=>{this.progressCallback_!==null&&o.removeUploadProgressListener(i),this.pendingConnection_=null;const a=o.getErrorCode()===L.NO_ERROR,c=o.getStatus();if(!a||jt(c,this.additionalRetryCodes_)&&this.retry){const m=o.getErrorCode()===L.ABORT;s(!1,new Y(!1,null,m));return}const d=this.successCodes_.indexOf(c)!==-1;s(!0,new Y(d,o))})},n=(s,r)=>{const o=this.resolve_,i=this.reject_,a=r.connection;if(r.wasSuccessCode)try{const c=this.callback_(a,a.getResponse());vt(c)?o(c):o()}catch(c){i(c)}else if(a!==null){const c=he();c.serverResponse=a.getErrorText(),this.errorCallback_?i(this.errorCallback_(a,c)):i(c)}else if(r.canceled){const c=this.appDelete_?Be():xt();i(c)}else{const c=Ct();i(c)}};this.canceled_?n(!1,new Y(!1,null,!0)):this.backoffId_=Ut(t,n,this.timeout_)}getPromise(){return this.promise_}cancel(t){this.canceled_=!0,this.appDelete_=t||!1,this.backoffId_!==null&&Dt(this.backoffId_),this.pendingConnection_!==null&&this.pendingConnection_.abort()}}class Y{constructor(t,n,s){this.wasSuccessCode=t,this.connection=n,this.canceled=!!s}}function Mt(e,t){t!==null&&t.length>0&&(e.Authorization="Firebase "+t)}function Ft(e,t){e["X-Firebase-Storage-Version"]="webjs/"+(t??"AppManager")}function $t(e,t){t&&(e["X-Firebase-GMPID"]=t)}function Ht(e,t){t!==null&&(e["X-Firebase-AppCheck"]=t)}function qt(e,t,n,s,r,o,i=!0){const a=Me(e.urlParams),c=e.url+a,d=Object.assign({},e.headers);return $t(d,t),Mt(d,n),Ft(d,o),Ht(d,s),new Bt(c,e.method,d,e.body,e.successCodes,e.additionalRetryCodes,e.handler,e.errorHandler,e.timeout,e.progressCallback,r,i)}/**
 * @license
 * Copyright 2017 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */function Vt(){return typeof BlobBuilder<"u"?BlobBuilder:typeof WebKitBlobBuilder<"u"?WebKitBlobBuilder:void 0}function zt(...e){const t=Vt();if(t!==void 0){const n=new t;for(let s=0;s<e.length;s++)n.append(e[s]);return n.getBlob()}else{if(pe())return new Blob(e);throw new y(R.UNSUPPORTED_ENVIRONMENT,"This browser doesn't seem to support creating Blobs")}}function Gt(e,t,n){return e.webkitSlice?e.webkitSlice(t,n):e.mozSlice?e.mozSlice(t,n):e.slice?e.slice(t,n):null}/**
 * @license
 * Copyright 2021 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */function Wt(e){if(typeof atob>"u")throw Nt("base-64");return atob(e)}/**
 * @license
 * Copyright 2017 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */const N={RAW:"raw",BASE64:"base64",BASE64URL:"base64url",DATA_URL:"data_url"};class te{constructor(t,n){this.data=t,this.contentType=n||null}}function Kt(e,t){switch(e){case N.RAW:return new te(Fe(t));case N.BASE64:case N.BASE64URL:return new te($e(e,t));case N.DATA_URL:return new te(Zt(t),Yt(t))}throw he()}function Fe(e){const t=[];for(let n=0;n<e.length;n++){let s=e.charCodeAt(n);if(s<=127)t.push(s);else if(s<=2047)t.push(192|s>>6,128|s&63);else if((s&64512)===55296)if(!(n<e.length-1&&(e.charCodeAt(n+1)&64512)===56320))t.push(239,191,189);else{const o=s,i=e.charCodeAt(++n);s=65536|(o&1023)<<10|i&1023,t.push(240|s>>18,128|s>>12&63,128|s>>6&63,128|s&63)}else(s&64512)===56320?t.push(239,191,189):t.push(224|s>>12,128|s>>6&63,128|s&63)}return new Uint8Array(t)}function Xt(e){let t;try{t=decodeURIComponent(e)}catch{throw G(N.DATA_URL,"Malformed data URL.")}return Fe(t)}function $e(e,t){switch(e){case N.BASE64:{const r=t.indexOf("-")!==-1,o=t.indexOf("_")!==-1;if(r||o)throw G(e,"Invalid character '"+(r?"-":"_")+"' found: is it base64url encoded?");break}case N.BASE64URL:{const r=t.indexOf("+")!==-1,o=t.indexOf("/")!==-1;if(r||o)throw G(e,"Invalid character '"+(r?"+":"/")+"' found: is it base64 encoded?");t=t.replace(/-/g,"+").replace(/_/g,"/");break}}let n;try{n=Wt(t)}catch(r){throw r.message.includes("polyfill")?r:G(e,"Invalid character found")}const s=new Uint8Array(n.length);for(let r=0;r<n.length;r++)s[r]=n.charCodeAt(r);return s}class He{constructor(t){this.base64=!1,this.contentType=null;const n=t.match(/^data:([^,]+)?,/);if(n===null)throw G(N.DATA_URL,"Must be formatted 'data:[<mediatype>][;base64],<data>");const s=n[1]||null;s!=null&&(this.base64=Jt(s,";base64"),this.contentType=this.base64?s.substring(0,s.length-7):s),this.rest=t.substring(t.indexOf(",")+1)}}function Zt(e){const t=new He(e);return t.base64?$e(N.BASE64,t.rest):Xt(t.rest)}function Yt(e){return new He(e).contentType}function Jt(e,t){return e.length>=t.length?e.substring(e.length-t.length)===t:!1}/**
 * @license
 * Copyright 2017 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */class U{constructor(t,n){let s=0,r="";Ee(t)?(this.data_=t,s=t.size,r=t.type):t instanceof ArrayBuffer?(n?this.data_=new Uint8Array(t):(this.data_=new Uint8Array(t.byteLength),this.data_.set(new Uint8Array(t))),s=this.data_.length):t instanceof Uint8Array&&(n?this.data_=t:(this.data_=new Uint8Array(t.length),this.data_.set(t)),s=t.length),this.size_=s,this.type_=r}size(){return this.size_}type(){return this.type_}slice(t,n){if(Ee(this.data_)){const s=this.data_,r=Gt(s,t,n);return r===null?null:new U(r)}else{const s=new Uint8Array(this.data_.buffer,t,n-t);return new U(s,!0)}}static getBlob(...t){if(pe()){const n=t.map(s=>s instanceof U?s.data_:s);return new U(zt.apply(null,n))}else{const n=t.map(i=>fe(i)?Kt(N.RAW,i).data:i.data_);let s=0;n.forEach(i=>{s+=i.byteLength});const r=new Uint8Array(s);let o=0;return n.forEach(i=>{for(let a=0;a<i.length;a++)r[o++]=i[a]}),new U(r,!0)}}uploadData(){return this.data_}}/**
 * @license
 * Copyright 2017 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */function me(e){let t;try{t=JSON.parse(e)}catch{return null}return Lt(t)?t:null}/**
 * @license
 * Copyright 2017 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */function Qt(e){if(e.length===0)return null;const t=e.lastIndexOf("/");return t===-1?"":e.slice(0,t)}function en(e,t){const n=t.split("/").filter(s=>s.length>0).join("/");return e.length===0?n:e+"/"+n}function qe(e){const t=e.lastIndexOf("/",e.length-2);return t===-1?e:e.slice(t+1)}/**
 * @license
 * Copyright 2017 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */function tn(e,t){return t}class E{constructor(t,n,s,r){this.server=t,this.local=n||t,this.writable=!!s,this.xform=r||tn}}let J=null;function nn(e){return!fe(e)||e.length<2?e:qe(e)}function ge(){if(J)return J;const e=[];e.push(new E("bucket")),e.push(new E("generation")),e.push(new E("metageneration")),e.push(new E("name","fullPath",!0));function t(o,i){return nn(i)}const n=new E("name");n.xform=t,e.push(n);function s(o,i){return i!==void 0?Number(i):i}const r=new E("size");return r.xform=s,e.push(r),e.push(new E("timeCreated")),e.push(new E("updated")),e.push(new E("md5Hash",null,!0)),e.push(new E("cacheControl",null,!0)),e.push(new E("contentDisposition",null,!0)),e.push(new E("contentEncoding",null,!0)),e.push(new E("contentLanguage",null,!0)),e.push(new E("contentType",null,!0)),e.push(new E("metadata","customMetadata",!0)),J=e,J}function sn(e,t){function n(){const s=e.bucket,r=e.fullPath,o=new k(s,r);return t._makeStorageReference(o)}Object.defineProperty(e,"ref",{get:n})}function rn(e,t,n){const s={};s.type="file";const r=n.length;for(let o=0;o<r;o++){const i=n[o];s[i.local]=i.xform(s,t[i.server])}return sn(s,e),s}function Ve(e,t,n){const s=me(t);return s===null?null:rn(e,s,n)}function on(e,t,n,s){const r=me(t);if(r===null||!fe(r.downloadTokens))return null;const o=r.downloadTokens;if(o.length===0)return null;const i=encodeURIComponent;return o.split(",").map(d=>{const m=e.bucket,b=e.fullPath,u="/b/"+i(m)+"/o/"+i(b),p=H(u,n,s),h=Me({alt:"media",token:d});return p+h})[0]}function an(e,t){const n={},s=t.length;for(let r=0;r<s;r++){const o=t[r];o.writable&&(n[o.server]=e[o.local])}return JSON.stringify(n)}/**
 * @license
 * Copyright 2019 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */const ke="prefixes",Ae="items";function ln(e,t,n){const s={prefixes:[],items:[],nextPageToken:n.nextPageToken};if(n[ke])for(const r of n[ke]){const o=r.replace(/\/$/,""),i=e._makeStorageReference(new k(t,o));s.prefixes.push(i)}if(n[Ae])for(const r of n[Ae]){const o=e._makeStorageReference(new k(t,r.name));s.items.push(o)}return s}function cn(e,t,n){const s=me(n);return s===null?null:ln(e,t,s)}class K{constructor(t,n,s,r){this.url=t,this.method=n,this.handler=s,this.timeout=r,this.urlParams={},this.headers={},this.body=null,this.errorHandler=null,this.progressCallback=null,this.successCodes=[200],this.additionalRetryCodes=[]}}/**
 * @license
 * Copyright 2017 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */function _e(e){if(!e)throw he()}function ze(e,t){function n(s,r){const o=Ve(e,r,t);return _e(o!==null),o}return n}function un(e,t){function n(s,r){const o=cn(e,t,r);return _e(o!==null),o}return n}function dn(e,t){function n(s,r){const o=Ve(e,r,t);return _e(o!==null),on(o,r,e.host,e._protocol)}return n}function we(e){function t(n,s){let r;return n.getStatus()===401?n.getErrorText().includes("Firebase App Check token is invalid")?r=yt():r=Rt():n.getStatus()===402?r=bt(e.bucket):n.getStatus()===403?r=Tt(e.path):r=s,r.status=n.getStatus(),r.serverResponse=s.serverResponse,r}return t}function be(e){const t=we(e);function n(s,r){let o=t(s,r);return s.getStatus()===404&&(o=wt(e.path)),o.serverResponse=r.serverResponse,o}return n}function hn(e,t,n){const s=t.fullServerUrl(),r=H(s,e.host,e._protocol),o="GET",i=e.maxOperationRetryTime,a=new K(r,o,ze(e,n),i);return a.errorHandler=be(t),a}function fn(e,t,n,s,r){const o={};t.isRoot?o.prefix="":o.prefix=t.path+"/",n.length>0&&(o.delimiter=n),s&&(o.pageToken=s),r&&(o.maxResults=r);const i=t.bucketOnlyServerUrl(),a=H(i,e.host,e._protocol),c="GET",d=e.maxOperationRetryTime,m=new K(a,c,un(e,t.bucket),d);return m.urlParams=o,m.errorHandler=we(t),m}function pn(e,t,n){const s=t.fullServerUrl(),r=H(s,e.host,e._protocol),o="GET",i=e.maxOperationRetryTime,a=new K(r,o,dn(e,n),i);return a.errorHandler=be(t),a}function mn(e,t){const n=t.fullServerUrl(),s=H(n,e.host,e._protocol),r="DELETE",o=e.maxOperationRetryTime;function i(c,d){}const a=new K(s,r,i,o);return a.successCodes=[200,204],a.errorHandler=be(t),a}function gn(e,t){return e&&e.contentType||t&&t.type()||"application/octet-stream"}function _n(e,t,n){const s=Object.assign({},n);return s.fullPath=e.path,s.size=t.size(),s.contentType||(s.contentType=gn(null,t)),s}function wn(e,t,n,s,r){const o=t.bucketOnlyServerUrl(),i={"X-Goog-Upload-Protocol":"multipart"};function a(){let T="";for(let w=0;w<2;w++)T=T+Math.random().toString().slice(2);return T}const c=a();i["Content-Type"]="multipart/related; boundary="+c;const d=_n(t,s,r),m=an(d,n),b="--"+c+`\r
Content-Type: application/json; charset=utf-8\r
\r
`+m+`\r
--`+c+`\r
Content-Type: `+d.contentType+`\r
\r
`,u=`\r
--`+c+"--",p=U.getBlob(b,s,u);if(p===null)throw St();const h={name:d.fullPath},g=H(o,e.host,e._protocol),_="POST",A=e.maxUploadRetryTime,C=new K(g,_,ze(e,n),A);return C.urlParams=h,C.headers=i,C.body=p.uploadData(),C.errorHandler=we(t),C}class bn{constructor(){this.sent_=!1,this.xhr_=new XMLHttpRequest,this.initXhr(),this.errorCode_=L.NO_ERROR,this.sendPromise_=new Promise(t=>{this.xhr_.addEventListener("abort",()=>{this.errorCode_=L.ABORT,t()}),this.xhr_.addEventListener("error",()=>{this.errorCode_=L.NETWORK_ERROR,t()}),this.xhr_.addEventListener("load",()=>{t()})})}send(t,n,s,r){if(this.sent_)throw z("cannot .send() more than once");if(this.sent_=!0,this.xhr_.open(n,t,!0),r!==void 0)for(const o in r)r.hasOwnProperty(o)&&this.xhr_.setRequestHeader(o,r[o].toString());return s!==void 0?this.xhr_.send(s):this.xhr_.send(),this.sendPromise_}getErrorCode(){if(!this.sent_)throw z("cannot .getErrorCode() before sending");return this.errorCode_}getStatus(){if(!this.sent_)throw z("cannot .getStatus() before sending");try{return this.xhr_.status}catch{return-1}}getResponse(){if(!this.sent_)throw z("cannot .getResponse() before sending");return this.xhr_.response}getErrorText(){if(!this.sent_)throw z("cannot .getErrorText() before sending");return this.xhr_.statusText}abort(){this.xhr_.abort()}getResponseHeader(t){return this.xhr_.getResponseHeader(t)}addUploadProgressListener(t){this.xhr_.upload!=null&&this.xhr_.upload.addEventListener("progress",t)}removeUploadProgressListener(t){this.xhr_.upload!=null&&this.xhr_.upload.removeEventListener("progress",t)}}class Rn extends bn{initXhr(){this.xhr_.responseType="text"}}function X(){return new Rn}/**
 * @license
 * Copyright 2019 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */class B{constructor(t,n){this._service=t,n instanceof k?this._location=n:this._location=k.makeFromUrl(n,t.host)}toString(){return"gs://"+this._location.bucket+"/"+this._location.path}_newRef(t,n){return new B(t,n)}get root(){const t=new k(this._location.bucket,"");return this._newRef(this._service,t)}get bucket(){return this._location.bucket}get fullPath(){return this._location.path}get name(){return qe(this._location.path)}get storage(){return this._service}get parent(){const t=Qt(this._location.path);if(t===null)return null;const n=new k(this._location.bucket,t);return new B(this._service,n)}_throwIfRoot(t){if(this._location.path==="")throw Ot(t)}}function yn(e,t,n){e._throwIfRoot("uploadBytes");const s=wn(e.storage,e._location,ge(),new U(t,!0),n);return e.storage.makeRequestWithTokens(s,X).then(r=>({metadata:r,ref:e}))}function Tn(e){const t={prefixes:[],items:[]};return Ge(e,t).then(()=>t)}async function Ge(e,t,n){const r=await Cn(e,{pageToken:n});t.prefixes.push(...r.prefixes),t.items.push(...r.items),r.nextPageToken!=null&&await Ge(e,t,r.nextPageToken)}function Cn(e,t){t!=null&&typeof t.maxResults=="number"&&re("options.maxResults",1,1e3,t.maxResults);const n=t||{},s=fn(e.storage,e._location,"/",n.pageToken,n.maxResults);return e.storage.makeRequestWithTokens(s,X)}function xn(e){e._throwIfRoot("getMetadata");const t=hn(e.storage,e._location,ge());return e.storage.makeRequestWithTokens(t,X)}function En(e){e._throwIfRoot("getDownloadURL");const t=pn(e.storage,e._location,ge());return e.storage.makeRequestWithTokens(t,X).then(n=>{if(n===null)throw It();return n})}function kn(e){e._throwIfRoot("deleteObject");const t=mn(e.storage,e._location);return e.storage.makeRequestWithTokens(t,X)}function An(e,t){const n=en(e._location.path,t),s=new k(e._location.bucket,n);return new B(e.storage,s)}/**
 * @license
 * Copyright 2017 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */function Sn(e){return/^[A-Za-z]+:\/\//.test(e)}function In(e,t){return new B(e,t)}function We(e,t){if(e instanceof Re){const n=e;if(n._bucket==null)throw At();const s=new B(n,n._bucket);return t!=null?We(s,t):s}else return t!==void 0?An(e,t):e}function Nn(e,t){if(t&&Sn(t)){if(e instanceof Re)return In(e,t);throw se("To use ref(service, url), the first argument must be a Storage instance.")}else return We(e,t)}function Se(e,t){const n=t==null?void 0:t[je];return n==null?null:k.makeFromBucketSpec(n,e)}function On(e,t,n,s={}){e.host=`${t}:${n}`,e._protocol="http";const{mockUserToken:r}=s;r&&(e._overrideAuthToken=typeof r=="string"?r:st(r,e.app.options.projectId))}class Re{constructor(t,n,s,r,o){this.app=t,this._authProvider=n,this._appCheckProvider=s,this._url=r,this._firebaseVersion=o,this._bucket=null,this._host=Le,this._protocol="https",this._appId=null,this._deleted=!1,this._maxOperationRetryTime=gt,this._maxUploadRetryTime=_t,this._requests=new Set,r!=null?this._bucket=k.makeFromBucketSpec(r,this._host):this._bucket=Se(this._host,this.app.options)}get host(){return this._host}set host(t){this._host=t,this._url!=null?this._bucket=k.makeFromBucketSpec(this._url,t):this._bucket=Se(t,this.app.options)}get maxUploadRetryTime(){return this._maxUploadRetryTime}set maxUploadRetryTime(t){re("time",0,Number.POSITIVE_INFINITY,t),this._maxUploadRetryTime=t}get maxOperationRetryTime(){return this._maxOperationRetryTime}set maxOperationRetryTime(t){re("time",0,Number.POSITIVE_INFINITY,t),this._maxOperationRetryTime=t}async _getAuthToken(){if(this._overrideAuthToken)return this._overrideAuthToken;const t=this._authProvider.getImmediate({optional:!0});if(t){const n=await t.getToken();if(n!==null)return n.accessToken}return null}async _getAppCheckToken(){const t=this._appCheckProvider.getImmediate({optional:!0});return t?(await t.getToken()).token:null}_delete(){return this._deleted||(this._deleted=!0,this._requests.forEach(t=>t.cancel()),this._requests.clear()),Promise.resolve()}_makeStorageReference(t){return new B(this,t)}_makeRequest(t,n,s,r,o=!0){if(this._deleted)return new Pt(Be());{const i=qt(t,this._appId,s,r,n,this._firebaseVersion,o);return this._requests.add(i),i.getPromise().then(()=>this._requests.delete(i),()=>this._requests.delete(i)),i}}async makeRequestWithTokens(t,n){const[s,r]=await Promise.all([this._getAuthToken(),this._getAppCheckToken()]);return this._makeRequest(t,n,s,r).getPromise()}}const Ie="@firebase/storage",Ne="0.13.5";/**
 * @license
 * Copyright 2020 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */const Ke="storage";function Pn(e,t,n){return e=M(e),yn(e,t,n)}function Un(e){return e=M(e),xn(e)}function Dn(e){return e=M(e),Tn(e)}function vn(e){return e=M(e),En(e)}function Ln(e){return e=M(e),kn(e)}function oe(e,t){return e=M(e),Nn(e,t)}function ie(e=et(),t){e=M(e);const s=tt(e,Ke).getImmediate({identifier:t}),r=nt("storage");return r&&jn(s,...r),s}function jn(e,t,n,s={}){On(e,t,n,s)}function Bn(e,{instanceIdentifier:t}){const n=e.getProvider("app").getImmediate(),s=e.getProvider("auth-internal"),r=e.getProvider("app-check-internal");return new Re(n,s,r,t,at)}function Mn(){ot(new it(Ke,Bn,"PUBLIC").setMultipleInstances(!0)),Te(Ie,Ne,""),Te(Ie,Ne,"esm2017")}Mn();const Fn=()=>{const[e,t]=f.useState([]),[n,s]=f.useState(!0),[r,o]=f.useState(null),[i,a]=f.useState(!1);f.useEffect(()=>{(async()=>{try{const h=await new W().getClients();console.log("Fetched clients:",h.length);const g=ie(),_=h.map(async T=>{const w=T.cid,O=oe(g,`${Pe.FIRESTORE_ACTIVE_USERS_COLLECTION}/${w}/`);try{const S=await Dn(O);if(S.items.length===0)return[];const D=S.items.map(async q=>{const Z=await Un(q),Q=await vn(q);return{clientName:`${T.firstName} ${T.lastName}`,documentTitle:Z.name,dateAdded:Z.timeCreated,downloadURL:Q,storagePath:q.fullPath}});return await Promise.all(D)}catch(S){return console.error(`Error fetching documents for CID ${w}:`,S),[]}}),C=(await Promise.all(_)).flat();C.sort((T,w)=>new Date(w.dateAdded).getTime()-new Date(T.dateAdded).getTime()),console.log("Total documents fetched:",C.length),console.log("Documents:",C),t(C),s(!1)}catch(p){console.error("Error fetching documents:",p),s(!1)}})()},[]);const c=u=>{o(u),a(!0)},d=async u=>{if(window.confirm(`Are you sure you want to delete ${u.documentTitle}?`))try{const h=ie(),g=oe(h,u.storagePath);await Ln(g),t(_=>_.filter(A=>A.storagePath!==u.storagePath)),alert("File deleted successfully.")}catch(h){console.error("Error deleting file:",h),alert("Failed to delete the file.")}};if(n)return l.jsx("div",{className:"text-center",children:l.jsx(Oe,{color:"primary"})});const m=[{key:"clientName",label:"Client",_style:{width:"20%"}},{key:"documentTitle",label:"Document Title",_style:{width:"40%"}},{key:"dateAdded",label:"Date Added",_style:{width:"15%"},sorter:!0},{key:"actions",label:"Quick Actions",_style:{width:"10%"},filter:!1}],b=e.map(u=>({...u,dateAdded:new Date(u.dateAdded).toLocaleDateString()}));return console.log("Items to display:",b),l.jsxs(De,{children:[l.jsx(lt,{items:b,columns:m,columnSorter:!0,columnFilter:!0,itemsPerPage:50,pagination:!0,scopedColumns:{actions:u=>l.jsxs("td",{children:[l.jsx(j,{color:"info",variant:"ghost",size:"sm",className:"mr-2",onClick:()=>c(u),children:l.jsx(Ce,{icon:mt,size:"lg"})}),l.jsx(j,{color:"danger",variant:"ghost",size:"sm",onClick:()=>d(u),children:l.jsx(Ce,{icon:ct,size:"lg"})})]})},tableProps:{striped:!0,hover:!0}}),l.jsxs(ae,{size:"xl",visible:i,onClose:()=>a(!1),children:[l.jsx(le,{closeButton:!0,children:l.jsx(ce,{children:r==null?void 0:r.documentTitle})}),l.jsx(ue,{children:r&&l.jsx("iframe",{src:r.downloadURL,title:"Document Preview",style:{width:"100%",height:"80vh"}})})]})]})},$n=({visible:e,onClose:t,onUploadSuccess:n})=>{const s=new W,[r,o]=f.useState(""),[i,a]=f.useState([]),[c,d]=f.useState([]),[m,b]=f.useState(""),[u,p]=f.useState([]),[h,g]=f.useState(!1),[_,A]=f.useState(!0),[C,T]=f.useState({}),[w,O]=f.useState(null),[S,D]=f.useState(null);f.useEffect(()=>{(async()=>{const I=await s.getClients();a(I),d(I)})()},[]),f.useEffect(()=>{const x=i.filter(I=>{var P;return(((P=I.firstName)==null?void 0:P.toLowerCase().includes(r.toLowerCase()))||I.lastName.toLowerCase().includes(r.toLowerCase()))??!1});d(x)},[r,i]);const F=i.map(x=>({label:`${x.firstName} ${x.lastName}`,value:x.cid})),q=async x=>{const I=x.slice(0,1);if(I.length===0)O(await s.getClient(C.parentDocId??""));else{const P=I[0].label,V=I[0].value;console.log(V),O(await s.getClient(V)??await s.getClient(C.parentDocId??"")),_&&T({...C,recipient:P})}},Z=async()=>{if(!w||!w.cid){D("Please select a client.");return}if(u.length===0){D("Please select at least one file.");return}D(null),await ye()},Q=x=>{x.target.files&&p(Array.from(x.target.files))},ye=async()=>{if(!w||!w.cid){console.error("No client selected.");return}if(u.length===0){console.error("No files to upload.");return}g(!0);const x=w.cid,I=u.map(P=>{const V=`${Pe.FIRESTORE_ACTIVE_USERS_COLLECTION}/${x}/${P.name}`;console.log(`Uploading file to: ${V}`);const Xe=oe(ie(),V);return Pn(Xe,P)});try{await Promise.all(I),console.log("All files uploaded successfully."),n(),p([])}catch(P){console.error("Error uploading files:",P)}finally{g(!1)}};return l.jsxs(ae,{visible:e,onClose:t,size:"lg",alignment:"center",children:[l.jsx(le,{closeButton:!0,children:l.jsx(ce,{children:"Add Statement"})}),l.jsxs(ue,{children:[l.jsx(Ue,{options:F,onChange:q,placeholder:"Select Client",multiple:!1}),l.jsxs("div",{className:"mb-3 mt-3",children:[" ",l.jsx(ne,{type:"file",accept:".pdf",multiple:!0,onChange:Q}),u.length>0&&l.jsxs("div",{style:{marginTop:"10px"},children:[l.jsx("strong",{children:"Selected files:"}),l.jsx("ul",{children:u.map(x=>l.jsx("li",{children:x.name},x.name))})]})]}),S&&l.jsx(de,{color:"danger",children:S})]}),l.jsxs(ve,{children:[l.jsx(j,{color:"secondary",onClick:t,disabled:h,children:"Cancel"}),l.jsx(j,{color:"primary",onClick:Z,disabled:h,children:h?"Uploading...":"Upload"})]})]})},Hn=({showModal:e,setShowModal:t,clientOptions:n})=>{const s=new W,[r,o]=v.useState(null),[i,a]=v.useState(null),[c,d]=v.useState(null),[m,b]=v.useState(!1);return l.jsxs(ae,{visible:e,onClose:()=>t(!1),size:"lg",alignment:"center",children:[l.jsx(le,{closeButton:!0,children:l.jsx(ce,{children:"Generate Statement"})}),l.jsx(ue,{children:l.jsxs(l.Fragment,{children:[l.jsxs(dt,{children:[l.jsx(Ue,{id:"client",className:"mb-3a custom-multiselect-dropdown",options:n,defaultValue:r==null?void 0:r.cid,placeholder:"Select Client",selectAll:!1,multiple:!1,allowCreateOptions:!1,onChange:async u=>{if(u.length===0)return;const p=u.map(g=>g.value)[0];u.map(g=>g.label)[0];const h=await s.getClient(p);h&&o(h)}}),l.jsx(xe,{children:"Start Date"}),l.jsx(ne,{type:"date",onChange:u=>{const p=new Date(u.target.value);a(p)}}),l.jsx(xe,{children:"End Date"}),l.jsx(ne,{type:"date",onChange:u=>{const p=new Date(u.target.value);d(p)}})]}),i&&c&&i>c&&l.jsx("div",{className:"text-danger mt-2",children:"Start date must be before end date"})]})}),l.jsxs(ve,{children:[l.jsx(j,{color:"secondary",onClick:()=>t(!1),children:"Cancel"}),l.jsx(ut,{color:"primary",onClick:async()=>{const u=new W;b(!0),await u.generateStatementPDF(r,i,c),b(!1),t(!1)},loading:m,disabled:!r||!i||!c||i>c,children:"Generate"})]})]})},Zn=()=>{const[e,t]=f.useState([]),[n,s]=f.useState([]),[r,o]=f.useState(!0),[i,a]=f.useState(!1),[c,d]=f.useState(!1),m=()=>{a(!1)},b=()=>{a(!1),window.location.reload()};return f.useEffect(()=>{(async()=>{const h=await new W().getClients();s(h.map(g=>({value:g.cid,label:g.firstName+" "+g.lastName})).sort((g,_)=>g.label.localeCompare(_.label))),t(h),o(!1)})()},[]),r?l.jsx("div",{className:"text-center",children:l.jsx(Oe,{color:"primary"})}):l.jsxs(De,{children:[l.jsxs("div",{className:"d-grid gap-2 py-3",children:[l.jsx(j,{color:"secondary",onClick:()=>d(!0),children:"Generate Statement"}),l.jsx(j,{color:"primary",onClick:()=>a(!0),children:"Add Statement +"})]}),l.jsx($n,{visible:i,onClose:m,onUploadSuccess:b}),c&&l.jsx(Hn,{showModal:c,setShowModal:d,clientOptions:n}),l.jsx(Fn,{})]})};export{Zn as default};
