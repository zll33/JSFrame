package com.jsview.zhangxiuquan.androidframe;

import java.util.Iterator;

import org.json.JSONArray;
import org.json.JSONObject;

import android.annotation.SuppressLint;
import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteDatabase.CursorFactory;
import android.database.sqlite.SQLiteOpenHelper;

public class JsSQLite extends SQLiteOpenHelper {
	final static String table = "jsSqlitRecordTable";
	final static String tName = "tableName";
	final static String time = "lastModifyTime";
	final static String modifyId = "lastModifyId";

	String tableName;
	String dbName;
	JSONObject info = new JSONObject();
	static CursorFactory factory = null;
	static int version = 1;;
	Context mContext = null;
	private SQLiteDatabase StorageDatadb = null;

	@SuppressWarnings("rawtypes")
	@Override
	public void onCreate(SQLiteDatabase db) {
		// 创建记录表
		StringBuffer sqlRecord = new StringBuffer("CREATE TABLE IF NOT EXISTS ");
		sqlRecord.append(table);
		sqlRecord.append("(id INTEGER PRIMARY KEY AUTOINCREMENT,");
		sqlRecord.append(tName + " varchar NOT NULL UNIQUE,");
		sqlRecord.append(time + " long DEFAULT 0,");
		sqlRecord.append(modifyId + " int DEFAULT 0");
		sqlRecord.append(")");
		String sqlRecordStr = sqlRecord.toString();
		db.execSQL(sqlRecordStr);
	}

