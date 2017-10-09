package xencod;

import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.security.InvalidKeyException;

import android.graphics.Bitmap;
import android.os.Environment;

import com.zhangxiuquan.p2p.P2PApplication;
import com.zhangxiuquan.p2p.helpApi;

/**
 * 这个类用于方便对数据使用AES算法对数据进行加密。AES算法只能一块一块对数据进行加密。
 * 
 * @author szuJobs
 * 
 */
public class Rijndael_Util {
	private static final int DEFAULT_BLOCK_SIZE = 16;

	private static final int KeysLenght = 100;
	private final static byte KeysMap[] = getKeysMap();

	// static void save(byte KeysMap[]) {
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

	// static byte[] getKeysMap() {
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

	static byte[] getKeysMap() {

		try {

			int size = Fero1.KeysMap.length + Fero2.KeysMap.length;
			byte keys[] = new byte[size];

			System.arraycopy(Fero1.KeysMap, 0, keys, 0, Fero1.KeysMap.length);
			System.arraycopy(Fero2.KeysMap, 0, keys, Fero1.KeysMap.length,
					Fero2.KeysMap.length);

			return keys;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return new byte[0];
	}

	static int getKeySeekRandomInt() {
		int seek = 0;
		if (KeysMap.length > KeysLenght) {
			seek = (int) (Math.random() * (KeysMap.length - KeysLenght));
		}
		return seek;
	}

	static int getSeekFormKeySeekRandom(String keySeek) throws NumberFormatException, UnsupportedEncodingException {
		byte[] ct = Base64.decode(keySeek);
		int seek = Integer.valueOf(new String(ct,"UTF-8"));
		return seek;
	}

	static String getKeyWithKeySeek(String keySeek) throws NumberFormatException, UnsupportedEncodingException {
		String key = "";
		if (keySeek != null) {
			int seek = getSeekFormKeySeekRandom(keySeek);
			if (seek >= 0 && seek < KeysMap.length - KeysLenght) {
				byte kes[] = new byte[KeysLenght];
				System.arraycopy(KeysMap, seek, kes, 0, KeysLenght);
				key = Base64.encode(kes);
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
	public static String getKeySeekRandom() throws UnsupportedEncodingException {
		int seek = getKeySeekRandomInt();
		String keySeek = Base64.encode(String.valueOf(seek).getBytes("UTF-8"));
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
	public static String encodeEx(String keySeek, String strData)
			throws InvalidKeyException, UnsupportedEncodingException {
		String key = getKeyWithKeySeek(keySeek);
		byte[] kb = make_kb_32(key);
		byte[] pt = strData.getBytes("UTF-8");
		byte[] ct = encode(kb, pt, DEFAULT_BLOCK_SIZE);
		return Base64.encode(ct);
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
	public static String decodeEx(String keySeek, String strData)
			throws InvalidKeyException, UnsupportedEncodingException {
		String key = getKeyWithKeySeek(keySeek);
		byte[] kb = make_kb_32(key);
		byte[] ct = Base64.decode(strData);
		byte[] cpt = decode(kb, ct, DEFAULT_BLOCK_SIZE);
		return new String(cpt,"UTF-8");
	}

	/**
	 * 将4个byte组装成一个整数
	 * 
	 * @param bytes
	 * @param offSet
	 * @return
	 */
	final static int getInt(byte[] bytes, int offSet) {
		return ((((bytes[offSet + 0] & 0xff) << 24)
				| ((bytes[offSet + 1]) << 16)
				| ((bytes[offSet + 2] & 0xff) << 8) | ((bytes[offSet + 3] & 0xff) << 0)));
	}

	/**
	 * 将一个整数拆为4个byte
	 * 
	 * @param val
	 * @param bytes
	 * @param offSet
	 */
	final static void putInt(int val, byte[] bytes, int offSet) {
		bytes[offSet] = (byte) (val >> 24);
		bytes[offSet + 1] = (byte) (val >> 16);
		bytes[offSet + 2] = (byte) (val >> 8);
		bytes[offSet + 3] = (byte) val;
	}

	static String byte2String(byte[] bytes) {
		StringBuffer buff = new StringBuffer();
		for (int i = 0; i < bytes.length; ++i) {
			if (i != 0) {
				buff.append(", ");
			}
			buff.append(bytes[i]);
		}
		return buff.toString();
	}

	static byte[] make_kb_16(String strKey) {
		return make_kb(strKey, 16);
	}

	static byte[] make_kb_24(String strKey) {
		return make_kb(strKey, 24);
	}

	static byte[] make_kb_32(String strKey) {
		return make_kb(strKey, 32);
	}

	private static byte[] make_kb(String strKey, int size) {
		byte[] kb = new byte[size];
		byte[] bytes = strKey.getBytes();
		System.arraycopy(bytes, 0, kb, 0, bytes.length > size ? size
				: bytes.length);
		return kb;
	}

	static String encode(String key, String strData) throws InvalidKeyException {
		byte[] kb = make_kb_32(key);
		byte[] pt = strData.getBytes();
		byte[] ct = encode(kb, pt, DEFAULT_BLOCK_SIZE);
		return Base64.encode(ct);
	}

	static String encode(String key, String strData, int blockSize)
			throws InvalidKeyException {
		byte[] kb = make_kb_32(key);
		byte[] pt = strData.getBytes();
		byte[] ct = encode(kb, pt, blockSize);
		return Base64.encode(ct);
	}

	static String decode(String key, String strData) throws InvalidKeyException {
		byte[] kb = make_kb_32(key);
		byte[] ct = Base64.decode(strData);
		byte[] cpt = decode(kb, ct, DEFAULT_BLOCK_SIZE);
		return new String(cpt);
	}

	static String decode(String key, String strData, int blockSize)
			throws InvalidKeyException {
		byte[] kb = make_kb_32(key);
		byte[] ct = Base64.decode(strData);
		byte[] cpt = decode(kb, ct, blockSize);
		return new String(cpt);
	}

	static byte[] encode(byte[] kb, byte[] pt, int blockSize)
			throws InvalidKeyException {
		Object key = Rijndael_Algorithm.makeKey(kb, blockSize);

		int dataLength = pt.length;

		int mode = dataLength % blockSize;

		byte[] ct = new byte[mode == 0 ? pt.length : 8 + dataLength + blockSize
				- mode];

		for (int i = 0; i < dataLength; i += blockSize) {
			int restDataLength = dataLength - i;

			if (restDataLength >= blockSize) {
				byte[] block_ct = Rijndael_Algorithm.blockEncrypt(pt, i, key,
						blockSize);
				System.arraycopy(block_ct, 0, ct, i, blockSize);
			} else {
				if (blockSize == 16 || blockSize == 24) {
					Object last_block_key = Rijndael_Algorithm.makeKey(kb,
							blockSize + 8);
					byte[] block_pt = new byte[blockSize + 8];
					System.arraycopy(pt, i, block_pt, 0, restDataLength);
					putInt(dataLength, block_pt, blockSize);

					byte[] block_ct = Rijndael_Algorithm.blockEncrypt(block_pt,
							0, last_block_key, blockSize + 8);

					System.arraycopy(block_ct, 0, ct, i, blockSize + 8);
				} else { // 32
					Object key_16 = Rijndael_Algorithm.makeKey(kb, 16);
					byte[] block_24_pt = new byte[24];
					if (restDataLength > 16) {
						byte[] block_16_ct = Rijndael_Algorithm.blockEncrypt(
								pt, i, key_16, 16);
						restDataLength -= 16;
						System.arraycopy(block_16_ct, 0, ct, i, 16);

						System.arraycopy(pt, i + 16, block_24_pt, 0,
								restDataLength);
					} else {
						byte[] block_pt = new byte[16];
						System.arraycopy(pt, i, block_pt, 0, restDataLength);

						byte[] block_16_ct = Rijndael_Algorithm.blockEncrypt(
								block_pt, 0, key_16, 16);
						System.arraycopy(block_16_ct, 0, ct, i, 16);
					}

					Object key_24 = Rijndael_Algorithm.makeKey(kb, 24);

					putInt(dataLength, block_24_pt, 16);

					byte[] block_24_ct = Rijndael_Algorithm.blockEncrypt(
							block_24_pt, 0, key_24, 24);
					System.arraycopy(block_24_ct, 0, ct, i + 16, 24);
				}
			}
		}

		return ct;
	}

	static byte[] decode(byte[] kb, byte[] ct, int blockSize)
			throws InvalidKeyException {

		int mode = ct.length % blockSize;

		Object key = Rijndael_Algorithm.makeKey(kb, blockSize);

		byte[] pt;
		if (mode == 0) {
			pt = new byte[ct.length];

			for (int i = 0; i < ct.length; i += blockSize) {
				byte[] block_pt = Rijndael_Algorithm.blockDecrypt(ct, i, key,
						blockSize);

				System.arraycopy(block_pt, 0, pt, i, blockSize);
			}
		} else {
			if (blockSize == 16 || blockSize == 24) {
				Object first_key = Rijndael_Algorithm
						.makeKey(kb, blockSize + 8);
				byte[] last_block_pt = Rijndael_Algorithm.blockDecrypt(ct,
						ct.length - blockSize - 8, first_key, blockSize + 8);

				int dataLength = getInt(last_block_pt, blockSize);

				pt = new byte[dataLength];
				System.arraycopy(last_block_pt, 0, pt, ct.length - blockSize
						- 8, dataLength % blockSize);
			} else { // 32
				Object key_24 = Rijndael_Algorithm.makeKey(kb, 24);
				byte[] last_block_24_pt = Rijndael_Algorithm.blockDecrypt(ct,
						ct.length - 24, key_24, 24);

				int dataLength = getInt(last_block_24_pt, 16);
				pt = new byte[dataLength];

				if (dataLength > ct.length - 24) {
					System.arraycopy(last_block_24_pt, 0, pt, ct.length - 24,
							dataLength - (ct.length - 24));
				}

				Object key_16 = Rijndael_Algorithm.makeKey(kb, 16);
				byte[] last_block_16_pt = Rijndael_Algorithm.blockDecrypt(ct,
						ct.length - 24 - 16, key_16, 16);
				if (pt.length > ct.length - 24) {
					System.arraycopy(last_block_16_pt, 0, pt,
							ct.length - 24 - 16, 16);
				} else {
					System.arraycopy(last_block_16_pt, 0, pt,
							ct.length - 24 - 16, pt.length
									- (ct.length - 24 - 16));
				}
			}

			for (int i = 0; i < ct.length - blockSize - 8; i += blockSize) {
				byte[] block_pt = Rijndael_Algorithm.blockDecrypt(ct, i, key,
						blockSize);
				System.arraycopy(block_pt, 0, pt, i, blockSize);
			}
		}

		return pt;
	}

}
