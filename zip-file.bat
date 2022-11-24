@ECHO OFF

SET Source=D:\task\copy-script\Source\file*

SET Desination=D:\task\pipeline_using_bat\test1.zip
SET zipUtility="C:\Program Files\7-Zip\7z.exe"

%zipUtility% a "%Desination%" "%Source%"




