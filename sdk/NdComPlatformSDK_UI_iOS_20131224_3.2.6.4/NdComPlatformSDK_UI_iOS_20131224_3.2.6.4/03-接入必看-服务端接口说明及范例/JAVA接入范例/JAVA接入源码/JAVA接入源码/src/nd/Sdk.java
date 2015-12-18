package nd;

import java.io.UnsupportedEncodingException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
//import java.util.regex.Matcher;
//import java.util.regex.Pattern;
import java.io.BufferedReader;   
import java.io.InputStreamReader;   
import java.net.URL;   
import java.net.URLConnection;   

import net.sf.json.JSONObject;


public class Sdk {
	
	//�����������APPID
	private String appid = ͬ�ͻ���һ�µ�APPID;  
	//�����������APPKEY
	private String appkey = ͬ�ͻ���һ�µ�APPKEY;
	//91�ķ�������ַ
	private String goUrl ="http://service.sj.91.com/usercenter/ap.aspx?";
	

	/**
	 * ��ѯ֧����������API����
	 * @param cooOrderSerial �̻�������
	 * @return ERRORCODE��ֵ
	 * @throws Exception API����ʧ��
	 */
	public int queryPayResult(String cooOrderSerial)  throws Exception{
		String act = "1";
		StringBuilder strSign = new StringBuilder();
		strSign.append(appid);
		strSign.append(act);
		strSign.append(cooOrderSerial);
		strSign.append(appkey);
		String sign = md5(strSign.toString());
		StringBuilder getUrl = new StringBuilder();
		getUrl.append("Appid=");
		getUrl.append(appid);
		getUrl.append("&Act=");
		getUrl.append(act);
		getUrl.append("&CooOrderSerial=");
		getUrl.append(cooOrderSerial);
		getUrl.append("&Sign=");
		getUrl.append(sign);
		return GetResult(HttpGetGo(getUrl.toString()));
	}
	
	/**
	 * ����û���½SESSIONID�Ƿ���Ч
	 * @param uin 91�˺�ID
	 * @param sessionID
	 * @return
	 * @throws Exception
	 */
	public int checkUserLogin(String uin,String sessionID) throws Exception{
		String act = "4";
		StringBuilder strSign = new StringBuilder();
		strSign.append(appid);
		strSign.append(act);
		strSign.append(uin);
		strSign.append(sessionID);
		strSign.append(appkey);
		String sign = md5(strSign.toString());
		StringBuilder getUrl = new StringBuilder();
		getUrl.append("Appid=");
		getUrl.append(appid);
		getUrl.append("&Act=");
		getUrl.append(act);
		getUrl.append("&Uin=");
		getUrl.append(uin);
		getUrl.append("&SessionId=");
		getUrl.append(sessionID);
		getUrl.append("&Sign=");
		getUrl.append(sign);
		return GetResult(HttpGetGo(getUrl.toString()));
	}
	
	/**
	 * ����֧��������
	 * @param appid
	 * @param act
	 * @param productName
	 * @param consumeStreamId
	 * @param cooOrderSerial
	 * @param uin
	 * @param goodsId
	 * @param goodsInfo
	 * @param goodsCount
	 * @param originalMoney
	 * @param orderMoney
	 * @param note
	 * @param payStatus
	 * @param createTime
	 * @param fromSign
	 * @return ֧�����
	 * @throws UnsupportedEncodingException 
	 */
	public int payResultNotify(String appid,String act, String productName,String consumeStreamId,
			String cooOrderSerial,String uin,String goodsId,String goodsInfo,String goodsCount,
			String originalMoney,String orderMoney,String note,
			String payStatus,String createTime,String fromSign) throws UnsupportedEncodingException{
		
		StringBuilder strSign = new StringBuilder();
		strSign.append(appid);
		strSign.append(act);
		strSign.append(productName);
		strSign.append(consumeStreamId);
		strSign.append(cooOrderSerial);
		strSign.append(uin);
		strSign.append(goodsId);
		strSign.append(goodsInfo);
		strSign.append(goodsCount);
		strSign.append(originalMoney);
		strSign.append(orderMoney);
		strSign.append(note);
		strSign.append(payStatus);
		strSign.append(createTime);
		strSign.append(appkey);
		String sign = md5(strSign.toString());
		
		if(!this.appid.equals(appid)){
			return 2; //appid��Ч
		}
		if(!"1".equals(act)){
			return 3; //Act��Ч
		}
		if(!sign.toLowerCase().equals(fromSign.toLowerCase())){
			return 5; //sign��Ч
		}
		int payResult = -1;
		if("1".equals(payStatus)){
			try {
				if(queryPayResult(cooOrderSerial) == 1){
					payResult = 1; //�ж���
				}
				else{
					payResult = 11; //�޶���
				}
			} catch (Exception e) {
				payResult = 6; //�Զ��壺��������
			}
			return payResult;
		}
		return 0;  //����
	}
	
	
	/**
	 * ��ȡ91���������صĽ��
	 * @param jsonStr
	 * @return
	 * @throws Exception
	 */
	private int GetResult(String jsonStr) throws Exception{
//		Pattern p = Pattern.compile("(?<=\"ErrorCode\":\")\\d{1,3}(?=\")");
//		Matcher m = p.matcher(jsonStr);
//		m.find();
//		return Integer.parseInt(m.group());
		
		//������Ҫ����JSON-LIB���ڵ�JAR
		JSONObject jo = JSONObject.fromObject(jsonStr); 
		return Integer.parseInt(jo.getString("ErrorCode"));
	}
	
	

	/**
	 * ���ַ�������MD5�����ؽ��
	 * @param sourceStr
	 * @return
	 */
	private String md5(String sourceStr){
		String signStr = "";
		try {
			byte[] bytes = sourceStr.getBytes("utf-8");
			MessageDigest md5 = MessageDigest.getInstance("MD5"); md5.update(bytes);
			byte[] md5Byte = md5.digest();
			if(md5Byte != null){
			signStr = HexBin.encode(md5Byte); }
			} catch (NoSuchAlgorithmException e) { e.printStackTrace();
			} catch (UnsupportedEncodingException e) { e.printStackTrace();
			}
			return signStr;
	}
	
	/**
	 * ����GET���󲢻�ȡ���
	 * @param getUrl
	 * @return
	 * @throws Exception
	 */
	private String HttpGetGo(String getUrl) throws Exception{   
	    StringBuffer readOneLineBuff = new StringBuffer();   
	    String content ="";   
        URL url = new URL( goUrl + getUrl);   
        URLConnection conn = url.openConnection();   
        BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream(),"utf-8"));          
        String line = "";   
        while ((line = reader.readLine()) != null) {   
            readOneLineBuff.append(line);   
        }   
        content = readOneLineBuff.toString();   
        reader.close();   
	    return content;   
	}   
	
	

	

}
