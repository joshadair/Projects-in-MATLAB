function names_out = clean_list(names_in)
names_out={names_in{1}};
names_lower={lower(names_in{1})};
  for i1=2:numel(names_in)
      a=names_in{i1};
      temp=lower(a);
      if ~any(contains(names_lower,temp))
          names_out{end+1}=a;
          names_lower{end+1}=temp;
      end
  end
  
end
