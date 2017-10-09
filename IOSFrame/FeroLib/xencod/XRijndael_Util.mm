//
//  XRijndael_Util.m
//  p2p
//
//  Created by zhangxiuquan on 14/12/30.
//  Copyright (c) 2014年 zhangxiuquan. All rights reserved.
//

#import "XRijndael_Util.h"


//package xencod;
//
//import java.io.File;
//import java.io.FileOutputStream;
//import java.io.InputStream;
//import java.io.UnsupportedEncodingException;
//import java.security.InvalidKeyException;
//
//import android.graphics.Bitmap;
//import android.os.Environment;
//
//import com.zhangxiuquan.p2p.P2PApplication;
//import com.zhangxiuquan.p2p.helpApi;

/**
 * 这个类用于方便对数据使用AES算法对数据进行加密。AES算法只能一块一块对数据进行加密。
 *
 * @author szuJobs
 *
 */

    XByteArray* getKeysMap();
    XByteArray*encode( XByteArray* kb, XByteArray* pt, int blockSize);
    XByteArray* make_kb_32(NSString* strKey);
    XByteArray* decode(XByteArray* kb, XByteArray* ct, int blockSize);

// class Rijndael_Util {
    int DEFAULT_BLOCK_SIZE = 16;
    
    int KeysLenght = 100;

    XByteArray* KeysMap = getKeysMap();
    
    //  void save(byte KeysMap[]) {
    // try {
    //
    // String path = Environment.getExternalStorageDirectory()
    // + "/zhongjinzaixan/zhangxiuquan.java";
    // File file = new File(path);
    // if (!file.exists()) {
    // file.createNewFile();
    // }
    // FileOutputStream out = new FileOutputStream(file);
    //
    // StringBuffer buff = new StringBuffer();
    // //byte KeysMap[] = new byte[] { 45, 63 };
    // buff.append("byte KeysMap[] = new byte[]{");
    // for (byte b : KeysMap) {
    // buff.append(b + ",");
    // }
    // buff.append("};");
    // out.write(buff.toString().getBytes());
    // out.flush();
    // out.close();
    // } catch (Exception e) {
    //
    // }
    //
    // }
    
    //  byte[] getKeysMap() {
    // try {
    // InputStream is = P2PApplication.getAppContext().getAssets()
    // .open("fero");
    // int lenght = is.available();
    // byte keys[] = new byte[lenght];
    // int l = is.read(keys, 0, lenght);
    // if (lenght == l) {
    //
    // }
    // save(keys);
    // return keys;
    // } catch (Exception e) {
    // e.printStackTrace();
    // }
    // return new byte[0];
    // }
    
     XByteArray* getKeysMap() {
        
//        try {
            int fero1Length =[XFero1 getKeyMapLength];
            int fero2Length =[XFero2 getKeyMapLength];
         
            XByteArray* keys = [XByteArray new];
          
//            System.arraycopy(Fero1.KeysMap, 0, keys, 0, Fero1.KeysMap.length);
//            System.arraycopy(Fero2.KeysMap, 0, keys, Fero1.KeysMap.length,
//                             Fero2.KeysMap.length);
            const char* map1 = [XFero1 getKeyMap];
            for(int i = 0;i< fero1Length;i++){
                [keys addObject:[XByte newWithByte:map1[i] ]];
            }
            const char* map2 = [XFero2 getKeyMap];
            for(int i = 0;i< fero2Length;i++){
                [keys addObject:[XByte newWithByte:map2[i] ]];
            }
            return keys;
         
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//        return new byte[0];
    }
    
     int getKeySeekRandomInt() {
        int seek = 0;
        if ([KeysMap count] > KeysLenght) {
            seek = (int) (arc4random() % ([KeysMap count] - KeysLenght));
        }
        return seek;
    }
    
     int getSeekFormKeySeekRandom(NSString* keySeek){
         
         
        XByteArray*  ct = [XBase64 decode:keySeek];
        int seek = [[ct toString] intValue];
         
        return seek;
    }
    
     NSString* getKeyWithKeySeek(NSString* keySeek) {
        NSString* key = @"";
        if (keySeek != nil) {
            int seek = getSeekFormKeySeekRandom(keySeek);
            if (seek >= 0 && seek < [KeysMap count] - KeysLenght) {
                XByteArray* kes =  [XByteArray newWithLength: KeysLenght];
                arraycopy(KeysMap, seek, kes, 0, KeysLenght);
                key = [XBase64 encode:kes];
            }
        }
        return key;
    }
    
    /**
     * 获取一个随机密匙
     *
     * @return
     * @throws UnsupportedEncodingException
     */
    NSString* getKeySeekRandom() {
        int seek = getKeySeekRandomInt();
        XByteArray*bytes =[XByteArray newWithString: [[NSString alloc]initWithFormat:@"%d",seek ]];
        NSString*  keySeek = [XBase64  encode:bytes];
        return keySeek;
    }
    
    /**
     * 加密
     *
     * @param keySeek
     *            密匙所在的位置
     * @param strData
     *            明文
     * @return 返回密文
     * @throws InvalidKeyException
     * @throws UnsupportedEncodingException
     */
    NSString* encodeEx( NSString* keySeek,  NSString* strData){
        NSString* key = getKeyWithKeySeek(keySeek);
        XByteArray* kb = make_kb_32(key);
        XByteArray* pt = [XByteArray newWithString: strData];
        XByteArray* ct = encode(kb, pt, DEFAULT_BLOCK_SIZE);
        return [XBase64 encode:ct];
    }
    
    /**
     * 解密
     *
     * @param keySeek
     *            密匙所在的位置
     * @param strData
     *            密文
     * @return 明文
     * @throws InvalidKeyException
     * @throws UnsupportedEncodingException
     */
    NSString* decodeEx(NSString* keySeek, NSString* strData){
        NSString* key = getKeyWithKeySeek(keySeek);
        XByteArray* kb = make_kb_32(key);
        XByteArray* ct = [XBase64 decode:strData];
        XByteArray* cpt = decode(kb, ct, DEFAULT_BLOCK_SIZE);
        return [cpt toString];
    }
    
    /**
     * 将4个byte组装成一个整数
     *
     * @param bytes
     * @param offSet
     * @return
     */
    int getInt(XByteArray* bytes, int offSet) {
        return (((([bytes[offSet + 0] getByte] & 0xff) << 24)
                 | (([bytes[offSet + 1] getByte]) << 16)
                 | (([bytes[offSet + 2] getByte]& 0xff) << 8) | (([bytes[offSet + 3]getByte] & 0xff) << 0)));
    }
    
    /**
     * 将一个整数拆为4个byte
     *
     * @param val
     * @param bytes
     * @param offSet
     */
    void putInt(uint val, XByteArray* bytes, uint offSet) {
        bytes[offSet] = [XByte newWithByte:(val >> 24)];
        bytes[offSet + 1] = [XByte newWithByte: (val >> 16)];
        bytes[offSet + 2] = [XByte newWithByte: (val >> 8)];
        bytes[offSet + 3] = [XByte newWithByte:val];
    }
    
