function BaseViewForm(){
	Form.call(this);
	var thiz = this;
	this.mainLay = new View();
	this.setContentView(this.mainLay);
	
	//左上、上中、右上，左中、中间、右中，左下、中下、右下
	var layoutG = [
	GravityLeft|GravityTop, GravityCenterH|GravityTop, GravityRight|GravityTop,
	GravityLeft|GravityCenterV, GravityCenterH|GravityCenterV, GravityRight|GravityCenterV,
	GravityLeft|GravityBottom, GravityCenterH|GravityBottom, GravityRight|GravityBottom
	];
	var layoutText = [
	"左上", "中上", "右上",
	"左中", "中间", "右中",
	"左下", "中下", "右下"
	];
	var centerView=null;
	for(var i=0;i<layoutG.length;i++){
		var view = new TextView();
		view.setText(layoutText[i]);
		view.setGravity(layoutG[i]);
		view.setWidth(50);
		view.setHeight(50); 
		view.setMargin(10);
		view.setBackColor(0xff888888);
		view.setLayoutGravity(layoutG[i]);
		this.mainLay.addView(view);
		if(i==4){
			centerView = view;
			view.setPadding(10);
			view.setWidth(200);
			view.setHeight(100);			
			view.setBackImage("gif0.gif");
			view.setScaleType(ScaleMax);
			view.setOnClick(function(){
				//不能使用view，view最后便动了。可以使用this
				if(this.getScaleType()==ScaleMax){
					this.setScaleType(ScaleCrop);
				}else if(this.getScaleType()==ScaleCrop){
					this.setScaleType(ScaleFill);
				}else {
					this.setScaleType(ScaleMax);
				}
				this.setGravity(GravityCenterH|GravityCenterV);
			});
		}else{
			view.setOnClick(function(){
				centerView.setGravity(this.gravity);
			});
		}
	}
	//放一个编辑框
	var editView = new EditView();
	editView.setBackColor(0x88888800);
	editView.setWidth(120);
	editView.setHeight(40);
	editView.setMTop(80);
	editView.setPadding(10);
	editView.setLayoutGravity(GravityCenterH);
	editView.setText("这是一个编辑框");
	editView.setOnTextChange(function(text){
		thiz.titleBar.setTitle(text);
	});
	this.mainLay.addView(editView);
	
	//
	var pic =new View();
	pic.setWidth(200);
	pic.setHeight(120);
	pic.setMTop(140);
	pic.setBackImage("back1.png");
	pic.setScaleType(ScaleMax);
	pic.setLayoutGravity(GravityCenterH);
	pic.setOnClick(function(){
		if(pic.getScaleType()==ScaleMax){
			pic.setScaleType(ScaleCrop);
		}else if(pic.getScaleType()==ScaleCrop){
			pic.setScaleType(ScaleFill);
		}else {
			pic.setScaleType(ScaleMax);
		}
	});
	this.mainLay.addView(pic);
	
	
	//中下边放一段文本呢
	var topC = new TextView();
	topC.setText("这是一个文本视图，可以放置文本",16,0xff000000);
	topC.setMTop(160);
	topC.setPadding(15);
	topC.setBackColor(0x55aaaaaa);
	topC.setLayoutGravity(GravityCenter);
	this.mainLay.addView(topC);
	
}
Extern(BaseViewForm,Form);