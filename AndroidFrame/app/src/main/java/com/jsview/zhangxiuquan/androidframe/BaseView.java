package com.jsview.zhangxiuquan.androidframe;

import android.app.ActionBar;
import android.content.Context;
import android.content.res.ColorStateList;
import android.content.res.Resources;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.ColorFilter;
import android.graphics.Outline;
import android.graphics.PorterDuff;
import android.graphics.Rect;
import android.graphics.Region;
import android.graphics.drawable.Drawable;
import android.os.Build;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.text.Editable;
import android.text.TextWatcher;
import android.util.AttributeSet;
import android.util.TypedValue;
import android.view.Gravity;
import android.view.KeyEvent;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.widget.EditText;
import android.widget.FrameLayout;
import android.widget.ScrollView;
import android.widget.TextView;

import com.bumptech.glide.Glide;
import com.bumptech.glide.load.resource.drawable.GlideDrawable;
import com.bumptech.glide.load.resource.gif.GifDrawable;
import com.bumptech.glide.request.animation.GlideAnimation;
import com.bumptech.glide.request.target.SimpleTarget;
import com.bumptech.glide.request.target.SquaringDrawable;

import org.xmlpull.v1.XmlPullParser;
import org.xmlpull.v1.XmlPullParserException;

import java.io.IOException;

/**
 * Created by zhangxiuquan on 2017/9/26.
 */

public class BaseView {
    final static int TView=0;// 四个基础控件
    final static int TTextView=1;// 四个基础控件
    final static int TEditView=2;// 四个基础控件
    final static int TScrollView=3;// 四个基础控件

    final static int GravityNO = 0X00000000;
    final static int GravityLeft = 0X00000001<<0;
    final static int GravityRight = 0X00000001<<1;
    final static int GravityCenterH = 0X00000001<<2;

    final static int GravityTop = 0X00000001<<4;
    final static int GravityBottom = 0X00000001<<5;
    final static int GravityCenterV = 0X00000001<<6;

    final static int  ScaleMax = 0;//默认：图片填满View的宽或高，View可能不留空。图片可能按比例缩放，图片显示完整。
    final static int  ScaleCrop = 1;//图片填满View，View完全不留空。图片可能按比例缩放，多余的图片会剪切掉。
    final static int  ScaleFill = 2;//图片填满View，View完全不留空。图片可能变形，图片显示完整。

    JsRunner jsRunner;
    View view;
    int toPx(float dp){
        return (int)(dp*Frame.density+0.5f);
    }
    float toDp(int px){
        return (px/Frame.density);
    }
    Context context;
    String baseUrl;
    public BaseView(Context context,String baseUrl, final JsRunner jsRunner, int type){
        this.jsRunner=jsRunner;
        this.context=context;
        this.baseUrl=baseUrl;

        if(type==TTextView){
            view = new TextView(context);
        }else if(type==TEditView){
            view = new EditText(context);
        }else if(type==TScrollView){
            view = new ScrollView(context){
                @Override
                protected void onScrollChanged(int l, int t, int oldl, int oldt) {
                    super.onScrollChanged(l, t, oldl, oldt);
                    if(onScroll!=null){
                        jsRunner.callFunction(onScroll,-toDp(l) ,-toDp(t),0);
                    }
                }
            };
            //
            contentViewLay = new FrameLayout(context);
            ((ScrollView)view).addView(contentViewLay,new FrameLayout.LayoutParams(FrameLayout.LayoutParams.MATCH_PARENT,FrameLayout.LayoutParams.WRAP_CONTENT));
            //

        }else{
            //ViewGroup
            view = new FrameLayout(context);
        }
    }
    public View getMainView(){
        return view;
    }

