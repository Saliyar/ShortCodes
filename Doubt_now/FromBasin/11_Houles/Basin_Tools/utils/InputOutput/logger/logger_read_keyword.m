function line = logger_read_keyword(fid, keyword)

line = 0;
while feof (fid) == 0
    tline = fgets(fid);
    line = line + 1;
    test  = strmatch(keyword, tline);
    if test
        return
    end
end
