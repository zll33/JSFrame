package com.jsview.zhangxiuquan.androidframe;

import android.os.Handler;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.view.Window;
import android.widget.FrameLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

public class MainActivity extends AppCompatActivity {
    public FrameLayout mainLay;
    JsRunner jsRunner;
    Frame frame;
    JsLoader loader;
    Handler handler = new Handler();
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        this.requestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView(R.layout.activity_main);

        mainLay = (FrameLayout)findViewById(R.id.mainLay);


        //创建js接口对象
        jsRunner = new JsRunner(this);
        loader = new JsLoader(this,"http://app.demo.fero.com.cn/html_xview/");
        frame = new Frame(this,mainLay,jsRunner,loader);
        frame.textView = (TextView)findViewById(R.id.mesureText);


        //加载主文件
        loader.addPath("my_app.js");
        loader.start(new JsLoader.OnFinish() {
            String appJs;
            @Override
            public void onFinish(String path, String js, boolean isEnd) {
                if(js!=null){
                    appJs=js;
                }
                if(isEnd){
                    handler.post(new Runnable() {
                        @Override
                        public void run() {
                            jsRunner.loadJs(appJs,"my_app.js");
                        }
                    });
                }
            }
        });
        //
        findViewById(R.id.button).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                frame.callLayoutChange();
            }
        });
    }
}
