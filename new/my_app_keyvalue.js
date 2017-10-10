function KeyValueForm(){
	Form.call(this);
	var thiz = this;
	this.mainLay = new LinearLayout();
	this.mainLay.setPadding(15);
	this.setContentView(this.mainLay);
	
	//提示语
	var noty = new TextView();
	noty.setText("测试保存数据",14);
	noty.setWidth(MatchParent);
	noty.setMRight(60);
	noty.setLineSpace(3);
	this.mainLay.addView(noty);
	//
	var lay = new LinearLayout(Horizontal);
	lay.setMTop(10);
	lay.setWidth(MatchParent);
	lay.setHeight(45);
	lay.setGravity(GravityCenterV);
	this.mainLay.addView(lay);
	var tab = new TextView();
	tab.setText("请输入KEY：");
	lay.addView(tab);
	var keyView = new EditView();
	keyView.setWeight(1);
	keyView.setHeight(MatchParent);
	keyView.setText("name");
	keyView.setGravity(GravityCenterV);
	lay.addView(keyView);
	//
	var lay2 = new LinearLayout(Horizontal);
	lay2.setMTop(10);
	lay2.setWidth(MatchParent);
	lay2.setHeight(45);
	lay2.setGravity(GravityCenterV);
	this.mainLay.addView(lay2);
	var tab2 = new TextView();
	tab2.setText("请输入VALUE：");
	lay2.addView(tab2);
	var valueView = new EditView();
	valueView.setWeight(1);
	valueView.setHeight(MatchParent);
	valueView.setText("张秀全");
	valueView.setGravity(GravityCenterV);
	lay2.addView(valueView);
	
	//
	var saveButton=new TextView();
	saveButton.setGravity(GravityCenterV|GravityCenterH);
	saveButton.setHeight(40);
	saveButton.setWidth(MatchParent);
	saveButton.setBackColor(0xff008000);
	saveButton.setText("保存",14,0xffffffff);
	saveButton.setMTop(10);
	this.mainLay.addView(saveButton);
	saveButton.setOnClick(function(){
		KeyValue.save(keyView.getText(),valueView.getText());
	});
	//
	
	
	//
	var lay3 = new LinearLayout(Horizontal);
	lay3.setMTop(20);
	lay3.setWidth(MatchParent);
	lay3.setHeight(45);
	lay3.setGravity(GravityCenterV);
	this.mainLay.addView(lay3);
	var tab3 = new TextView();
	tab3.setText("请输入KEY：");
	lay3.addView(tab3);
	var key3View = new EditView();
	key3View.setWeight(1);
	key3View.setHeight(MatchParent);
	key3View.setText("name");
	key3View.setPadding(5);
	key3View.setGravity(GravityCenterV);
	lay3.addView(key3View);
	
	//
	var saveButton=new TextView();
	saveButton.setGravity(GravityCenterV|GravityCenterH);
	saveButton.setHeight(40);
	saveButton.setWidth(MatchParent);
	saveButton.setBackColor(0xff008000);
	saveButton.setMTop(10);
	saveButton.setText("读取",14,0xffffffff);
	this.mainLay.addView(saveButton);
	saveButton.setOnClick(function(){
		value3.setText(KeyValue.getString(key3View.getText()));
	});
	//
	var value3 = new TextView();
	value3.setMTop(10);
	value3.setText("");
	value3.setWidth(MatchParent);
	this.mainLay.addView(value3);
	//
	
}
Extern(KeyValueForm,Form);