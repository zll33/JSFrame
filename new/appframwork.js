function App(){
	this.rootView=new View()
	this.rootView.setBackColor(0xffffffff);
	this.rootView.setWidth(MatchParent);
	this.rootView.setHeight(MatchParent);
	//
	this.formView=new View()
	this.formView.setWidth(MatchParent);
	this.formView.setHeight(MatchParent);
	this.rootView.addView(this.formView);
	//
	setMainView(this.rootView);
	
	//
	this.formArray=[];
	this.currForm=null;
}
//
App.prototype.getRootView=function(){
	 return this.rootView;
};
//开启一个页面
App.prototype.showForm=function(form){
	 form.app=this;
	 if(this.currForm!=null){
		 this.formView.removeView(this.currForm);
	 }
	 this.formArray.push(form);
	 this.currForm = form;
	 form.setWidth(MatchParent);
	 form.setHeight(MatchParent);
	 this.formView.addView(this.currForm);
};
App.prototype.closeForm=function(form){
	
	if(this.currForm==form){
		if(this.formArray.length>1){
			this.formView.removeView(form);
			this.currForm =this.formArray[this.formArray.length-2];
			this.formView.addView(this.currForm);			
		}else{
			return;
		}
	}
	if(this.formArray.removeValue(form)){
		if(form.onClose!=null){
			form.onClose();
		}
	}
	
};
//全局弹出信息
App.prototype.showMsg=function(msg){
	var msgTv = new TextView();
	msgTv.setPadding(25);
	msgTv.setText(msg,16,0xffffffff);
	msgTv.setBackColor(0xaa000000);
	msgTv.setMBottom(100);
	msgTv.setLayoutGravity(GravityCenter);
	this.rootView.addView(msgTv);
	Frame.postDelayed(function(){
		msgTv.removeFromParent();
	},2000);
};

function Form(){
	View.call(this);
	var thiz=this;
	this.app=null;
	this.onClose=null;
	this.contentView=null;
	this.contentScrollView=null;
	this.useScrollView=false;
	
	//创建title
	this.titleBar = new LinearLayout(Horizontal);
	this.titleBar.setWidth(MatchParent);
	this.titleBar.setHeight(48);
	this.titleBar.setGravity(GravityCenterV);
	this.titleBar.leftImage=new View();
	this.titleBar.leftTitle=new TextView();
	this.titleBar.middleSpace=new View();
	this.titleBar.rightTitle=new TextView();
	this.titleBar.rightImage=new View();
	this.titleBar.middleTitle=new TextView();
	this.titleBar.bottonLine = new Line();
	this.titleBar.addView(this.titleBar.leftImage);
	this.titleBar.addView(this.titleBar.leftTitle);
	this.titleBar.addView(this.titleBar.middleSpace);
	this.titleBar.addView(this.titleBar.rightTitle);
	this.titleBar.addView(this.titleBar.rightImage);
	this.titleBar.addViewOnBase(this.titleBar.middleTitle);
	this.titleBar.addViewOnBase(this.titleBar.bottonLine);
	//
	this.titleBar.middleSpace.setWeight(1);
	this.titleBar.middleTitle.setLayoutGravity(GravityCenter);
	//this.titleBar.bottonLine.setLineColor(0xff000000);
	this.titleBar.bottonLine.setHeight1();
	this.titleBar.bottonLine.setWidth(MatchParent);
	this.titleBar.bottonLine.setLayoutGravity(GravityBottom);
	this.addView(this.titleBar);
	//
	this.titleBar.leftImage.setHeight(MatchParent);
	this.titleBar.leftTitle.setText("返回",14,0xff000000);
	this.titleBar.leftTitle.setPLeft(15)
	this.titleBar.leftTitle.setPRight(15)
	this.titleBar.leftTitle.setPTop(15)
	this.titleBar.leftTitle.setPBottom(15)
	//this.titleBar.leftTitle.setHeight(MatchParent)
	this.titleBar.leftTitle.setHeight(WrapContent)
	var closeFun = function(){
		thiz.close();
	};
	this.titleBar.leftImage.setOnClick(closeFun);
	this.titleBar.leftTitle.setOnClick(closeFun);
	
	this.titleBar.middleTitle.setPadding(15);
	this.titleBar.setTitle=function(txt){
		thiz.titleBar.middleTitle.setText(txt);
	}
	//
	this.titleBar.setBackColor(0xffffffff);
	if(Form.setOnInit){
		Form.setOnInit(this);
	}
};
//继承View
Extern(Form,View);
Form.setOnInit=null;
Form.prototype.checkContent=function(){
	var cview=null;
	if(this.useScrollView){
		if(this.contentScrollView==null){
			this.contentScrollView = new ScrollView();
			//this.contentScrollView.setBackColor(0xff00ff00);
			this.contentScrollView.setWidth(MatchParent);
			this.contentScrollView.setHeight(MatchParent);
		}
		
		if(this.contentScrollView.parent!=this){
			this.contentScrollView.removeFromParent();
			this.addView(this.contentScrollView);
		}
		if(this.contentView!=null){
			//this.contentView.setBackColor(0x55000000);
			this.contentView.setWidth(MatchParent);
			this.contentView.setHeight(WrapContent);
			this.contentView.setMTop(0);
			if(this.contentView.parent!=this.contentScrollView){
				this.contentView.removeFromParent();
				this.contentScrollView.setContentView(this.contentView);
			}
		}
		cview = this.contentScrollView;
	}else{
		cview = this.contentView;
		if(this.contentView!=null){
			this.contentView.setWidth(MatchParent);
			this.contentView.setHeight(MatchParent);
			if(this.contentView.parent!=this){
				this.contentView.removeFromParent();
				this.addView(this.contentView);
			}
		}
	}

	if(cview){
		if(this.titleBar.isGone()){
			cview.setMTop(0);
		}else{
			cview.setMTop(48);
		}
	}
}
Form.prototype.setContentView=function(view){
	this.contentView=view;
	this.checkContent();
};
Form.prototype.setUseGestureBack=function(use){
	
}
Form.prototype.setUseScroll=function(use){
	if(typeof(use)=="undefined"){
		use=true;
	}
	this.useScrollView=use;
	this.checkContent();
};
//
Form.prototype.hideTitleBar=function(){
	this.titleBar.setGone();
	this.checkContent();
};
Form.prototype.showTitleBar=function(){
	this.titleBar.setVisibel();
	this.checkContent();
};
Form.prototype.close=function(){
	if(this.app){
		this.app.closeForm(this);
	}
};
Form.prototype.showForm=function(form){
	if(this.app){
		this.app.showForm(form);
	}
};

Form.prototype.showMsg=function(msg){
	
};

