function LinearLayoutForm(){
	Form.call(this);
	var thiz = this;
	this.mainLay = new LinearLayout();
	this.mainLay.setPadding(15);
	this.setContentView(this.mainLay);
	
	var createText=function(text,weight,width,back){
		var lay = new View();
		if(weight>0){
			lay.setWeight(weight);
		}else{
			lay.setWidth(width);
		}
		lay.setHeight(MatchParent);
		lay.setBackColor(back);
		var tv = new TextView();
		tv.setText(text);
		tv.setLayoutGravity(GravityCenter);
		lay.addView(tv);
		return lay;
	}
	
	//上比重1
	var lay1 = new LinearLayout(Horizontal);
	lay1.setWidth(MatchParent);
	lay1.setWeight(1);
	lay1.setBackColor(0x55000000);
	this.mainLay.addView(lay1);
	{
		lay1.addView(createText("占比1",1,0,0x33ff0000));
		lay1.addView(createText("占比2",2,0,0x3300ff00));
		lay1.addView(createText("占比3",3,0,0x330000ff));
	}
	//中比重1
	var lay2 = new LinearLayout(Horizontal);
	lay2.setMTop(20);
	lay2.setWidth(MatchParent);
	lay2.setWeight(1);
	lay2.setBackColor(0x55000000);
	this.mainLay.addView(lay2);
	{
		lay2.addView(createText("占比1",1,0,0x33ff0000));
		lay2.addView(createText("固定100",0,100,0x3300ff00));
		lay2.addView(createText("占比1",1,0,0x330000ff));
	}
	//中比重2
	var lay3 = new LinearLayout(Horizontal);
	lay3.setMTop(20);
	lay3.setWidth(MatchParent);
	lay3.setWeight(1);
	lay3.setBackColor(0x55000000);
	this.mainLay.addView(lay3);
	{
		lay3.addView(createText("固定100",0,100,0x33ff0000));
		lay3.addView(createText("占比1",1,0,0x3300ff00));
		lay3.addView(createText("固定100",0,100,0x330000ff));
	}
}
Extern(LinearLayoutForm,Form);