package com.jsview.zhangxiuquan.androidframe;

import android.content.Context;

import org.mozilla.javascript.Callable;
import org.mozilla.javascript.Function;
import org.mozilla.javascript.Scriptable;
import org.mozilla.javascript.ScriptableObject;

/**
 * Created by zhangxiuquan on 2017/9/27.
 */

public class JsRunner {
    static org.mozilla.javascript.Context rhino = org.mozilla.javascript.Context.enter();
    Scriptable scope;
    static {
        rhino.setOptimizationLevel(-1);

    }

    public JsRunner(Context content){
        scope = rhino.initStandardObjects();
    }
    public void addObject(String name,Object object){
        try {
            ScriptableObject.putProperty(scope, name,org.mozilla.javascript.Context.javaToJS(object, scope));
            //ScriptableObject.putProperty(scope, name,object);
        }catch (Exception e){
            doException(e);
        }
    }
    public Object callFunction(Object funtion,Object...args){
        try {
            if(funtion instanceof Function){
                if (args != null) {
                    args = args.clone();
                } else {
                    args = new Object[0];
                }
                Object result = ((Function)funtion).call(rhino, scope, scope, args);
                return result;
            }
        }catch (Exception e){
            doException(e);
        }
        return null;
    }
    public Object loadJs(String js,String sourceName){
        try {
            return rhino.evaluateString(scope, js, sourceName, 1, null);
        }catch (Exception e){
            doException(e);
        }
       return null;
    }
    void doException(Exception e){
        e.printStackTrace();
    }
}
