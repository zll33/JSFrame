package com.jsview.zhangxiuquan.androidframe;

import android.content.Context;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.HttpStatus;
import org.apache.http.HttpVersion;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.conn.ClientConnectionManager;
import org.apache.http.conn.scheme.PlainSocketFactory;
import org.apache.http.conn.scheme.Scheme;
import org.apache.http.conn.scheme.SchemeRegistry;
import org.apache.http.conn.ssl.SSLSocketFactory;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.impl.conn.tsccm.ThreadSafeClientConnManager;
import org.apache.http.params.BasicHttpParams;
import org.apache.http.params.HttpConnectionParams;
import org.apache.http.params.HttpParams;
import org.apache.http.params.HttpProtocolParams;
import org.apache.http.protocol.HTTP;
import org.json.JSONArray;
import org.json.JSONObject;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.Socket;
import java.net.URL;
import java.net.UnknownHostException;
import java.security.KeyManagementException;
import java.security.KeyStore;
import java.security.KeyStoreException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.UnrecoverableKeyException;
import java.security.cert.CertificateException;
import java.security.cert.X509Certificate;
import java.util.ArrayList;

import javax.net.ssl.SSLContext;
import javax.net.ssl.TrustManager;
import javax.net.ssl.X509TrustManager;

/**
 * Created by zhangxiuquan on 2017/9/26.
 */

public class JsLoader {
    String baseUrl;
    JsSQLite jsSQLite;
    public JsLoader(Context con,String baseUrl){
        try {
            this.baseUrl=baseUrl;
            jsSQLite = new JsSQLite(con,"jsfilesqlite","jsfile","{'md5':'','modified':'','match':'','js':'','url':''}");
        }catch (Exception e){

        }
    }
    public  interface  OnFinish{
        void onFinish(String path,String js,boolean isEnd);
    }
    ArrayList<String>pathList = new ArrayList<String>();
    public  void addPath(String path){
        if(path.toLowerCase().startsWith("http")){
            pathList.add(path);
        }else{
            pathList.add(baseUrl+path);
        }
    }
    Thread thread = null;
    public void start(final OnFinish onfinish){
        if(thread==null){
            thread = new Thread(){
                @Override
                public void run() {
                    try {
                        ArrayList<String> list = pathList;
                        pathList = new ArrayList<String>();
                        for (String path:list ) {
                            doDownList(path,onfinish);
                        }
                    }catch (Exception e){
                        e.printStackTrace();
                    }
                    finally {
                        thread = null;
                        onfinish.onFinish(null,null,true);
                    }
                }
            };
            thread.start();
        }
    }
    public void stop(){
        if(thread!=null){
            thread.interrupt();
            thread = null;
        }
    }
    void doDownList(String url ,OnFinish onfinish){
        JSONObject info =  new JSONObject();;
        try {
            //获取本地保存的数据
            String md5 = getMd5(url);
            JSONArray arr = jsSQLite.find("md5=?",new String[]{md5});
            String modified=null;
            String match=null;
            if(arr!=null&&arr.length()>0){
                info = arr.optJSONObject(0);
                modified = info.optString("modified");
                match = info.optString("match");
            }
            //判断是否需要更新,//更新文件，并保存文件信息
            HttpGet httpGet = new HttpGet(url);
            HttpClient httpClient = getNewHttpClient();
            //添加询问缓存是否可用
            if(modified!=null){
                httpGet.addHeader("If-Modified-Since",modified);
            }
            if(match!=null){
                httpGet.addHeader("If-None-Match",match);
            }
            InputStream inputStream = null;
            HttpResponse mHttpResponse = httpClient.execute(httpGet);
            int status = mHttpResponse.getStatusLine().getStatusCode();
            if (status == HttpStatus.SC_OK) {
                HttpEntity mHttpEntity = mHttpResponse.getEntity();
                inputStream = mHttpEntity.getContent();
                String newjs = readString(inputStream);
                inputStream.close();
                //记录更新

                info.put("md5", md5);
                info.putOpt("modified", mHttpResponse.getFirstHeader("Last-Modified").getValue());
                info.putOpt("match", mHttpResponse.getFirstHeader("ETag").getValue());
                info.put("url", url);
                info.put("js", newjs);

                //
                jsSQLite.updateOrInsert("md5=?", new String[] { md5 }, info);

            }
            //如果缓存可用，使用缓存
            else if (status == HttpStatus.SC_NOT_MODIFIED) {
            }



        }catch (Exception e){
            e.printStackTrace();
        }
        finally {
            onfinish.onFinish(url,info.optString("js",null),false);
        }
    }
    private static final char HEX_DIGITS[] = { '0', '1', '2', '3', '4', '5',
            '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F' };