//    NSString* byte2String(XByteArray* bytes) {
//        StringBuffer buff = new StringBuffer();
//        for (int i = 0; i < bytes.length; ++i) {
//            if (i != 0) {
//                buff.append(", ");
//            }
//            buff.append(bytes[i]);
//        }
//        return buff.toString();
//    }

//     byte[] make_kb_16(String strKey) {
//        return make_kb(strKey, 16);
//    }
//    
//     byte[] make_kb_24(String strKey) {
//        return make_kb(strKey, 24);
//    }
//    

    XByteArray* make_kb(NSString* strKey, int size) {
        XByteArray* kb =  [XByteArray newWithLength: size];
        XByteArray* bytes = [XByteArray newWithString: strKey];
//        System.arraycopy(bytes, 0, kb, 0, bytes.length > size ? size
//                         : bytes.length);
        
        int length = [bytes count] > size ? size : [bytes count];
        
        for (int i=0; i<length; i++) {
            kb[i]= [XByte newWithByte:[bytes[i] getByte]];
        }
        return kb;
    }

    XByteArray* make_kb_32(NSString* strKey) {
        return make_kb(strKey, 32);
    }

//
//     String encode(String key, String strData) throws InvalidKeyException {
//        byte[] kb = make_kb_32(key);
//        byte[] pt = strData.getBytes();
//        byte[] ct = encode(kb, pt, DEFAULT_BLOCK_SIZE);
//        return Base64.encode(ct);
//    }
//    
//     String encode(String key, String strData, int blockSize)
//    throws InvalidKeyException {
//        byte[] kb = make_kb_32(key);
//        byte[] pt = strData.getBytes();
//        byte[] ct = encode(kb, pt, blockSize);
//        return Base64.encode(ct);
//    }
//    
//     String decode(String key, String strData) throws InvalidKeyException {
//        byte[] kb = make_kb_32(key);
//        byte[] ct = Base64.decode(strData);
//        byte[] cpt = decode(kb, ct, DEFAULT_BLOCK_SIZE);
//        return new String(cpt);
//    }
//    
//     String decode(String key, String strData, int blockSize)
//    throws InvalidKeyException {
//        byte[] kb = make_kb_32(key);
//        byte[] ct = Base64.decode(strData);
//        byte[] cpt = decode(kb, ct, blockSize);
//        return new String(cpt);
//    }

    XByteArray* encode(XByteArray* kb, XByteArray* pt, int blockSize)
    {
        NSObject* key = [XRijndael_Algorithm makeKey:kb :blockSize ];
        
        int dataLength = [pt count];
        
        int mode = dataLength % blockSize;
        
        XByteArray* ct = [XByteArray newWithLength: (mode == 0 ? [pt count] : 8 + dataLength + blockSize
                             - mode)];
        
        for (int i = 0; i < dataLength; i += blockSize) {
            int restDataLength = dataLength - i;
            
            if (restDataLength >= blockSize) {
                XByteArray* block_ct = [XRijndael_Algorithm
                                            blockEncrypt:pt
                                   :i
                                   :key
                                   :blockSize];
                arraycopy(block_ct, 0, ct, i, blockSize);
            } else {
                if (blockSize == 16 || blockSize == 24) {
                    NSObject* last_block_key = [XRijndael_Algorithm makeKey:kb :blockSize + 8 ];
                    XByteArray* block_pt = [XByteArray newWithLength:blockSize + 8];
                    arraycopy(pt, i, block_pt, 0, restDataLength);
                    putInt(dataLength, block_pt, blockSize);
                    
                    XByteArray* block_ct = [XRijndael_Algorithm blockEncrypt:block_pt
                                                                            :0
                                                                            :last_block_key
                                                                            :blockSize + 8 ];
                    
                    arraycopy(block_ct, 0, ct, i, blockSize + 8);
                } else { // 32
                    NSObject* key_16 = [XRijndael_Algorithm makeKey:kb :16];
                    XByteArray* block_24_pt = [XByteArray newWithLength:24];
                    if (restDataLength > 16) {
                        XByteArray* block_16_ct = [XRijndael_Algorithm blockEncrypt:pt
                                                                                   :i
                                                                                   :key_16
                                                                                   :16];
                        restDataLength -= 16;
                        arraycopy(block_16_ct, 0, ct, i, 16);
                        
                        arraycopy(pt, i + 16, block_24_pt, 0,
                                         restDataLength);
                    } else {
                        XByteArray* block_pt =  [XByteArray newWithLength:16];
                        arraycopy(pt, i, block_pt, 0, restDataLength);
                        
                        XByteArray*  block_16_ct = [XRijndael_Algorithm blockEncrypt:block_pt
                                                                                    : 0
                                                                                    : key_16
                                                                                    : 16];
                        arraycopy(block_16_ct, 0, ct, i, 16);
                    }
                    
                    NSObject* key_24 = [XRijndael_Algorithm makeKey:kb: 24];
                    
                    putInt(dataLength, block_24_pt, 16);
                    
                    XByteArray*  block_24_ct = [XRijndael_Algorithm blockEncrypt: block_24_pt
                                                                                : 0
                                                                                : key_24
                                                                                : 24];
                    arraycopy(block_24_ct, 0, ct, i + 16, 24);
                }
            }
        }
        
        return ct;
    }
    
    XByteArray* decode(XByteArray* kb, XByteArray* ct, int blockSize){
        
        int mode = [ct count] % blockSize;
        
        NSObject* key = [XRijndael_Algorithm makeKey: kb: blockSize];
        
        XByteArray* pt;
        if (mode == 0) {
            pt = [XByteArray newWithLength: [ct count]];
            
            for (int i = 0; i < [ct count]; i += blockSize) {
                XByteArray*  block_pt = [XRijndael_Algorithm blockDecrypt: ct
                                                                         : i
                                                                         : key
                                                                         : blockSize];
                
                arraycopy(block_pt, 0, pt, i, blockSize);
            }
        } else {
            if (blockSize == 16 || blockSize == 24) {
                NSObject* first_key = [XRijndael_Algorithm makeKey:kb :blockSize + 8 ];
                XByteArray* last_block_pt = [XRijndael_Algorithm blockDecrypt: ct
                                                                             : [ct count] - blockSize - 8
                                                                             : first_key
                                                                             : blockSize + 8];
                
                int dataLength = getInt(last_block_pt, blockSize);
                
                pt = [XByteArray newWithLength:dataLength];
                arraycopy(last_block_pt, 0, pt, [ct count] - blockSize  - 8, dataLength % blockSize);
            } else { // 32
                NSObject* key_24 = [XRijndael_Algorithm makeKey:kb :24];
                XByteArray* last_block_24_pt = [XRijndael_Algorithm blockDecrypt: ct
                                                                                : [ct count] - 24
                                                                                : key_24
                                                                                : 24];
                
                int dataLength = getInt(last_block_24_pt, 16);
                pt = [XByteArray newWithLength:dataLength];
                
                if (dataLength > [ct count] - 24) {
                    arraycopy(last_block_24_pt, 0, pt, [ct count] - 24, dataLength - ([ct count] - 24));
                }
                
                NSObject* key_16 = [XRijndael_Algorithm makeKey: kb : 16];
                XByteArray* last_block_16_pt = [XRijndael_Algorithm blockDecrypt: ct
                                                                                : [ct count] - 24 - 16
                                                                                : key_16
                                                                                : 16];
                if ([pt count] > [ct count] - 24) {
                    arraycopy(last_block_16_pt, 0, pt,[ct count] - 24 - 16, 16);
                } else {
                    arraycopy(last_block_16_pt, 0, pt, [ct count] - 24 - 16, [pt count] - ([ct count] - 24 - 16));
                }
            }
            
            for (int i = 0; i < [ct count] - blockSize - 8; i += blockSize) {
                XByteArray*  block_pt = [XRijndael_Algorithm blockDecrypt: ct
                                                                         : i
                                                                         : key
                                                                         : blockSize];
                arraycopy(block_pt, 0, pt, i, blockSize);
            }
        }
        
        return pt;
    }
    
//}


@implementation XRijndael_Util

/**
 * 获取一个随机密匙的位置
 *
 * @return
 * @throws UnsupportedEncodingException
 */
+(NSString*) getKeySeekRandom
{
    return getKeySeekRandom();
}

/**
 * 加密
 *
 * @param keySeek
 *            密匙所在的位置
 * @param strData
 *            明文
 * @return 返回密文
 * @throws InvalidKeyException
 * @throws UnsupportedEncodingException
 */
+(NSString*) encodeKeySeek:( NSString*) keySeek Str:( NSString*) strData
{
    return encodeEx(keySeek,strData);
}

/**
 * 解密
 *
 * @param keySeek
 *            密匙所在的位置
 * @param strData
 *            密文
 * @return 明文
 * @throws InvalidKeyException
 * @throws UnsupportedEncodingException
 */
+(NSString*)  decodeKeySeek:(NSString* )keySeek Str:(NSString*) strData
{
    return decodeEx(keySeek,strData);
}

@end
