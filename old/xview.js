//Cat.prototype = new Animal();
var MatchParent = -1;
var WrapContent = -2;

var GravityNO = 0X00000000;
var GravityLeft = 0X00000001<<0;
var GravityRight = 0X00000001<<1;
var GravityCenterH = 0X00000001<<2;

var GravityTop = 0X00000001<<4;
var GravityBottom = 0X00000001<<5;
var GravityCenterV = 0X00000001<<6;

var GravityLeftTop = GravityLeft|GravityTop;
var GravityLeftCenter = GravityLeft|GravityCenterV;
var GravityLeftBottom = GravityLeft|GravityBottom;
var GravityCenterTop = GravityCenterH|GravityTop;
var GravityCenter = GravityCenterH|GravityCenterV;
var GravityCenterBottom = GravityCenterH|GravityBottom;
var GravityRightTop = GravityRight|GravityTop;
var GravityRightCenter = GravityRight|GravityCenterV;
var GravityRightBottom = GravityRight|GravityBottom;

//判断当前view在父窗体的方位. 先判断自己是否指定方位，没有再判断父窗体是否制定
function isOnLeft(layoutGravity,parentGravity){
	if((layoutGravity&GravityCenterH)>0){
		return false;
	}
	if((layoutGravity&GravityRight)>0){
		return false;
	}
	if((parentGravity&GravityCenterH)>0){
		return false;
	}
	if((parentGravity&GravityRight)>0){
		return false;
	}
	return true;
}
function isOnRight(layoutGravity,parentGravity){
	if((layoutGravity&GravityLeft)>0){
		return false;
	}
	if((layoutGravity&GravityCenterH)>0){
		return false;
	}
	if((layoutGravity&GravityRight)>0){
		return true;
	}
	if((parentGravity&GravityRight)>0){
		return true;
	}
	return false;
}
function isOnCenterH(layoutGravity,parentGravity){
	if((layoutGravity&GravityLeft)>0){
		return false;
	}
	if((layoutGravity&GravityCenterH)>0){
		return true;
	}
	if((layoutGravity&GravityRight)>0){
		return false;
	}
	if((parentGravity&GravityCenterH)>0){
		return true;
	}
	return false;
}
function isOnTop(layoutGravity,parentGravity){
	if((layoutGravity&GravityCenterV)>0){
		return false;
	}
	if((layoutGravity&GravityBottom)>0){
		return false;
	}
	if((parentGravity&GravityCenterV)>0){
		return false;
	}
	if((parentGravity&GravityBottom)>0){
		return false;
	}
	return true;
}
function isOnCenterV(layoutGravity,parentGravity){
	if((layoutGravity&GravityTop)>0){
		return false;
	}
	if((layoutGravity&GravityCenterV)>0){
		return true;
	}
	if((layoutGravity&GravityBottom)>0){
		return false;
	}
	if((parentGravity&GravityCenterV)>0){
		return true;
	}
	return false;
}
function isOnBottom(layoutGravity,parentGravity){
	if((layoutGravity&GravityTop)>0){
		return false;
	}
	if((layoutGravity&GravityCenterV)>0){
		return false;
	}
	if((layoutGravity&GravityBottom)>0){
		return true;
	}
	if((parentGravity&GravityBottom)>0){
		return true;
	}
	return false;
}
//继承
function Extern(ClassChild,ClassParent){
	//复制父类的静态方法，静态函数
	for(var name in ClassParent){
		ClassChild[name] = ClassParent[name];
	}
	//记录类型
	ClassChild.ThisClass=ClassChild;
	ClassChild.SuperClass=ClassParent;
	// 创建一个没有实例方法的类
	var Super = function(){};
	Super.prototype = ClassParent.prototype;
	//将实例作为子类的原型
	ClassChild.prototype = new Super();
	//重写获取类型方法
	//ClassChild.prototype.__thisClsss=function(){
	//	return ClassChild;
	//}
	//ClassChild.prototype.__superClsss=function(){
	//	return ClassParent;
	//}
	//子实例共享一个父类实例，错误继承
	//ClassChild.prototype = new ClassParent();
}
//重载父类方法
function Override(Class,funName,newFunc){
	var superFun=Class.prototype[funName];
	Class.prototype[funName]=newFunc;
	//记录父类方法,调用时从arguments.callee再此获取/。 浏览器严格模式下获取不到。
	//newFunc.ThisClass = Class;
	//newFunc.ThisFun = newFunc;
	newFunc.SuperFun = superFun;
}
//调用父类方法
function CallSuper(...pama){
	var currFun = arguments.callee;
	return currFun.SuperFun.apply(arguments.caller,pama);
}