    public static String toHexString(byte[] b) {
        StringBuilder sb = new StringBuilder(b.length * 2);
        for (int i = 0; i < b.length; i++) {
            sb.append(HEX_DIGITS[(b[i] & 0xf0) >>> 4]);
            sb.append(HEX_DIGITS[b[i] & 0x0f]);
        }
        return sb.toString();
    }
    static MessageDigest digest=null;
    // 获取字符串的MD5
    public static String getMd5(String s) {

        try {
            // Create MD5 Hash
            if(digest==null){
                digest = java.security.MessageDigest.getInstance("MD5");
            }
            digest.update(s.getBytes());
            byte messageDigest[] = digest.digest();
            String mm = new String(messageDigest);
            return toHexString(messageDigest);
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        }
        return null;
    }
    public static String readString(InputStream in) {
        return readString(in, "UTF-8");
    }

    public static String readString(InputStream in, String encoding) {
        String str = null;
        if (in == null) {
            return null;
        }
        try {
            byte[] data = new byte[1024];
            int length = 0;
            ByteArrayOutputStream bout = new ByteArrayOutputStream();
            while ((length = in.read(data)) != -1) {
                bout.write(data, 0, length);
            }
            str = new String(bout.toByteArray(), encoding);
        } catch (Exception e) {
            e.printStackTrace();
        }

        return str;

    }
    private static class MySSLSocketFactory extends SSLSocketFactory {
        SSLContext sslContext = SSLContext.getInstance("TLS");

        public MySSLSocketFactory(KeyStore truststore)
                throws NoSuchAlgorithmException, KeyManagementException,
                KeyStoreException, UnrecoverableKeyException {
            super(truststore);

            TrustManager tm = new X509TrustManager() {
                public void checkClientTrusted(X509Certificate[] chain,
                                               String authType) throws CertificateException {
                }

                public void checkServerTrusted(X509Certificate[] chain,
                                               String authType) throws CertificateException {
                }

                public X509Certificate[] getAcceptedIssuers() {
                    return null;
                }
            };

            sslContext.init(null, new TrustManager[] { tm }, null);
        }

        @Override
        public Socket createSocket(Socket socket, String host, int port,
                                   boolean autoClose) throws IOException, UnknownHostException {
            return sslContext.getSocketFactory().createSocket(socket, host,
                    port, autoClose);
        }

        @Override
        public Socket createSocket() throws IOException {
            return sslContext.getSocketFactory().createSocket();
        }
    }

    private static final int SET_CONNECTION_TIMEOUT = 20 * 1000;
    private static final int SET_SOCKET_TIMEOUT = 30 * 1000;

    // 支持https
    public static HttpClient getNewHttpClient() {
        try {
            KeyStore trustStore = KeyStore.getInstance(KeyStore
                    .getDefaultType());
            trustStore.load(null, null);

            SSLSocketFactory sf = new MySSLSocketFactory(trustStore);
            sf.setHostnameVerifier(SSLSocketFactory.ALLOW_ALL_HOSTNAME_VERIFIER);

            HttpParams params = new BasicHttpParams();

            HttpConnectionParams.setConnectionTimeout(params, 10000);
            HttpConnectionParams.setSoTimeout(params, 10000);

            HttpProtocolParams.setVersion(params, HttpVersion.HTTP_1_1);
            HttpProtocolParams.setContentCharset(params, HTTP.UTF_8);

            SchemeRegistry registry = new SchemeRegistry();
            registry.register(new Scheme("http", PlainSocketFactory
                    .getSocketFactory(), 80));
            registry.register(new Scheme("https", sf, 443));

            ClientConnectionManager ccm = new ThreadSafeClientConnManager(
                    params, registry);

            HttpConnectionParams.setConnectionTimeout(params,
                    SET_CONNECTION_TIMEOUT);
            HttpConnectionParams.setSoTimeout(params, SET_SOCKET_TIMEOUT);
            HttpClient client = new DefaultHttpClient(ccm, params);

            return client;
        } catch (Exception e) {
            return new DefaultHttpClient();
        }
    }
}
