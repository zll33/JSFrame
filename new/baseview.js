var Frame=null;
(function(){
//自定义view，继承div
var BaseViewX_V=null;
function createDiv(){
	var div;
	if(typeof(document.registerElement)=="undefined"){
		div = document.createElement("div");
	}else{
		if(BaseViewX_V==null){
			// 向浏览器注册自定义元素
			BaseViewX_V =  document.registerElement('X-V', { prototype: Object.create(HTMLDivElement.prototype,{
					createdCallback: { value: function(){ }}, 
					// 元素添加到DOM树时触发
					attachedCallback: { value: function(){ }  },
					// 元素DOM树上移除时触发
					detachedCallback: { value: function(){ }  },
					// 元素的attribute发生变化时触发
					attributeChangedCallback: { value: function(attrName, oldVal, newVal){ } }
			})});
		}
		div = new BaseViewX_V();
	}
	div.style.overflow="hidden";
    div.style.position="absolute";//   static|relative|absolute|fixed
	
	return div;
}
function BaseView(vType){
	this.div = createDiv();
	this.viewType=vType;
	this.init();
	return this;
};
BaseView.prototype.init= function(){
      //console.log('invoked createCallback!')
      //const raw = this.innerHTML

	if(TScrollView==this.viewType){
		this.div.style.overflow="auto";
		this.div.style.overflowScrolling="touch";
		//div透明不能支持事件
		this.div.style.background="url(#)";
		//IOS 手机
		this.div.style.webkitOverflowScrolling="touch";
		 
	}
	else if(TTextView==this.viewType||TEditView==this.viewType){
		this.tv=createDiv();
		this.tv.style.position="";
		this.tv.style.display="table-cell";
		this.tv.style.width="100%";
		this.tv.style.height="100%";
		this.tv.style.left="auto";
		this.tv.style.top="auto";
		this.tv.style.right="auto";
		this.tv.style.bottom="auto";
		this.div.appendChild(this.tv);
	}
	//编辑框滚动需要设置absolute
	else if(TEditView==this.viewType){
		this.tv=this.div;
	}
	else{
		
	}
 
	
	//	--- 父窗体的padding无法限制子div
	this.div.style.left="0px";
	this.div.style.top="0px";
	this.div.style.right="auto";
	this.div.style.bottom="auto";
	this.div.style.width="0px";
	this.div.style.height="0px";
	this.div.style.margin="auto";
 
	//
	this.setScaleType(ScaleMax);
	this.div.style.backgroundPositionX="center";
	this.div.style.backgroundPositionY="center";
	this.div.style.backgroundPosition="center";
	this.div.style.backgroundRepeatX="no-repeat";
	this.div.style.backgroundRepeatY="no-repeat";
	this.div.style.backgroundRepeat="no-repeat";
	 
	//	
	this.width=0;
	this.height=0;
	this.pTextLeft=0;
	this.pTextTop=0;
	this.pTextRight=0;
	this.pTextBottom=0;
	
	
	//
	this.div.style.wordBreak="break-all";
	this.fontSize=16;
	this.lineSpace=0;
	this.charSpace=0;
	this.fontColor=0xff000000;
	this.setFontSize(16);
	//
	
	//
	this.onAddToApp=null;
	this.onRemoveFormApp=null;
	//
	this.contentView=null;
	
	//文本编辑框
	if(TEditView==this.viewType){
		this.tv.contentEditable=true;
	}
}
//object.style.clip="rect(0px,50px,50px,0px)"
//shape	设置元素的形状。唯一合法的形状值是：rect (top, right, bottom, left)
//auto	默认值。不应用任何剪裁。
//inherit	规定应该从父元素继承 clip 属性的值。
BaseView.prototype.setClip=function(clip){
	if(clip){
		this.div.style.clip="inherit";
	}else{
		this.div.style.clip="auto";
	}
}
BaseView.prototype.setRect=function(x,y,w,h){
			this.setX(x);
			this.setY(x);
			this.setWidth(w);
			this.setHeight(h);
  }
BaseView.prototype.setWidth=function(w){
		if(w<0){
			w=0;
		}
		if(this.width!=w){
			this.width =w;
			this.div.style.width=getSizeFormInt(this.width);
			if(this.tv){
				this.tv.style.width=getSizeFormInt(this.width-this.pTextLeft-this.pTextRight);
			}
		}
  }
BaseView.prototype.setHeight= function(h){
		if(h<0){
			h=0;
		}
		if(this.height!=h){				
			this.height =h;
			this.div.style.height=getSizeFormInt(this.height);
			if(this.tv){
				this.tv.style.height=getSizeFormInt(this.height-this.pTextTop-this.pTextBottom);
			}
		}
  }
BaseView.prototype.setX=function(x){
			this.div.style.left=getSizeFormInt(x);
  }
BaseView.prototype.setY=function(y){
			this.div.style.top=getSizeFormInt(y);
  }
BaseView.prototype.setText= function(str){
       this.tv.innerText=str; 
	   this.tv.style.fontSize=getFontSizeFormInt(this.fontSize);
	   this.tv.style.letterSpacing=getFontSizeFormInt(this.charSpace);
	   this.tv.style.lineHeight=getFontSizeFormInt(this.fontSize+this.lineSpace);
  }
BaseView.prototype.getText= function(){
       return this.tv.innerText; 
}
function ___isIE() { //ie?
	if (!!window.ActiveXObject || "ActiveXObject" in window)
		return true;
	else
		return false;
}
//文本编辑框
BaseView.prototype.setOnTextChange=function(onchange){
	var thiz=this;
	var ontextChang=function(evnt){
		onchange.call(thiz,thiz.getText());
	}
	
	// if(___isIE()) {
	//	this.div.onpropertychange=function(evnt){
	//		onchange.call(thiz,thiz.getText());
	//	}
	//}else{
	//	this.div.oninput=function(evnt){
	//		onchange.call(thiz,thiz.getText());
	//	}
	//}
  

  	this.tv.oninput=ontextChang;
	this.tv.onpropertychange=ontextChang;
}
  //IOS\DIV没有内边距概念，强制支持TextPadding，正常的pading在XYWH上已经计算完成。 但是内边距不支持clip
BaseView.prototype.setTextPadding=function(left,top,right,bottom){
		if(this.pTextLeft!=left||this.pTextTop!=top||this.pTextRight!=right||this.pTextBottom!=bottom){
			this.pTextLeft =left;
			this.pTextTop =top;
			this.pTextRight =right;
			this.pTextBottom =bottom;
			
			this.tv.style.paddingLeft = getSizeFormInt(left);
			this.tv.style.paddingTop = getSizeFormInt(top);
			this.tv.style.paddingRight = getSizeFormInt(right);
			this.tv.style.paddingBottom = getSizeFormInt(bottom);
			
			this.tv.style.width=getSizeFormInt(this.width-this.pTextLeft-this.pTextRight);
			this.tv.style.height=getSizeFormInt(this.height-this.pTextTop-this.pTextBottom);
		}  
  }
BaseView.prototype.setLineSpace=function(value){
		if(value!=this.lineSpace){
			this.lineSpace=value;
			
			this.tv.style.fontSize=getFontSizeFormInt(this.fontSize);
			this.tv.style.letterSpacing=getFontSizeFormInt(this.charSpace);
			this.tv.style.lineHeight=getFontSizeFormInt(this.fontSize+this.lineSpace);
		}
  }
BaseView.prototype.setCharSpace=function(value){
       	if(value!=this.charSpace){
			this.charSpace=value;
			
			this.tv.style.fontSize=getFontSizeFormInt(this.fontSize);
			this.tv.style.letterSpacing=getFontSizeFormInt(this.charSpace);
			this.tv.style.lineHeight=getFontSizeFormInt(this.fontSize+this.lineSpace);
		} 
  }
BaseView.prototype.setFontSize=function(value){
        if(value!=this.fontSize){
			this.fontSize=value;
			
			this.tv.style.fontSize=getFontSizeFormInt(this.fontSize);
			this.tv.style.letterSpacing=getFontSizeFormInt(this.charSpace);
			this.tv.style.lineHeight=getFontSizeFormInt(this.fontSize+this.lineSpace);
		}  
  }
BaseView.prototype.setFontColor=function(color){
		if(this.fontColor!=color){
			this.fontColor=color;
			this.tv.style.color=getFontColorFormInt(color);
		}
   };
BaseView.prototype.setTextGravity=function(gravity){
	if(this.viewType==TTextView||this.viewType==TEditView){
		//
		if(gravity&GravityLeft){
			this.tv.style.textAlign="left";
		}
		else if(gravity&GravityCenterH){
			this.tv.style.textAlign="center";
		}
		else if(gravity&GravityRight){
			this.tv.style.textAlign="right";
		}
		if(gravity&GravityTop){
			this.tv.style.verticalAlign="top"; 
		}
		else if(gravity&GravityCenterV){
			this.tv.style.verticalAlign="middle"; 
		}
		else{
			this.tv.style.verticalAlign="bottom"; 
		}
	}
};   

BaseView.prototype.setBackColor=function(color){
		this.div.style.backgroundColor=getBackColorFormInt(color); 
  };
BaseView.prototype.setBackImage=function(url){
		this.div.style.backgroundImage="url("+url+")";
};
BaseView.prototype.setScaleType=function(type){
	if(type==ScaleFill){
		this.div.style.backgroundSize ="100% 100%";//
	}else if(type==ScaleCrop){
		this.div.style.backgroundSize ="cover";//
	}else{
		this.div.style.backgroundSize ="contain";//
	}
}
BaseView.prototype.addView=function(view,index){
		if(typeof(index)=="undefined"||index<0||index>this.div.childNodes.length-1){
			this.div.appendChild(view.div);
		}else{
			this.div.insertBefore(view.div,this.div.childNodes.item(index))
		}
    };
BaseView.prototype.removeView=function(view){
		this.div.removeChild(view.div);
  };
BaseView.prototype.setOnClick=function(fun){
	this.div.onclick = function(){
		fun();
		if(event.cancelBubble){
			event.cancelBubble();
		}else if(event.stopPropagation){
			event.stopPropagation();
		}
	};
}
//
BaseView.prototype.setContentView=function(view){
	if(this.contentView!=view){
		if(this.contentView!=null){
			this.removeView(view);
		}
		this.contentView=view;
		this.addView(view);
	}
}
//垂直滚动条overflow-y:visible或overflow-y:hidden
BaseView.prototype.setShowVertical=function(show){
	this.div.style.overflowY=show?"auto":"hidden";
}
//水平滚动条
BaseView.prototype.setShowHorizontal=function(show){
	this.div.style.overflowX=show?"auto":"hidden";
}
//设置滚动监听。 向上滚动，滚动的位置为负数，向下滚动滚动的位置为正数
BaseView.prototype.setOnScroll=function(onScroll){
	var thiz=this;
	//var sss=0;
	this.div.onscroll=function(evnt){
		//sss++;
		//console.log(sss + 'evnt='+JSON.stringify(evnt));
		onScroll.call(thiz,-thiz.div.scrollLeft,-thiz.div.scrollTop,0);
	}
	this.div.touchstart=function(evnt){
		
	}
	this.div.touchmove=function(evnt){
		onScroll.call(thiz,-thiz.div.scrollLeft,-thiz.div.scrollTop,0);
	}
	this.div.touchend=function(evnt){
		
	}
	this.div.touchcancel=function(evnt){
		
	}
	
}
//完全隐藏
BaseView.prototype.setGone=function(){
	 this.div.style.display="none";
}
//完全可见
BaseView.prototype.setVisibel=function(){
	 this.div.style.display="";
}
BaseView.prototype.setRotate=function(rotate,cx,cy){
	this.RS_R_rotate=rotate;
	this.RS_R_cx=cx;
	this.RS_R_cy=cy;
	this.checkRS();

}
BaseView.prototype.setAlpha=function(alpha){
	this.div.style.filter=1-alpha;
	this.div.style.opacity=1-alpha;
}
BaseView.prototype.setScale=function(sx,sy,cx,cy){
	this.RS_S_sx=sx;
	this.RS_S_sy=sy;
	this.RS_S_cx=cx;
	this.RS_S_cy=cy;
	this.checkRS();
	
	 //transform-origin:20% 40%;/
}
BaseView.prototype.checkRS=function(){
	var transform= "";//"scale(3,3)";
	if("RS_R_rotate" in this && this.RS_R_rotate!=0){
		transform += " rotate("+this.RS_R_rotate+"deg)";
	}
	if(("RS_S_sx" in this && this.RS_S_sx!=1)
	||"RS_S_sy" in this && this.RS_S_sy!=1){
		var sx = ("RS_S_sx" in this)?this.RS_S_sx:1;
		var sy = ("RS_S_sy" in this)?this.RS_S_sy:1;
		transform += " scale("+sx+","+sy+")";
	}
	this.div.style.transform = transform;
	//transform-origin:20% 40%;/
}
//动画类
BaseView.prototype.startAnimation=function(){
	
}
BaseView.prototype.stopAnimation=function(){
	 
}
BaseView.prototype.clearAnimation=function(){
	 this.animation="";
}
//动画循环次数
BaseView.prototype.setAnimationCount=function(){
	 
}
//动画结束，保持结束状态
BaseView.prototype.setAnimationKeep=function(){
	 
}
/*
animation: name duration timing-function delay iteration-count direction;
name:keyframe的名称，也就是定义了关键帧的动画的名称,这个名称用来区别不同的动画。
duration:完成动画所需要的时间（2s 或者 2000ms）
timing-function:完成动画的速度曲线
delay：动画开始之前的延迟
iteration-count：动画播放次数
direction：是否轮流反向播放动画（normal:正常顺序播放，alternate下一次反向播放）如果把动画设置为只播放一次，则该属性没有效果。
*/
BaseView.prototype.addTranslate=function(delayTime,continueTime,changeType,fromx,tox,fromy,toy){
	 
	 //this.div.style.transformOrigin
	 //this.div.style.webkitTransform="translate(120px)";

	 //this.div.style.webkitTransform="translate(0px,100px) scale(1) translateZ(0px)";
	 
	 //this.div.style.webkitTransform="translate scale  translateZ";
	 
	 
	 //transiton: 过渡属性 过渡所需要时间 过渡动画函数 过渡延迟时间；
	 
	 this.div.style.transitionDelay=delayTime+"ms,"+delayTime+"ms";
	 this.div.style.transitionProperty="left,top";
	 //this.div.style.transitionProperty="margin-left(100px),margin-top(200px)";
	 this.div.style.transitionDuration=continueTime+"ms,"+continueTime+"ms";
	 
	 
	  
	 
}
BaseView.prototype.addAlpha=function(delayTime,continueTime,changeType,fromAlpha,toAlpha){
	 
}
BaseView.prototype.addScale=function(delayTime,continueTime,changeType,fromX,toX,fromY,toY,pX,pY){
	 
}
BaseView.prototype.addRotate=function(delayTime,continueTime,changeType,fromRotate,toRotate,cenerX,cenery){
	 
}

function getFontSizeFormInt(size){
	if(typeof(size)!= "string"){
		return size+"px";
	}
	return size;
}
function getSizeFormInt(size){
	return getFontSizeFormInt(size);
}
function getFontColorFormInt(color){
	if(typeof(color)!= "string"){
		return "rgba("+((color>>16)&0x000000ff)+","+((color>>8)&0x000000ff)+","+(color&0x000000ff)+","+((color>>24)&0x000000ff)/0x00ff+")";
	}
	return color;
}
function getBackColorFormInt(color){
	return getFontColorFormInt(color);
}

/** 
 * 基础测量函数
 * js获取文本显示宽度 
 * @param str: 文本 
 * @return 文本显示宽度   
 */
var BaseViewMesuerTextView=null;

function BaseViewMeasureSize(str,maxWidth,fontSize,lineSpace,charSpace){
	if(BaseViewMesuerTextView==null){
		BaseViewMesuerTextView = document.createElement("div");
		BaseViewMesuerTextView.style.position="absolute";
		BaseViewMesuerTextView.style.wordBreak="break-all";
		BaseViewMesuerTextView.style.width="auto";
		BaseViewMesuerTextView.style.margin="auto";
		BaseViewMesuerTextView.style.color="rgba(0,0,0,0)";
		document.body.appendChild(BaseViewMesuerTextView);
	}
	BaseViewMesuerTextView.innerText=str;
	BaseViewMesuerTextView.style.maxWidth=getFontSizeFormInt(maxWidth);
	BaseViewMesuerTextView.style.fontSize=getFontSizeFormInt(fontSize);
	BaseViewMesuerTextView.style.letterSpacing=getFontSizeFormInt(charSpace);
	BaseViewMesuerTextView.style.lineHeight=getFontSizeFormInt(fontSize+lineSpace);
	
	var rect = BaseViewMesuerTextView.getBoundingClientRect();
	BaseViewMesuerTextView.innerText="";
	return {w:rect.width>0?(rect.width+1):0,h:rect.height>0?(rect.height+1):0};
}
//一下需要适配
var  BaseViewOnNeedLayoutIf=null;
var  BaseViewNeedLayoutOnCallBack=null;
var  hasCallBaseViewOnNeedLayoutIf=false;
//
//外部调用函数
function setMainBaseView(baseView,onMainSizeChange,onNeedLayoutIf){
	//document.body.style.position="absolute";;
	document.body.style.margin="0px";
	document.body.style.padding="0px";
	document.body.style.overflow="hidden";
	
	
	var mainview = new BaseView();
	mainview.div.style.left="0px"
	mainview.div.style.top="0px"
	mainview.div.style.right="0px"
	mainview.div.style.bottom="0px"
	mainview.div.style.width="auto"
	mainview.div.style.height="auto"
	mainview.setBackColor(0xff000000);
	mainview.div.appendChild(baseView.div);
	document.body.appendChild(mainview.div);
	
	//document.body.appendChild(baseView);
	var rect = mainview.div.getBoundingClientRect();
	
	
	BaseViewOnNeedLayoutIf =  onNeedLayoutIf;
	BaseViewNeedLayoutOnCallBack = function(){
		hasCallBaseViewOnNeedLayoutIf = false;
		baseView;
		var rect = mainview.div.getBoundingClientRect();
		onNeedLayoutIf(rect.width,rect.height);
	};
	window.onresize =function(){
		onMainSizeChange();
	};
	BaseViewNeedLayoutOnCallBack();
}
//外部调用函数
//
function setBaseViewNeedLayout(){
	if(hasCallBaseViewOnNeedLayoutIf==false){
		hasCallBaseViewOnNeedLayoutIf = true;
		setTimeout(BaseViewNeedLayoutOnCallBack,1);
	}
}
//外部调用函数
//1dp = density*1px;
//获取屏幕密度
function getDensity(){
	return 1;
}
//外部调用函数
//延时执行。单位毫秒
function postDelayed(fun,delayed){
	if(typeof(delayed)=="undefined"){
		delayed =1;
	}
	setTimeout(fun,delayed,true);//允许后台调用
}
//外部调用函数
//开机时间。单位毫秒
function currentTimeMillis(){
	return (new Date()).getTime();
}

//加载js
var JSPath =null;
//外部调用函数
function loadJS(path){
	
	if(JSPath==null){
		JSPath = [];
		JSPath.push(path);
		startLoadJS(path);
	}else{
		JSPath.push(path);
	}
}
var JSCount=0;
function startLoadJS(path){
	
	var  callback = function(){
		JSCount++;
		if(JSCount<JSPath.length){
			startLoadJS(JSPath[JSCount]);
		}else if(loadJSFinish!=null){
			loadJSFinish();
		}
	};
	var addJSCallBack = function(script){
		if(typeof(callback) != "undefined"){
	    if (script.readyState) {
		      script.onreadystatechange = function () {
		        if(script.readyState == "loaded" || script.readyState == "complete") {
		          script.onreadystatechange = null;
					callback();
		        }
		      };
		    } else {
		      script.onload = function () {
		        callback();
		      };
		   }
	  	}
	};
	var script = document.createElement("script");
	script.type = "text/javascript";
	addJSCallBack(script);
	script.src = path;
	document.body.appendChild(script);
}
var loadJSFinish=null;

function setLoadJSFinish(fun){
	loadJSFinish = fun;
}
var LStorage=localStorage;
if(typeof(LStorage)=="undefined"){
	LStorage={
		data:{},
		setItem:function(key,value){
			LStorage.data[key] = value;
		},
		getItem:function(key){
			var value = LStorage.data[key];
			if(typeof(value)=="undefined"){
				return "";
			}
			return value;
		}
	};
}
//适配变量
Frame = {
	getFrameVersion:function(){
		return 1;
	},
	getFramePlatform:function(){
		return "html";
	},
	createView:function(type){
		return new BaseView(type);
	},
	setMainBaseView:setMainBaseView,
	setBaseViewNeedLayout:setBaseViewNeedLayout,
	getDensity:getDensity,
	currentTimeMillis:currentTimeMillis,
	postDelayed:postDelayed,
	measureTextSize:BaseViewMeasureSize,
	loadJS:loadJS,
	setLoadJSFinish:setLoadJSFinish,
	createHttp:function(){
		var http={request:{type:"GET",async:"true",cache:"false",headers:{}}};
		//适配函数
		http.setUrl=function(url){
			this.request.url=url;
		};
		//适配函数
		http.setMethod=function(method){
			this.request.type=method;
		};
		//适配函数.需要KEY完全正确
		http.setHeader=function(key,value){
			this.request.headers[key]=value;
		};
		//适配函数
		http.setData=function(str){
			this.request.data=str;
		};
		//适配函数 onResponse = function(response,statue,json); response = {statue,headers,string}
		http.setOnResponse=function(onResponse){
			this.request.complete=function(XHR, TS){
				onResponse.call(http,XHR.getAllResponseHeaders(),XHR.status, XHR.responseText);
			};
			this.request.error=function(XHR, TS){
				
			};
			this.request.success=function(XHR, TS){
			
			};
		};
		//适配函数
		http.doRequest=function(){
			$.ajax(this.request);
		};
		return http;
	},
	//string,string
	saveKeyValue:function(key,value){
		LStorage.setItem(key,value);		
	},
	getKeyValue:function(key){
		return LStorage.getItem(key);		
	}
};
})();