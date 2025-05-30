package com.learn.mycart.helper;

public class Helper {
    public static String get10Words(String desc)
    {
        String[] strs = desc.split(" ");
        
        if(strs.length>10)
        {
            String res="";
            for(int i=0;i<10;i++)
            {
                res=res+strs[i]+" ";
            }
            return (res+"...");
        }else
        {
            
            return (desc+"...");
        }
        
    }
    
    public static String escapeJavaScript(String str) {
        if (str == null) {
            return "";
        }
        return str.replace("\\", "\\\\")
                 .replace("'", "\\'")
                 .replace("\"", "\\\"")
                 .replace("\r", "\\r")
                 .replace("\n", "\\n")
                 .replace("\t", "\\t");
    }
}
