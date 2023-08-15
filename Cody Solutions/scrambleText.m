function sOut = scrambleText(sIn)
sOut = '';
i_spaces = (sIn==' ');
prev_space = 0;
  for i=1:length(i_spaces)
      if i==length(i_spaces)
          if sIn(i) == '.'
              word = sIn(prev_space+1:end-1);
              punctuation = '.';
          else
              word = sIn(prev_space+1:end);
              punctuation = '';
          end
              new_word = ''; 
              if length(word) <= 3
              new_word = word;
          
              else
              randomize_i = randperm(length(word)-2);
              word_scramble = '';
              
              for i_new = 1:length(randomize_i)
                  word_scramble(end+1) = word(randomize_i(i_new)+1);
              end
              new_word = cat(2,word(1),word_scramble,word(end));
              
              sOut=cat(2,sOut,new_word,punctuation);
          
              end
              
      elseif i_spaces(i) == 1
          word = sIn(prev_space+1:i-1);
          prev_space = i;
          new_word = '';
          if length(word) <= 3
              new_word = word;
              sOut=cat(2,sOut,new_word,' ');
          else
              randomize_i = randperm(length(word)-2);
              word_scramble = '';
              for i_new = 1:length(randomize_i)
                  word_scramble(end+1) = word(randomize_i(i_new)+1);
              end
              new_word = cat(2,word(1),word_scramble,word(end));
              sOut=cat(2,sOut,new_word,' ');
          end         
      end
  end
end