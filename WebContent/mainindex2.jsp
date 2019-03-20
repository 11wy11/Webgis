 create or replace function savepicture(xpicture varchar,xpicname varchar)
    returns int as $$
begin
insert in temp_picture(picture,picturename) values(cast(xpicture as bytea),xpicname);
return 1;
end $$ language plpgsql;
部分代码处理
             String picture= null;
            byte[] data = null;
            File file = new File(path);
            FileInputStream  input = null;
            try {
                input = new FileInputStream (file);
                ByteArrayOutputStream output = new ByteArrayOutputStream();
                byte[] buf = new byte[(int)file.length()];
                int byteread = 0;
                try {
                    while((byteread = input.read(buf))!=-1){
                        output.write(buf, 0, byteread);
                    }
                data = output.toByteArray();
                picture= binarys(data);
                output.close();
                input.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            } catch (FileNotFoundException e) {
                e.printStackTrace();
            }catch (IOException e1) {
                e1.printStackTrace();
            }

public static String binarys(byte[] bytes){
        StringBuffer sbf = new StringBuffer("");
        for (int i = 0; i < bytes.length; i++) {
            String tmp = Integer.toOctalString(bytes[i] & 0xff);
            switch (tmp.length()) {
            case 1:
                tmp = "\\00" +tmp;
                break;
            case 2:
                tmp = "\\0" +tmp;
                break;
            case 3:
                tmp = "\\" +tmp;
                break;
            default:
                break;
            }
            sbf.append(tmp);
        }
        
        return sbf.toString();
    }