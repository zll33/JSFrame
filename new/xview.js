//Cat.prototype = new Animal();

var Extern;
var OverrideFunction;
var CallSuperFunction;

//
var TView=0;// 四个基础控件
var TTextView=1;// 四个基础控件
var TEditView=2;// 四个基础控件
var TScrollView=3;// 四个基础控件


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


//
var Horizontal = 1;
var Vertical = 2;

//
var ScrollStart=1;//开始滚动
var ScrollStartSlide=2;//手指松开，开始惯性滑动
var ScrollSlide=3;//惯性滑动中
var ScrollStop=4;//滚动结束

//
var ScaleMax = 0;//默认：图片填满View的宽或高，View可能不留空。图片可能按比例缩放，图片显示完整。
var ScaleCrop = 1;//图片填满View，View完全不留空。图片可能按比例缩放，多余的图片会剪切掉。
var ScaleFill = 2;//图片填满View，View完全不留空。图片可能变形，图片显示完整。

//
var Rule={
	//关系
	Equal:0,
	LessThan:1,
	GreaterThan:2,
	//属性为空，用于出现变动，通知自己的
	NO:0,
	//水平属性
	MLeft:1,
	Left:2,
	Width:3,
	PLeft:4,
	CenterH:5,
	PRight:6,
	Right:7,
	MRight:8,
	
	//
	Center:10,
	
	//垂直属性
	MTop:11,
	Top:12,
	Height:13,
	PTop:14,
	CenterV:15,
	PBottom:16,
	Bottom:17,
	MBottom:18,
	
	
};
var View;
var TextView;
var LinearLayout;
var ScrollView;
var ListView;
var EditView;
var Line;
var setMainView;