//重载父类方法
function OverrideFunction(Class,funName,newFunc){
	var superFun=Class.prototype[funName];
	Class.prototype[funName] = function(...pama){
		superFun._Thiz=this;
		pama.unshift(superFun);
		return newFunc.apply(this,pama);
	}
}
//调用父类方法
function CallSuperFunction(superFun,...pama){
	return superFun.apply(superFun._Thiz,pama);
}
//重载父类方法
function OverrideFunction(Class,funName,newFunc){
	var superFun=Class.prototype[funName];
	//Class.prototype[funName]=newFunc;
	//记录父类方法,调用时从arguments.callee再此获取/。 浏览器严格模式下获取不到。
	//newFunc.ThisClass = Class;
	//newFunc.ThisFun = newFunc;
	//newFunc.SuperFun = superFun;
	Class.prototype[funName] = function(...pama){
		superFun._Thiz=this;
		pama.unshift(superFun);
		return newFunc.apply(this,pama);
	}
	
}
//调用父类方法
function CallSuperFunction(superFun,...pama){
	//var currFun = arguments.callee;
	//currFun.SuperFun.apply(arguments.callee.caller,pama);
	return superFun.apply(superFun._Thiz,pama);
}
//测试类型
function ClassA(){}
ClassA.prototype.test=function(num){
	console.log('执行ClassA.test num='+num);
}
function ClassB(){ClassA.call(this)}
Extern(ClassB,ClassA);
OverrideFunction(ClassB,"test",function(superFun,num){
	console.log('执行ClassB.test num='+num);
	CallSuperFunction(superFun,num+1);
});
function ClassC(){ClassB.call(this)}
Extern(ClassC,ClassB);
OverrideFunction(ClassC,"test",function(superFun,num){
	console.log('执行ClassC.test num='+num);
	CallSuperFunction(superFun,num+1);
});
function ClassD(){ClassC.call(this)}
Extern(ClassD,ClassC);
OverrideFunction(ClassD,"test",function(superFun,num){
	console.log('执行ClassD.test num='+num);
	CallSuperFunction(superFun,num+1);
});
//
Array.prototype.removeValue = function(val) {
  for(var i=0; i<this.length; i++) {
    if(this[i] == val) {
      this.splice(i, 1);
      break;
    }
  }
}

