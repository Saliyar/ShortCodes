function strr= cleanString(strr,Vec2Remove)
for i= 1:length(Vec2Remove)
   strr = strrep(strr ,Vec2Remove{i},'');
end

end