	@Override
	public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
		db.execSQL("DROP TABLE IF EXISTS diary");
		onCreate(db);
	}

	public JsSQLite(Context context, String name, String table, String tableInfo)
			throws Exception {
		super(context, name, factory, version);
//		int flags = android.database.sqlite.SQLiteDatabase.CREATE_IF_NECESSARY
//				| android.database.sqlite.SQLiteDatabase.OPEN_READWRITE
//				| android.database.sqlite.SQLiteDatabase.NO_LOCALIZED_COLLATORS;
//		SQLiteDatabase base = SQLiteDatabase.openDatabase(name, null, flags);
		mContext = context;
		dbName = name;
		tableName = table;

		StorageDatadb = getWritableDatabase();

		createTable(StorageDatadb, tableInfo);
	}

	void createTable(SQLiteDatabase db, String tableInfo) throws Exception {
		info = null;

		if (tableInfo != null) {
			info = new JSONObject(tableInfo);
		}

		if (info != null && info.length() > 0) {

			// 创建具体表
			StringBuffer sql = new StringBuffer("CREATE TABLE IF NOT EXISTS "
					+ tableName + "(id INTEGER PRIMARY KEY AUTOINCREMENT");

			Iterator it = info.keys();
			try {
				while (it.hasNext()) {
					String name = (String) it.next();
					Object value = info.get(name);
					if (value instanceof String) {
						String v = (String) value;
						sql.append("," + name + " varchar");
						if (v.equals("key")) {
							sql.append(" primary key");
						} else {
							sql.append(" DEFAULT '" + v + "'");
						}
					} else if (value instanceof Boolean) {
						boolean v = ((Boolean) value).booleanValue();
						sql.append("," + name + " BOOLEAN");
						sql.append(" DEFAULT " + v);
					} else if (value instanceof Integer) {
						if (!name.equals("id")) {
							int v = ((Integer) value).intValue();
							sql.append("," + name + " int");
							sql.append(" DEFAULT " + v);
						}
					} else if (value instanceof Float) {
						double v = (double) ((Float) value).floatValue();
						sql.append("," + name + " double");
						sql.append(" DEFAULT " + v);
					} else if (value instanceof Double) {
						double v = ((Double) value).doubleValue();
						sql.append("," + name + " double");
						sql.append(" DEFAULT " + v);
					} else if (value instanceof JSONArray) {
						sql.append("," + name + " image");
						sql.append(" NOT NULL DEFAULT 0");
					} else if (value instanceof Long) {
						sql.append("," + name + " long");
						sql.append(" NOT NULL DEFAULT 0");
					}

				}

			} catch (Exception e) {

				e.printStackTrace();

			}
			// sql.append(",modifyTime DATETIME NOT NULL ON UPDATE CURRENT_TIMESTAMP");
			sql.append(",createTime DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP");

			sql.append(")");
			String sqlStr = sql.toString();
			db.execSQL(sqlStr);
		}
	}

	public JSONArray find(String selection, String[] whereArgs,
			String[] columns, String groupBy, String having, String orderBy)
			throws Exception {

		JSONArray jsonArray = new JSONArray();
		synchronized (this) {
			Cursor cursor = StorageDatadb.query(tableName, columns, selection,
					whereArgs, groupBy, having, orderBy);
			if (cursor.moveToFirst()) {
				while (!cursor.isAfterLast()) {
					JSONObject json = getInfo(cursor);
					jsonArray.put(json);
					cursor.moveToNext();
				}
			}
		}
		return jsonArray;
	}

	public JSONArray find(String selection, String[] whereArgs)
			throws Exception {
		JSONArray jsonArray = new JSONArray();
		synchronized (this) {
			Cursor cursor = StorageDatadb.query(tableName, null, selection,
					whereArgs, null, null, null);
			if (cursor.moveToFirst()) {
				while (!cursor.isAfterLast()) {
					JSONObject json = getInfo(cursor);
					jsonArray.put(json);
					cursor.moveToNext();
				}
			}
		}
		return jsonArray;
	}

	public boolean update(String selection, String[] whereArgs, String valueinfo)
			throws Exception {
		boolean ret = false;
		synchronized (this) {
			long id = -1;
			ContentValues values = getContentValues(valueinfo);
			id = StorageDatadb.update(tableName, values, selection, whereArgs);
			ret = id > 0;
			if (ret) {
				recordModify((int) id);
			}
		}
		return ret;
	}

	public boolean insert(String valueinfo) throws Exception {
		boolean ret = false;
		synchronized (this) {
			long id = -1;
			ContentValues values = getContentValues(valueinfo);
			id = StorageDatadb.insert(tableName, null, values);
			ret = id > 0;
			if (ret) {
				recordModify((int) id);
			}
		}
		return ret;
	}
	public boolean updateOrInsert(String selection, String[] whereArgs,
								  JSONObject valueinfo) throws Exception {

		boolean ret = false;
		synchronized (this) {
			long id = -1;
			ContentValues values = getContentValues(valueinfo);
			id = StorageDatadb.update(tableName, values, selection, whereArgs);
			if (id <= 0) {
				id = StorageDatadb.insert(tableName, null, values);
			}
			ret = id > 0;
			if (ret) {
				recordModify((int) id);
			}
		}
		return ret;
	}
	public boolean updateOrInsert(String selection, String[] whereArgs,
			String valueinfo) throws Exception {

		boolean ret = false;
		synchronized (this) {
			long id = -1;
			ContentValues values = getContentValues(valueinfo);
			id = StorageDatadb.update(tableName, values, selection, whereArgs);
			if (id <= 0) {
				id = StorageDatadb.insert(tableName, null, values);
			}
			ret = id > 0;
			if (ret) {
				recordModify((int) id);
			}
		}
		return ret;
	}

	public boolean delete(String selection, String[] whereArgs) {
		synchronized (this) {
			int num = StorageDatadb.delete(tableName, selection, whereArgs);
			if (num > 0) {
				recordModify(0);
			}
		}
		return true;
	}

	public int getCount() throws Exception {
		int count = 0;
		synchronized (this) {
			Cursor cursor = StorageDatadb.rawQuery(
					"select count(*) as totalcount from " + tableName, null);
			if (cursor.moveToFirst()) {
				count = cursor.getInt(0);
			}
		}
		return count;
	}

	public JSONArray query(String selection, String[] whereArgs)
			throws Exception {
		JSONArray jsonArray = null;
		synchronized (this) {
			Cursor cursor = StorageDatadb.rawQuery(selection, whereArgs);
			if (cursor.moveToFirst()) {
				jsonArray = new JSONArray();
				while (!cursor.isAfterLast()) {
					JSONObject json = getInfo(cursor);
					jsonArray.put(json);
					cursor.moveToNext();
				}
			}
			if (cursor != null) {
				cursor.close();
			}
		}
		return jsonArray;
	}

	public void execSQL(String execsql, String[] whereArgs) {
		synchronized (this) {
			if (whereArgs == null) {
				StorageDatadb.execSQL(execsql);
			} else {
				StorageDatadb.execSQL(execsql, whereArgs);
			}
			recordModify(0);
		}
		return;
	}

	public void newColumn(String valueinfo) throws Exception {
		synchronized (this) {
			JSONObject json = new JSONObject(valueinfo);
			Iterator<String> it = json.keys();
			while (it.hasNext()) {
				String n = it.next();
				Object v = json.get(n);
				newColumn(n, v);
			}
		}
		return;
	}

	boolean hasColumn(String columnName) {
		boolean has = false;
		Cursor cursor = StorageDatadb.rawQuery(
				"select * from sqlite_master where name = ? and sql like ?",
				new String[] { tableName, "%" + columnName + "%" });
		has = null != cursor && cursor.moveToFirst();
		if (cursor != null) {
			cursor.close();
		}
		return has;
	}

	void newColumn(String name, Object value) {
		if (!hasColumn(name)) {
			String sql = "ALTER TABLE '" + tableName + "' ADD '" + name + "' ";
			if (value instanceof String) {
				sql += "varchar DEFAULT '" + String.valueOf(value) + "'";
			} else if (value instanceof Boolean) {
				sql += "BOOLEAN DEFAULT " + String.valueOf(value);
			} else if (value instanceof Integer) {
				sql += "int DEFAULT " + String.valueOf(value);
			} else if (value instanceof Float || value instanceof Double) {
				sql += "double DEFAULT " + String.valueOf(value);
			} else if (value instanceof JSONArray) {
				sql += "image NOT NULL DEFAULT 0";
			} else {
				sql += "varchar";
			}
			StorageDatadb.execSQL(sql, new String[0]);
			recordModify(0);
		}
	}

	@SuppressWarnings({ "static-access" })
	private boolean recordModify(int modifyId) {

		boolean ret = false;
		synchronized (this) {
			long id = -1;
			ContentValues values = new ContentValues();
			values.put(time, System.currentTimeMillis());
			values.put(this.modifyId, modifyId);
			String[] whereArgs = new String[] { tableName };
			id = StorageDatadb.update(table, values, tName + "=?", whereArgs);
			if (id <= 0) {
				values.put(this.tName, tableName);
				id = StorageDatadb.insert(table, null, values);
			}
			ret = id > 0;
		}
		return ret;
	}

	public long getModifyTime() {
		long lastModify = 0;
		synchronized (this) {
			String[] whereArgs = new String[] { tableName };
			Cursor cursor = StorageDatadb.query(table, null, tName + "=?",
					whereArgs, null, null, null);
			if (cursor != null) {
				if (cursor.moveToFirst()) {
					lastModify = cursor.getLong(cursor.getColumnIndex(time));
				}
				cursor.close();
			}
		}
		return lastModify;
	}

	public void close() {
		synchronized (this) {
			StorageDatadb.close();
			super.close();
		}
	}

	@SuppressWarnings("unchecked")
	ContentValues getContentValues(String info) throws Exception {

		ContentValues values = new ContentValues();
		JSONObject json = new JSONObject(info);
		Iterator<String> it = json.keys();
		while (it.hasNext()) {
			String n = it.next();
			Object v = json.get(n);
			putValue(values, n, v);
		}
		return values;
	}
	ContentValues getContentValues(JSONObject json) throws Exception {

		ContentValues values = new ContentValues();
		Iterator<String> it = json.keys();
		while (it.hasNext()) {
			String n = it.next();
			Object v = json.get(n);
			putValue(values, n, v);
		}
		return values;
	}
	void putValue(ContentValues values, String n, Object v) {

		if (v instanceof String) {
			String value = (String) v;
			values.put(n, value);
		} else if (v instanceof Boolean) {
			boolean value = ((Boolean) v).booleanValue();
			if (value) {
				values.put(n, "true");
			} else {
				values.put(n, "false");
			}

		} else if (v instanceof Integer) {
			int value = ((Integer) v).intValue();
			values.put(n, value);
		} else if (v instanceof Float) {
			double value = (double) ((Float) v).floatValue();
			values.put(n, value);
		} else if (v instanceof Double) {
			double value = ((Double) v).doubleValue();
			values.put(n, value);
		} else if (v instanceof JSONArray) {

			JSONArray vs = (JSONArray) v;
			int length = vs.length();
			byte[] value = new byte[length];
			for (int i = 0; i < length; i++) {
				int num = ((Number) (vs.optDouble(i, 0))).intValue();
				value[i] = (byte) (num & 0x000000ff);
			}
			values.put(n, value);
		} else if (v instanceof Long) {
			Long value = (Long) v;
			values.put(n, value);
		}
	}

	@SuppressLint("NewApi")
	JSONObject getInfo(Cursor cursor) throws Exception {
		JSONObject json = new JSONObject();
		String names[] = cursor.getColumnNames();

		for (String n : names) {
			int index = cursor.getColumnIndex(n);
			int type = cursor.getType(index);

			switch (type) {
			case Cursor.FIELD_TYPE_BLOB: {
				byte[] value = cursor.getBlob(index);
				JSONArray vs = new JSONArray();
				for (byte b : value) {
					vs.put(b);
				}
				json.put(n, vs);
			}
				break;
			case Cursor.FIELD_TYPE_FLOAT: {
				double value = cursor.getDouble(index);
				// float value = Float.valueOf(cursor.getString(index));
				// double value = Double.valueOf(cursor.getString(index));
				json.put(n, value);
			}
				break;
			case Cursor.FIELD_TYPE_INTEGER: {
				try {
					long value = cursor.getLong(index);
					json.put(n, value);
				} catch (Exception e) {
					int value = cursor.getInt(index);
					json.put(n, value);
				}

			}
				break;
			case Cursor.FIELD_TYPE_NULL: {
				if (n.equals("id")) {
					int value = cursor.getInt(index);
					json.put(n, value);
				}
			}
				break;
			case Cursor.FIELD_TYPE_STRING: {
				String value = cursor.getString(index);
				json.put(n, value);
			}
				break;
			default:
				break;
			}
		}
		return json;
	}
}
