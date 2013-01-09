function appendOptions(field, fieldname, value) {
 switch(fieldname) {
 case 'Gender':

	var option = document.createElement('option'); 
	option.setAttribute('value', '1'); 
	if ('1' == value) { 
	option.setAttribute('selected', 'true'); 
	} 
	var option_value = document.createTextNode('Male'); 
	option.appendChild(option_value); 
	field.appendChild(option); 
	var option = document.createElement('option'); 
	option.setAttribute('value', '0'); 
	if ('0' == value) { 
	option.setAttribute("selected", "true"); 
	} 
	var option_value = document.createTextNode('Female'); 
	option.appendChild(option_value); 
	field.appendChild(option); 
 break;

 case 'US Citizen':

	var option = document.createElement('option'); 
	option.setAttribute('value', '0'); 
	if ('0' == value) { 
	option.setAttribute("selected", "true"); 
	} 
	var option_value = document.createTextNode('No'); 
	option.appendChild(option_value); 
	field.appendChild(option); 
	var option = document.createElement('option'); 
	option.setAttribute('value', '1'); 
	if ('1' == value) { 
	option.setAttribute("selected", "true"); 
	} 
	var option_value = document.createTextNode('Yes'); 
	option.appendChild(option_value); 
	field.appendChild(option); 
 break;

 case 'Position':

	var option = document.createElement('option'); 
	option.setAttribute('value', '0'); 
	if ('0' == value) { 
	option.setAttribute("selected", "true"); 
	} 
	var option_value = document.createTextNode('Not Staff'); 
	option.appendChild(option_value); 
	field.appendChild(option); 
	var option = document.createElement('option'); 
	option.setAttribute('value', '1'); 
	if ('1' == value) { 
	option.setAttribute("selected", "true"); 
	} 
	var option_value = document.createTextNode('Staff'); 
	option.appendChild(option_value); 
	field.appendChild(option); 
 break;

 case 'Marital Status':

	var option = document.createElement('option'); 
	option.setAttribute('value', 'M'); 
	if ('M' == value) { 
	option.setAttribute("selected", "true"); 
	} 
	var option_value = document.createTextNode('Married'); 
	option.appendChild(option_value); 
	field.appendChild(option); 
	var option = document.createElement('option'); 
	option.setAttribute('value', 'S'); 
	if ('S' == value) { 
	option.setAttribute("selected", "true"); 
	} 
	var option_value = document.createTextNode('Single'); 
	option.appendChild(option_value); 
	field.appendChild(option); 
	var option = document.createElement('option'); 
	option.setAttribute('value', 'D'); 
	if ('D' == value) { 
	option.setAttribute("selected", "true"); 
	} 
	var option_value = document.createTextNode('Divorced'); 
	option.appendChild(option_value); 
	field.appendChild(option); 
	var option = document.createElement('option'); 
	option.setAttribute('value', 'P'); 
	if ('P' == value) { 
	option.setAttribute("selected", "true"); 
	} 
	var option_value = document.createTextNode('Seperated'); 
	option.appendChild(option_value); 
	field.appendChild(option); 
	var option = document.createElement('option'); 
	option.setAttribute('value', 'W'); 
	if ('W' == value) { 
	option.setAttribute("selected", "true"); 
	} 
	var option_value = document.createTextNode('Widowed'); 
	option.appendChild(option_value); 
	field.appendChild(option); 
 break;

 case 'Status':

  var option = document.createElement('option'); 
  option.setAttribute('value', 'started'); 
  if ('started' == value) { 
    option.setAttribute("selected", "true"); 
  } 
  var option_value = document.createTextNode('Applicant'); 
  option.appendChild(option_value); 
  field.appendChild(option); 
  
  var option = document.createElement('option'); 
  option.setAttribute('value', 'submitted'); 
  if ('submitted' == value) { 
    option.setAttribute("selected", "true"); 
  } 
  var option_value = document.createTextNode('Submitted'); 
  option.appendChild(option_value); 
  field.appendChild(option); 
  
	var option = document.createElement('option'); 
	option.setAttribute('value', 'completed'); 
	if ('completed' == value) { 
    option.setAttribute("selected", "true"); 
	} 
	var option_value = document.createTextNode('Ready'); 
	option.appendChild(option_value); 
	field.appendChild(option); 
	
	var option = document.createElement('option'); 
	option.setAttribute('value', 'being_evaluated'); 
	if ('being_evaluated' == value) { 
    option.setAttribute("selected", "true"); 
	} 
	var option_value = document.createTextNode('Being Evaluated'); 
	option.appendChild(option_value); 
	field.appendChild(option); 
	
	var option = document.createElement('option'); 
	option.setAttribute('value', 'pre_a'); 
	if ('pre_a' == value) { 
    option.setAttribute("selected", "true"); 
	} 
	var option_value = document.createTextNode('Pre A'); 
	option.appendChild(option_value); 
	field.appendChild(option); 
	
	var option = document.createElement('option'); 
	option.setAttribute('value', 'accepted'); 
	if ('accepted' == value) { 
    option.setAttribute("selected", "true"); 
	} 
	var option_value = document.createTextNode('Accepted'); 
	option.appendChild(option_value); 
	field.appendChild(option); 
	
	var option = document.createElement('option'); 
	option.setAttribute('value', 'follow_through'); 
	if ('follow_through' == value) { 
    option.setAttribute("selected", "true"); 
	} 
	var option_value = document.createTextNode('Follow Through'); 
	option.appendChild(option_value); 
	field.appendChild(option); 
	
	var option = document.createElement('option'); 
	option.setAttribute('value', 'placed'); 
	if ('placed' == value) { 
    option.setAttribute("selected", "true"); 
	} 
	var option_value = document.createTextNode('Placed'); 
	option.appendChild(option_value); 
	field.appendChild(option); 
	
	var option = document.createElement('option'); 
	option.setAttribute('value', 'on_assignment'); 
	if ('on_assignment' == value) { 
    option.setAttribute("selected", "true"); 
	} 
	var option_value = document.createTextNode('On Assignment'); 
	option.appendChild(option_value); 
	field.appendChild(option); 
	
	var option = document.createElement('option'); 
	option.setAttribute('value', 'declined'); 
	if ('declined' == value) { 
    option.setAttribute("selected", "true"); 
	} 
	var option_value = document.createTextNode('Declined'); 
	option.appendChild(option_value); 
	field.appendChild(option); 
	
	var option = document.createElement('option'); 
	option.setAttribute('value', 'withdrawn'); 
	if ('withdrawn' == value) { 
    option.setAttribute("selected", "true"); 
	} 
	var option_value = document.createTextNode('Withdrawn'); 
	option.appendChild(option_value); 
	field.appendChild(option); 
	
	var option = document.createElement('option'); 
	option.setAttribute('value', 'alumni'); 
	if ('alumni' == value) { 
    option.setAttribute("selected", "true"); 
	} 
	var option_value = document.createTextNode('Alumni'); 
	option.appendChild(option_value); 
	field.appendChild(option); 
	
	var option = document.createElement('option'); 
	option.setAttribute('value', 're-applied'); 
	if ('re-applied' == value) { 
    option.setAttribute("selected", "true"); 
	} 
	var option_value = document.createTextNode('Re-Applied'); 
	option.appendChild(option_value); 
	field.appendChild(option); 
	
	var option = document.createElement('option'); 
	option.setAttribute('value', 'terminated'); 
	if ('terminated' == value) { 
    option.setAttribute("selected", "true"); 
	} 
	var option_value = document.createTextNode('Terminated'); 
	option.appendChild(option_value); 
	field.appendChild(option); 
 break;

 case 'Intern Type':

  var option = document.createElement('option'); 
  option.setAttribute('value', 'STINT'); 
  if ('STINT' == value) { 
  option.setAttribute("selected", "true"); 
  } 
  var option_value = document.createTextNode('STINT'); 
  option.appendChild(option_value); 
  field.appendChild(option); 
  
  var option = document.createElement('option'); 
  option.setAttribute('value', 'ICS'); 
  if ('ICS' == value) { 
  option.setAttribute("selected", "true"); 
  } 
  var option_value = document.createTextNode('ICS'); 
  option.appendChild(option_value); 
  field.appendChild(option); 
  
	var option = document.createElement('option'); 
	option.setAttribute('value', 'Internship'); 
	if ('Internship' == value) { 
	option.setAttribute("selected", "true"); 
	} 
	var option_value = document.createTextNode('Internship'); 
	option.appendChild(option_value); 
	field.appendChild(option); 
	
	var option = document.createElement('option'); 
	option.setAttribute('value', 'Affiliate'); 
	if ('Affiliate' == value) { 
	option.setAttribute("selected", "true"); 
	} 
	var option_value = document.createTextNode('Affiliate'); 
	option.appendChild(option_value); 
	field.appendChild(option); 
	
  var option = document.createElement('option'); 
  option.setAttribute('value', 'Part_Time_Field_Staff'); 
  if ('Part_Time_Field_Staff' == value) { 
  option.setAttribute("selected", "true"); 
  } 
  var option_value = document.createTextNode('Part Time Field Staff'); 
  option.appendChild(option_value); 
  field.appendChild(option); 
  
  var option = document.createElement('option'); 
  option.setAttribute('value', 'Alumni'); 
  if ('Alumni' == value) { 
  option.setAttribute("selected", "true"); 
  } 
  var option_value = document.createTextNode('Alumni'); 
  option.appendChild(option_value); 
  field.appendChild(option); 
 break;

 case 'Team Leader':

	var option = document.createElement('option'); 
	option.setAttribute('value', '0'); 
	if ('0' == value) { 
	option.setAttribute("selected", "true"); 
	} 
	var option_value = document.createTextNode('No'); 
	option.appendChild(option_value); 
	field.appendChild(option); 
	var option = document.createElement('option'); 
	option.setAttribute('value', '1'); 
	if ('1' == value) { 
	option.setAttribute("selected", "true"); 
	} 
	var option_value = document.createTextNode('Yes'); 
	option.appendChild(option_value); 
	field.appendChild(option); 
 break;

 case 'App Year':

	var option = document.createElement('option'); 
	option.setAttribute('value', '1996'); 
	if ('1996' == value) { 
	option.setAttribute("selected", "true"); 
	} 
	var option_value = document.createTextNode('1996'); 
	option.appendChild(option_value); 
	field.appendChild(option); 
	var option = document.createElement('option'); 
	option.setAttribute('value', '1997'); 
	if ('1997' == value) { 
	option.setAttribute("selected", "true"); 
	} 
	var option_value = document.createTextNode('1997'); 
	option.appendChild(option_value); 
	field.appendChild(option); 
	var option = document.createElement('option'); 
	option.setAttribute('value', '1998'); 
	if ('1998' == value) { 
	option.setAttribute("selected", "true"); 
	} 
	var option_value = document.createTextNode('1998'); 
	option.appendChild(option_value); 
	field.appendChild(option); 
	var option = document.createElement('option'); 
	option.setAttribute('value', '1999'); 
	if ('1999' == value) { 
	option.setAttribute("selected", "true"); 
	} 
	var option_value = document.createTextNode('1999'); 
	option.appendChild(option_value); 
	field.appendChild(option); 
	var option = document.createElement('option'); 
	option.setAttribute('value', '2000'); 
	if ('2000' == value) { 
	option.setAttribute("selected", "true"); 
	} 
	var option_value = document.createTextNode('2000'); 
	option.appendChild(option_value); 
	field.appendChild(option); 
	var option = document.createElement('option'); 
	option.setAttribute('value', '2001'); 
	if ('2001' == value) { 
	option.setAttribute("selected", "true"); 
	} 
	var option_value = document.createTextNode('2001'); 
	option.appendChild(option_value); 
	field.appendChild(option); 
	var option = document.createElement('option'); 
	option.setAttribute('value', '2002'); 
	if ('2002' == value) { 
	option.setAttribute("selected", "true"); 
	} 
	var option_value = document.createTextNode('2002'); 
	option.appendChild(option_value); 
	field.appendChild(option); 
	var option = document.createElement('option'); 
	option.setAttribute('value', '2003'); 
	if ('2003' == value) { 
	option.setAttribute("selected", "true"); 
	} 
	var option_value = document.createTextNode('2003'); 
	option.appendChild(option_value); 
	field.appendChild(option); 
	var option = document.createElement('option'); 
	option.setAttribute('value', '2004'); 
	if ('2004' == value) { 
	option.setAttribute("selected", "true"); 
	} 
	var option_value = document.createTextNode('2004'); 
	option.appendChild(option_value); 
	field.appendChild(option); 
	var option = document.createElement('option'); 
	option.setAttribute('value', '2005'); 
	if ('2005' == value) { 
	option.setAttribute("selected", "true"); 
	} 
	var option_value = document.createTextNode('2005'); 
	option.appendChild(option_value); 
	field.appendChild(option); 
	var option = document.createElement('option'); 
	option.setAttribute('value', '2006'); 
	if ('2006' == value) { 
	option.setAttribute("selected", "true"); 
	} 
	var option_value = document.createTextNode('2006'); 
	option.appendChild(option_value); 
	field.appendChild(option); 
 break;

 case 'Tenure':

	var option = document.createElement('option'); 
	option.setAttribute('value', 'First_Year'); 
	if ('First_Year' == value) { 
	option.setAttribute("selected", "true"); 
	} 
	var option_value = document.createTextNode('First Year'); 
	option.appendChild(option_value); 
	field.appendChild(option); 
	var option = document.createElement('option'); 
	option.setAttribute('value', 'Second_Year'); 
	if ('Second_Year' == value) { 
	option.setAttribute("selected", "true"); 
	} 
	var option_value = document.createTextNode('Second Year'); 
	option.appendChild(option_value); 
	field.appendChild(option); 
	var option = document.createElement('option'); 
	option.setAttribute('value', 'Exception'); 
	if ('Exception' == value) { 
	option.setAttribute("selected", "true"); 
	} 
	var option_value = document.createTextNode('Exception'); 
	option.appendChild(option_value); 
	field.appendChild(option); 
 break;

 case 'Region of Origin':

	var option = document.createElement('option'); 
	option.setAttribute('value', 'GL'); 
	if ('GL' == value) { 
	option.setAttribute("selected", "true"); 
	} 
	var option_value = document.createTextNode('GL'); 
	option.appendChild(option_value); 
	field.appendChild(option); 
	var option = document.createElement('option'); 
	option.setAttribute('value', 'GP'); 
	if ('GP' == value) { 
	option.setAttribute("selected", "true"); 
	} 
	var option_value = document.createTextNode('GP'); 
	option.appendChild(option_value); 
	field.appendChild(option); 
	var option = document.createElement('option'); 
	option.setAttribute('value', 'AIA'); 
	if ('AIA' == value) { 
	option.setAttribute("selected", "true"); 
	} 
	var option_value = document.createTextNode('AIA'); 
	option.appendChild(option_value); 
	field.appendChild(option); 
	var option = document.createElement('option'); 
	option.setAttribute('value', 'MA'); 
	if ('MA' == value) { 
	option.setAttribute("selected", "true"); 
	} 
	var option_value = document.createTextNode('MA'); 
	option.appendChild(option_value); 
	field.appendChild(option); 
	var option = document.createElement('option'); 
	option.setAttribute('value', 'MS'); 
	if ('MS' == value) { 
	option.setAttribute("selected", "true"); 
	} 
	var option_value = document.createTextNode('MS'); 
	option.appendChild(option_value); 
	field.appendChild(option); 
	var option = document.createElement('option'); 
	option.setAttribute('value', 'NC'); 
	if ('NC' == value) { 
	option.setAttribute("selected", "true"); 
	} 
	var option_value = document.createTextNode('NC'); 
	option.appendChild(option_value); 
	field.appendChild(option); 
	var option = document.createElement('option'); 
	option.setAttribute('value', 'NE'); 
	if ('NE' == value) { 
	option.setAttribute("selected", "true"); 
	} 
	var option_value = document.createTextNode('NE'); 
	option.appendChild(option_value); 
	field.appendChild(option); 
	var option = document.createElement('option'); 
	option.setAttribute('value', 'NW'); 
	if ('NW' == value) { 
	option.setAttribute("selected", "true"); 
	} 
	var option_value = document.createTextNode('NW'); 
	option.appendChild(option_value); 
	field.appendChild(option); 
	var option = document.createElement('option'); 
	option.setAttribute('value', 'RR'); 
	if ('RR' == value) { 
	option.setAttribute("selected", "true"); 
	} 
	var option_value = document.createTextNode('RR'); 
	option.appendChild(option_value); 
	field.appendChild(option); 
	var option = document.createElement('option'); 
	option.setAttribute('value', 'SE'); 
	if ('SE' == value) { 
	option.setAttribute("selected", "true"); 
	} 
	var option_value = document.createTextNode('SE'); 
	option.appendChild(option_value); 
	field.appendChild(option); 
	var option = document.createElement('option'); 
	option.setAttribute('value', 'SW'); 
	if ('SW' == value) { 
	option.setAttribute("selected", "true"); 
	} 
	var option_value = document.createTextNode('SW'); 
	option.appendChild(option_value); 
	field.appendChild(option); 
	var option = document.createElement('option'); 
	option.setAttribute('value', 'UM'); 
	if ('UM' == value) { 
	option.setAttribute("selected", "true"); 
	} 
	var option_value = document.createTextNode('UM'); 
	option.appendChild(option_value); 
	field.appendChild(option); 
 break;

 case 'Caring Region':

	var option = document.createElement('option'); 
	option.setAttribute('value', 'GL'); 
	if ('GL' == value) { 
	option.setAttribute("selected", "true"); 
	} 
	var option_value = document.createTextNode('GL'); 
	option.appendChild(option_value); 
	field.appendChild(option); 
	var option = document.createElement('option'); 
	option.setAttribute('value', 'GP'); 
	if ('GP' == value) { 
	option.setAttribute("selected", "true"); 
	} 
	var option_value = document.createTextNode('GP'); 
	option.appendChild(option_value); 
	field.appendChild(option); 
	var option = document.createElement('option'); 
	option.setAttribute('value', 'AIA'); 
	if ('AIA' == value) { 
	option.setAttribute("selected", "true"); 
	} 
	var option_value = document.createTextNode('AIA'); 
	option.appendChild(option_value); 
	field.appendChild(option); 
	var option = document.createElement('option'); 
	option.setAttribute('value', 'MA'); 
	if ('MA' == value) { 
	option.setAttribute("selected", "true"); 
	} 
	var option_value = document.createTextNode('MA'); 
	option.appendChild(option_value); 
	field.appendChild(option); 
	var option = document.createElement('option'); 
	option.setAttribute('value', 'MS'); 
	if ('MS' == value) { 
	option.setAttribute("selected", "true"); 
	} 
	var option_value = document.createTextNode('MS'); 
	option.appendChild(option_value); 
	field.appendChild(option); 
	var option = document.createElement('option'); 
	option.setAttribute('value', 'NC'); 
	if ('NC' == value) { 
	option.setAttribute("selected", "true"); 
	} 
	var option_value = document.createTextNode('NC'); 
	option.appendChild(option_value); 
	field.appendChild(option); 
	var option = document.createElement('option'); 
	option.setAttribute('value', 'NE'); 
	if ('NE' == value) { 
	option.setAttribute("selected", "true"); 
	} 
	var option_value = document.createTextNode('NE'); 
	option.appendChild(option_value); 
	field.appendChild(option); 
	var option = document.createElement('option'); 
	option.setAttribute('value', 'NW'); 
	if ('NW' == value) { 
	option.setAttribute("selected", "true"); 
	} 
	var option_value = document.createTextNode('NW'); 
	option.appendChild(option_value); 
	field.appendChild(option); 
	var option = document.createElement('option'); 
	option.setAttribute('value', 'RR'); 
	if ('RR' == value) { 
	option.setAttribute("selected", "true"); 
	} 
	var option_value = document.createTextNode('RR'); 
	option.appendChild(option_value); 
	field.appendChild(option); 
	var option = document.createElement('option'); 
	option.setAttribute('value', 'SE'); 
	if ('SE' == value) { 
	option.setAttribute("selected", "true"); 
	} 
	var option_value = document.createTextNode('SE'); 
	option.appendChild(option_value); 
	field.appendChild(option); 
	var option = document.createElement('option'); 
	option.setAttribute('value', 'SW'); 
	if ('SW' == value) { 
	option.setAttribute("selected", "true"); 
	} 
	var option_value = document.createTextNode('SW'); 
	option.appendChild(option_value); 
	field.appendChild(option); 
	var option = document.createElement('option'); 
	option.setAttribute('value', 'UM'); 
	if ('UM' == value) { 
	option.setAttribute("selected", "true"); 
	} 
	var option_value = document.createTextNode('UM'); 
	option.appendChild(option_value); 
	field.appendChild(option); 
 break;

 case 'Asg Year':

	var option = document.createElement('option'); 
	option.setAttribute('value', '1996-1997'); 
	if ('1996-1997' == value) { 
	option.setAttribute("selected", "true"); 
	} 
	var option_value = document.createTextNode('1996-1997'); 
	option.appendChild(option_value); 
	field.appendChild(option); 
	var option = document.createElement('option'); 
	option.setAttribute('value', '1997-1998'); 
	if ('1997-1998' == value) { 
	option.setAttribute("selected", "true"); 
	} 
	var option_value = document.createTextNode('1997-1998'); 
	option.appendChild(option_value); 
	field.appendChild(option); 
	var option = document.createElement('option'); 
	option.setAttribute('value', '1998-1999'); 
	if ('1998-1999' == value) { 
	option.setAttribute("selected", "true"); 
	} 
	var option_value = document.createTextNode('1998-1999'); 
	option.appendChild(option_value); 
	field.appendChild(option); 
	var option = document.createElement('option'); 
	option.setAttribute('value', '1999-2000'); 
	if ('1999-2000' == value) { 
	option.setAttribute("selected", "true"); 
	} 
	var option_value = document.createTextNode('1999-2000'); 
	option.appendChild(option_value); 
	field.appendChild(option); 
	var option = document.createElement('option'); 
	option.setAttribute('value', '2000-2001'); 
	if ('2000-2001' == value) { 
	option.setAttribute("selected", "true"); 
	} 
	var option_value = document.createTextNode('2000-2001'); 
	option.appendChild(option_value); 
	field.appendChild(option); 
	var option = document.createElement('option'); 
	option.setAttribute('value', '2001-2002'); 
	if ('2001-2002' == value) { 
	option.setAttribute("selected", "true"); 
	} 
	var option_value = document.createTextNode('2001-2002'); 
	option.appendChild(option_value); 
	field.appendChild(option); 
	var option = document.createElement('option'); 
	option.setAttribute('value', '2002-2003'); 
	if ('2002-2003' == value) { 
	option.setAttribute("selected", "true"); 
	} 
	var option_value = document.createTextNode('2002-2003'); 
	option.appendChild(option_value); 
	field.appendChild(option); 
	var option = document.createElement('option'); 
	option.setAttribute('value', '2003-2004'); 
	if ('2003-2004' == value) { 
	option.setAttribute("selected", "true"); 
	} 
	var option_value = document.createTextNode('2003-2004'); 
	option.appendChild(option_value); 
	field.appendChild(option); 
	var option = document.createElement('option'); 
	option.setAttribute('value', '2004-2005'); 
	if ('2004-2005' == value) { 
	option.setAttribute("selected", "true"); 
	} 
	var option_value = document.createTextNode('2004-2005'); 
	option.appendChild(option_value); 
	field.appendChild(option); 
	var option = document.createElement('option'); 
	option.setAttribute('value', '2005-2006'); 
	if ('2005-2006' == value) { 
	option.setAttribute("selected", "true"); 
	} 
	var option_value = document.createTextNode('2005-2006'); 
	option.appendChild(option_value); 
	field.appendChild(option); 
	var option = document.createElement('option'); 
	option.setAttribute('value', '2006-2007'); 
	if ('2006-2007' == value) { 
	option.setAttribute("selected", "true"); 
	} 
	var option_value = document.createTextNode('2006-2007'); 
	option.appendChild(option_value); 
	field.appendChild(option); 
 break;

 case 'Strategy':

	var option = document.createElement('option'); 
	option.setAttribute('value', 'Catalytic'); 
	if ('Catalytic' == value) { 
	option.setAttribute("selected", "true"); 
	} 
	var option_value = document.createTextNode('Catalytic'); 
	option.appendChild(option_value); 
	field.appendChild(option); 
	var option = document.createElement('option'); 
	option.setAttribute('value', 'ESM'); 
	if ('ESM' == value) { 
	option.setAttribute("selected", "true"); 
	} 
	var option_value = document.createTextNode('ESM'); 
	option.appendChild(option_value); 
	field.appendChild(option); 
	var option = document.createElement('option'); 
	option.setAttribute('value', 'OPS'); 
	if ('OPS' == value) { 
	option.setAttribute("selected", "true"); 
	} 
	var option_value = document.createTextNode('OPS'); 
	option.appendChild(option_value); 
	field.appendChild(option); 
	var option = document.createElement('option'); 
	option.setAttribute('value', 'Staffed'); 
	if ('Staffed' == value) { 
	option.setAttribute("selected", "true"); 
	} 
	var option_value = document.createTextNode('Staffed'); 
	option.appendChild(option_value); 
	field.appendChild(option); 
	var option = document.createElement('option'); 
	option.setAttribute('value', 'WSN'); 
	if ('WSN' == value) { 
	option.setAttribute("selected", "true"); 
	} 
	var option_value = document.createTextNode('WSN'); 
	option.appendChild(option_value); 
	field.appendChild(option); 
 break;

 case 'Needs Debt Check':

	var option = document.createElement('option'); 
	option.setAttribute('value', '0'); 
	if ('0' == value) { 
	option.setAttribute("selected", "true"); 
	} 
	var option_value = document.createTextNode('No'); 
	option.appendChild(option_value); 
	field.appendChild(option); 
	var option = document.createElement('option'); 
	option.setAttribute('value', '1'); 
	if ('1' == value) { 
	option.setAttribute("selected", "true"); 
	} 
	var option_value = document.createTextNode('Yes'); 
	option.appendChild(option_value); 
	field.appendChild(option); 
 break;

 case 'Future Plans':

	var option = document.createElement('option'); 
	option.setAttribute('value', 'No_Info'); 
	if ('No_Info' == value) { 
	option.setAttribute("selected", "true"); 
	} 
	var option_value = document.createTextNode('No Info'); 
	option.appendChild(option_value); 
	field.appendChild(option); 
	var option = document.createElement('option'); 
	option.setAttribute('value', 'Staff'); 
	if ('Staff' == value) { 
	option.setAttribute("selected", "true"); 
	} 
	var option_value = document.createTextNode('Staff'); 
	option.appendChild(option_value); 
	field.appendChild(option); 
	var option = document.createElement('option'); 
	option.setAttribute('value', 'Second_Year'); 
	if ('Second_Year' == value) { 
	option.setAttribute("selected", "true"); 
	} 
	var option_value = document.createTextNode('Second Year'); 
	option.appendChild(option_value); 
	field.appendChild(option); 
	var option = document.createElement('option'); 
	option.setAttribute('value', 'Terminate'); 
	if ('Terminate' == value) { 
	option.setAttribute("selected", "true"); 
	} 
	var option_value = document.createTextNode('Terminate'); 
	option.appendChild(option_value); 
	field.appendChild(option); 
	var option = document.createElement('option'); 
	option.setAttribute('value', 'Affiliate'); 
	if ('Affiliate' == value) { 
	option.setAttribute("selected", "true"); 
	} 
	var option_value = document.createTextNode('Affiliate'); 
	option.appendChild(option_value); 
	field.appendChild(option); 
 break;

 case 'Eval Doc Type':

	var option = document.createElement('option'); 
	option.setAttribute('value', 'Email'); 
	if ('Email' == value) { 
	option.setAttribute("selected", "true"); 
	} 
	var option_value = document.createTextNode('Email'); 
	option.appendChild(option_value); 
	field.appendChild(option); 
	var option = document.createElement('option'); 
	option.setAttribute('value', 'Paper'); 
	if ('Paper' == value) { 
	option.setAttribute("selected", "true"); 
	} 
	var option_value = document.createTextNode('Paper'); 
	option.appendChild(option_value); 
	field.appendChild(option); 
 break;

 case 'Debt Follow Up':

	var option = document.createElement('option'); 
	option.setAttribute('value', 'Needs_Follow_Up'); 
	if ('Needs_Follow_Up' == value) { 
	option.setAttribute("selected", "true"); 
	} 
	var option_value = document.createTextNode('Needs Follow Up'); 
	option.appendChild(option_value); 
	field.appendChild(option); 
	var option = document.createElement('option'); 
	option.setAttribute('value', 'No_Debt'); 
	if ('No_Debt' == value) { 
	option.setAttribute("selected", "true"); 
	} 
	var option_value = document.createTextNode('No Debt'); 
	option.appendChild(option_value); 
	field.appendChild(option); 
	var option = document.createElement('option'); 
	option.setAttribute('value', 'Cleared'); 
	if ('Cleared' == value) { 
	option.setAttribute("selected", "true"); 
	} 
	var option_value = document.createTextNode('Cleared'); 
	option.appendChild(option_value); 
	field.appendChild(option); 
 break;
 }
}