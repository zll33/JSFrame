function AnimationForm(){
	Form.call(this);
	var thiz = this;
	this.mainLay = new LinearLayout();
	this.setContentView(this.mainLay);
	
	var delayTime=0;
	var continueTime=3000;
	var changeType=0;
	
	var fromx =0;
	var tox =100;
	var fromy=0;
	var toy=100;
	
	//平移动画
	var translateView = new TextView();
	translateView.setText("平移动画",16,0xff000000);
	translateView.setMTop(60);
	translateView.setPadding(15);
	translateView.setBackColor(0x55aaaaaa);
	translateView.setLayoutGravity(GravityCenter);
	translateView.setAnimationEndFromEnd(true);
	translateView.addTranslate(delayTime,continueTime,changeType,
								fromx,tox,fromy,fromy
								);
								
	translateView.setOnClick(function(){
			this.startAnimation();
	});
	this.mainLay.addView(translateView);
	//渐变动画
	var alphaView = new TextView();
	alphaView.setText("渐变动画",16,0xff000000);
	alphaView.setMTop(60);
	alphaView.setPadding(15);
	alphaView.setBackColor(0x55aaaaaa);
	alphaView.setLayoutGravity(GravityCenter);
	alphaView.setAnimationEndFromEnd(true);
	alphaView.addAlpha(delayTime,continueTime,changeType,
								0,1);
	alphaView.setOnClick(function(){
			this.startAnimation();
	});
	this.mainLay.addView(alphaView);
	
	//旋转动画
	var rotateView = new TextView();
	rotateView.setText("旋转动画",16,0xff000000);
	rotateView.setMTop(60);
	rotateView.setPadding(15);
	rotateView.setBackColor(0x55aaaaaa);
	rotateView.setLayoutGravity(GravityCenter);
	rotateView.setAnimationEndFromEnd(true);
	rotateView.addRotate(delayTime,continueTime,changeType,0,360,0,0);
	rotateView.setOnClick(function(){
			this.startAnimation();
	});
	this.mainLay.addView(rotateView);
	
	//缩放动画
	var scaleView = new TextView();
	scaleView.setText("缩放动画",16,0xff000000);
	scaleView.setMTop(60);
	scaleView.setPadding(15);
	scaleView.setBackColor(0x55aaaaaa);
	scaleView.setLayoutGravity(GravityCenter);
	scaleView.setAnimationEndFromEnd(true);
	scaleView.addScale(delayTime,continueTime,changeType,0.5,1.5,0.5,1.5,0,0);
	scaleView.setOnClick(function(){
			this.startAnimation();
	});
	this.mainLay.addView(scaleView);
	
	//Matrix
	var msgView = new TextView();
	msgView.setText("Matrix连续变换待开发",16,0xff000000);
	msgView.setMTop(60);
	msgView.setPadding(15);
	this.mainLay.addView(msgView);
}
Extern(AnimationForm,Form);