    //以下是js调用接口
    public void setClip(boolean clip){


    }
    public void setRect(float x,float y,float w,float h){
        setX(x);
        setY(x);
        setWidth(w);
        setHeight(h);
    }
    public void setWidth(float w){
        if(w<0){
            w=0;
        }
        ViewGroup.LayoutParams params = view.getLayoutParams();
        if(params!=null){
            params.width =toPx(w);
            view.setLayoutParams(params);
        }
    }
    public void setHeight(float h){
        if(h<0){
            h=0;
        }
        ViewGroup.LayoutParams params = view.getLayoutParams();
        if(params!=null){
            params.height =toPx(h);
            view.setLayoutParams(params);
        }
    }
    public void setX(float x){
        //view.setLeft(toPx(x));
        //view.setX(toPx(x));

        ViewGroup.LayoutParams params = view.getLayoutParams();
        if(params instanceof  FrameLayout.LayoutParams){
            ((FrameLayout.LayoutParams)params).leftMargin=toPx(x);
            view.setLayoutParams(params);
        }

    }
    public void setY(float y){
        //view.setTop(toPx(y));
        //view.setY(toPx(y));

        ViewGroup.LayoutParams params = view.getLayoutParams();
        if(params instanceof  FrameLayout.LayoutParams){
            ((FrameLayout.LayoutParams)params).topMargin=toPx(y);
            view.setLayoutParams(params);
        }
    }
    public void setText(String str){
        if(view instanceof TextView){
            ((TextView)view).setText(str);
        }else if(view instanceof EditText){
            ((EditText)view).setText(str);
        }
    }
    public String getText(){
        if(view instanceof TextView){
           return ((TextView)view).getText().toString();
        }else if(view instanceof EditText){
            return ((EditText)view).getText().toString();
        }
        return null;
    }
    TextWatcher textWatcher;
    //文本编辑框
    public void setOnTextChange(final Object onchange){
        if(view instanceof EditText){


            if(textWatcher!=null){
                ((EditText)view).removeTextChangedListener(textWatcher);
            }
            textWatcher = new TextWatcher() {
                @Override
                public void beforeTextChanged(CharSequence s, int start, int count, int after) {

                }

                @Override
                public void onTextChanged(CharSequence s, int start, int before, int count) {
                    jsRunner.callFunction(onchange);
                }

                @Override
                public void afterTextChanged(Editable s) {

                }
            };
            ((EditText)view).addTextChangedListener(textWatcher);
        }


    }
    //IOS\DIV没有内边距概念，强制支持TextPadding，正常的pading在XYWH上已经计算完成。 但是内边距不支持clip
    public void setTextPadding(float left,float top,float right,float bottom){
        if(view instanceof TextView){
            TextView tv = (TextView)view;
            tv.setPadding(toPx(left) ,toPx(top),toPx(right),toPx(bottom));
            //tv.setPadding((int)left,(int)top,(int)right,(int)bottom);
        }
    }
    public void setLineSpace(float value){
        if(view instanceof TextView){
            TextView tv = (TextView)view;
            tv.setLineSpacing(value,1);
        }
    }
    public void setCharSpace(float value){
        if(view instanceof TextView){
            TextView tv = (TextView)view;
            //tv.setLineSpacing(toPx(value),0);
            //tv.setLetterSpacing(toPx(value));

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                tv.setLetterSpacing(value);
            }
        }
    }
    public void setFontSize(float value){
        if(view instanceof TextView){
            TextView tv = (TextView)view;
            tv.setTextSize(TypedValue.COMPLEX_UNIT_DIP, value);
        }else if(view instanceof EditText){
            EditText tv = (EditText)view;
            tv.setTextSize(TypedValue.COMPLEX_UNIT_DIP, value);
        }
    }
    public void setFontColor(long color){
        if(view instanceof TextView){
            TextView tv = (TextView)view;
            tv.setTextColor((int)color);
            //tv.setTextColor(Color.BLACK);

        }else if(view instanceof EditText){
            EditText tv = (EditText)view;
            tv.setTextColor((int)color);
        }
    };
    public void setTextGravity(long gravity){
        if(view instanceof TextView){
            TextView tv = (TextView)view;
            //tv.setTextColor((int)color);
            int tg = 0;
            if ((gravity&GravityRight)>0){
                tg = tg| Gravity.RIGHT;
            }else if ((gravity&GravityCenterH)>0){
                tg = tg| Gravity.CENTER_HORIZONTAL;
            }else{
                tg = tg| Gravity.LEFT;
            }
            if ((gravity&GravityBottom)>0){
                tg = tg| Gravity.BOTTOM;
            }else if ((gravity&GravityCenterV)>0){
                tg = tg| Gravity.CENTER_VERTICAL;
            }else{
                tg = tg| Gravity.TOP;
            }
            tv.setGravity(tg);

        }else if(view instanceof EditText){
            EditText tv = (EditText)view;
            //tv.setTextColor((int)color);
            int tg = 0;
            if ((gravity&GravityRight)>0){
                tg = tg| Gravity.RIGHT;
            }else if ((gravity&GravityCenterH)>0){
                tg = tg| Gravity.CENTER_HORIZONTAL;
            }else{
                tg = tg| Gravity.LEFT;
            }
            if ((gravity&GravityBottom)>0){
                tg = tg| Gravity.BOTTOM;
            }else if ((gravity&GravityCenterV)>0){
                tg = tg| Gravity.CENTER_VERTICAL;
            }else{
                tg = tg| Gravity.TOP;
            }
            tv.setGravity(tg);
        }
    };

    public void setBackColor(long color){
        view.setBackgroundColor((int)color);
    };
    private static final float SQUARE_RATIO_MARGIN = 0.05f;
    public void setBackImage(String  url){
        //this.div.style.backgroundImage="url("+url+")";

        if(url!=null&&!url.toLowerCase().startsWith("http")){
            url = baseUrl+url;
        }
        Glide.with(context).load(url).centerCrop().into(new SimpleTarget<GlideDrawable>() {
            @Override
            public void onResourceReady(final GlideDrawable resource, GlideAnimation<? super GlideDrawable> glideAnimation) {

//                if (!resource.isAnimated()) {
//                    //TODO: Try to generalize this to other sizes/shapes.
//                    // This is a dirty hack that tries to make loading square thumbnails and then square full images less costly
//                    // by forcing both the smaller thumb and the larger version to have exactly the same intrinsic dimensions.
//                    // If a drawable is replaced in an ImageView by another drawable with different intrinsic dimensions,
//                    // the ImageView requests a layout. Scrolling rapidly while replacing thumbs with larger images triggers
//                    // lots of these calls and causes significant amounts of jank.
//                    float viewRatio = view.getWidth() / (float) view.getHeight();
//                    float drawableRatio = resource.getIntrinsicWidth() / (float) resource.getIntrinsicHeight();
//                    if (Math.abs(viewRatio - 1f) <= SQUARE_RATIO_MARGIN
//                            && Math.abs(drawableRatio - 1f) <= SQUARE_RATIO_MARGIN) {
//                        resource = new SquaringDrawable(resource, view.getWidth());
//                    }
//                }
                final int imageWidth = resource.getIntrinsicWidth();
                final int imageHeight= resource.getIntrinsicHeight();
                if(resource.isAnimated()){
                    view.setBackground(resource);
                    resource.setLoopCount(-1);
                    resource.start();
                }else{

                    view.setBackground(new SquaringDrawable(resource,0){
                        @Override
                        public int getIntrinsicWidth() {
                            return imageWidth;
                        }
                        @Override
                        public int getIntrinsicHeight() {
                            return imageHeight;
                        }

                        @Override
                        public void setBounds(int left, int top, int right, int bottom) {
                            if(scaleType==ScaleMax){
                                if(imageWidth>0&&imageHeight>0){
                                    float w = right - left;
                                    float h = bottom - top;
                                    //计算最大值
                                    float sw =w/imageWidth;
                                    float sh =h/imageHeight;

                                    if(sw<sh){//宽度比例小，则优先显示宽度。即
                                        float dy = (h - sw*imageHeight )/2;
                                        top+=dy;
                                        bottom-=dy;
                                    }else{
                                        float dx = (w - sh*imageWidth)/2;
                                        left+=dx;
                                        right-=dx;
                                    }
                                }
                            }else if(scaleType==ScaleCrop){
                                if(imageWidth>0&&imageHeight>0){
                                    float w = right - left;
                                    float h = bottom - top;
                                    //计算最大值
                                    float sw =w/imageWidth;
                                    float sh =h/imageHeight;
                                    if(sw>sh){
                                        float dy = (h - sw*imageHeight )/2;
                                        top+=dy;
                                        bottom-=dy;
                                    }else{
                                        float dx = (w - sh*imageWidth)/2;
                                        left+=dx;
                                        right-=dx;
                                    }
                                }
                            }else if(scaleType==ScaleFill) {

                            }
                            super.setBounds(left, top, right, bottom);

                        }
                    });
                }
            }
        });
        //view.setBackground();
    };
    int scaleType = ScaleMax;
    public void setScaleType(int type){
        if(scaleType!=type){
            scaleType = type;
            Drawable drawable = view.getBackground();
            if(drawable!=null){
                drawable.setBounds(0,0,view.getWidth(),view.getHeight());
                drawable.invalidateSelf();
            }
            view.invalidate();
        }
    }
    public void addView(BaseView view,int index){
       if(this.view instanceof ViewGroup){
           if(index<0){
               ((ViewGroup)this.view).addView(view.getMainView());
               view.setRect(0,0,0,0);
           }else{
               ((ViewGroup)this.view).addView(view.getMainView(),index);
               view.setRect(0,0,0,0);
           }
       }
    };
    public void removeView(BaseView view){
        if(this.view instanceof ViewGroup){
            ((ViewGroup)this.view).removeView(view.getMainView());
        }
    };
    public void setOnClick(final Object fun){
        view.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                jsRunner.callFunction(fun);
            }
        });
    }
