<%@page import="nd.Sdk"%>
<%@ page language="java" import="java.util.*"  pageEncoding="utf-8"%>

<%


String appid = request.getParameter("AppId");
String act = request.getParameter("Act");
String productName = request.getParameter("ProductName");
if(productName!=null && productName.length()>0 ){
	productName = new String(productName.getBytes("ISO8859_1"),"UTF-8");
}
String consumeStreamId = request.getParameter("ConsumeStreamId");
String cooOrderSerial = request.getParameter("CooOrderSerial");
String uin = request.getParameter("Uin");
String goodsId = request.getParameter("GoodsId");
String goodsInfo = request.getParameter("GoodsInfo");
if(goodsInfo!=null && goodsInfo.length()>0 ){
	goodsInfo = new String(goodsInfo.getBytes("ISO8859_1"),"UTF-8");
}
String goodsCount = request.getParameter("GoodsCount");
String originalMoney = request.getParameter("OriginalMoney");
String orderMoney = request.getParameter("OrderMoney");
String note = request.getParameter("Note");
if(note!=null && note.length()>0 ){
	note = new String(note.getBytes("ISO8859_1"),"UTF-8");
}
String payStatus = request.getParameter("PayStatus");
String createTime = request.getParameter("CreateTime");
String sign = request.getParameter("Sign");

int resultNum;

if(appid==null || act == null || productName == null || consumeStreamId == null 
|| cooOrderSerial == null || uin == null
|| goodsId == null|| goodsCount == null|| originalMoney == null|| orderMoney == null
|| payStatus == null|| createTime == null
|| sign == null){
	resultNum = 4;
}
else{
//先对接收到的91通知进行验证
	Sdk sdk = new Sdk();
	resultNum = sdk.payResultNotify(appid, act, productName, consumeStreamId, cooOrderSerial,
	uin, goodsId, goodsInfo, goodsCount, originalMoney, orderMoney, note, payStatus, createTime, sign);
}

String result = "{\"ErrorCode\":\""+ resultNum +"\"}";
out.println(result);

//然后对正确的通知进行处理
if(resultNum==1){
	//判断该订单是否已经处理，未处理的进行处理，否则不做任何处理
	//开发者自己的代码

}


%>