//以上是全局变量
//以下是内部函数，防止函数被修改
(function(){
function RectF(left,top,w,h){
	this.left=left;
	this.top=top;
	this.right=left+w;
	this.bottom=top+h;
	this.width=function(){
		return this.right-this.left;
	};
	this.height=function(){
		return this.bottom-this.top;
	};
	return this;
}
//
Rule.doRule=function(view1){
	view1.rule.forEach(function(node,index){
		if(node.firstType!=Rule.NO){
			Rule.setRelativeFirst(node.firstView, node.firstType, node.toView, node.toType,node.multiple, node.disparity, node.keepWH,node.relation);
		}
	});
}
Rule.setRelativeFirst=function(firstView, firstType,
			toView, toType, multiple, disparity,
			keepWH,relation) {

		if (toView.parent == null) {
			return;
		}
		if (firstType == Rule.Center && toType == Rule.Center) {
			var value = Rule.getRelative(toView, CRule.enterH);
			value -= Rule.getDParent(firstView, toView, Rule.CenterH);
			Rule.setRelative(firstView, Rule.CenterH, value * multiple + disparity,keepWH,relation);

			value = Rule.getRelative(toView, Rule.CenterV);
			value -= Rule.getDParent(firstView, toView, Rule.CenterV);
			Rule.setRelative(firstView, Rule.CenterV, value * multiple + disparity,keepWH,relation);

		} else {
			if (firstType >= Rule.MLeft && firstType <= Rule.MRight && toType <= Rule.MRight && toType >= Rule.MLeft) {
				var value = Rule.getRelative(toView, toType);
				value -= Rule.getDParent(firstView, toView, firstType);
				Rule.setRelative(firstView, firstType, value * multiple + disparity, keepWH,relation);
			}
			if (firstType >= Rule.MTop && firstType <= Rule.MBottom && toType <= Rule.MBottom && toType >= Rule.MTop) {
				var value = Rule.getRelative(toView, toType);
				value -= Rule.getDParent(firstView, toView, firstType);
				Rule.setRelative(firstView, firstType, value * multiple + disparity, keepWH,relation);
			}
		}
		//将不带父窗体内边的布局，转换为带父窗体内边距的布局
		var x = firstView.layoutRect.left;
		var y = firstView.layoutRect.top;
		var w= firstView.layoutRect.width();
		var h = firstView.layoutRect.height();
		if(firstView.parent!=null){
			x += firstView.parent.pLeft;
			y += firstView.parent.pTop;
		}
		firstView.setLayoutX(x);
		firstView.setLayoutY(y);
		firstView.setLayoutWidth(w);
		firstView.setLayoutHeight(h);
	}

	Rule.getDParent=function (view1, view2,  type) {
		var value = 0;
		var rect = view1.parent.getLayoutRectInView(view2.parent);

		rect.left += view1.parent.pLeft - view2.parent.pLeft;
		rect.top += view1.parent.pTop - view2.parent.pTop;

		switch (type) {
		case Rule.MLeft:
			value = rect.left;
			break;
		case Rule.Left:
			value = rect.left;
			break;
		case Rule.Width:
			value = 0;
			break;
		case Rule.PLeft:
			value = rect.left;
			break;
		case Rule.CenterH:
			value = rect.left;
			break;
		case Rule.PRight:
			value = rect.left;
			break;
		case Rule.MRight:
			value = rect.left;
			break;
		case Rule.Right:
			value = rect.left;
			break;
		case Rule.MTop:
			value = rect.top;
			break;
		case Rule.Top:
			value = rect.top;
			break;
		case Rule.Height:
			value = 0;
			break;
		case Rule.PTop:
			value = rect.top;
			break;
		case Rule.CenterV:
			value = rect.top;
			break;
		case Rule.PBottom:
			value = rect.top;
			break;
		case Rule.Bottom:
			value = rect.top;
			break;
		case Rule.MBottom:
			value = rect.top;
			break;
		default:
			break;
		}
		return value;
	}

	Rule.getRelative=function(view, type) {
		var value = 0;
		switch (type) {
		case Rule.MLeft:
			value = view.layoutRect.left - view.mLeft;
			break;
		case Rule.Left:
			value = view.layoutRect.left;
			break;
		case Rule.Width:
			value = view.layoutRect.width();
			break;
		case Rule.PLeft:
			value = view.layoutRect.left + view.pLeft();
			break;
		case Rule.CenterH:
			value = (view.layoutRect.left + view.layoutRect.right) / 2;
			break;
		case Rule.PRight:
			value = view.layoutRect.right - view.getPRight();
			break;
		case Rule.MRight:
			value = view.layoutRect.right + view.getMRight();
			break;
		case Rule.Right:
			value = view.layoutRect.right;
			break;
		case Rule.MTop:
			value = view.layoutRect.top - view.getMTop();
			break;
		case Rule.Top:
			value = view.layoutRect.top;
			break;
		case Rule.Height:
			value = view.layoutRect.height();
			break;
		case Rule.PTop:
			value = view.layoutRect.top + view.getPTop();
			break;
		case Rule.CenterV:
			value = (view.layoutRect.top + view.layoutRect.bottom) / 2;
			break;
		case Rule.PBottom:
			value = view.layoutRect.bottom - view.getPBottom();
			break;
		case Rule.Bottom:
			value = view.layoutRect.bottom;
			break;
		case Rule.MBottom:
			value = view.layoutRect.bottom + view.getPBottom();
			break;
		default:
			break;
		}
		return value;
	}

	Rule.setRelative=function (view, type, value,keepWH, relation) {
		var w = view.layoutRect.width();
		var h = view.layoutRect.height();
		switch (type) {
		case Rule.MLeft:
			if(relation==Rule.Equal
					||(relation==Rule.LessThan && view.layoutRect.left>value + view.mLeft)
					||(relation==Rule.GreaterThan && view.layoutRect.left<value + view.mLeft))
			{
				view.layoutRect.left = value + view.getMLeft();
				
			}
			if (keepWH) {
				view.layoutRect.right = view.layoutRect.left + w;
			}
			break;
		case Rule.Left:
			if(relation==Rule.Equal
					||(relation==Rule.LessThan && view.layoutRect.left>value)
					||(relation==Rule.GreaterThan && view.layoutRect.left<value))
			{
				view.layoutRect.left = value;
			}

			if (keepWH) {
				view.layoutRect.right = view.layoutRect.left + w;
			}
			break;
		case Rule.Width:
			if(relation==Rule.Equal
					||(relation==Rule.LessThan && view.layoutRect.right> value + view.layoutRect.left)
					||(relation==Rule.GreaterThan && view.layoutRect.right < value + view.layoutRect.left))
			{
				view.layoutRect.right = value + view.layoutRect.left;
			}

			break;
		case Rule.PLeft:
			if(relation==Rule.Equal
					||(relation==Rule.LessThan && view.layoutRect.left > value - view.getPLeft())
					||(relation==Rule.GreaterThan && view.layoutRect.left < value - view.getPLeft()))
			{
				view.layoutRect.left = value - view.getPLeft();
			}

			if (keepWH) {
				view.layoutRect.right = view.layoutRect.left + w;
			}
			break;
		case Rule.CenterH:
			var centerH = view.layoutRect.left+w/2;
			if(relation==Rule.Equal
					||(relation==Rule.LessThan && centerH > value)
					||(relation==Rule.GreaterThan && centerH < value))
			{
				view.layoutRect.left = value - w / 2;
				view.layoutRect.right = view.layoutRect.left + w;
			}

			break;
		case Rule.PRight:
			if(relation==Rule.Equal
					||(relation==Rule.LessThan && view.layoutRect.right > value + view.getPRight())
					||(relation==Rule.GreaterThan && view.layoutRect.right < value + view.getPRight()))
			{
				view.layoutRect.right = value + view.getPRight();
			}

			if (keepWH) {
				view.layoutRect.left = view.layoutRect.right - w;
			}
			break;
		case Rule.MRight:
			if(relation==Equal
					||(relation==Rule.LessThan && view.layoutRect.right > value - view.getMRight())
					||(relation==Rule.GreaterThan && view.layoutRect.right < value - view.getMRight()))
			{
				view.layoutRect.right = value - view.getMRight();
			}
			if (keepWH) {
				view.layoutRect.left = view.layoutRect.right - w;
			}
			break;

		case Rule.Right:
			if(relation==Rule.Equal
					||(relation==Rule.LessThan && view.layoutRect.right > value)
					||(relation==Rule.GreaterThan && view.layoutRect.right < value))
			{
				view.layoutRect.right = value;
			}
			if (keepWH) {
				view.layoutRect.left = view.layoutRect.right - w;
			}
			break;
		case Rule.MTop:
			if(relation==Rule.Equal
					||(relation==Rule.LessThan && view.layoutRect.top > value + view.getMTop())
					||(relation==Rule.GreaterThan && view.layoutRect.top < value + view.getMTop()))
			{
				view.layoutRect.top = value + view.getMTop();
			}
			if (keepWH) {
				view.layoutRect.bottom = view.layoutRect.top + h;
			}
			break;
		case Rule.Top:
			if(relation==Rule.Equal
					||(relation==Rule.LessThan && view.layoutRect.top > value)
					||(relation==Rule.GreaterThan && view.layoutRect.top < value))
			{
				view.layoutRect.top = value;
			}
			if (keepWH) {
				view.layoutRect.bottom = view.layoutRect.top + h;
			}
			break;
		case Rule.Height:
			if(relation==Rule.Equal
					||(relation==Rule.LessThan && view.layoutRect.bottom > view.layoutRect.top + value)
					||(relation==Rule.GreaterThan && view.layoutRect.bottom < view.layoutRect.top + value))
			{
				view.layoutRect.bottom = view.layoutRect.top + value;
			}
			if (keepWH) {
				view.layoutRect.top = view.layoutRect.bottom - h;
			}
			break;
		case Rule.PTop:
			if(relation==Rule.Equal
					||(relation==Rule.LessThan && view.layoutRect.top > value - view.getPTop())
					||(relation==Rule.GreaterThan && view.layoutRect.top < value - view.getPTop()))
			{
				view.layoutRect.top = value - view.getPTop();
			}
			if (keepWH) {
				view.layoutRect.bottom = view.layoutRect.top + h;
			}
			break;
		case Rule.CenterV:
			var centerV = view.layoutRect.top+ h / 2;
			if(relation==Rule.Equal
					||(relation==Rule.LessThan && centerV > value)
					||(relation==Rule.GreaterThan && centerV < value))
			{
				view.layoutRect.top = value - h / 2;
				view.layoutRect.bottom = view.layoutRect.top + h;
			}
			break;
		case Rule.PBottom:
			if(relation==Rule.Equal
					||(relation==Rule.LessThan && view.layoutRect.bottom > value + view.getPBottom())
					||(relation==Rule.GreaterThan && view.layoutRect.bottom < value + view.getPBottom()))
			{
				view.layoutRect.bottom = value + view.getPBottom();
			}
			if (keepWH) {
				view.layoutRect.top = view.layoutRect.bottom - h;
			}
			break;
		case Rule.Bottom:
			if(relation==Rule.Equal
					||(relation==Rule.LessThan && view.layoutRect.bottom > value)
					||(relation==Rule.GreaterThan && view.layoutRect.bottom < value))
			{
				view.layoutRect.bottom = value;
			}
			if (keepWH) {
				view.layoutRect.top = view.layoutRect.bottom - h;
			}
			break;
		case Rule.MBottom:
			if(relation==Rule.Equal
					||(relation==Rule.LessThan && view.layoutRect.bottom > value - view.getPBottom())
					||(relation==Rule.GreaterThan && view.layoutRect.bottom < value - view.getPBottom()))
			{
				view.layoutRect.bottom = value - view.getPBottom();
			}
			if (keepWH) {
				view.layoutRect.top = view.layoutRect.bottom - h;
			}
			break;
		default:
			break;
		}
	}
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
Extern =function(ClassChild,ClassParent){
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
//调用父类方法. IE 低版本不支持...pama
//function CallSuper(...pama){
function CallSuper(){
	var currFun = arguments.callee;
	return currFun.SuperFun.apply(arguments.caller,arguments);
}

//重载父类方法
function OverrideFunction(Class,funName,newFunc){
	var superFun=Class.prototype[funName];
	Class.prototype[funName] = function(){
		
		superFun._Thiz=this;
		var pama = [superFun];
		for(var i=0;i<arguments.length;i++){
			pama.push(arguments[i]);
		}
		return newFunc.apply(this,pama);
	}
}
//调用父类方法
CallSuperFunction =function(){
	var pama = [];
	for(var i=1;i<arguments.length;i++){
		pama.push(arguments[i]);
	}
	return arguments[0].apply(arguments[0]._Thiz,pama);
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
	  return true;
    }
  }
  return false;
}

//仅仅子View变化，不需要父窗体布局的，加入队列中。
var NeedLayoutViews =[];
function addNeedLayoutView(view){
	if(view.parent!=null&&view.parent.hasLayout==false){
		return;
	}
	NeedLayoutViews.push(view);
	Frame.setBaseViewNeedLayout();
}

var MainView=null;
setMainView = function(view){
	MainView = view;
	var orfun = view.setNeedLayout;
	Frame.setMainBaseView(view.baseView,
	//窗体变动
	function(){
		view.onParentChange();
		orfun.call(view);
	},
	//开始布局
	function(w,h){
		var nLayViews = NeedLayoutViews;
		NeedLayoutViews=[];
		//清楚局部布局队列中，父窗体也布局的
		for(var i=0;i<nLayViews.length;i++){			
			if(nLayViews[i].isOnApp==false
			||(nLayViews[i].parent!=null&&nLayViews[i].parent.hasLayout==false)){
				nLayViews.splice(i,1);
				i--;
			}
		}
		
		//先怎整体布局
		view.layoutIf(w,h);
		//根据约束关系排序
		nLayViews=sortRuleChilds(nLayViews);
		
		//再局部布局
		nLayViews.forEach(function(view,index){
			if(view.parent!=null){
				doLayoutFormSelf(view);
			}else{
				view.layoutIf(w,h);
			}
		});
		//清楚全的局部布局
		nLayViews=null;
	});
	view.setNeedLayout = function(){
		orfun.call(view);
		Frame.setBaseViewNeedLayout();
	};
	view.setOnApp(true);
}
//布局单个view
function doLayoutFormSelf(view){
	//判断仅仅布局动画
	if(view.hasLayout&&view.hasLayoutFormRoot&&view.hasDoAnimation==false){
		view.doAnimation();
	}else{
		view.layoutIf(view.parent.layoutRect.width()-view.parent.pLeft-view.parent.pRight,view.parent.layoutRect.height()-view.parent.pTop-view.parent.pBottom);
	}
}
View = function (vType){
	var thiz=this;
	if(typeof(vType)=="undefined"){
		vType = TView;
	}
	this.baseView = Frame.createView(vType);//  new BaseView(vType);// document.createElement("div");
	this.parent=null;
	this.isOnApp =false;
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
	this.setVisibel();
	//
	this.layoutParentBoundW=0;
	this.layoutParentBoundH=0;
	this.layoutParentGravity=0;
	//
	this.baseView.setRect(0,0,0,0);
	 
	this.hasLayout=false;
	this.hasLayoutFormRoot=false;
	this.hasDoAnimation=true;
	//
	this.visibelLayout=true;
	//
	this.rule=[];
	this.beRule=[];
	//
	this.layoutRect= new RectF(0,0,0,0);
	
	//变动调用view
	this.layoutChangeCallViews=[];
	//
	this.setScaleType(ScaleMax);
	//动画属性
	this.animations=[];
	this.aStartTime=0;
	this.aPasueTime=0;
	this.aCount=0;
	this.aState=AStop;
	this.aKeep=true;
	this.aEndFromEnd=false;
	this.aContinue=0;
	//
	this.setClip(true);
	//动画属性
	this.animation={
	};
	//旧的边框位置
	this._oldX =0;
	this._oldY =0;
	this._oldW =0;
	this._oldH =0;
	
	
	return this;
}

View.prototype.setClip=function(clip){
	this.baseView.setClip(clip);
}
View.prototype.addView = function(view,index){
	if(typeof(index)=="undefined"){
		this.baseView.addView(view.baseView,-1);
		this.childs.push(view);
	}else{
		this.baseView.addView(view.baseView,index);
		this.childs.splice(index, 0, view);
	}
	view.parent=this;
	view.setOnApp(this.isOnApp);
	view.setNeedLayout();
}
View.prototype.getChildView = function(index){
	if(index>=0&&index<this.childs.length){
		return this.childs[index];
	}
	return null;
}
View.prototype.removeView = function(view){
	this.baseView.removeView(view.baseView);
	if(this.childs.removeValue(view)){
		view.setOnApp(false);
		view.parent=null;
		this.setNeedLayout();
	};
}
View.prototype.removeFromParent = function(){
	if(this.parent!=null){
		this.parent.removeView(this);
	}
}
View.prototype.removeAllView = function(){
	var cs = this.childs;
	this.childs=[];
	var thiz = this;
	cs.forEach(function(node,index){
		thiz.baseView.removeView(node.baseView);
		node.setOnApp(false);
		node.parent=null;
	});
	this.setNeedLayout();
}
View.prototype.getChildCount = function(){
	return this.childs.length;
}
/**
 *
 */
View.prototype.setOnApp = function(isOnApp){
	if(this.isOnApp==isOnApp){
		return;
	}
	this.isOnApp=isOnApp;
	this.checkRules();
	if(isOnApp){
		this.onAddToApp();
		//检查重启动画
		if(this.animations.length>0){
			this.callNeedDoAnimationToRoot();
		}
		//检查布局方位
		this.resetLayoutGravity();
	}else{
		this.onRemoveFromApp();
	}
	this.getAllViews().forEach(function(view,index){
		view.setOnApp(isOnApp);
	});
}
View.prototype.onAddToApp = function(){
}
View.prototype.onRemoveFromApp = function(){
}
View.prototype.getAllViews = function(){
	return this.childs;
}
/**
* 添加相对规则
* thisType 当前view的属性
* relation 比较的关系：等于、大于、小于
* toView 比较的目标View
* toType 目标属性 默认同thisType
* multiple 计算倍数 默认1倍
* disparity 计算差值 默认0
* keepWH 是否保持长宽不变。 默认false。 大部分场景既设置Left又设置Right，目的为了定位宽度。
*
**/
View.prototype.addRule=function(firstType,relation,toView,toType,multiple,disparity,keepWH){
	if(typeof(toType)=="undefined"){
		toType = firstType;
	}
	if(typeof(multiple)=="undefined"){
		multiple = 1;
	}
	if(typeof(disparity)=="undefined"){
		disparity = 0;
	}
	if(typeof(keepWH)=="undefined"){
		keepWH =  false;
	}
	var rule = {
		firstView:this,
		firstType:firstType,
		relation:relation,
		toView:toView,
		toType:toType,
		multiple:multiple,
		disparity:disparity,
		keepWH:keepWH,
		ruleLink:[]//链接链：所有变动view需要调用firstView布局的集合
	};
	this.rule.push(rule);
	toView.beRule.push(rule);
	this.checkRule(rule);
}
//检查约束，没有找到链接链的，需要找
View.prototype.checkRules=function(){
	this.rule.forEach(function(rule,index){
		rule.firstView.checkRule(rule);
	});
	this.beRule.forEach(function(rule,index){
		rule.firstView.checkRule(rule);
	});
}

View.prototype.checkRule=function(rule){
	//
	if(rule.firstView.isOnApp==false||rule.toView.isOnApp==false){
		this.cutRuleLink(rule);
	}
	//
	else if(rule.ruleLink.length==0){
		var theRootView = findRootView(this,rule.toView);
		if(theRootView != null) {
			var linkView = rule.toView;
			while(linkView!=theRootView){
				rule.ruleLink.push(linkView);
				linkView.addRuleCallView(rule);
				linkView = linkView.parent;
			}
			rule.ruleLink.push(linkView);
			linkView.addRuleCallView(rule);
			if(theRootView!=rule.firstView){
				linkView = rule.firstView.parent;
				while(linkView!=theRootView){
					rule.ruleLink.push(linkView);
					linkView.addRuleCallView(rule);
					linkView = linkView.parent;
				}
			}
		}
	}
}
//加入链接
View.prototype.addRuleCallView=function(rule){
	this.layoutChangeCallViews.removeValue(rule);
	this.layoutChangeCallViews.push(rule);
}
//移除链接
View.prototype.removeRuleCallView=function(rule){
	this.layoutChangeCallViews.removeValue(rule);
}
//自己某个约束链接断掉
View.prototype.cutRuleLink=function(rule){
	rule.ruleLink.forEach(function(view,index){
		view.removeRuleCallView(rule);
	});
	rule.ruleLink =[];
}

View.prototype.setWeight=function(w){
	if(this.weight != w){
		this.weight = w;
		this.setNeedLayout();
	}
}

View.prototype.setHeight=function(h){
	if(this.height != h){
		this.height = h;
		this.setNeedLayout();
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
View.prototype.getRectX=function(){
	return this.layoutRect.left;
}
View.prototype.getRectY=function(){
	return this.layoutRect.top;
}
View.prototype.getRectW=function(){
	return this.layoutRect.width();
}
View.prototype.getRectH=function(){
	return this.layoutRect.height();
}

View.prototype.setBackColor=function(color){
	this.baseView.setBackColor(color);
}
View.prototype.setBackImage=function(url){
	this.baseView.setBackImage(url);
}
View.prototype.setScaleType=function(type){
	this.scaleType=type;
	this.baseView.setScaleType(type);
}
View.prototype.getScaleType=function(type){
	return this.scaleType;
}
View.prototype.setGravity=function(g){
	if(this.gravity != g){
		this.gravity = g;
		if(this.isOnApp){
			this.getAllViews().forEach(function(view,index){
				view.resetLayoutGravity();
			});
		}
		this.setNeedLayout();
	}
}
View.prototype.setLayoutGravity=function(g){
 	if(this.layoutGravity != g){
		this.layoutGravity = g;
		if(this.isOnApp){
			this.resetLayoutGravity();
		}
		this.setNeedLayout();
	}
}
View.prototype.setMargin=function(l,t,r,b){
	if(typeof(t)=="undefined"){
		t=l;
		r=l;
		b=l;
	}
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
	if(typeof(t)=="undefined"){
		t=l;
		r=l;
		b=l;
	}
	this.setPLeft(l);
	this.setPTop(t);
	this.setPRight(r);
	this.setPBottom(b);
}
View.prototype.setPLeft=function(value){
	 if(this.pLeft != value){
		this.pLeft = value;
		this.setNeedLayout();
	}
}
View.prototype.setPTop=function(value){
	 if(this.pTop != value){
		this.pTop = value;
		this.setNeedLayout();
	}
}
View.prototype.setPRight=function(value){
	 if(this.pRight != value){
		this.pRight = value;
		this.setNeedLayout();
	}
}
View.prototype.setPBottom=function(value){
	 if(this.pBottom != value){
		this.pBottom = value;
		this.setNeedLayout();
	}
}

View.prototype.setOnClick=function(fun){
	var thiz=this;
	this.baseView.setOnClick(function(event){
		if(fun){
			fun.call(thiz);
		}		
	});
}
//子view变动，询问父窗体是否需要重新布局
View.prototype.onChildChange=function(child){
	//判断自己是否需要变动
	if(this.hasLayout){
		if(this.width==WrapContent
			||this.height==WrapContent){
			this.setNeedLayout();
		}else{
			addNeedLayoutView(child);
		}
	}
}
//父view变动，询问子窗体是否需要重新布局
View.prototype.onParentChange=function(){
	//防止循环
	if(this.hasLayout){
		var parentGravity= GravityNO;
		if(this.parent!=null){
			parentGravity = this.parent.gravity;
		}
	
		//判断自己是否需要重新布局
		if(this.width==MatchParent
			||this.height==MatchParent
			||!(isOnLeft(this.layoutGravity,parentGravity)&&isOnTop(this.layoutGravity,parentGravity))
			){
			this.setNeedLayout();
		}
	}
}
//属性发生变化，需要重新布局。（非真正布局，真正布局是浏览器执行的，所以不一定需要按层级向上请求）
View.prototype.setNeedLayout=function(){
	if(this.hasLayout){
		this.doSetNeedLayoutSelf();
	}
	//通知父View
	if(this.parent!=null){
		this.parent.onChildChange(this);
	}
}
View.prototype.doSetNeedLayoutSelf=function(){
	this.hasLayout=false;
	//不需要主动遍历是否变动子view，防止多次循环。 放在实际布局函数layoutifneed中判断ziview是否需要重新布局
	//先遍历子View. 不能用in遍历，in会把数组自定义方法也遍历出来
	//this.childs.forEach(function(value,intdex){
	//	value.onParentChange();
	//});
	//再遍历一遍自己变动，需要变动的相对view
	this.layoutChangeCallViews.forEach(function(value,intdex){
		value.firstView.setNeedLayout();
	});
}
//仅仅自己需要布局。 不改变内外边距大小Gravity。仅仅是动画,或则滚动
View.prototype.callNeedLayoutToRoot=function(){
	if(this.hasLayoutFormRoot){
		this.hasLayoutFormRoot=false;
		addNeedLayoutView(this);
		//再遍历一遍自己变动，需要变动的相对view
		this.layoutChangeCallViews.forEach(function(value,intdex){
			value.firstView.setNeedLayout();
		});
	}

}
View.prototype.callNeedDoAnimationToRoot=function(){
	if(this.hasDoAnimation){
		this.hasDoAnimation=false;
		addNeedLayoutView(this);
	}

}
//layoutRect 不包含父窗体padding，但是X包含
View.prototype.setLayoutX=function(x){
	 this.baseView.setX(x);
	 var w = this.layoutRect.width();
	 this.layoutRect.left = x-((this.parent!=null)?this.parent.pLeft:0);
	 this.layoutRect.right = (this.layoutRect.left+w);
}
View.prototype.setLayoutY=function(y){
	 this.baseView.setY(y);
	 var h = this.layoutRect.height();
	 this.layoutRect.top = y-((this.parent!=null)?this.parent.pTop:0);
	 this.layoutRect.bottom=(this.layoutRect.top+h);
}
View.prototype.setLayoutWidth=function(w){
	 this.baseView.setWidth(w);
	 this.layoutRect.right=(this.layoutRect.left+w);
}
View.prototype.setLayoutHeight=function(h){
	this.baseView.setHeight(h);
	this.layoutRect.bottom=(this.layoutRect.top+h);
}
View.prototype.getLayoutRectInView=function(view) {
	var meOnScr = this.getLayoutRectOnRoot();
	var viewOnScr = view.getLayoutRectOnRoot();
	return new RectF(meOnScr.left - viewOnScr.left, meOnScr.top
			- viewOnScr.top, meOnScr.right - viewOnScr.left, meOnScr.bottom
			- viewOnScr.top);
}
View.prototype.getLayoutRectOnRoot=function(){
	var w = this.layoutRect.width();
	var h = this.layoutRect.height();
	var x = this.layoutRect.left;
	var y = this.layoutRect.top;
	var p = this.parent;

	while (p != null) {
		var dx = p.layoutRect.left + p.pLeft;
		var dy = p.layoutRect.top + p.pTop;
		x += dx;
		y += dy;
		p = p.parent;
	}
	return new RectF(x, y, w, h);;
}
	
//布局相对约束
View.prototype.layoutRule=function(){
	 Rule.doRule(this);
}
View.prototype.layoutUseParentWidth=function(){
	if(this.width==MatchParent){
		return true;
	}
	if(this.isOnRight_||this.isOnCenterH_){
		return true;
	}
	if(this.parent!=null&&this.parent.isChildLayoutUseParentWidth){
		return  this.parent.isChildLayoutUseParentWidth(this);
	}
	return false;
}
View.prototype.layoutUseParentHeigth=function(){
	if(this.height==MatchParent){
		return true;
	}
	if(this.isOnBottom_||this.isOnCenterV_){
		return true;
	}
	if(this.parent!=null&&this.parent.isChildLayoutUseParentHeight){
		return  this.parent.isChildLayoutUseParentHeight(this);
	}
	return false;
}
//布局，计算适应内容的具体宽高
View.prototype.layoutIf=function(boundW,boundH){
	//判断是否需要布局

	if(this.hasLayout&&this.parent!=null&&this.layoutParentGravity!=this.parent.gravity){
		this.hasLayout = false;
	}
	if(this.hasLayout&&this.layoutParentBoundW!=boundW&&this.layoutUseParentWidth()){
		this.hasLayout = false;
	}
	if(this.hasLayout&&this.layoutParentBoundH!=boundH&&this.layoutUseParentHeigth()){
		this.hasLayout = false;
	}

	if(this.hasLayout&&this.hasLayoutFormRoot){
		return;
	}
	this.layoutParentBoundW=boundW;
	this.layoutParentBoundH=boundH;
	this.layoutParentGravity=this.parent!=null?this.parent.gravity:0;
	
	//
	this.hasLayout = true;
	this.hasLayoutFormRoot=true;
	var mesuerSize=null;
	//重新布局大小.
	var thizW=0;
	var thizH=0;
	
	//宽
	if(this.width==MatchParent){
		thizW=boundW-this.mLeft-this.mRight;
	}else if(this.width==WrapContent){
		mesuerSize = this.measure(boundW,boundH);
		thizW = mesuerSize.w-this.mLeft-this.mRight;
	}else{
		thizW = this.width;
	}
	this.setLayoutWidth(thizW);
	//高
	if(this.height==MatchParent){
		thizH=boundH-this.mTop-this.mBottom;
	}else if(this.height==WrapContent){
		mesuerSize = this.measure(boundW,boundH);
		thizH= mesuerSize.h-this.mTop-this.mBottom;
	}else{
		thizH = this.height;
	}
	this.setLayoutHeight(thizH);
	
	//重新布局比重
	this.checkThisGravity(boundW,boundH,thizW,thizH);
	
	//
	if(this.parent!=null&&this.parent.layoutChild){
		this.parent.layoutChild(this);
	}
	//布局行对位置
	this.layoutRule();
	
	//布局所有子view
	var thiz = this;
	thizW = this.layoutRect.width();
	thizH = this.layoutRect.height();
	this.layoutChilds(thizW-thiz.pLeft-thiz.pRight,thizH-thiz.pTop-thiz.pBottom);
	
	//
	this.doAnimation();
	//
	this.checkOnRectChange();
	
	return;
}
View.prototype.layoutChilds=function(boundW,boundH){
	this.getLayoutChilds().forEach(function(child,intdex){
		child.layoutIf(boundW,boundH);
	});
}
View.prototype.setOnRectChange=function(onchange){
	this.onRectChangeFun = onchange;
}
View.prototype.checkOnRectChange=function(){
	var x = this.getRectX();
	var y = this.getRectY();
	var w = this.getRectW();
	var h = this.getRectH();
	if(x!=this._oldX||y!=this._oldY||w!=this._oldW||h!=this._oldH){
		this.onRectChange(x,y,w,h,this._oldX,this._oldY,this._oldW,this._oldH);
		this._oldX =x;
		this._oldY =y;
		this._oldW =w;
		this._oldH =h;
	}
}
View.prototype.onRectChange=function(x,y,w,h,oldX,oldY,oldW,oldH){
	if(this.onRectChangeFun){
		this.onRectChangeFun(x,y,w,h,oldX,oldY,oldW,oldH);
	}
}
//查找功能的根目录
function findRootView(view1,view2){
		var root1 = view1;
		var root2 = view2;
		while (root1!=root2&&root1!=null&&root2!=null){
			while (root1!=root2&&root2!=null){
				root2 = root2.parent;;
			}
			if(root1==root2){
				break;
			}else{
				root1 = root1.parent;
				root2 = view2;
			}
		}
		if(root1==root2){
			return root1;
		}
		return null;
}
//根据约束关系排序
function sortRuleChilds(userByList){
		var userByList1 = [];
		var userByList2 = [];
		for (var i=0;i<userByList.length;i++) {
			var xView = userByList[i];
			if (xView.rule.length > 0
					|| xView.beRule.length > 0) {
				userByList2.push(xView);
			} else {
				userByList1.push(xView);
			}
		}
		var count = userByList2.length;
		if (count > 0) {
			userByList=[];
			// 排序
			for (var i = 0; i < count; i++) {
				var v1 = userByList2[i];
				var hasAdd = false;
				//寻找插入的位置
				for (var j = userByList.length-1; j >= 0 && hasAdd==false; j--) {
					var v2 = userByList[j];
					if (v1.isNeedLayoutAfter(v2)) {
						for (var k=j+1;k<userByList.length&&hasAdd==false;k++){
							var v3 = userByList[k];
							if (v3.isNeedLayoutAfter(v1)){
								userByList.splice(k-1,0,v1);
								hasAdd =true;
								break;
							}
						}
						if (hasAdd==false){
							userByList.splice(j+1,0,v1);
							hasAdd =true;
						}
						break;
					}
				}
				if (hasAdd==false){
					userByList.splice(0,0,v1);
				}
			}
			Array.prototype.push.apply(userByList1, userByList);
			userByList = userByList1;
		}
		return userByList;
}
function getCanLayoutViews(views){
	var arr = [];
	for (var i=0;i<views.length;i++) {
		var view = views[i];
		if (view.visibelLayout) {
			arr.push(view);
		}
	}
	return arr;
}
//获取基础布局的view，其它重写View布局的，需要重写此函数
View.prototype.getLayoutChilds=function(){
	//return sortRuleChilds(getCanLayoutViews(this.childs));
	return sortRuleChilds(this.childs);
}
View.prototype.isNeedLayoutAfter=function(toView) {
	for (var i=0;i<this.rule.length;i++) {
		if (this.rule[i].toView == toView) {
			//自己需要对方，则自己后布局。
			return true;
		}
	}
	return false;
}
//更新布局方位，不用每次都计算
View.prototype.resetLayoutGravity=function(){
	//注意父窗体的内边距需要子View实现
	var parentGravity= GravityNO;
	if(this.parent!=null){
		parentGravity = this.parent.gravity;
	}
	this.isOnRight_=false;
	this.isOnCenterH_=false;
	if(isOnRight(this.layoutGravity,parentGravity)){
		this.isOnRight_=true;
	}else if(isOnCenterH(this.layoutGravity,parentGravity)){
		this.isOnCenterH_=true;
	}else{
	 
	}
	
	this.isOnBottom_=false;
	this.isOnCenterV_=false;
	if(isOnBottom(this.layoutGravity,parentGravity)){
		this.isOnBottom_=true;
	}else if(isOnCenterV(this.layoutGravity,parentGravity)){
		this.isOnCenterV_=true;
	}else{
		
	}
}
View.prototype.checkThisGravity=function(pw,ph,w,h){
	//注意父窗体的内边距需要子View实现
	var parentPLeft=0;
	var parentPTop=0;
	if(this.parent!=null){
		parentPLeft = this.parent.pLeft;
		parentPTop = this.parent.pTop;
	}

	if(this.isOnRight_){
		this.setLayoutX(parentPLeft + (pw-this.mRight-w));
	}else if(this.isOnCenterH_){
		this.setLayoutX(parentPLeft + (pw-this.mRight-this.mLeft-w)/2 +this.mLeft);
	}else{
		this.setLayoutX(parentPLeft + this.mLeft);
	}
	
	if(this.isOnBottom_){
		this.setLayoutY(parentPTop+ (ph-this.mBottom-h));
	}else if(this.isOnCenterV_){
		this.setLayoutY(parentPTop+ (ph-this.mBottom-this.mTop-h)/2 + this.mTop);
	}else{
		this.setLayoutY(parentPTop+ this.mTop);
	}
	
}


//测量子view的最大宽高，忽略使用比重的。包含外边距。
View.prototype.measureChild=function(boundW,boundH){
	var size = {w:0,h:0};
	this.getLayoutChilds().forEach(function(view,index){
		var temp = view.measure(boundW,boundH);
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
	//线性布局
	
	//
	if(this.width==WrapContent||this.height==WrapContent){
		var boundW = this.width==WrapContent?0:size.w-this.pLeft-this.pRight;
		var boundH = this.height==WrapContent?0:size.h-this.pTop-this.pBottom;
		var childSize = this.measureChild(boundW,boundH);
		if(this.width==WrapContent){
			size.w = childSize.w+this.pLeft+this.pRight;
		}
		if(this.height==WrapContent){
			size.h =childSize.h+this.pTop+this.pBottom;
		}
	}
	size.w+=this.mLeft+this.mRight;
	size.h+=this.mTop+this.mBottom;
	return size;
}

//其它方法
View.prototype.setText=function(text,size,color){
	//this.baseView.innerHTML = text;
	if(this.viewType==TEditView||this.text!=text){
		this.text=text;
		this.baseView.setText(text);
		this.setNeedLayout();
	}
	if(typeof(size)!="undefined"){
		this.setFontSize(size);
	}
	if(typeof(color)!="undefined"){
		this.setFontColor(color);
	}
}
View.prototype.getText=function(){
	if(this.viewType==TEditView){
		return this.baseView.getText();
	}
	return  this.text;
}
View.prototype.setFontSize=function(size){
	if(this.fontSize!=size){
		this.fontSize=size;
		this.baseView.setFontSize(size);
		this.setNeedLayout();
	}
}
View.prototype.getFontSize=function(size){
	return this.fontSize;
}
View.prototype.setFontColor=function(color){
	this.fontColor=color;
	this.baseView.setFontColor(color);
}
View.prototype.getFontColor=function(color){
	return this.fontColor;
}
View.prototype.setLineSpace=function(value){
	if(this.lineSpace!=value){
		this.lineSpace=value;
		this.baseView.setLineSpace(value);
		this.setNeedLayout();
	}
}
View.prototype.getLineSpace=function(value){
	return this.lineSpace;
}
View.prototype.setCharSpace=function(value){
	if(this.charSpace!=value){
		this.charSpace=value;
		this.baseView.setCharSpace(value);
		this.setNeedLayout();
	}
}
View.prototype.getCharSpace=function(value){
	return this.charSpace;
}
//for leng oldtr,newS leng newStr
View.prototype.setOnTextChange=function(fun){
	var thiz = this;
	this.baseView.setOnTextChange(function(txt){
		fun.call(thiz,txt);
	});
}
//完全隐藏
View.prototype.setGone=function(){
	 this.baseView.setGone();
	 this.isgone=true; 
	 this.visibelLayout=false;
}
//完全可见
View.prototype.setVisibel=function(){
	 this.baseView.setVisibel();
	 this.isgone=false; 
	 this.visibelLayout=true;
}
//隐藏但需要布局
View.prototype.setInVisibel=function(){
	this.baseView.setGone();
	this.isgone=true;
	this.visibelLayout=true;
}

View.prototype.isGone=function(){
	return this.isgone; 
}
View.prototype.isVisibel=function(){
	return this.isgone==false && this.visibelLayout==true; 
}
View.prototype.isInVisibel=function(){
	return this.isgone==true && this.visibelLayout==true;
}
 
View.prototype.setRotate=function(rotate,cx,cy){
	this.animation.rotate={r:rotate,x:cx,y:cy};
	this.callNeedDoAnimationToRoot();
}
View.prototype.setAlpha=function(alpha){
	this.animation.alpha=alpha;
	this.callNeedDoAnimationToRoot(); 
}
View.prototype.setScale=function(sx,sy,cx,cy){
	this.animation.scale={sx:sx,sy:sy,x:cx,y:cy};
	this.callNeedDoAnimationToRoot(); 
}
//动画类
//	this.animations=[];
//	this.aStartTime=0;
//	this.aStartPasueTime=0;
//	this.aCount=0;
//	this.aState=AStop;//
//	this.aKeep=true;
//	this.aEndFromEnd=false;
//	this.aContinue=0;
var AStop=0;
var ARunning=1;
var APasue=2;
View.prototype.doAnimation=function(){

	if(this.hasDoAnimation){
		return;
	}
	//清空动画属性
	if(this.animation.rotate){
		this.baseView.setRotate(this.animation.rotate.r,this.animation.rotate.x,this.animation.rotate.y);
	}
	if(this.animation.alpha){
		this.baseView.setAlpha(this.animation.alpha);
	}
	if(this.animation.scale){
		this.baseView.setScale(this.animation.scale.sx,this.animation.scale.sy,this.animation.scale.x,this.animation.scale.y);
	}
	
	this.hasDoAnimation = true;
	if(this.aState==AStop||this.aContinue<=0||this.animations.length==0){
		return;
	}
	var aTime = 0;
	
	if(this.aState==APasue){
		aTime = this.aPasueTime - this.aStartTime;
	}else{
		aTime = Frame.currentTimeMillis()-this.aStartTime;
	}
	//是否结束
	var count = aTime/this.aContinue;
	if(count>this.aCount&&this.aKeep==false){
		return;
	}
	
	//是否停在最后的位置.如果停下，则下次不刷新
	if(this.aCount>0&&count>this.aCount){
		if(this.aKeep){
			aTime=0;
		}else{
			return;
		}
	}else{
		if(this.aState!=APasue){
			this.callNeedDoAnimationToRoot();
		}
	}
	//计算当前时间
	count = Math.floor(count);
	aTime = aTime%this.aContinue;
	if(this.aEndFromEnd&&(count%2)==1){
		aTime = this.aContinue - aTime;
	}
	//遍历动画的当前属性
	 
	for(var i=0;i<this.animations.length;i++){
		var anim = this.animations[i];
		//计算进度
		var p = (aTime-anim.delayTime)/anim.continueTime;
		if(p<0){
			p=0;
		}else if(p>1){
			p=1;
		}
		//根据变化规律重新计算进度
		p = getAnimationTypeProgress(anim.changeType,p);
	
		//计算属性
		var value1 = anim.from1 + p*(anim.to1-anim.from1);
		if(anim.type=="move"){
			//如果是LinearLayout两次调用doAnimation，就BUG了
			this.baseView.setX(this.layoutRect.left+value1);
			var value2 = anim.from2 + p*(anim.to2-anim.from2);
			this.baseView.setY(this.layoutRect.top+value2);
		}else if(anim.type=="alpha"){
			this.baseView.setAlpha(value1);
		}else if(anim.type=="scale"){
			var value2 = anim.from2 + p*(anim.to2-anim.from2);
			this.baseView.setScale(value1,value2,anim.pX,anim.pY);
		}else if(anim.type=="rotate"){
			this.baseView.setRotate(value1,anim.pX,anim.pY);
		}
	}
}
function getAnimationTypeProgress(changeType,aTime){
	return aTime;
}
View.prototype.addAnimation=function(type,delayTime,continueTime,changeType,from1,to1,from2,to2,pX,pY){
	var ani = {
		type:type,
		delayTime:delayTime,
		continueTime:continueTime,
		changeType:changeType,
		from1:from1,
		to1:to1,
		from2:from2,
		to2:to2,
		pX:pX,
		pY:pY,
	};
	//计算最大时间
	if(this.aContinue<delayTime+continueTime){
		this.aContinue=delayTime+continueTime;
	}
	this.animations.push(ani);
	this.startAnimation();
}
View.prototype.startAnimation=function(){
	//this.baseView.startAnimation();
	if(this.aKeep==APasue){
		this.aStartTime = this.aStartTime+(Frame.currentTimeMillis()-this.aPasueTime);
	}else{
		this.aStartTime = Frame.currentTimeMillis();
	}
	this.aState=ARunning;
	this.callNeedDoAnimationToRoot();
}
View.prototype.stopAnimation=function(){
	 //this.baseView.stopAnimation();
	 this.aState=AStop;
	 this.aContinue=0;
	 this.callNeedDoAnimationToRoot();
}
View.prototype.clearAnimation=function(){
	 //this.baseView.clearAnimation();
	 this.aState=AStop;
	 this.aContinue=0;
	 this.callNeedDoAnimationToRoot();
}
View.prototype.pasueAnimation=function(){
	 //this.baseView.clearAnimation();
	 this.aKeep=APasue;
	 this.aPasueTime = Frame.currentTimeMillis();	
}
//动画循环次数
View.prototype.setAnimationCount=function(count){
	//this.baseView.setAnimationCount(count); 
	this.aCount=count;
}
View.prototype.setAnimationEndFromEnd=function(count){
	//this.baseView.setAnimationCount(count); 
	this.aEndFromEnd=count;
}
//动画结束，保持结束状态
View.prototype.setAnimationKeep=function(keep){
	 //this.baseView.setAnimationKeep(keep); 
	 this.aEndFromEnd=keep;
}
View.prototype.addTranslate=function(delayTime,continueTime,changeType,fromx,tox,fromy,toy){
	if(typeof(fromy)=="undefined"){
		fromy=0;
	}
	if(typeof(toy)=="undefined"){
		toy=0;
	}
	this.addAnimation("move",delayTime,continueTime,changeType,fromx,tox,fromy,toy);
	//this.baseView.addTranslate(delayTime,continueTime,changeType,fromx,tox,fromy,toy);
}
View.prototype.addAlpha=function(delayTime,continueTime,changeType,fromAlpha,toAlpha){
	this.addAnimation("alpha",delayTime,continueTime,changeType,fromAlpha,toAlpha);
	 //this.baseView.addAlpha(delayTime,continueTime,changeType,fromAlpha,toAlpha);
}
View.prototype.addScale=function(delayTime,continueTime,changeType,fromX,toX,fromY,toY,pX,pY){
	if(typeof(fromY)=="undefined"){
		fromY=0;
	}
	if(typeof(toy)=="undefined"){
		toy=0;
	}
	if(typeof(pX)=="undefined"){
		pX=0;
	}
	if(typeof(pY)=="undefined"){
		pY=0;
	}
	this.addAnimation("scale",delayTime,continueTime,changeType,fromX,toX,fromY,toY,pX,pY);
	// this.baseView.addScale(delayTime,continueTime,changeType,fromX,toX,fromY,toY,pX,pY);
}
View.prototype.addRotate=function(delayTime,continueTime,changeType,fromRotate,toRotate,cenerX,cenery){
	if(typeof(cenerX)=="undefined"){
		cenerX=0;
	}
	if(typeof(cenery)=="undefined"){
		cenery=0;
	}
	 this.addAnimation("rotate",delayTime,continueTime,changeType,fromRotate,toRotate,0,0,cenerX,cenery);//this.baseView.addRotate(delayTime,continueTime,changeType,fromRotate,toRotate,cenerX,cenery);
}


//
TextView = function (){
	//
	View.call(this,TTextView);
	this.setText("",16,0xff000000);
	this.setLineSpace(0);
	this.setCharSpace(0);
	return this;
}
//TextView继承View
Extern(TextView,View);
OverrideFunction(TextView,"setGravity",function(superFun,g){
	CallSuperFunction(superFun,g);
	this.baseView.setTextGravity(g);
});
OverrideFunction(TextView,"measureChild",function(superFun,boundW,boundH){
	var size;// = CallSuperFunction(superFun,pw,ph);
	if(this.width==WrapContent ){
		size = Frame.measureTextSize(this.getText(),0x8fffffff,this.fontSize,this.lineSpace,this.charSpace);
	}else if(this.width>=0){
		size = Frame.measureTextSize(this.getText(),this.width,this.fontSize,this.lineSpace,this.charSpace);
	}else{
		size = Frame.measureTextSize(this.getText(),boundW,this.fontSize,this.lineSpace,this.charSpace);
	}
	return size;
});
OverrideFunction(TextView,"layoutIf",function(superFun,pw,ph){
	CallSuperFunction(superFun,pw,ph);
	this.baseView.setTextPadding(this.pLeft,this.pTop,this.pRight,this.pBottom);
});
//
//
LinearLayout = function(orientation){
	//
	View.call(this,TView);
	if(typeof(orientation)=="undefined"){
		orientation=Vertical
	}
	this.orientation = orientation;
	this.linearChilds=[];
	//重新布局
	this.layoutChild=function(view){
		var xywh = view.layXYWH;
		if(xywh){
			if("x" in xywh){
				view.setLayoutX(xywh.x);
			}
			if("y" in xywh){
				view.setLayoutY(xywh.y);
			}
			view.setLayoutWidth(xywh.w);
			view.setLayoutHeight(xywh.h);
		}
	};
	//快速计算是否需要布局
	this.isChildLayoutUseParentWidth=function(view){
		return this.orientation==Horizontal;
	}
	this.isChildLayoutUseParentHeight=function(view){
		return this.orientation==Vertical;
	}
	return this;
}
//LinearLayout继承View
Extern(LinearLayout,View);
//
LinearLayout.prototype.setOrientation=function(value){
	if(this.orientation!=value){
		this.orientation=value;
		this.setNeedLayout();
	}
}
LinearLayout.prototype.layoutIfHorizontalChilds=function(boundW,boundH){
	var childs = this.getLinearLayoutChilds();
	
	//计算偏移，注意当前view的pading需要计算在内
	//判断子View的方向
	if(isOnRight(GravityNO,this.gravity)){
		var lastDRight=this.pRight;
		for(var i=childs.length-1;i>=0;i--){
			var view = childs[i];
			var measuerLinearTemp = view.measuerLinearTemp;
			view.layXYWH={x:boundW - (measuerLinearTemp.w-view.mLeft+lastDRight),
							w:measuerLinearTemp.w-view.mLeft-view.mRight,
							h:measuerLinearTemp.h-view.mTop-view.mBottom,
						 };
			view.layoutIf(measuerLinearTemp.w,boundH);
			lastDRight+=measuerLinearTemp.w;
			view.doAnimation();
		}
	}else
	{
		var lastDleft = this.pLeft;
		if(isOnCenterH(GravityNO,this.gravity)){
			//获取总宽度
			var childsW=0;
			childs.forEach(function(view,index){
				childsW+=view.measuerLinearTemp.w;
			});
			lastDleft = this.pLeft + (boundW - childsW)/2;
		}
		childs.forEach(function(view,index){
			var measuerLinearTemp = view.measuerLinearTemp;
			view.layXYWH={x:lastDleft+view.mLeft,
				w:measuerLinearTemp.w-view.mLeft-view.mRight,
				h:measuerLinearTemp.h-view.mTop-view.mBottom,
			 };
			view.layoutIf(measuerLinearTemp.w,boundH);
			lastDleft+=measuerLinearTemp.w;
			view.doAnimation();
		});
	}
	
}
LinearLayout.prototype.layoutIfVerticalChilds=function(boundW,boundH){
	var childs = this.getLinearLayoutChilds();
	
	//计算偏移，注意当前view的pading需要计算在内
	//判断子View的方向
	if(isOnBottom(GravityNO,this.gravity)){
		var lastDBottom=this.pBottom;
		for(var i=childs.length-1;i>=0;i--){
			var view = childs[i];
			var measuerLinearTemp = view.measuerLinearTemp;
			view.layXYWH={y:boundH - (measuerLinearTemp.h-view.mTop+lastDBottom),
				w:measuerLinearTemp.w-view.mLeft-view.mRight,
				h:measuerLinearTemp.h-view.mTop-view.mBottom,
			};
			view.layoutIf(boundW,measuerLinearTemp.h);
			lastDBottom+=measuerLinearTemp.h;
			view.doAnimation();
		}
	}else
	{
		var lastDTop = this.pTop;
		if(isOnCenterV(GravityNO,this.gravity)){
			//获取总宽度
			var childsH=0;
			childs.forEach(function(view,index){
				childsH+=view.measuerLinearTemp.h;
			});
			lastDTop = this.pTop + (boundH - childsH)/2;
		}
		childs.forEach(function(view,index){
			var measuerLinearTemp = view.measuerLinearTemp;
			view.layXYWH={y:lastDTop+view.mTop,
				w:measuerLinearTemp.w-view.mLeft-view.mRight,
				h:measuerLinearTemp.h-view.mTop-view.mBottom,
			};
			view.layoutIf(boundW,measuerLinearTemp.h);
			lastDTop+=measuerLinearTemp.h;
			view.doAnimation();
		});
	}
	
}
LinearLayout.prototype.getLinearLayoutChilds=function(pw,ph){
	return getCanLayoutViews(this.linearChilds);
}
//其它方法
LinearLayout.prototype.addViewOnBase=LinearLayout.prototype.addView;
//添加线性View
OverrideFunction(LinearLayout,"addView",function(superFun,view){
	CallSuperFunction(superFun,view);
	this.childs.removeValue(view);
	this.linearChilds.push(view);
});
//
OverrideFunction(LinearLayout,"getChildView",function(superFun,index){
	if(index>=0&&index<this.childs.length){
		return CallSuperFunction(superFun,index);
	}else if(index>=this.childs.length&&index<this.childs.length-this.childs.length){
		return this.linearChilds[index-this.childs.length];
	}
	return null;
});

OverrideFunction(LinearLayout,"removeView",function(superFun,view){
	CallSuperFunction(superFun,view);
	if(this.linearChilds.removeValue(view)){
		view.parent=null;
		this.setNeedLayout();
	};
});

OverrideFunction(LinearLayout,"removeAllView",function(superFun){
	CallSuperFunction(superFun);
	
	var cs = this.linearChilds;
	this.linearChilds=[];
	var thiz = this;
	cs.forEach(function(node,index){
		thiz.baseView.removeView(node.baseView);
		node.setOnApp(false);
		node.parent=null;
	});
	this.setNeedLayout();
});
  

//子view变动，询问父窗体是否需要重新布局
OverrideFunction(LinearLayout,"onChildChange",function(superFun,child){
	if(this.hasLayout){
		if(this.linearChilds.indexOf(child)>=0){
			this.setNeedLayout();
		}else{
			CallSuperFunction(superFun,child);
		}
	}
});

OverrideFunction(LinearLayout,"setNeedLayout",function(superFun){
	if(this.hasLayout){ 
		CallSuperFunction(superFun);
		//强制布局
		this.linearChilds.forEach(function(value,intdex){
			value.doSetNeedLayoutSelf();
		});
	}else{
		CallSuperFunction(superFun);
	}
});

OverrideFunction(LinearLayout,"getLayoutChilds",function(superFun){
	return CallSuperFunction(superFun);
});
OverrideFunction(LinearLayout,"getAllViews",function(superFun){
	var list = [];
	Array.prototype.push.apply(list, CallSuperFunction(superFun));
	Array.prototype.push.apply(list, this.linearChilds);
	return list;
});
OverrideFunction(LinearLayout,"getChildCount",function(superFun){
	var n1 = CallSuperFunction(superFun)
	return n1+this.linearChilds.length;
});

OverrideFunction(LinearLayout,"layoutChilds",function(superFun,boundW,boundH){
	//快速布局中，不能依赖子view自行判断是否需要布局。 对于LinearLayout，强制关系view布局
	this.linearChilds.forEach(function(value,intdex){
		value.doSetNeedLayoutSelf();
	});
	
	//先判断是否已经测量所有view。测量后，大小已经确认。
	//if(this.width!=WrapContent&&this.height!=WrapContent){
		this.measureLinearChild(boundW,boundH);
	//}
	//先布局线性view
	if(this.orientation==Horizontal){
		this.layoutIfHorizontalChilds(boundW,boundH);
	}else{
		this.layoutIfVerticalChilds(boundW,boundH);
	}
	//再布局基础View
	CallSuperFunction(superFun,boundW,boundH);
	
});
LinearLayout.prototype.measureLinearChild=function(boundW,boundH){
	var childs = this.getLinearLayoutChilds();
	var leftW = boundW;
	var leftH = boundH;
	var size = {w:0,h:0};
	var allWeight = 0;
	//var allWeightMargnW=0;
	//var allWeightMargnH=0;
	childs.forEach(function(view,index){
		if(view.weight>0){
			allWeight+=view.weight;
			//allWeightMargnW +=(view.mLeft+view.mRight);
			//allWeightMargnH +=(view.mTop+view.mBottom);
		}
	});
	var weightView=[];
	if(this.orientation==Horizontal){
		childs.forEach(function(view,index){
			if(view.weight>0){
				weightView.push(view);
				size.w +=(view.mLeft+view.mRight);
				leftW -=(view.mLeft+view.mRight);
			}else{
				var temp = view.measure(leftW,leftH);
				view.measuerLinearTemp = temp;
				size.w +=temp.w;
				leftW -=temp.w;
				if(temp.h>size.h){
					size.h=temp.h;
				}
			}
		});
		weightView.forEach(function(view,index){
			var tempW = view.width;
			view.width = leftW*view.weight/allWeight;
			var temp = view.measure(leftW*view.weight/allWeight+view.mLeft+view.mRight,leftH);
			view.width = tempW;
			view.measuerLinearTemp = temp;
			size.w +=temp.w;
			size.w -=(view.mLeft+view.mRight);
			if(temp.h>size.h){
				size.h=temp.h;
			}
		});
	}else{
		childs.forEach(function(view,index){
			if(view.weight>0){
				weightView.push(view);
				size.h +=(+view.mTop+view.mBottom);
				leftH -=(+view.mTop+view.mBottom);
			}else{
				var temp = view.measure(leftW,leftH);
				view.measuerLinearTemp = temp;
				size.h +=temp.h;
				leftH -=temp.h;
				if(temp.w>size.w){
					size.w=temp.w;
				}
			}
		});
		weightView.forEach(function(view,index){
			var tempH = view.height;
			view.height = leftH*view.weight/allWeight;
			var temp = view.measure(leftW,leftH*view.weight/allWeight+view.mTop+view.mBottom);
			view.height=tempH;
			view.measuerLinearTemp = temp;
			size.h +=temp.h;
			size.h -=(+view.mTop+view.mBottom);
			if(temp.w>size.w){
					size.w=temp.w;
			}
		});
	}
	return size;
}
OverrideFunction(LinearLayout,"measureChild",function(superFun,boundW,boundH){
	var size =  CallSuperFunction(superFun,boundW,boundH);
	var size2 = this.measureLinearChild(boundW,boundH);
	
	return {w:size.w>size2.w?size.w:size2.w,h:size.h>size2.h?size.h:size2.h};
});
//滚动控件
ScrollView=function(){
	//
	View.call(this,TScrollView);
	this.showVertical = false;
	this.showHorizontal = false;
	this.contentView=null;
	this.setShowVertical(true);
	this.setShowHorizontal(true);
	
	//滚动的差值
	this.scrollSx=0;
	this.scrollSy=0;
	this.onScroll=null;
	//
	var thiz=this;
	//
	this.baseView.setOnScroll(function(sx,sy,state){
		thiz.scrollSx=sx;
		thiz.scrollSy=sy;
		//
		if(thiz.contentView){
			//contentView 不能加规则、动画，否则此处需要调用刷新。 thiz.contentView.callNeedLayoutToRoot();
			//thiz.contentView.callNeedLayoutToRoot();
			
			var w = thiz.layoutRect.width();
			thiz.contentView.layoutRect.left = thiz.contentView.layoutRectLeft+thiz.scrollSx;
			thiz.contentView.layoutRect.right = (thiz.contentView.layoutRect.left+w);

			var h = thiz.layoutRect.height();
			thiz.contentView.layoutRect.top = thiz.contentView.layoutRectTop+thiz.scrollSy;
			thiz.contentView.layoutRect.bottom = (thiz.contentView.layoutRect.top+h);
			
			//再遍历一遍自己变动，需要变动的相对view
			thiz.layoutChangeCallViews.forEach(function(value,intdex){
				value.firstView.setNeedLayout();
			});
		}
		
		if(thiz.onScroll!=null){
			thiz.onScroll(sx,sy,state);
		}
		
	});
	//根据滚动的位置，修复contentView的位置。
	this.layoutChild=function(view){
		if(view==this.contentView){
			var w = view.layoutRect.width();
			view.layoutRectLeft=view.layoutRect.left;
			view.layoutRect.left+=this.scrollSx;
			view.layoutRect.right = (view.layoutRect.left+w);

			var h = view.layoutRect.height();
			view.layoutRectTop = view.layoutRect.top;
			view.layoutRect.top+=this.scrollSy;
			view.layoutRect.bottom = (view.layoutRect.top+h);
		}
	}
	return this;
};
//继承View
Extern(ScrollView,View);
//垂直滚动条
ScrollView.prototype.setOnScroll=function(onScroll){
	this.onScroll=onScroll;
};
//垂直滚动条
ScrollView.prototype.setShowVertical=function(show){
	if(this.showVertical!=show){
		this.showVertical=show;
		this.baseView.setShowVertical(show);
	}
};
//水平滚动条
ScrollView.prototype.setShowHorizontal=function(show){
	if(this.showHorizontal!=show){
		this.showHorizontal=show;
		this.baseView.setShowHorizontal(show);
	}
};
//水平滚动条
ScrollView.prototype.setContentView=function(view){
	if(this.contentView!=view){
		if(this.contentView!=null){
			this.removeView(this.contentView);
		}
		this.contentView=view;
		//
		this.childs.push(view);
		view.parent=this;
		view.setOnApp(this.isOnApp);
		view.setNeedLayout();
		this.baseView.setContentView(view.baseView);
	}
};

ListView=function(){
	ScrollView.call(this);
	//设置特殊的加载模式。当滚动的布局的时候，计算可见的item是否发生改变
	var thiz=this;
	this.lsItemLay = new View();
	this.lsItemLay.setWidth(MatchParent);
	this.lsItemLay.setHeight(0);
	
	//
	this.setContentView(this.lsItemLay);
	//
	this.needUpdate=true;
	//html浏览器不能即使处理滚动事件，防止快速滚动后无法及时刷洗出item，可以实现多刷新一部分。
	this.itemVisibelMoreHieght=0;
	//循环利用的Item. 
	this._items=[];
	this._itemCount=0;
	this._visibelItems=[];
	this._itemPosition=[];//预测试位置
	this._itemVisibelFirstItem=0;
	//将新的item添加到队列，默认新的队列是占用的
	this._addItemMayFree=function(item,type,isUse){
		if(typeof(isUse)=="undefined"){
			isUse=true;
		}
		item._iType=type;
		item._iUse=isUse;
		if(isUse){
			thiz._items.unshift(item);//添加在0处
		}else{
			thiz._items.push(item);//添加在末尾处
		}
		
	};
	//清空所有item
	this._clearItems=function(){
		thiz._items=[];
	};
	//获取一个空闲的item。 默认获取成功，既使用
	this._getFreeItem=function(type,isUse){
		var item = null;
		if(typeof(isUse)=="undefined"){
			isUse=true;
		}
		for(var index=thiz._items.length-1;index>=0;index--){
			var item = thiz._items[index];
			if(item._iUse==false&&item._iType==type){
					if(isUse){
						item._iUse=true;
						thiz._items.splice(index, 1);
						thiz._items.unshift(item);
					}		
				return item;
			}
		}
		
		return null;
	};
	//清楚占用标识
	this._undoOccupy=function(item){
		item._iUse=false;
		 for(var i=0;i<thiz._items.length;i++){
			 var node = thiz._items[i];
			 if(node==item){
				thiz._items.splice(i, 1);
				thiz._items.push(node);
			}
		 }
	}
	
	this.defaultGetCount=function(){
		return 0;//个数 getCount
	};
	this.defaultGetType=function(index){
		return 0;//类型 getType
	};
	this.defaultGetItem=function(item,index){
		return null;//view getItem
	};
	this.setAdapter(this.defaultGetCount,this.defaultGetType,this.defaultGetItem);
	this.superOnScroll=null;
	//重写监听滚动函数，判断是否需要加载Item
	this.onListScroll=function(sx,sy,state){
		if(this.superOnScroll){
			this.superOnScroll(sx,sy,state);
		}
		//this.checkItemLayout();
		//新增布局，处理IOS不能及时刷新问题
		this.setNeedLayout();
		doLayoutFormSelf(this);
	};
	ScrollView.prototype.setOnScroll.call(this,this.onListScroll);
	//
	this.setShowVertical(true);

	
	
	
	
};
//滚动控件
Extern(ListView,ScrollView);

//
OverrideFunction(ListView,"setOnScroll",function(superFun,fun){
	//CallSuperFunction(superFun,fun);
	this.superOnScroll = fun;
});

OverrideFunction(ListView,"onRectChange",function(superFun,x,y,w,h,oldX,oldY,oldW,oldH){
	CallSuperFunction(superFun,x,y,w,h,oldX,oldY,oldW,oldH);
	
});


ListView.prototype.setAdapter=function(getCount,getType,getItem){
	
	//支持对象传输
	if(typeof(getCount)!="function"){
		getItem = getCount.getItem;
		getType = getCount.getType;
		getCount = getCount.getCount;
	}
	
	if(getCount==null||typeof(getCount)=="undefined"){
		this.getCount=this.defaultGetType;
	}else{
		this.getCount=getCount;
	}
	if(getType==null||typeof(getType)=="undefined"){
		this.getType=this.defaultGetCount;
	}else{
		this.getType=getType;
	}
	if(getItem==null||typeof(getItem)=="undefined"){
		this.getItem=this.defaultGetItem;
	}else{
		this.getItem=getItem;
	}
	this.notifyInvalidated();
};
ListView.prototype.notifyInvalidated=function(){
	//清空所有的预算数据
	this._clearItems();
	this.lsItemLay.removeAllView();
	this.lsItemLay.setHeight(0);
	this._itemVisibelFirstItem=0;
	this._itemPosition=[];
	this._itemCount=this.getCount();
	for(var i=0;i<this._itemCount-1;i++){
		this._itemPosition.push({y:0,w:0,h:0,hasMeasure:false});
	}
	this.notifyUpdate();
};
ListView.prototype.notifyUpdate=function(){
//	//判断是否多出item. 多出，则移除
//	var count = this.getCount();
//	for(var i=this._visibelItems.length-1;i>=0;i--){
//		var item = this._visibelItems[i];
//		if(item.index>=count){
//			this._visibelItems.split(i,1);
//			i++;
//			this._undoOccupy(item);
//		}
//	}
//	//
//	//更新所有的view
//	var thiz = this;
//	this._visibelItems.forEach(function(node){
//		//判断类型是否改变
//		var newType = thiz.getType(node.index);
//		if(node._iType==newType){
//			var itemView = thiz.getItem(node.itemView,node.index,node._iType);
//			if(itemView!=node.itemView){
//				node.itemView = itemView;
//			}
//		}else{
//			
//		}		
//	});
	
	this.needUpdate=true;
	this.callNeedLayoutToRoot();
	
};
ListView.prototype.doUpdate=function(){
	if(this.needUpdate){
		this.needUpdate=false;
		var thiz = this;
		//直接清空所有的使用item
		this.lsItemLay.removeAllView();
		this._visibelItems.forEach(function(node){
			thiz._undoOccupy(node);
		});
		this._visibelItems =[];
		this._itemPosition=[];
		this._itemCount=this.getCount();
		if(this._itemCount<=0){
			this._itemPosition=[];
			this._itemCount =0;
		}
		//清除或添加预算数据
		else if(this._itemCount<this._itemPosition.length){
			 this._itemPosition.splice(this._itemCount-1,this._itemPosition.length-this._itemCount);
			 this._itemPosition.forEach(function(node){
				node.hasMeasure=false;
			});
		}else{
			this._itemPosition.forEach(function(node){
				node.hasMeasure=false;
			});
			if(this._itemCount>this._itemPosition.length){
				for(var i=this._itemPosition.length-1;i<this._itemCount-1;i++){
					this._itemPosition.push({y:0,w:0,h:0,hasMeasure:false});
				}
			}
		}	
	}
}
//判断是否需要加载更多
ListView.prototype.checkItemLayout=function(){
	

	//
	var scrTop = this.scrollSy;//当前滑动的距离
	var scrHeight = this.getRectH();//listview的高度
	var scrWidth = this.getRectW();
	
	if(scrHeight==0||scrWidth==0){
		
		return;
	}
	
	//没有子view
	if(this.lsItemLay.getChildCount()==0){
		var itemTmp;
		var itemY=0;
		var itemH=0;
		//查找顶部第一个位置顶部位置
		for(var i=0;i<this._itemCount;i++){
			var itype = this.getType(i);
			var iPosition=this._itemPosition[i];
			itemTmp = null;
			//如果没有测量过，
			if(iPosition.h==0){				
				itemTmp = this._getFreeItem(itype,false);
				if(itemTmp==null){
					itemTmp = {};	
					itemTmp.itemView = null;
					this._addItemMayFree(itemTmp,itype,false);
				}
				itemTmp.itemView = this.getItem(itemTmp.itemView,i,itype);
				itemTmp.itemView.setWidth(scrWidth);
				itemTmp.itemView.setHeight(WrapContent);
				itemTmp.itemView.setMTop(0);
				
				var size = itemTmp.itemView.measure(scrWidth,0);
				iPosition.h=size.h;
				iPosition.w=scrWidth;
				iPosition.hasMeasure=true;
			}
			itemY+=iPosition.h;
			//如果预测不可见，则继续
			if(itemY<=-scrTop){
				continue;
			}
			//可见，则判断测量实际高度
			if(iPosition.hasMeasure==false){
				itemTmp = this._getFreeItem(itype,true);
				if(itemTmp==null){
					itemTmp = {};	
					itemTmp.itemView = null;
					this._addItemMayFree(itemTmp,itype,true);
				}
				itemTmp.itemView = this.getItem(itemTmp.itemView,i,itype);
				itemTmp.itemView.setWidth(scrWidth);
				itemTmp.itemView.setHeight(WrapContent);
				itemTmp.itemView.setMTop(0);
				
				var oldH = iPosition.h;
				//如果实际高度发生变化
				var size = itemTmp.itemView.measure(scrWidth,0);
				iPosition.h=size.h;
				iPosition.w=scrWidth;
				iPosition.hasMeasure=true;
				
				itemY-=oldH;
				itemY+=iPosition.h;
				//如果实际不可见，则继续
				if(itemY<=-scrTop){
					continue;
				}
			}else{
				itemTmp = this._getFreeItem(itype,true);
				if(itemTmp==null){
					itemTmp = {};	
					itemTmp.itemView = null;
					this._addItemMayFree(itemTmp,itype,true);
				}
				itemTmp.itemView = this.getItem(itemTmp.itemView,i,itype);	
				itemTmp.itemView.setWidth(scrWidth);
				
			}
			
			itemTmp.index=i;
			itemTmp.y=itemY-iPosition.h;
			itemTmp.h=iPosition.h;
			itemTmp.itemView.setMTop(itemTmp.y);
			itemTmp.itemView.setHeight(itemTmp.h);
			itemTmp.itemView._itemNode=itemTmp;
	
			this.lsItemLay.addView(itemTmp.itemView);
			this._visibelItems.push(itemTmp);
			
			//如果已经超出，则返回
			if(itemY>(-scrTop+scrHeight)+this.itemVisibelMoreHieght){
				break;
			}
		}
		//预算itemLay高度
		this.checkContentViewHeight();
	}
	//lsItemLay中有子View，说明没有调用notifyUpdate，即触发的是滑动变化
	else{
		//
		//return;
		var itemTmp;
		
		//获取lsItemLay第一个item
		var firstItem = this._visibelItems[0];
		//判断顶部是否不足,即Y在屏幕顶部的下方
		if(firstItem.y>-scrTop-this.itemVisibelMoreHieght){
			//顶部可能变动的大小
			var needChangeTopHeight=0;
			var lastY = firstItem.y;
			//一直向上添加
			for(var i=firstItem.index-1;i>=0;i--){
				var itype = this.getType(i);
				//获取一个空闲可添加的Item
				itemTmp = this._getFreeItem(itype,true);
				if(itemTmp==null){
					itemTmp = {};	
					itemTmp.itemView = null;
					this._addItemMayFree(itemTmp,itype,true);
				}
				itemTmp.itemView = this.getItem(itemTmp.itemView,i,itype);
				itemTmp.itemView.setWidth(scrWidth);
				
				//如果没有测量，则直接测量
				var iPosition=this._itemPosition[i];
				var oldH = iPosition.h;
				if(iPosition.hasMeasure==false||iPosition.w!=scrWidth){
					itemTmp.itemView.setHeight(WrapContent);
					itemTmp.itemView.setMTop(0);
					
					var size = itemTmp.itemView.measure(scrWidth,0);
					iPosition.h=size.h;
					iPosition.w=scrWidth;
					iPosition.hasMeasure=true;
					//判断高度是否变化，重新调整滚动位置
					if(oldH>0&&oldH!=iPosition.h){
						needChangeTopHeight += (iPosition.h -oldH);
					}
				}
				//添加到lsItemLay
				lastY -=iPosition.h; 
				itemTmp.index=i;
				itemTmp.y=lastY;
				itemTmp.h=iPosition.h;
				itemTmp.itemView.setMTop(itemTmp.y);
				itemTmp.itemView.setHeight(itemTmp.h);
				itemTmp.itemView._itemNode=itemTmp;
		
				this.lsItemLay.addView(itemTmp.itemView,0);
				this._visibelItems.splice(0,0,itemTmp);
				//检查互动到顶部
				if(i==0&&itemTmp.y!=0){
					var dy = itemTmp.y;
					needChangeTopHeight += dy;
					this._visibelItems.forEach(function(node){
						node.y-=dy;
					});
				}
				//是否完成
				if(lastY<-scrTop-this.itemVisibelMoreHieght){
					break;
				}
			}
			//
			
			//调整滑动
			if(needChangeTopHeight!=0){
				this.changeScrollTop(needChangeTopHeight);
			}
		}
		var lastItem = this._visibelItems[this._visibelItems.length-1];
		//判断底部是否不够，即最后一个在屏幕上面
		if(lastItem.y+lastItem.h<(-scrTop)+scrHeight+this.itemVisibelMoreHieght){
			var lastYH = lastItem.y+lastItem.h;
			var needYH = (-scrTop)+scrHeight+this.itemVisibelMoreHieght;
			var lastIndex=lastItem.index;
			//一直向下添加
			for(var i=lastItem.index+1;i<this._itemCount;i++){
				var itype = this.getType(i);
				//获取一个空闲可添加的Item
				itemTmp = this._getFreeItem(itype,true);
				if(itemTmp==null){
					itemTmp = {};	
					itemTmp.itemView = null;
					this._addItemMayFree(itemTmp,itype,true);
				}
				itemTmp.itemView = this.getItem(itemTmp.itemView,i,itype);
				itemTmp.itemView.setWidth(scrWidth);
				
				//如果没有测量，则直接测量
				var iPosition=this._itemPosition[i];
				if(iPosition.hasMeasure==false||iPosition.w!=scrWidth){
					itemTmp.itemView.setHeight(WrapContent);
					itemTmp.itemView.setMTop(0);
					
					var size = itemTmp.itemView.measure(scrWidth,0);
					iPosition.h=size.h;
					iPosition.w=scrWidth;
					iPosition.hasMeasure=true;
				}
				//添加到lsItemLay
				
				itemTmp.index=i;
				itemTmp.y=lastYH;
				itemTmp.h=iPosition.h;
				itemTmp.itemView.setMTop(itemTmp.y);
				itemTmp.itemView.setHeight(itemTmp.h);
				itemTmp.itemView._itemNode=itemTmp;
		
				this.lsItemLay.addView(itemTmp.itemView);
				this._visibelItems.push(itemTmp);
				lastIndex = i;
				
				
				lastYH +=iPosition.h; 
				
				//检查滑动到底部
				if(i==this._itemCount-1&&this.lsItemLay.height!=lastYH){
					this.lsItemLay.setHeight(lastYH);
					break;
				}
				
				//是否完成
				if(lastYH>=needYH){
					break;
				}
			}
			//检查高度
			if(lastIndex<this._itemCount-1 && lastYH>=this.lsItemLay.height){
				this.checkContentViewHeight();		 
			}
		}
		//顶部是否已经移除屏幕
		if(firstItem.y+firstItem.h<-scrTop-this.itemVisibelMoreHieght){
			//一直向下删除
			for(var i=0;i<this._visibelItems.length;i++){
				var itm = this._visibelItems[i];
				if(itm.y+itm.h<-scrTop-this.itemVisibelMoreHieght){
					this.lsItemLay.removeView(itm.itemView);
					this._visibelItems.splice(i,1);
					this._undoOccupy(itm);
					i--;
				}else{
					break;
				}
			}
		}
		//底部元素是否已经移除屏幕
		if(lastItem.y>(-scrTop)+scrHeight+this.itemVisibelMoreHieght){
			//一直向上删除
			for(var i=this._visibelItems.length-1;i>=0;i--){
				var itm = this._visibelItems[i];
				if(itm.y>(-scrTop)+scrHeight+this.itemVisibelMoreHieght){
					this.lsItemLay.removeView(itm.itemView);
					this._visibelItems.splice(i,1);
					this._undoOccupy(itm);
				}else{
					break;
				}
			}
		}
	}

};
//当变动item后，重新估算contentView的高度
ListView.prototype.checkContentViewHeight=function(){
	var iHeight=0;
	var iNum=0;
	this._visibelItems.forEach(function(node,index){
		iHeight+=node.h;
		iNum++;
	});
	//应该预算可见的位置高度
	
	if(iNum>0){
		var lastItem = this._visibelItems[this._visibelItems.length-1];
		this.lsItemLay.setHeight(lastItem.y+lastItem.h+  (iHeight/iNum)*(this._itemCount-1 -lastItem.index));
		
	}else{
		this.lsItemLay.setHeight(0);
	}
};
//当变动item上部高度突然变动时，需要改变滑动的距离，而不影响当前视图位置，以及其它惯性
ListView.prototype.changeScrollTop=function(dh){
	
};
OverrideFunction(ListView,"layoutChilds",function(superFun,boundW,boundH){
	//判断是否需要布局
	this.doUpdate();
	//计算布局
	this.checkItemLayout();
	//再布局基础View
	CallSuperFunction(superFun,boundW,boundH);
});
//滚动控件
EditView=function(){
	//
	View.call(this,TEditView);
	this.setText("",16,0xff000000);
	this.setLineSpace(0);
	this.setCharSpace(0);
	//
	this.setOnClick(function(){
		
		
	});
	//
	this.setOnTextChange(function(txt){
		if(this.userOnTextChange){
			this.userOnTextChange(txt);
		}
		if(this.height==WrapContent||this.width==WrapContent){
			this.setNeedLayout();
		}
	});
	this.setOnTextChange=function(fun){
		this.userOnTextChange=fun;
	}
	return this;
};
//继承View
Extern(EditView,View);
OverrideFunction(EditView,"setGravity",function(superFun,g){
	CallSuperFunction(superFun,g);
	this.baseView.setTextGravity(g);
});
//特殊的线
Line=function(){
	View.call(this);
	this.lineView=this;
	this.setLineColor(0xffe4e4e4);
	var thiz = this;
	this.createLineViewIF=function(){
		if(thiz.lineView==thiz){
			thiz.lineView = new View();
			thiz.lineView.setHeight(MatchParent);
			thiz.lineView.setWidth(MatchParent);
			thiz.addView(thiz.lineView);
			thiz.setLineColor(thiz.lineColor);
			thiz.setBackColor(0);
		}
	}
}
Extern(Line,View);
Line.prototype.setHeight1=function(){
	this.setHeight(1/Frame.getDensity());
}
Line.prototype.setWidth1=function(){
	this.setWidth(1/Frame.getDensity());
}
Line.prototype.setLineColor=function(color){
	this.lineColor=color;
	this.lineView.setBackColor(this.lineColor);
}
OverrideFunction(Line,"setPLeft",function(superFun,value){
	CallSuperFunction(superFun,value);
	this.createLineViewIF();
});
OverrideFunction(Line,"setPRight",function(superFun,value){
	CallSuperFunction(superFun,value);
	this.createLineViewIF();
});
OverrideFunction(Line,"setPTop",function(superFun,value){
	CallSuperFunction(superFun,value);
	this.createLineViewIF();
});
OverrideFunction(Line,"setPBottom",function(superFun,value){
	CallSuperFunction(superFun,value);
	this.createLineViewIF();
});

})();

