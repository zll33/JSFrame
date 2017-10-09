function RuleForm(){
	Form.call(this);
	var thiz = this;
	this.mainLay = new View();
	this.mainLay.setPadding(15);
	this.setContentView(this.mainLay);
	
	//提示语
	var noty = new TextView();
	noty.setText("拖动右方滚动条，观察彩色方框与头像的位置关系",14);
	noty.setWidth(MatchParent);
	noty.setMRight(60);
	noty.setLineSpace(3);
	this.mainLay.addView(noty);
	//
	var tv = new TextView();
	tv.setText("红色无法拖动头像越过这条边界线");
	tv.setPadding(10);
	tv.setBackColor(0x33000000);
	tv.setMTop(100);
	this.mainLay.addView(tv);
	//
	var face = new View();
	face.setWidth(100);
	face.setHeight(100);
	face.setBackImage("back1.png");
	face.setScaleType(ScaleCrop);
	this.mainLay.addView(face);
	
	//
	var name = new TextView();
	name.setText("左边等于头像的右边",18,0xff000000);
	name.setPadding(5);
	this.mainLay.addView(name);
	name.addRule(Rule.Left,Rule.Equal,face,Rule.Right,1,10,true);
	name.addRule(Rule.Top,Rule.Equal,face,Rule.Top,1,0,true);
	//
	var msg = new TextView();
	msg.setText("top或则bottom等于\n头像的top或则bottom",14,0xff888888);
	msg.setPadding(5);
	msg.setLineSpace(3);
	this.mainLay.addView(msg);
	msg.addRule(Rule.Left,Rule.Equal,face,Rule.Right,1,10,true);
	msg.addRule(Rule.Bottom,Rule.Equal,face,Rule.Bottom,1,0,true);
	
	//
	var scr = new ScrollView();
	scr.setWidth(50);
	scr.setHeight(MatchParent);
	scr.setLayoutGravity(GravityRight);
	scr.setBackColor(0x55000000);
	this.mainLay.addView(scr);
	var cv = new View();
	cv.setHeight(1500);
	cv.setWidth(MatchParent);
	scr.setContentView(cv);
	
	var v1 = new View();
	v1.setWidth(30);
	v1.setHeight(30);
	v1.setBackColor(0xff880000);
	v1.setMTop(300);
	cv.addView(v1);
	
	var v2 = new View();
	v2.setWidth(30);
	v2.setHeight(30);
	v2.setBackColor(0xff000088);
	v2.setMTop(500);
	cv.addView(v2);
	
	//红色规则
	face.addRule(Rule.Top,Rule.Equal,v1,Rule.Top,1,0,true);
	//边界线规则
	face.addRule(Rule.Top,Rule.GreaterThan,tv,Rule.Bottom,1,0,true);
	//蓝色规则
	face.addRule(Rule.Bottom,Rule.LessThan,v2,Rule.Top,1,0,true);
	//顶部规则
	face.addRule(Rule.Top,Rule.GreaterThan,this.mainLay,Rule.Top,1,0,true);
	
}
Extern(RuleForm,Form);