function HttpForm(){
	Form.call(this);
	var thiz = this;
	this.mainLay = new LinearLayout();
	this.mainLay.setPadding(15);
	this.setContentView(this.mainLay);
	
	var lay = new LinearLayout(Horizontal);
	lay.setMTop(10);
	lay.setWidth(MatchParent);
	lay.setHeight(45);
	lay.setGravity(GravityCenterV);
	this.mainLay.addView(lay);
	var tab = new TextView();
	tab.setText("请求地址：");
	tab.setMRight(5);
	tab.setWidth(100);
	lay.addView(tab);
	var keyView = new EditView();
	keyView.setWeight(1);
	keyView.setHeight(MatchParent);
	keyView.setText("http://www.zhangxiuquan.com/act/test.php");
	keyView.setGravity(GravityCenterV);
	lay.addView(keyView);
	
	//
	var selectMothed="GET";
	var lay2 = new LinearLayout(Horizontal);
	lay2.setMTop(10);
	lay2.setWidth(MatchParent);
	lay2.setHeight(45);
	lay2.setGravity(GravityCenterV);
	this.mainLay.addView(lay2);
	var methodView = new TextView();
	methodView.setText("方法：GET");
	methodView.setMRight(5);
	methodView.setWidth(100);
	lay2.addView(methodView);
	var getView = new TextView();
	getView.setWidth(80);
	getView.setHeight(MatchParent);
	getView.setText("GET",16,0xffffffff);
	getView.setBackColor(0xff008800);
	getView.setGravity(GravityCenterV|GravityCenterH);
	getView.setOnClick(function(){
		selectMothed="GET";
		methodView.setText("方法：GET");
		getView.setBackColor(0xff008800);
		postView.setBackColor(0xff808080);
	});
	lay2.addView(getView);
	var postView = new TextView();
	postView.setWidth(80);
	postView.setHeight(MatchParent);
	postView.setText("POST",16,0xffffffff);
	postView.setBackColor(0xff808080);
	postView.setGravity(GravityCenterV|GravityCenterH);
	lay2.addView(postView);
	postView.setOnClick(function(){
		selectMothed="POST";
		methodView.setText("方法：POST");
		postView.setBackColor(0xff008800);
		getView.setBackColor(0xff808080);
	});
	//
	var lay3 = new LinearLayout(Horizontal);
	lay3.setMTop(10);
	lay3.setWidth(MatchParent);
	lay3.setHeight(45);
	lay3.setGravity(GravityCenterV);
	this.mainLay.addView(lay3);
	var param = new TextView();
	param.setText("参数：");
	param.setMRight(5);
	param.setWidth(100);
	lay3.addView(param);
	var paramView = new EditView();
	paramView.setWeight(1);
	paramView.setHeight(MatchParent);
	paramView.setText("{'word':\"张\"}");
	paramView.setGravity(GravityCenterV);
	lay3.addView(paramView);
	
	//
	var sendButton=new TextView();
	sendButton.setGravity(GravityCenterV|GravityCenterH);
	sendButton.setHeight(40);
	sendButton.setWidth(MatchParent);
	sendButton.setBackColor(0xff008000);
	sendButton.setText("发送",14,0xffffffff);
	sendButton.setMTop(10);
	this.mainLay.addView(sendButton);
	sendButton.setOnClick(function(){
		new Http().request({
			url:"http://www.zhangxiuquan.com/act/test.php",
			method:selectMothed,
			data:paramView.getText(),//{word:"zhang"},//
			timeout:3000,
			onResponse:function(headers,state,str){
				if(state==200){
					result.setText(str);
				}else{
					result.setText("错误码:"+state);
				}
			}
		});
	});
	//提示语
	var noty = new TextView();
	noty.setText("请求数据:",14);
	noty.setWidth(MatchParent);
	noty.setMTop(20);
	noty.setLineSpace(3);
	this.mainLay.addView(noty);
	var result = new TextView();
	result.setText("");
	result.setWidth(MatchParent);
	result.setMTop(10);
	result.setLineSpace(3);
	this.mainLay.addView(result);

	
}
Extern(HttpForm,Form);