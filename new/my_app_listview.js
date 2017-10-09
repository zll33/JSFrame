function ListViewForm(){
	Form.call(this);
	var thiz = this;
	this.listView = new ListView();
	this.titleBar.rightTitle.setVisibel();
	this.titleBar.rightTitle.setText("刷新");
	this.titleBar.rightTitle.setPadding(15);
	this.titleBar.rightTitle.setOnClick(function(){
		thiz.listView.notifyUpdate();
	});
	this.setContentView(this.listView);
	
	 this.listView.setAdapter(function(){
		 
		 return 100;
	 },function(index){
		 return 0;
	 },function(view,index,type){
		 if(view==null){
			 view = new TextView();
		 }
		 if(index<90){
			 view.setText("这是第"+index+"个");
		 }else{
			 view.setText("这是第"+index+"个\n\n\n\n小伙伴");
		 }
		 
		 
		 return view;
	 });
	 /*
	 this.listView.setAdapter({
		 getCount:function(){
			return 20;
		 },
		 getType:function(index){
			return 0;
		 },
		 getItem:function(view,index,type){
			if(view==null){
				 view = new TextView();
			 }
			 view.setText("这是第"+index+"个");
			 return view;
		 }});
	*/
}
Extern(ListViewForm,Form);