//添加视图到body上
function setAppMainView(view){
	//view.div.style.width="100%";
	//view.div.style.height="100%";
	view.div.style.position="absolute";
	document.body.style.margin="0px";
	document.body.style.padding="0px";
	document.body.style.overflow="hidden";
	document.body.appendChild(view.div);
	
	view.setWidth(MatchParent);
	view.setHeight(MatchParent);
	//创建一个假的父类
	view.parent = new View();
	
	var onLayout = function(){
		var rect = view.div.getBoundingClientRect();
		view.layoutIf(rect.width,rect.height);
	};
	//
	var callNeedLayou = view.setNeedLayout;
	view.setNeedLayout = function(){
		if(this.hasLayout){
			setTimeout(onLayout,0);
		}
		callNeedLayou.call(view);
	}
	window.onresize =function(){
		callNeedLayou.call(view);
		onLayout();
	};
	onLayout();
	
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
 * js获取文本显示宽度 
 * @param str: 文本 
 * @return 文本显示宽度   
 */
var mesuerTextView=null;
function getTextWidthHeight(text,maxWidth,size) {
		if(mesuerTextView==null){
			mesuerTextView = document.createElement("div");
			//mesuerTextView.style.display="none";
			//mesuerTextView.style.letterSpacing="0px";
			//mesuerTextView.style.lineHeight="0px";
			mesuerTextView.style.position="absolute";
			mesuerTextView.style.wordBreak="break-all";
			mesuerTextView.style.margin="auto";
			mesuerTextView.style.color="rgba(0,0,0,0)";
			document.body.appendChild(mesuerTextView);
		}
		mesuerTextView.innerText=text;
		mesuerTextView.style.width="auto";//getFontSizeFormInt(width);//"auto";
		mesuerTextView.style.maxWidth=getFontSizeFormInt(maxWidth);
		mesuerTextView.style.fontSize=getFontSizeFormInt(size);
		mesuerTextView.style.lineHeight=getFontSizeFormInt(size);
		var rect = mesuerTextView.getBoundingClientRect();
		if(rect.width>maxWidth&&rect.height<size*1.5){
			mesuerTextView.style.width=getFontSizeFormInt(maxWidth);
			rect  = mesuerTextView.getBoundingClientRect();
		}
		mesuerTextView.innerText="";
		return {w:rect.width,h:rect.height};
      
      return w;  
}  
//自定义view，继承div
const XViewProto = Object.create(HTMLDivElement.prototype, {
  /* 元素生命周期的事件 */
  // 实例化时触发
  createdCallback: {
    value: function(){
      //console.log('invoked createCallback!')
      const raw = this.innerHTML
       
    }
  },
  onAddToApp: {
    get: function(){
		return onAddToApp;
	},
    set: function(val){
		onAddToApp = val;
	}
  },
  onRemoveFormApp: {
    get: function(){ 
		return onRemoveFormApp;
	},
    set: function(val){
		onRemoveFormApp = val;
	}
  },
  // 元素添加到DOM树时触发
  attachedCallback: {
    value: function(){
      //console.log('invoked attachedCallback!')
	  if(this.onAddToApp){
		  this.onAddToApp();
	  }
    }
  },
  // 元素DOM树上移除时触发
  detachedCallback: {
    value: function(){
      //console.log('invoked detachedCallback!')
	  if(this.onRemoveFormApp){
		  this.onRemoveFormApp();
	  }
    }
  },
  // 元素的attribute发生变化时触发
  attributeChangedCallback: {
    value: function(attrName, oldVal, newVal){
      //console.log(`attributeChangedCallback-change ${attrName} from ${oldVal} to ${newVal}`)
    }
  },
  /* 定义元素的公有方法和属性 */
  // 重写textContent属性
  innerText2: {
    get: function(){ 
		//return super.innerText;
		return innerText;
	},
    set: function(val){
		//super.innerText = val;
		innerText = val;
	}
  },
  close: {
    value: function(){ this.style.display = 'none' }
  },
  show: {
    value: function(){ this.style.display = 'block' }
  },
  mLeft:{
	  get:function(){
		  return mleft;
	  },
	  set:function(value){
		  mleft = value;
	  }
  },
  resize:{
    value: function(){
      //console.log('invoked resize!')
    }
  }
}) 
// 向浏览器注册自定义元素
const XView = document.registerElement('x-View', { prototype: XViewProto })


function View(){
	var thiz=this;
	this.div = new XView();// document.createElement("div");
	this.div.style.position="absolute";//   static|relative|absolute|fixed
	this.div.style.wordBreak="break-all";
	this.div.style.overflow="hidden";
	this.parent=null;
	this.childs=[];
	this.gravity = GravityLeftTop;
	this.layoutGravity = GravityNO;
	this.width=WrapContent;
	this.height=WrapContent;
	this.weight=0;
	this.mLeft=0;
	this.mTop=0;
	this.mRight=0;
	this.mBottom=0;
	this.pLeft=0;
	this.pTop=0;
	this.pRight=0;
	this.pBottom=0;
 
	//
	this.div.style.left="0px";
	this.div.style.right="0px";
	this.div.style.top="0px";
	this.div.style.bottom="0px";
	this.div.style.margin="auto";
	//this.div.style.marginRight="10px";
	//this.div.style.marginBottom="110px";
 
	this.setWidth(WrapContent);
	this.setHeight(WrapContent);
	
	var sadasd = thiz.onAddToApp;
	//注意this类
	this.div.onAddToApp=function(){
		sadasd.call(thiz);//等同于thiz.onAddToApp();
	}
	this.div.onRemoveFormApp=function(){
		//View.call(this,thiz.onRemoveFormApp);
		thiz.onRemoveFormApp();
	}
	this.isOnAddToApp=false;
	this.hasLayout=false;
	return this;
}
View.Gone=1;
View.prototype.onAddToApp=function(){
	this.isOnAddToApp=true;
	//console.log('onAddToApp')
}
View.prototype.onRemoveFormApp=function(){
	this.isOnAddToApp=false;
	//console.log('onRemoveFormApp')
}
View.prototype.setClipBound=function(clip){
	if(clip){
		this.div.style.overflow="hidden";
	}else{
		this.div.style.overflow="visible";
	}
}
View.prototype.addView = function(view){
	this.div.appendChild(view.div);
	this.childs.push(view);
	view.parent=this;
	view.setNeedLayout();
}
View.prototype.removeView = function(view){
	this.div.removeChild(view.div);
	this.childs.removeValue(view);
	view.parent=null;
	setNeedLayout();
}
View.prototype.removeFromParent = function(view){
	if(view.parent!=null){
		view.parent.removeView(view);
	}
}
View.prototype.setWidth=function(w){
	if(this.width != w){
		this.width = w;
		this.setNeedLayout();
	}
}
View.prototype.setHeight=function(h){
	if(this.height != h){
		this.height = h;
		this.setNeedLayout();
	}
}
View.prototype.setBackColor=function(color){
	this.div.style.backgroundColor=getBackColorFormInt(color);
}
View.prototype.setBackImage=function(url){
	this.div.style.background="url("+url+")";
	//<div style="background:url(images/index8_29.gif) repeat-y;">
}
View.prototype.setGravity=function(g){
	if(this.gravity != g){
		this.gravity = g;
		this.setNeedLayout();
	}
}
View.prototype.setLayoutGravity=function(g){
 	if(this.layoutGravity != g){
		this.layoutGravity = g;
		this.setNeedLayout();
	}
}
View.prototype.setMargin=function(l,t,r,b){
	this.setMLeft(l);
	this.setMTop(t);
	this.setMRight(r);
	this.setMBottom(b);
}
View.prototype.setMLeft=function(value){
	 if(this.mLeft != value){
		this.mLeft = value;
		this.setNeedLayout();
	}
}
View.prototype.setMTop=function(value){
	 if(this.mTop != value){
		this.mTop = value;
		this.setNeedLayout();
	}
}
View.prototype.setMRight=function(value){
	 if(this.mRight != value){
		this.mRight = value;
		this.setNeedLayout();
	}
}
View.prototype.setMBottom=function(value){
	 if(this.mBottom != value){
		this.mBottom = value;
		this.setNeedLayout();
	}
}
View.prototype.setPadding=function(l,t,r,b){
	this.setPLeft(l);
	this.setPTop(t);
	this.setPRight(r);
	this.setPBottom(b);
}
View.prototype.setPLeft=function(value){
	 if(this.pLeft != value){
		this.pLeft = value;
		this.div.style.paddingLeft=getSizeFormInt(value);
		this.setNeedLayout();
	}
}
View.prototype.setPTop=function(value){
	 if(this.pTop != value){
		this.pTop = value;
		this.div.style.paddingTop=getSizeFormInt(value);
		this.setNeedLayout();
	}
}
View.prototype.setPRight=function(value){
	 if(this.pRight != value){
		this.pRight = value;
		this.div.style.paddingRight=getSizeFormInt(value);
		this.setNeedLayout();
	}
}
View.prototype.setPBottom=function(value){
	 if(this.pBottom != value){
		this.pBottom = value;
		this.div.style.paddingBottom=getSizeFormInt(value);
		this.setNeedLayout();
	}
}

View.prototype.setOnClick=function(fun){
	this.div.onclick= fun;
}
//子view变动，询问父窗体是否需要重新布局
View.prototype.onChildChange=function(child){
	this.setNeedLayout();
}
//父view变动，询问子窗体是否需要重新布局
View.prototype.onParentChange=function(){
	//防止循环
	if(this.hasLayout){
		//如果宽度适应父窗体，高度适应内容，则重新布局. 因为宽度改变，可能导致高度变化。
		if(this.width==MatchParent&&this.height==WrapContent){
			this.setNeedLayout();
		}
	}
}
View.prototype.checkThisGravity=function(){
	var parentGravity= GravityNO;
	if(this.parent!=null){
		parentGravity = this.parent.gravity;
	}
	//this.div.style.margin="auto";
	if(isOnRight(this.layoutGravity,parentGravity)){
		this.div.style.marginLeft="auto";
		this.div.style.marginRight="0px";
	}else if(isOnCenterH(this.layoutGravity,parentGravity)){
		this.div.style.marginLeft="auto";
		this.div.style.marginRight="auto";
	}else{
		this.div.style.marginLeft="0px";
		this.div.style.marginRight="auto";
	}
	
	if(isOnBottom(this.layoutGravity,parentGravity)){
		this.div.style.marginTop="auto";
		this.div.style.marginBottom="0px";
	}else if(isOnCenterV(this.layoutGravity,parentGravity)){
		this.div.style.marginTop="auto";
		this.div.style.marginBottom="auto";
	}else{
		this.div.style.marginTop="0px";
		this.div.style.marginBottom="auto";
	}
	
}
//属性发生变化，需要重新布局。（非真正布局，真正布局是浏览器执行的，所以不一定需要按层级向上请求）
View.prototype.setNeedLayout=function(){
	if(this.hasLayout){
		this.hasLayout=false;
		//先遍历子View. 不能用in遍历，in会把数组自定义方法也遍历出来
		this.childs.forEach(function(value,intdex){
			value.onParentChange();
		});
	}
	//通知父View
	if(this.parent!=null){
		this.parent.onChildChange(this);
	}
}
//布局，计算适应内容的具体宽高
View.prototype.layoutIf=function(pw,ph){
	//if(!this.isOnAddToApp){
	//	return;
	//}
	if(this.hasLayout){
		return;
	}
	//
	this.hasLayout = true;
	
	var mesuerSize=null;
	//重新布局大小. 注意div的实际宽度为style.width+style.paddingLeft+style.paddingRight
	var thizW=pw;
	var thizH=ph;
	
	//宽	--- 父窗体的padding无法限制子div
	this.div.style.left=getSizeFormInt(this.mLeft+this.parent.pLeft);
	this.div.style.right=getSizeFormInt(this.mRight+this.parent.pRight);
	if(this.width==MatchParent){
		this.div.style.width="auto";
		thizW = pw;
	}else if(this.width==WrapContent){
		//mesuerSize = this.measureChild(0,ph);//高度也可以为0
		mesuerSize = this.measure(pw,ph);
		this.div.style.width=getSizeFormInt(mesuerSize.w-this.mLeft-this.mRight-this.pLeft-this.pRight);
		thizW = mesuerSize.w;
	}else{
		this.div.style.width=getSizeFormInt(this.width-this.pLeft-this.pRight);
		thizW = this.width+this.mLeft+this.mRight;
	}
	
	//高
	this.div.style.top=getSizeFormInt(this.mTop+this.parent.pTop);
	this.div.style.bottom=getSizeFormInt(this.mBottom+this.parent.pBottom);
	if(this.height==MatchParent){
		this.div.style.height="auto";
		thizH = ph;
	}else if(this.height==WrapContent){
		mesuerSize = this.measure(pw,ph);
		this.div.style.height=getSizeFormInt(mesuerSize.h-this.mTop-this.mBottom-this.pTop-this.pBottom);
		thizH = mesuerSize.h;
	}else{
		this.div.style.height=getSizeFormInt(this.height-this.pTop-this.pBottom);
		thizH = this.height+this.mTop+this.mBottom;
	}
	
	//重新布局比重
	this.checkThisGravity();
	
	//布局所有子view
	var thiz = this;
	this.getLayoutChilds().forEach(function(child,intdex){
			child.layoutIf(thizW-thiz.mLeft-thiz.pLeft-thiz.mRight-thiz.pRight,thizH-thiz.mTop-thiz.mBottom-thiz.pTop-thiz.pBottom);
	});

}
//获取基础布局的view，其它重写View布局的，需要重写此函数
View.prototype.getLayoutChilds=function(){
	return this.childs;
}
//测量子view的最大宽高，忽略使用比重的。包含外边距。
View.prototype.measureChild=function(pw,ph){
	var size = {w:0,h:0};
	this.getLayoutChilds().forEach(function(view,index){
		var temp = view.measure(pw,ph);
		if(temp.w>size.w){
			size.w=temp.w;
		}
		if(temp.h>size.h){
			size.h=temp.h;
		}
	});
	return size;
}
//测量自己的最大宽高
View.prototype.measure=function(pw,ph){
	var size = {w:this.width,h:this.height};
	
	if(this.width==MatchParent){
		size.w = pw-this.mLeft-this.mRight;
	}
	if(this.height==MatchParent){
		size.h= ph-this.mTop-this.mBottom;
	}
	if(this.width==WrapContent||this.height==WrapContent){
		var boundW = this.width==WrapContent?0:size.w-this.pLeft-this.pRight;
		var boundH = this.height==WrapContent?0:size.h-this.pTop-this.pBottom;
		size = this.measureChild(boundW,boundH);
		size.w+=this.pLeft+this.pRight;
		size.h+=this.pTop+this.pBottom;
	}
	size.w+=this.mLeft+this.mRight;
	size.h+=this.mTop+this.mBottom;
	return size;
}
//
function TextView(){
	//
	View.call(this);

	 
	//this.div.style.display="table-cell";//剧中
	var thiz = this;
	var superSetGravity = this.setGravity;
	this.setGravity=function(gravity){
		if(gravity==GravityCenter){
			thiz.div.style.textAlign="center";
			thiz.div.style.align="center";
			thiz.div.style.verticalAlign="middle";
		}else{
			//superSetGravity(gravity);
			// 注意不能直接superSetGravity(gravity),否则函数中的this将变成window
			superSetGravity.call(thiz,gravity);
		}
	}
	this.lineSpace = 0;
	this.fontSize =0;
	this.setText("",16,0xff000000);
	this.setLineSpace(0);
	return this;
}
//TextView继承View
Extern(TextView,View);
//其它方法
TextView.prototype.setText=function(text,size,color){
	//this.div.innerHTML = text;
	if(this.text!=text){
		this.div.innerText=text;
		this.text=text;
		this.setNeedLayout();
	}
	if(typeof(size)!="undefined"){
		this.setTextSize(size);
	}
	if(typeof(color)!="undefined"){
		this.setTextColor(color);
	}
}
TextView.prototype.setTextSize=function(size){
	if(this.fontSize!=size){
		var fsize = getFontSizeFormInt(size);
		this.fontSize=size;
		
		this.div.style.fontSize=getFontSizeFormInt(this.fontSize);
		this.div.style.lineHeight=getFontSizeFormInt(this.fontSize+this.lineSpace);
		this.setNeedLayout();
	}
	
}
TextView.prototype.setTextColor=function(color){
	this.fontColor=color;
	this.div.style.color=getFontColorFormInt(color);
}
TextView.prototype.setLineSpace=function(value){
	if(this.lineSpace!=value){
		this.lineSpace=value;
		
		this.div.style.fontSize=getFontSizeFormInt(this.fontSize);
		this.div.style.lineHeight=getFontSizeFormInt(this.fontSize+this.lineSpace);
		this.setNeedLayout();
	}
}
//TextView.prototype.measureChild=function(pw,ph){
//	var size =null;
//	if(this.width==WrapContent ){
//		size = getTextWidthHeight(this.text,0x8fffffff,this.fontSize);
//	}else if(this.width>=0){
//		size = getTextWidthHeight(this.text,this.width,this.fontSize);
//	}else{
//		size = getTextWidthHeight(this.text,pw,this.fontSize);
//	}
//	return size;
//}
OverrideFunction(TextView,"measureChild",function(superFun,pw,ph){
	var size;// = CallSuperFunction(superFun,pw,ph);
	if(this.width==WrapContent ){
		size = getTextWidthHeight(this.text,0x8fffffff,this.fontSize);
	}else if(this.width>=0){
		size = getTextWidthHeight(this.text,this.width,this.fontSize);
	}else{
		size = getTextWidthHeight(this.text,pw,this.fontSize);
	}
	return size;
});

//
//
function LinearLayout(){
	//
	View.call(this);

 
	return this;
}
//LinearLayout继承View
Extern(LinearLayout,View);
//其它方法
OverrideFunction(LinearLayout,"addView",function(superFun,view){
	CallSuperFunction(superFun,view);
});
OverrideFunction(LinearLayout,"getLayoutChilds",function(superFun){
	return CallSuperFunction(superFun);
});
OverrideFunction(LinearLayout,"layoutIf",function(superFun,pw,ph){
	//先布局线性view
	
	//再布局基础View
	CallSuperFunction(superFun,pw,ph);
	
});
OverrideFunction(LinearLayout,"measureChild",function(superFun,pw,ph){
	var size =  CallSuperFunction(superFun,pw,ph);
	return size;
});
OverrideFunction(LinearLayout,"measure",function(superFun,pw,ph){
	
	var size =  CallSuperFunction(superFun,pw,ph);
	return size;
});
