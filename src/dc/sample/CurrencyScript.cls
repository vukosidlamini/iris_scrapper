Class dc.sample.CurrentData Extends %Persistent
{

Property Currency As %String(MAXLEN = 50) [ Required ];
Property UnitFromZAR As %Decimal(MAXVAL = 99999999.99, MINVAL = 0) [ Required ];
Property UnitToZAR As %Decimal(MAXVAL = 99999999.99, MINVAL = 0) [ Required ];

ClassMethod CreateRecord(ByRef id As %Integer) As %Status
{
    set sc=$$$OK
    Try {
        write "from Python       : "
        set builtins = ##class(%SYS.Python).Import("builtins")
        set id = builtins.list()
        set sc = ..CreateRecordPython(id)
        write id."__getitem__"(0)," successfully created with CreateRecordPython",!
        write "from ObjectScript : "
        set sc = ..CreateRecordObjesctScript(.id)   
        write id," successfully created with CreateRecordObjesctScript",!
    }
    Catch ex {
        Set tSC=ex.AsStatus()
    }
  
    return sc
}
ClassMethod CreateRecordObjesctScript(pCurrency As %String, pUnitFromZAR As %Decimal, pUnitToZAR As %Decimal) As %Status
{
    set sc=$$$OK
    set objPC=..%New()
    set objPC.Currency = pCurrency
    set objPC.UnitFromZAR = pUnitFromZAR
    set objPC.UnitToZAR = pUnitToZAR

    set sc=objPC.%Save()
    set id=objPC.%Id()
    return sc
}

ClassMethod CreateRecordPython() As %Status [ Language = python ]
{
import iris
import csv
import os
import requests
from bs4 import BeautifulSoup
from datetime import datetime
url = "https://www.x-rates.com/table/?from=ZAR&amount=1"
res = requests.get(url)
htmlData = res.content
parsedData = BeautifulSoup(htmlData, "html.parser")
currency_table = parsedData.find('table', class_="ratesTable").find(
    'td', string='US Dollar').parent.find_all('td')
rate_timestamp = parsedData.find('span', class_='ratesTimestamp').text
_rate_timestamp = datetime.strptime(
    rate_timestamp, "%b %d, %Y %H:%M %Z").date()
sc = None
if datetime.now().date() == _rate_timestamp:
    headings = ['Currency', 'UnitToZAR', 'UnitFromZAR']
    rows = []
    for children in currency_table:
       print(children)
       print(rows)
       rows.append(children.text)
    #construct the data
    data =[headings, rows]
    current_working_directory = os.getcwd()
    print(current_working_directory)
    directory_path =  '/home/irisowner/csv_output/output_report'
    os.makedirs(directory_path, exist_ok=True)
    file_path = os.path.join(directory_path, f'output_report.csv_{str(_rate_timestamp)}')
    with open(file_path, 'w', newline='') as file:
        print('create csv file')
        writer = csv.writer(file)
        writer.writerows(data)

    objPC=iris.cls('dc.sample.CurrentData')._New()
    objPC.Currency=rows[0]
    objPC.UnitToZAR=rows[1]
    objPC.UnitFromZAR=rows[2]
    sc=objPC._Save()
return sc
}

ClassMethod ReadProperty(id As %Integer) As %Status
{

    Set sc = $$$OK
    Try {
        write "from Python       : "
        set sc = ..ReadPropertyPython(id)   
    }
    Catch ex {
        Set tSC=ex.AsStatus()
    }
    Return sc
}



ClassMethod ReadPropertyPython(id As %Integer) As %Status [ Language = python ]
{
import iris
sc=1
if iris.cls('dc.sample.CurrentData')._ExistsId(id):
    obj=iris.cls('dc.sample.CurrentData')._OpenId(id)
    print(obj.Currency)
    print(obj.UnitFromZAR)
    print(obj.UnitToZAR)
else:
 print(id,'is not an existing ID in dc.sample.CurrentData')
return sc
}


}
