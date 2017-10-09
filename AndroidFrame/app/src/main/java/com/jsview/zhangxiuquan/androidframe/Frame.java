package com.jsview.zhangxiuquan.androidframe;

import android.content.Context;
import android.graphics.Paint;
import android.os.Build;
import android.os.Handler;
import android.util.TypedValue;
import android.view.View;
import android.widget.FrameLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

/**
 * Created by zhangxiuquan on 2017/9/26.
 */

public class Frame {
    FrameLayout mainLay;
    Context cont;
    JsRunner jsRunner;
    JsLoader jsLoader;
    TextView textView;
    public Frame(Context cont, FrameLayout mainLay, JsRunner jsRunner, JsLoader jsLoader){
        density = cont.getResources().getDisplayMetrics().density;
        this.cont=cont;
        this.mainLay=mainLay;
        this.jsRunner=jsRunner;
        this.jsLoader=jsLoader;
        jsRunner.addObject("Frame",this);
    }
    public static class  TextSize{
        public float w;
        public float h;
    }
    public int getFrameVersion(){
        return 1;
    }
    public String getFramePlatform(){
        return "Android";
    }
    public BaseView createView(int type){
        return new BaseView(cont,jsLoader.baseUrl,jsRunner,type);
    }
    Object  onMainSizeChangeFunction;
    Object  onNeedLayoutIfFunction;
    public void callLayoutChange(){
        jsRunner.callFunction(onMainSizeChangeFunction);
    }
    //设置主界面
    public void setMainBaseView(BaseView baseView,Object onMainSizeChangeFunction,Object onNeedLayoutIfFunction){
        RelativeLayout.LayoutParams params = new RelativeLayout.LayoutParams(RelativeLayout.LayoutParams.MATCH_PARENT,RelativeLayout.LayoutParams.MATCH_PARENT);
        mainLay.addView(baseView.getMainView(),params);
        this.onMainSizeChangeFunction=onMainSizeChangeFunction;
        this.onNeedLayoutIfFunction=onNeedLayoutIfFunction;
        setBaseViewNeedLayout();
    }
    Runnable callLayout = new Runnable() {
        @Override
        public void run() {
            handler.removeCallbacks(callLayout);
            jsRunner.callFunction(onNeedLayoutIfFunction,mainLay.getWidth()/density,mainLay.getHeight()/density);
        }
    };
    Handler handler = new Handler();
    //调用刷新
    public void setBaseViewNeedLayout(){
        handler.post(callLayout);
    }
    static float density = 1;
    public static float getDensity(){
        return density;
    }
    public long currentTimeMillis(){
        return System.currentTimeMillis();
    }
    public void postDelayed(final Object fun,int delayed){
        handler.postDelayed(new Runnable() {
            @Override
            public void run() {
                jsRunner.callFunction(fun);
            }
        },delayed);
    }
    Paint paint =new Paint();
    public TextSize measureTextSize(String str,float maxWidth,float fontSize,float lineSpace,float charSpace){
        TextSize size = new TextSize();
       // paint.setTextSize(fontSize*density);
        //paint.setLetterSpacing((int)lineSpace);

        try {
            textView.setText(str);
            textView.setTextSize(TypedValue.COMPLEX_UNIT_DIP, fontSize);
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                textView.setLetterSpacing(charSpace);
            }
            textView.setLineSpacing(lineSpace,1);
            textView.setMaxWidth((int)(maxWidth*density+0.5));
            int spec = View.MeasureSpec.makeMeasureSpec(0x0fffffff, View.MeasureSpec.AT_MOST);
            //int spec= View.MeasureSpec.makeMeasureSpec(0,  View.MeasureSpec.UNSPECIFIED);
            textView.measure(spec,spec);
            size.w=textView.getMeasuredWidth()/density;
            size.h=textView.getMeasuredHeight()/density;

        }catch (Exception e){
            e.printStackTrace();
        }
        //size.w=str.length()*fontSize;
        //size.h=40/density;
        return size;
    }
    public void loadJS(String path){
        jsLoader.addPath(path);
    }
    public void setLoadJSFinish(final Object fun){
        jsLoader.start(new JsLoader.OnFinish() {
            @Override
            public void onFinish(final String path, final String js, final boolean isEnd) {
                handler.post(new Runnable() {
                    @Override
                    public void run() {
                        if(js!=null){
                            jsRunner.loadJs(js,path.substring(path.lastIndexOf("/")+1));
                        }
                        if(isEnd){
                            jsRunner.callFunction(fun);
                        }
                    }
                });
            }
        });
    }
}
