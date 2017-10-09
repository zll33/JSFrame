
//设置更新模式。0等待提示更新，1等待强制更新,  2强制先更新文件
//Frame.setLoadMode(0);
//检查文件后，提示： 发现新的版本，新版本将在下次打开应用后生效。  好的 立即生效
Frame.loadJS("xview.js");
Frame.loadJS("appframwork.js");
Frame.loadJS("my_app_baseview.js");
Frame.loadJS("my_app_animation.js");
Frame.loadJS("my_app_linearlayout.js");
Frame.loadJS("my_app_rule.js");
Frame.loadJS("my_app_scroll.js");
Frame.loadJS("my_app_listview.js");
Frame.setLoadJSFinish(function(){
	//检查各文件的版本是否正确
	
	//启动应用
	new MyApp();
});
var GApp=null;
function MyApp(){
	//初始化静态函数
	Form.setOnInit = function(form){
		form.titleBar.leftImage.setWidth(13);
		//form.titleBar.leftImage.setHeight(21);
		form.titleBar.leftImage.setMLeft(10);
		form.titleBar.leftImage.setBackImage("goback.png");
		
		

	};
	
	//主页面
	function MainForm(){
		Form.call(this);
		var thiz = this;
		this.hideTitleBar();
		
		this.mainLay = new LinearLayout();
		this.mainLay.setGravity(GravityCenterH);
		this.setContentView(this.mainLay);
		this.setUseScroll(true);
		//测试基础布局
		this.mainLay.setPadding(15);
		this.mainLay.addView(createButton("基础View",BaseViewForm));
		//
		this.mainLay.addView(createButton("动画",AnimationForm));
		//
		this.mainLay.addView(createButton("线性布局",LinearLayoutForm));
		//
		this.mainLay.addView(createButton("相对约束",RuleForm));
		//
		this.mainLay.addView(createButton("滚动控件",ScrollViewForm));
		//
		this.mainLay.addView(createButton("ListView",ListViewForm));
		//
		this.mainLay.addView(createButton("网络请求"));
		//
		this.mainLay.addView(createButton("数据存储"));
		//
		this.mainLay.addView(createButton("页面跳转"));
		//
		this.mainLay.addView(createButton("硬件调用"));
		//
		var lfun = this.mainLay.layoutIf;
		var ojb=this.mainLay;
		
		this.mainLay.layoutIf = function(w,h){
			lfun.call(ojb,w,h);
		};
	}
	Extern(MainForm,Form);

	//
	GApp = new App();
	var form=new MainForm();
	GApp.showForm(form);
	
}
function createButton(title,formClass){
	var button = new TextView();
	button.setText(title,16,0xff000000);
	button.setWidth(160);
	button.setMargin(7.5);
	button.setPadding(20);
	button.setBackColor(0xff00ffff);
	if(formClass){
		button.setOnClick(function(){
			GApp.showForm(new formClass());
		});
	}else{
		button.setOnClick(function(){
			GApp.showMsg("“"+title+"”"+"开发中");
		});
	}
	button.setGravity(GravityCenter);
	return button;
}

