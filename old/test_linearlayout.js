function createTestLinearLayout(){
	var lay = new LinearLayout();
	lay.div.style.position="absolute";
	
	lay.setPadding(15,10,15,10);
	//
	var view1 = new View();
	view1.setWidth(50);
	view1.setHeight(50);
	view1.setBackColor(0xffff0000);
	lay.addView(view1);
	//
	var view2 = new View();
	view2.setWidth(50);
	view2.setHeight(50);
	view2.setBackColor(0xff00ff00);
	view2.setMLeft(20);
	lay.addView(view2);
	return lay;
}