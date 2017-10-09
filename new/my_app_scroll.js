function ScrollViewForm(){
	Form.call(this);
	var thiz = this;
	
	//
	this.titleBar.setTitle("滚动测试");
	//
	//
	var scr = new ScrollView();
	scr.setWidth(MatchParent);
	scr.setHeight(MatchParent);
	this.setContentView(scr);
	//
	this.mainLay = new LinearLayout ();
	this.mainLay.setPadding(15);
	this.mainLay.setWidth(MatchParent);
	scr.setContentView(this.mainLay);
	
	
	for(var i=0;i<20;i++){
		var lay = new View();
		lay.setWidth(MatchParent);
		this.mainLay.addView(lay);
		//
		var face = new View();
		face.setWidth(100);
		face.setHeight(100);
		face.setBackImage("back1.png");
		face.setScaleType(ScaleCrop);
		lay.addView(face);
		
		//
		var name = new TextView();
		name.setText("左边等于头像的右边",18,0xff000000);
		name.setPadding(5);
		lay.addView(name);
		name.addRule(Rule.Left,Rule.Equal,face,Rule.Right,1,10,true);
		name.addRule(Rule.Top,Rule.Equal,face,Rule.Top,1,0,true);
		//
		var msg = new TextView();
		msg.setText("top或则bottom等于\n头像的top或则bottom",14,0xff888888);
		msg.setPadding(5);
		msg.setLineSpace(3);
		lay.addView(msg);
		msg.addRule(Rule.Left,Rule.Equal,face,Rule.Right,1,10,true);
		msg.addRule(Rule.Bottom,Rule.Equal,face,Rule.Bottom,1,0,true);
	
		//提示语
		var noty = new TextView();
		noty.setText(i+": 拖动右方滚动条，观察彩色方框与头像的位置关系",14);
		noty.setWidth(MatchParent);
		noty.setLineSpace(3);
		noty.setMBottom(10);
		this.mainLay.addView(noty);
		//
		
	}
	
	//红色规则
	//face.addRule(Rule.Top,Rule.Equal,v1,Rule.Top,1,0,true);
	//边界线规则
	//face.addRule(Rule.Top,Rule.GreaterThan,tv,Rule.Bottom,1,0,true);
	//蓝色规则
	//face.addRule(Rule.Bottom,Rule.LessThan,v2,Rule.Top,1,0,true);
	//顶部规则
	//face.addRule(Rule.Top,Rule.GreaterThan,this.mainLay,Rule.Top,1,0,true);
	
}
Extern(ScrollViewForm,Form);