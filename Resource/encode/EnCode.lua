require"lfs"
function findindir (path, wefind, r_table, intofolder)
    for file in lfs.dir(path) do
        if file ~= "." and file ~= ".." then
            local f = path..'/'..file
            --print ("/t "..f)
            if string.find(f, wefind) ~= nil then
                --print("/t "..f)
                table.insert(r_table, f)
            end
            local attr = lfs.attributes (f)
            assert (type(attr) == "table")
            if attr.mode == "directory" and intofolder then
                findindir (f, wefind, r_table, intofolder)
            else
                --for name, value in pairs(attr) do
                --    print (name, value)
                --end
            end
        end
    end
end
-------------------------------------

--�����ַ�
bKey = "4A4C"

function EnCode(fileName)
	print(fileName)

	file = assert( io.open(fileName,"rb") )

	head = file:read(4)

	print(head)

	file:seek("set", 4)

	data = file:read("*all")

	print("----"..data)

	io.close( file )

	--�����ļ���ǰ��4���ֽڽ����滻
	file2 = assert( io.open(fileName,"wb") )

	file2:write(bKey..data)

	io.close( file2 )

end

function DeCode(fileName, fileType)
    print(fileType)
	file = io.open(fileName,"rb")

	headDel = file:read(4)
	print(headDel)
	--����ǰ����ܵ�4���ֽ�
	file:seek("set", 4)
	data = file:read("*all")

	print(data)

	io.close( file )

	file3 = io.open(fileName,"wb")

	if fileType == "PNG" then
	print("PNG")
	local head = "�PNG"
	file3:write(head..data)
	io.close( file3 )

	elseif fileType == "JPG" then
	print("JPG")
	--�����ƶ�һ����ȷJPG�ļ���ȡͷ���ڽ��ܣ���������ֱ����C++���������ڲ���ʹ��
	local file2 = io.open("e:/3.jpg","rb")
	local head = file2:read(4)
	print(head)
	io.close( file2 )

	file3:write(head..data)
	io.close( file3 )

	end


end


local input_table = {}
findindir("E:\\Resource", "%.jpg", input_table, true)--�ݹ�������е�JPG��Դ�ļ���PNG��Դ�ļ�

i = 1
while input_table[i]~=nil do
   print("encode   "..input_table[i])
    DeCode(input_table[i],"JPG")
   --EnCode(input_table[i])
   i = i+1
end

input_table = {}
i = 1
findindir("E:\\Resource", "%.png", input_table, true)

while input_table[i]~=nil do
   print("encode   "..input_table[i])
   DeCode(input_table[i],"PNG")
   --EnCode(input_table[i])
   i = i+1
end