//
    FrameLayout contentViewLay;
    View contentView;
    public void setContentView(BaseView view){
        if(this.view instanceof ScrollView){
            if(contentView!=null){
                contentViewLay.removeView(contentView);
            }
            contentView = view.getMainView();
            contentViewLay.addView(contentView);
        }
    }
//垂直滚动条overflow-y:visible或overflow-y:hidden
    public void setShowVertical(boolean show){

    }
//水平滚动条
    public void setShowHorizontal(boolean show){

    }

    Object onScroll;
//设置滚动监听。 向上滚动，滚动的位置为负数，向下滚动滚动的位置为正数
    public void setOnScroll(Object onScroll){
        this.onScroll=onScroll;
    }
//完全隐藏
    public void setGone(){
        view.setVisibility(View.GONE);
    }
//完全可见
    public void setVisibel(){
        view.setVisibility(View.VISIBLE);
    }
    public void setRotate(float rotate,float cx,float cy){
        view.setRotation(rotate);

    }
    public void setAlpha(float alpha){
        view.setAlpha(alpha);
    }
    public void setScale(float sx,float sy,float cx,float cy){
        view.setScaleX(sx);
        view.setScaleY(sy);

    }

//动画类
    public void startAnimation(){

    }
    public void stopAnimation(){

    }
    public void clearAnimation(){

    }
//动画循环次数
    public void setAnimationCount(){

    }
//动画结束，保持结束状态
    public void setAnimationKeep(){

    }
/*
animation: name duration timing-function delay iteration-count direction;
name:keyframe的名称，也就是定义了关键帧的动画的名称,这个名称用来区别不同的动画。
duration:完成动画所需要的时间（2s 或者 2000ms）
timing-function:完成动画的速度曲线
delay：动画开始之前的延迟
iteration-count：动画播放次数
direction：是否轮流反向播放动画（normal:正常顺序播放，alternate下一次反向播放）如果把动画设置为只播放一次，则该属性没有效果。
*/
    public void addTranslate(long delayTime,long continueTime,int changeType,float fromx,float tox,float fromy,float toy){

    }
    public void addAlpha(long delayTime,long continueTime,int changeType,float fromAlpha,float toAlpha){

    }
    public void addScale(long delayTime,long continueTime,int changeType,float fromX,float toX,float fromY,float toY,float pX,float pY){

    }
    public void addRotate(long delayTime,long continueTime,int changeType,float fromRotate,float toRotate,float cenerX,float cenery){

    }

}
