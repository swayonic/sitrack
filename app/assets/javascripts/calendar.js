/* Copyright (c) 2003 Washington Mutual.  All rights reserved. */

var g_iMonth, g_iDay, g_iYear, oDateTarget;
var id, colID, fieldname;
function setToday()
{
  g_iMonth  = g_dtToday.getMonth();
  g_iDay    = g_dtToday.getDate();
  g_iYear   = g_dtToday.getFullYear();
}

function clearDate(today)
{
	var params = "'"+fieldname+"','"+id+"','"+colID+"','"+today+"'";
	var href = 'href="javascript:popCalendar('+params+')"';
	oDateTarget.innerHTML = '<a '+href+'"><img src="/images/edit.png" border="0"/></a>';
	// use the iframe
	var loc = '/modify/update?value=&id='+id+'&type=date&colID='+colID+'&fieldname='+fieldname;
	var frame = window.frames["modify_frame"];
	frame.document.location = loc;
}
function changeDate(sNewDate)
{
	var params = "'"+fieldname+"','"+id+"','"+colID+"','"+sNewDate+"'";
	var href = 'href="javascript:popCalendar('+params+')"';
	oDateTarget.innerHTML = '<a '+href+'">'+sNewDate+'</a>';
	// use the iframe
	var loc = '/modify/update?value='+sNewDate+'&id='+id+'&type=date&colID='+colID+'&fieldname='+fieldname;
	var frame = window.frames["modify_frame"];
	frame.document.location = loc;
}

function popCalendar( p_fieldname, p_id, p_colID, dtSelDate)
{
  id = p_id;
  fieldname = p_fieldname;
  colID = p_colID;
  
  if ("" == dtSelDate)
 {
  setToday();
 }
 else
 {
  var saDtSelDate = new Array(3);
  saDtSelDate = dtSelDate.split("/");
  g_iMonth = saDtSelDate[0] - 1;
  g_iDay = saDtSelDate[1];
  g_iYear = saDtSelDate[2];
  }

  oDateTarget = document.getElementById(fieldname+id+'c'+colID);

  winCalendar = window.open("/directory/calendar?SelectDate=" + dtSelDate ,"winCalendar","resizable=yes,width=320,height=275");

  if (null == winCalendar.opener)
  {
    winCalendar.opener = self;
  }
}
