function pass_part_fail=aaa___text2im___test(varargin)
%Compare the output to pre-computed hashes to test exact equivalence
%
%Pass:    passes all tests
%Partial: [no partial passing condition]
%Fail:    fails any test
pass_part_fail='pass';

if nargin==0,RunTestHeadless=false;else,RunTestHeadless=true;end
%note: triggers the text2im_load_database function internal to text2im

checkpoint('aaa___text2im___test','ifversion___skip_test')
if RunTestHeadless || ifversion___skip_test
    button='No';
else
    button = questdlg('Test GUI?','','Yes','No','Yes');
end
if strcmp(button,'Yes')
    purge=true;
    ignore=text2im_load_database('ascii',purge,'trigger GUI'); %#ok<NASGU>
else
    purge=true;
    ignore=text2im_load_database('ascii',purge); %#ok<NASGU>
end

fail = 0;ME=[];TestIndex = 0;

% Test general consistency
TestIndex = TestIndex+1;
try if ~fail,test01,end
catch ME;if isempty(ME),ME = lasterror;end,fail = TestIndex;end %#ok<LERR>

% Now test UTF-8 handling (only really relevant on Octave).
TestIndex = TestIndex+1;
try if ~fail,test02,end
catch ME;if isempty(ME),ME = lasterror;end,fail = TestIndex;end %#ok<LERR>

% Test if a multiline input works.
TestIndex = TestIndex+1;
try if ~fail,test03,end
catch ME;if isempty(ME),ME = lasterror;end,fail = TestIndex;end %#ok<LERR>

% Test rich text conversion.
TestIndex = TestIndex+1;
try if ~fail,test04,end
catch ME;if isempty(ME),ME = lasterror;end,fail = TestIndex;end %#ok<LERR>

SelfTestFailMessage = '';
% Run the self-validator function(s).
SelfTestFailMessage = [SelfTestFailMessage SelfTest__error_];
SelfTestFailMessage = [SelfTestFailMessage SelfTest__PatternReplace];
SelfTestFailMessage = [SelfTestFailMessage SelfTest__regexp_outkeys];
checkpoint('read');
if ~isempty(SelfTestFailMessage) || fail>0
    if nargout==1
        pass_part_fail='fail';
    else
        if ~isempty(SelfTestFailMessage)
            error('Self-validator functions returned these error(s):\n%s',SelfTestFailMessage)
        else
            error('test %d failed with this message:\n%s',fail,ME.message)
        end
    end
end
disp(['tester function ' mfilename ' finished '])
if nargout==0,clear,end
end
function test01
str='The quick brown fox jumped over the lazy dog.';
font_list={...
    'cmu_typewriter_text','F359E6752670A03B4B80BF9E2FD2FBD9';...
    'cmu_concrete','E93A0D0F023D32DBF3D7A2555D78B825';...
    'ascii','A9D394C668F29F293477DBBDCC0E7877';...
    'droid_sans_mono','262172A9734A48009EAB2E7ACB8D20BD';...
    'ibm_plex_mono','353FA726802F4E99A76BB8FCFC50ECCE';...
    'liberation_mono','2AE74A75F3F8A93B7021E44F9B96C50F';...
    'monoid','F96E8394C5AFB2412A123D3D05E7DA0E'};
N=size(font_list,1);
for n=1:N
    I=text2im(str,font_list{n,1});
    checkpoint('aaa___text2im___test','ComputeNonCryptHash')
    hash=ComputeNonCryptHash(I,128,'-v2');
    if ~strcmp(hash,font_list{n,2})
        error('hash of generated image didn''t match hash in library')
    end
end
end
function test02
blank=[9 32 160 5760 8192:8202 8239 8287];
newlines=[10 11 12 13 133 8232 8233];
zerowidth=[173 8203 8204 8205 8288];
checkpoint('aaa___text2im___test','unicode_to_char')
str_=unicode_to_char([blank newlines zerowidth]);
try
    checkpoint('aaa___text2im___test','ComputeNonCryptHash')
    I=text2im(str_);
    hash=ComputeNonCryptHash(I,128,'-v2');
    if ~strcmp(hash,'5A61900CFEC38271667B13E7C768D652'),error('hash comparison failed');end
catch
    error('UTF-8 handling failed')
end
end
function test03
str='The quick brown fox jumped over the lazy dog.';
try
    checkpoint('aaa___text2im___test','ComputeNonCryptHash')
    I=text2im({'This will be two lines of the default font.',str});
    hash=ComputeNonCryptHash(I,128,'-v2');
    if ~strcmp(hash,'0EAAFD74F57FE4735F318D4B9A079656'),error('hash comparison failed');end
catch
    error('multiline failed')
end
end
function test04
str = [8304 185 178 179 8308 8309 8310 8311 8312 8313]; % 0-9 in superscript
for n=1:numel(str)
    checkpoint('aaa___text2im___test','ch_r')
    if ~isequal(...
            text2im(ch_r(str(n) ),'font','ascii') ,...
            text2im(ch_r('0'+n-1),'font','ascii') )
        error('rich text conversion failed')
    end
end
end
function str=ASCII_decode(str)
% Convert '&#___;' back to char (including the hexadecimal '&#x___;').

if isa(str,'char'),str = reshape(str,1,[]);end

w = warning('off','REGEXP:multibyteCharacters');
if isempty(regexp(str,'&#\d+;','once')) && isempty(regexp(str,'&#x[0-9A-Fa-f]+;','once'))
    % Nothing to convert, no need to spend time on a split and merge.
    warning(w); % Restore warning state.
    return
end

% First some housekeeping: convert hex encoding to decimal.
if ~isempty(regexp(str,'&#x[0-9A-Fa-f]+;','once'))
    checkpoint('ASCII_decode','regexp_outkeys')
    symbols = regexp_outkeys(str,'&#x[0-9A-Fa-f]+;','match');
    symbols = unique(symbols);
    for n=1:numel(symbols)
        str = strrep(...
            str,...
            symbols{n},...
            sprintf('&#%d;',hex2dec(symbols{n}(4:(end-1)))));
    end
end

% Make sure each symbol is in its own cell. That way we can use ismember to look up all occurences
% at once and do batch replacement.
checkpoint('ASCII_decode','regexp_outkeys')
[match,split] = regexp_outkeys(str,'&#\d+;','match','split');
symbols = unique(match);
match{end+1} = ''; % Make sure the allignment is correct.
txt = [split;match];txt = txt(:).'; % Merge and linearize.
for n=1:numel(symbols)
    % Convert each &#___; to the Unicode number and then to char.
    u = str2double(symbols{n}(3:(end-1)));
    checkpoint('ASCII_decode','CharIsUTF8','unicode_to_UTF8','unicode_to_UTF16')
    if CharIsUTF8,c = unicode_to_UTF8( u);
    else         ,c = unicode_to_UTF16(u);
    end
    txt(ismember(txt,symbols{n})) = {char(c)};
end
% Merge to a single char vector and return.
str = cell2mat(txt);
warning(w); % Restore warning state.
end
function str=ASCII_encode(str)
% This function will convert all rich text symbols (U>127) to '&#___;'. If there are already such
% tokens in the text, the ampersand will be encoded with '&#38;'.
w = warning('off','REGEXP:multibyteCharacters'); % Suppress warning and capture warn state.
NoHTMLSymbols = isempty(regexp(str,'&#\d+;','once'));
warning(w);% Restore warn state.
if NoHTMLSymbols && ~any(str>127)
    % No special characters and no &#___; exist in the text already.
    return
end

checkpoint('ASCII_encode','CharIsUTF8','UTF8_to_unicode','UTF16_to_unicode')
if CharIsUTF8,U =  UTF8_to_unicode(str);
else         ,U = UTF16_to_unicode(str);
end

if NoHTMLSymbols,symbol = uint32([]);else,symbol = uint32('&');end
U_cell = num2cell(U);
for u_elem=[symbol,unique(U(U>127))]
    % Convert to uint32 to keep the data type the same for each cell.
    % The casting to double is required for older releases of Matlab.
    L = ismember(U,u_elem);
    U_cell(L) = {uint32(sprintf('&#%d;',double(u_elem)))};
end
str = char(horzcat(U_cell{:}));
end
function out=bsxfun_plus(in1,in2)
%Implicit expansion for plus(), but without any input validation.
persistent type
if isempty(type)
    checkpoint('bsxfun_plus','hasFeature')
    type = ...
        double(hasFeature('ImplicitExpansion')) + ...
        double(hasFeature('bsxfun'));
end
if type==2
    % Implicit expansion is available.
    out = in1+in2;
elseif type==1
    % Implicit expansion is only available with bsxfun.
    out = bsxfun(@plus,in1,in2);
else
    % No implicit expansion, expand explicitly.
    sz1 = size(in1);
    sz2 = size(in2);
    if min([sz1 sz2])==0
        % Construct an empty array of the correct size.
        sz1(sz1==0) = inf;sz2(sz2==0) = inf;
        sz = max(sz1,sz2);
        sz(isinf(sz)) = 0;
        % Create an array and cast it to the correct type.
        out = feval(str2func(class(in1)),zeros(sz));
        return
    end
    in1 = repmat(in1,max(1,sz2./sz1));
    in2 = repmat(in2,max(1,sz1./sz2));
    out = in1+in2;
end
end
function out=ch_r(in)
checkpoint('ch_r','unicode_to_char','CharIsUTF8')
out = unicode_to_char(in,~CharIsUTF8);
end
function c=char2cellstr(str,LineEnding)
% Split char or uint32 vector to cell (1 cell element per line). Default splits are for CRLF/CR/LF.
% The input data type is preserved.
%
% Since the largest valid Unicode codepoint is 0x10FFFF (i.e. 21 bits), all values will fit in an
% int32 as well. This is used internally to deal with different newline conventions.
%
% The second input is a cellstr containing patterns that will be considered as newline encodings.
% This will not be checked for any overlap and will be processed sequentially.

returnChar = isa(str,'char');
str = int32(str); % Convert to signed, this should not crop any valid Unicode codepoints.

if nargin<2
    % Replace CRLF, CR, and LF with -10 (in that order). That makes sure that all valid encodings
    % of newlines are replaced with the same value. This should even handle most cases of files
    % that mix the different styles, even though such mixing should never occur in a properly
    % encoded file. This considers LFCR as two line endings.
    if any(str==13)
        checkpoint('char2cellstr','PatternReplace')
        str = PatternReplace(str,int32([13 10]),int32(-10));
        str(str==13) = -10;
    end
    str(str==10) = -10;
else
    for n=1:numel(LineEnding)
        checkpoint('char2cellstr','PatternReplace')
        str = PatternReplace(str,int32(LineEnding{n}),int32(-10));
    end
end

% Split over newlines.
newlineidx = [0 find(str==-10) numel(str)+1];
c=cell(numel(newlineidx)-1,1);
for n=1:numel(c)
    s1 = (newlineidx(n  )+1);
    s2 = (newlineidx(n+1)-1);
    c{n} = str(s1:s2);
end

% Return to the original data type.
if returnChar
    for n=1:numel(c),c{n} =   char(c{n});end
else
    for n=1:numel(c),c{n} = uint32(c{n});end
end
end
function tf=CharIsUTF8
% This provides a single place to determine if the runtime uses UTF-8 or UTF-16 to encode chars.
% The advantage is that there is only 1 function that needs to change if and when Octave switches
% to UTF-16. This is unlikely, but not impossible.
persistent persistent_tf
if isempty(persistent_tf)
    checkpoint('CharIsUTF8','ifversion')
    if ifversion('<',0,'Octave','>',0)
        % Test if Octave has switched to UTF-16 by looking if the Euro symbol is losslessly encoded
        % with char.
        % Because we will immediately reset it, setting the state for all warnings to off is fine.
        w = struct('w',warning('off','all'));[w.msg,w.ID] = lastwarn;
        persistent_tf = ~isequal(8364,double(char(8364)));
        warning(w.w);lastwarn(w.msg,w.ID); % Reset warning state.
    else
        persistent_tf = false;
    end
end
tf = persistent_tf;
end
function[v000,varargout]=ComputeNonCryptHash(v001,varargin),if nargin<1,...
error('HJW:ComputeNonCryptHash:InputIncorrect','At least 1 input required.'),end,if nargout>=2,...
varargout=cell(nargout-1,1);end,if nargin==2&&isa(varargin{1},...
'struct')&&varargin{1}.SkipInputParse,v002=varargin{1};else,[v003,v002,v004]=...
ComputeNonCryptHash_f10(varargin{:});if v003,v002=ComputeNonCryptHash_f13(v002);if nargout>=2,...
v002.SkipInputParse=true;varargout{1}=v002;end,else,ComputeNonCryptHash_f15(v002.print_to,v004),...
end,end,v005=v002.HashLength;v006=v002.Version;try v004=[];v001=ComputeNonCryptHash_f04(v001,...
v002);catch v004;if isempty(v004),v004=lasterror;end,if strcmp(v004.identifier,'MATLAB:nomem'),...
ComputeNonCryptHash_f15(v002.print_to,v004),else,if isfield(v002,'debug')&&v002.debug,v007=...
sprintf('\n[original error: %s %s]',v004.identifier,v004.message);else,v007='';end,...
ComputeNonCryptHash_f15(v002.print_to,'HJW:ComputeNonCryptHash:UnwindFailed',...
['The nested input contains an unsupported data type.' v007]),end,end,if mod(numel(v001),...
v005/16),v008=uint16(1:v005/16).';v008(1:mod(numel(v001),v005/16))=[];v001=[v001;v008];end,if ...
v006==1,v001=ComputeNonCryptHash_f03(v001);v001=ComputeNonCryptHash_f21(v001);v001=xor(v001,...
reshape(v001,[],16).');else,v001=ComputeNonCryptHash_f03(v001);v001=...
ComputeNonCryptHash_f21(v001);v001=ComputeNonCryptHash_f17(v001);end,v001=mod(sum(reshape(v001,...
v005,[]),2),2);v001=ComputeNonCryptHash_f02(v001);if v002.isSaltCall,v000=v001;return,end,v001=...
ComputeNonCryptHash_f18(v001,v002);v000=ComputeNonCryptHash_f01(v001);v000=reshape(v000.',1,[]);
end
function v000=ComputeNonCryptHash_f00(v001),persistent v002,if isempty(v002),v002=struct('HG2',...
ComputeNonCryptHash_f23('>=','R2014b','Octave','<',0),'ImplicitExpansion',...
ComputeNonCryptHash_f23('>=','R2016b','Octave','>',0),'bsxfun',ComputeNonCryptHash_f23('>=',...
'R2007a','Octave','>',0),'IntegerArithmetic',ComputeNonCryptHash_f23('>=','R2010b','Octave','>',...
0),'String',ComputeNonCryptHash_f23('>=','R2016b','Octave','<',0),'HTTPS_support',...
ComputeNonCryptHash_f23('>',0,'Octave','<',0),'json',ComputeNonCryptHash_f23('>=','R2016b',...
'Octave','>=',7),'strtrim',ComputeNonCryptHash_f23('>=',7,'Octave','>=',0),'accumarray',...
ComputeNonCryptHash_f23('>=',7,'Octave','>=',0));v002.CharIsUTF8=ComputeNonCryptHash_f09;end,...
v000=v002.(v001);end
function v000=ComputeNonCryptHash_f01(v001),persistent v002,if isempty(v002),v002=...
upper(dec2hex(0:(-1+2^16),4));end,v001=double(v001)+1;v000=v002(v001,:);end
function v000=ComputeNonCryptHash_f02(v000),persistent v001,if isempty(v001),v001=...
ComputeNonCryptHash_f00('ImplicitExpansion');end,if mod(numel(v000),16),...
v000(16*ceil(numel(v000)/16))=0;end,v002=uint16(2.^(15:-1:0))';v000=uint16(reshape(v000,16,[]));
if v001,v000=v000.*v002;else,v000=double(v000).*repmat(double(v002),[1 size(v000,2)]);v000=...
uint16(v000);end,v000=uint16(sum(v000,1)).';end
function v000=ComputeNonCryptHash_f03(v000),v001=65537;v002=479001600;v000=...
uint16(mod(double(v000) * v002,v001));end
function v000=ComputeNonCryptHash_f04(v000,v001),if isa(v000,'uint16'),v002='uint16';v003=...
size(v000).';v000=reshape(v000,[],1);v000=[v000;uint16(v002.');uint16(mod(v003,2^16))];return,...
end,v000=ComputeNonCryptHash_f05({v000},v001);v000([end-1 end])=[];end
function v000=ComputeNonCryptHash_f05(v000,v001),v002=size(v000).';v000=v000(:);for v003=...
1:numel(v000),if numel(v000{v003})==0,v004=double(class(v000{v003})');v000{v003}=uint16([0;v004;
size(v000{v003})']);continue,end,switch class(v000{v003}),case{'double','single'},v000{v003}=...
ComputeNonCryptHash_f06(v000{v003});case'logical',v000{v003}=...
ComputeNonCryptHash_f20(v000{v003});case{'uint8','uint16','uint32','uint64','int8','int16',...
'int32','int64'},v000{v003}=ComputeNonCryptHash_f42(v000{v003},v001);case'char',v000{v003}=...
ComputeNonCryptHash_f48(v000{v003},v001);case'string',v000{v003}=...
ComputeNonCryptHash_f49(v000{v003},v001);case'cell',v000{v003}=...
ComputeNonCryptHash_f05(v000{v003},v001);case'struct',v000{v003}=...
ComputeNonCryptHash_f07(v000{v003},v001);case{'gpuArray','tall'},v000{v003}=...
ComputeNonCryptHash_f05({gather(v000{v003})},v001);otherwise,...
ComputeNonCryptHash_f15(v001.print_to,'HJW:cast_to_uint16_vector:nosupport',...
'Unsupported data type in nested variable'),end,end,v000=cell2mat(v000);v000=[v000;
uint16(mod(v002,2^16))];end
function v000=ComputeNonCryptHash_f06(v000),v001=size(v000).';v002=class(v000);v000=...
reshape(v000,size(v000,1),[]);[v003,v004]=ComputeNonCryptHash_f47(double(v000));v005=mod(v003,...
2^16);v003=v003-v005;v003=v003/2^16;v004=v004.';v006=mod(v003,2^16);v003=v003-v006;v003=...
v003/2^16;v006=v006.';v007=mod(v003,2^16);v003=v003-v007;v003=v003/2^16;v007=v007.';v008=...
mod(v003,2^16);v008=v008.';v000=[v008;v007;v006;v004];v000=uint16(v000(:));v000=[v000;
uint16(v002.');uint16(mod(v001,2^16))];end
function v000=ComputeNonCryptHash_f07(v000,v001),v002=size(v000).';v000=v000(:);v003=...
fieldnames(v000);v004=cell(2,numel(v003));for v005=1:numel(v003),v004{1,v005}=v003{v005};v004{2,...
v005}={v000.(v003{v005})};end,v000=ComputeNonCryptHash_f05(v004,v001);v000=[v000;
uint16(mod(v002,2^16))];end
function v000=ComputeNonCryptHash_f08(v001,v002),v003=isa(v001,'char');v001=int32(v001);if ...
nargin<2,if any(v001==13),v001=ComputeNonCryptHash_f44(v001,int32([13 10]),int32(-10));
v001(v001==13)=-10;end,v001(v001==10)=-10;else,for v004=1:numel(v002),v001=...
ComputeNonCryptHash_f44(v001,int32(v002{v004}),int32(-10));end,end,v005=[0 find(v001==-10) ...
numel(v001)+1];v000=cell(numel(v005)-1,1);for v004=1:numel(v000),v006=(v005(v004)+1);v007=...
(v005(v004+1)-1);v000{v004}=v001(v006:v007);end,if v003,for v004=1:numel(v000),v000{v004}=...
char(v000{v004});end,else,for v004=1:numel(v000),v000{v004}=uint32(v000{v004});end,end,end
function v000=ComputeNonCryptHash_f09,persistent v001,if isempty(v001),if ...
ComputeNonCryptHash_f23('<',0,'Octave','>',0),v002=struct('w',warning('off','all'));[v002.msg,...
v002.ID]=lastwarn;v001=~isequal(8364,double(char(8364)));warning(v002.w);lastwarn(v002.msg,...
v002.ID);else,v001=false;end,end,v000=v001;end
function[v000,v001,v002]=ComputeNonCryptHash_f10(varargin),v003=false;[v004,v002]=...
ComputeNonCryptHash_f12(varargin{:});if~isempty(v002),v003=true;end,v005=...
ComputeNonCryptHash_f14;varargin=v004;[v000,v001,v002,v006,v007]=ComputeNonCryptHash_f40(v005,...
varargin{:});if v006,return,end,if v003,return,end,if numel(v007)==0,v000=true;v002=[];return,...
end,for v008=1:numel(v007),if strcmp(v007{v008},'VersionFlag'),try v009=...
str2double(v001.VersionFlag(3:end));if isnan(v009)||round(v009)~=v009||v009>2,error('trigger');
end,catch,v002.identifier='HJW:ComputeNonCryptHash:InputIncorrect';v002.message=...
'VersionFlag input incorrect. Must be ''-v1'', ''-v2''.';return,end,elseif strcmp(v007{v008},...
'HashLength'),v010=v001.HashLength;if numel(v010)~=1||~isnumeric(v010)||mod(v010,16)~=...
0||v010<16,v002.identifier='HJW:ComputeNonCryptHash:InputIncorrect';v002.message=...
'HashLength input must be a multiple of 16.';return,end,end,end,v000=true;v002=[];end
function[v000,v001,v002]=ComputeNonCryptHash_f11(v003),v001=v003{1};if ismember(class(v001),...
{'char','string'}),if isa(v001,'char')&&numel(v001)>=1&&strcmp('-',v001(1)),v000=1;else,v000=0;
end,else,if isa(v001,'struct'),v000=0;else,v000=2;end,end,v002=v003;if v000~=0,v002(1)=[];end,...
end
function[v000,v001]=ComputeNonCryptHash_f12(varargin),v001=[];v000=varargin;v002=[false false];
for v003=1:nargin,[v004,v005,v000]=ComputeNonCryptHash_f11(v000);switch v004,case 0,break,case ...
1,v006=v005;v002(1)=true;case 2,v007=v005;v002(2)=true;case 3,v001.identifier=...
'HJW:ComputeNonCryptHash:InputIncorrect';v001.message='Unable to determine a valid syntax.';
return,end,end,if nargin==sum(v002),v008=struct;if v002(1),v008.VersionFlag=v006;end,if v002(2),...
v008.HashLength=v007;end,v000={v008};else,if isa(v000{1},'stuct'),v008=v000{1};if v002(1),...
v008.VersionFlag=v006;end,if v002(2),v008.HashLength=v007;end,v000{1}=v008;else,v009=cell(1,0);
if v002(1),v009=[v009 {'VersionFlag',v006}];end,if v002(2),v009=[v009 {'HashLength',v007}];end,...
v000=[v009 v000];end,end,end
function v000=ComputeNonCryptHash_f13(v000),v000.Version=str2double(v000.VersionFlag(3:end));
if~isfield(v000,'re_encode_char_on_Octave'),v000.re_encode_char=v000.Version>=2;end,...
if~isfield(v000,'string_to_cellstr'),v000.string_to_cellstr=v000.Version>=2;if~isfield(v000,...
'cast_int64_double'),v000.cast_int64_double=v000.Version==1;end,end,end
function v003=ComputeNonCryptHash_f14,persistent v000,if isempty(v000),v000=struct;
v000.HashLength=256;v000.VersionFlag='-v2';v000.SkipInputParse=false;v000.isSaltCall=false;
[v000.print_to,v001]=ComputeNonCryptHash_f28;for v002=1:numel(v001),v000.(v001{v002})=[];end,...
end,v003=v000;end
function ComputeNonCryptHash_f15(v001,varargin),persistent v000,if isempty(v000),v000=func2str(...
@ComputeNonCryptHash_f15);end,if isempty(v001),v001=struct;end,v001=...
ComputeNonCryptHash_f43(v001);[v002,v003,v004,v005,v006]=ComputeNonCryptHash_f41(varargin{:});
if v006,return,end,v007=v005;if v001.params.ShowTraceInMessage,v003=sprintf('%s\n%s',v003,v005);
end,v008=struct('identifier',v002,'message',v003,'stack',v004);if ...
v001.params.WipeTraceForBuiltin,v008.stack=v004('name','','file','','line',[]);end,if ...
v001.boolean.obj,v009=v003;while v009(end)==10,v009(end)='';end,if any(v009==10),v009=...
ComputeNonCryptHash_f08(['Error: ' v009]);else,v009=['Error: ' v009];end,for v010=...
reshape(v001.obj,1,[]),try set(v010,'String',v009);catch,end,end,end,if v001.boolean.fid,v011=...
datestr(now,31);for v012=reshape(v001.fid,1,[]),try fprintf(v012,'[%s] Error: %s\n%s',v011,v003,...
v005);catch,end,end,end,if v001.boolean.fcn,if ismember(v000,{v004.name}),...
error('prevent recursion'),end,v013=v008;v013.trace=v007;for v014=reshape(v001.fcn,1,[]),if ...
isfield(v014,'data'),try feval(v014.h,'error',v013,v014.data);catch,end,else,try feval(v014.h,...
'error',v013);catch,end,end,end,end,rethrow(v008),end
function[v000,v001]=ComputeNonCryptHash_f16(v002,v001),if nargin==0,v002=1;end,if nargin<2,v001=...
dbstack;end,v001(1:v002)=[];if~isfield(v001,'file'),for v003=1:numel(v001),v004=v001(v003).name;
if strcmp(v004(end),')'),v005=strfind(v004,'(');v006=v004((v005(end)+1):(end-1));v007=...
v004(1:(v005(end)-2));else,v007=v004;[v008,v006]=fileparts(v004);end,[v008,v001(v003).file]=...
fileparts(v007);v001(v003).name=v006;end,end,persistent v009,if isempty(v009),v009=...
ComputeNonCryptHash_f23('<',0,'Octave','>',0);end,if v009,for v003=1:numel(v001),[v008,...
v001(v003).file]=fileparts(v001(v003).file);end,end,v010=v001;v011='>';v000=cell(1,...
numel(v010)-1);for v003=1:numel(v010),[v012,v010(v003).file,v013]=fileparts(v010(v003).file);if ...
v003==numel(v010),v010(v003).file='';end,if strcmp(v010(v003).file,v010(v003).name),...
v010(v003).file='';end,if~isempty(v010(v003).file),v010(v003).file=[v010(v003).file '>'];end,...
v000{v003}=sprintf('%c In %s%s (line %d)\n',v011,v010(v003).file,v010(v003).name,...
v010(v003).line);v011=' ';end,v000=horzcat(v000{:});end
function v000=ComputeNonCryptHash_f17(v000),persistent v001,v002=size(v000);if ...
isempty(v001)||any(size(v001)<v002)||isempty(v001{v002(1),v002(2)}),[v003,v004]=...
meshgrid(1:size(v000,2),1:size(v000,1));v005=mod(v003+v004-2,size(v000,1))+1;v006=...
sub2ind(size(v000),v005,v003);if prod(v002)<=1000,v001{v002(1),v002(2)}=v006;end,else,v006=...
v001{v002(1),v002(2)};end,v000=v000(v006);end
function v000=ComputeNonCryptHash_f18(v000,v001),v002=16*numel(v000);v003=v001;v003.Version=1;
v003.HashLength=v002;v003.SkipInputParse=1;v003.isSaltCall=1;v004=ComputeNonCryptHash(v000,...
v003);v004=ComputeNonCryptHash_f19(v004);if v001.Version>1,v004=v004(end:-1:1);end,v000=...
mod(double(v000).*double(v004),1+2^16);v000=uint16(v000);end
function v000=ComputeNonCryptHash_f19(v000),v001=65537;v002=1919;v000=uint16(mod(double(v000) * ...
v002,v001));end
function v000=ComputeNonCryptHash_f20(v000),v001=size(v000).';v000=v000(:);persistent v002,if ...
isempty(v002),v002=ComputeNonCryptHash_f00('ImplicitExpansion');end,if mod(numel(v000),16),...
v000(16*ceil(numel(v000)/16))=0;end,v003=uint16(2.^(15:-1:0))';v000=uint16(reshape(v000,16,[]));
if v002,v000=v000.*v003;else,v000=double(v000).*repmat(double(v003),[1 size(v000,2)]);v000=...
uint16(v000);end,v000=uint16(sum(v000,1)).';v000=[v000;uint16(mod(v001,2^16))];end
function v000=ComputeNonCryptHash_f21(v000),persistent v001,if isempty(v001),v001=...
dec2bin(0:(-1+2^16))=='1';v001=v001.';end,v000=double(v000)+1;v000=v001(:,v000);end
function v000=ComputeNonCryptHash_f22(v001,v002),persistent v003,if isempty(v003),v003=...
double(ComputeNonCryptHash_f00('ImplicitExpansion')) + ...
double(ComputeNonCryptHash_f00('bsxfun'));end,if v003==2,v000=v001+v002;elseif v003==1,v000=...
bsxfun(@plus,v001,v002);else,v004=size(v001);v005=size(v002);if min([v004 v005])==0,v004(v004==...
0)=inf;v005(v005==0)=inf;v006=max(v004,v005);v006(isinf(v006))=0;v000=...
feval(str2func(class(v001)),zeros(v006));return,end,v001=repmat(v001,max(1,v005./v004));v002=...
repmat(v002,max(1,v004./v005));v000=v001+v002;end,end
function v000=ComputeNonCryptHash_f23(v001,v002,v003,v004,v005),if nargin<2||nargout>1,...
error('incorrect number of input/output arguments'),end,persistent v006 v007 v008,if ...
isempty(v006),v008=exist('OCTAVE_VERSION','builtin');v006=[100,1] * sscanf(version,'%d.%d',2);
v007={'R13' 605;'R13SP1' 605;'R13SP2' 605;'R14' 700;'R14SP1' 700;'R14SP2' 700;'R14SP3' 701;
'R2006a' 702;'R2006b' 703;'R2007a' 704;'R2007b' 705;'R2008a' 706;'R2008b' 707;'R2009a' 708;
'R2009b' 709;'R2010a' 710;'R2010b' 711;'R2011a' 712;'R2011b' 713;'R2012a' 714;'R2012b' 800;
'R2013a' 801;'R2013b' 802;'R2014a' 803;'R2014b' 804;'R2015a' 805;'R2015b' 806;'R2016a' 900;
'R2016b' 901;'R2017a' 902;'R2017b' 903;'R2018a' 904;'R2018b' 905;'R2019a' 906;'R2019b' 907;
'R2020a' 908;'R2020b' 909;'R2021a' 910;'R2021b' 911;'R2022a' 912;'R2022b' 913;'R2023a' 914};end,...
if v008,if nargin==2,warning('HJW:ifversion:NoOctaveTest',...
['No version test for Octave was provided.',char(10),...
'This function might return an unexpected outcome.']),if isnumeric(v002),v009=...
0.1*v002+0.9*ComputeNonCryptHash_f27(v002);v009=round(100*v009);else,v010=ismember(v007(:,1),...
v002);if sum(v010)~=1,warning('HJW:ifversion:NotInDict',...
'The requested version is not in the hard-coded list.'),v000=NaN;return,else,v009=v007{v010,2};
end,end,elseif nargin==4,[v001,v009]=deal(v003,v004);v009=...
0.1*v009+0.9*ComputeNonCryptHash_f27(v009);v009=round(100*v009);else,[v001,v009]=deal(v004,...
v005);v009=0.1*v009+0.9*ComputeNonCryptHash_f27(v009);v009=round(100*v009);end,else,if ...
isnumeric(v002),v009=ComputeNonCryptHash_f27(v002*100);if mod(v009,10)==0,v009=...
ComputeNonCryptHash_f27(v002)*100+mod(v002,1)*10;end,else,v010=ismember(v007(:,1),v002);if ...
sum(v010)~=1,warning('HJW:ifversion:NotInDict',...
'The requested version is not in the hard-coded list.'),v000=NaN;return,else,v009=v007{v010,2};
end,end,end,switch v001,case'==',v000=v006==v009;case'<',v000=v006 < v009;case'<=',v000=v006 <=...
v009;case'>',v000=v006 > v009;case'>=',v000=v006 >=v009;end,end
function[v000,v001]=ComputeNonCryptHash_f24(v002,varargin),switch numel(v002),case 0,...
error('parse_NameValue:MixedOrBadSyntax',...
'Optional inputs must be entered as Name,Value pairs or as a scalar struct.'),case 1,otherwise,...
v002=v002(1);end,v000=v002;v001={};if nargin==1,return,end,try v003=numel(varargin)==...
1&&isa(varargin{1},'struct');v004=mod(numel(varargin),2)==0&&all(cellfun('isclass',...
varargin(1:2:end),'char')|cellfun('isclass',varargin(1:2:end),'string'));if~(v003||v004),...
error('trigger'),end,if nargin==2,v005=fieldnames(varargin{1});v006=struct2cell(varargin{1});
else,v005=cellstr(varargin(1:2:end));v006=varargin(2:2:end);end,if~iscellstr(v005),...
error('trigger');end,catch,error('parse_NameValue:MixedOrBadSyntax',...
'Optional inputs must be entered as Name,Value pairs or as a scalar struct.'),end,v007=...
fieldnames(v002);v008=cell(1,4);v009{1}=v007;v009{2}=lower(v009{1});v009{3}=strrep(v009{2},'_',...
'');v009{4}=strrep(v009{3},'-','');v005=strrep(v005,' ','_');v001=false(size(v007));for v010=...
1:numel(v005),v011=v005{v010};[v012,v008{1}]=ComputeNonCryptHash_f25(v008{1},v009{1},v011);if ...
numel(v012)~=1,v011=lower(v011);[v012,v008{2}]=ComputeNonCryptHash_f25(v008{2},v009{2},v011);
end,if numel(v012)~=1,v011=strrep(v011,'_','');[v012,v008{3}]=ComputeNonCryptHash_f25(v008{3},...
v009{3},v011);end,if numel(v012)~=1,v011=strrep(v011,'-','');[v012,v008{4}]=...
ComputeNonCryptHash_f25(v008{4},v009{4},v011);end,if numel(v012)~=1,...
error('parse_NameValue:NonUniqueMatch',v005{v010}),end,v000.(v007{v012})=v006{v010};v001(v012)=...
true;end,v001=v007(v001);end
function[v000,v001]=ComputeNonCryptHash_f25(v001,v002,v003),v000=find(ismember(v002,v003));if ...
numel(v000)==1,return,end,if isempty(v001),v001=ComputeNonCryptHash_f26(v002);end,v004=v001(:,...
1:min(end,numel(v003)));if size(v004,2)<numel(v003),v004=[v004 repmat(' ',size(v004,1),...
numel(v003)-size(v004,2))];end,v005=numel(v003)-sum(cumprod(double(v004==repmat(v003,size(v004,...
1),1)),2),2);v000=find(v005==0);end
function v000=ComputeNonCryptHash_f26(v000),v001=cellfun('prodofsize',v000);v002=max(v001);for ...
v003=find(v001<v002).',v000{v003}((end+1):v002)=' ';end,v000=vertcat(v000{:});end
function v000=ComputeNonCryptHash_f27(v000),v000=fix(v000+eps*1e3);end
function[v002,v003]=ComputeNonCryptHash_f28,persistent v000 v001,if isempty(v000),[v000,v001]=...
ComputeNonCryptHash_f29;end,v002=v000;v003=v001;end
function[v001,v004]=ComputeNonCryptHash_f29,v000=struct('ShowTraceInMessage',false,...
'WipeTraceForBuiltin',false);v001=struct('params',v000,'fid',[],'obj',[],'fcn',struct('h',{},...
'data',{}),'boolean',struct('con',[],'fid',false,'obj',false,'fcn',false,'IsValidated',false));
v002=fieldnames(v000);for v003=1:numel(v002),v002{v003}=['option_' v002{v003}];end,v004=...
[{'params'};v002;{'con';'fid';'obj';'fcn'}];for v003=1:numel(v004),v004{v003}=['print_to_' ...
v004{v003}];end,v004=sort(v004);end
function v000=ComputeNonCryptHash_f30(v001),persistent v002 v003 v004,if isempty(v003),[v002,...
v003]=ComputeNonCryptHash_f28;v005='print_to_option_';for v006=numel(v003):-1:1,if~strcmp(v005,...
v003{v006}(1:min(end,numel(v005)))),v003(v006)=[];end,end,v004=strrep(v003,v005,'');end,v000=...
v002;if isfield(v001,'print_to_params'),v000.params=v001.print_to_params;else,for v006=...
1:numel(v003),v007=v003{v006};if isfield(v001,v003{v006}),v008=v004{v006};v000.params.(v008)=...
v001.(v007);end,end,end,if isfield(v001,'print_to_fid'),v000.fid=v001.print_to_fid;end,if ...
isfield(v001,'print_to_obj'),v000.obj=v001.print_to_obj;end,if isfield(v001,'print_to_fcn'),...
v000.fcn=v001.print_to_fcn;end,if isfield(v001,'print_to_con'),v000.boolean.con=...
v001.print_to_con;end,v000.boolean.IsValidated=false;end
function[v000,v001,v002]=ComputeNonCryptHash_f31(v002),v003=nargout>=3;v001=struct('identifier',...
'','message','');v000=true;if nargout>=3,v003=true;end,[v004,v005]=...
ComputeNonCryptHash_f46(v002.boolean.IsValidated);if v004&&v005,return,end,[v004,...
v002.boolean.con]=ComputeNonCryptHash_f46(v002.boolean.con);if~v004&&~isempty(v002.boolean.con),...
v001.message=['Invalid print_to_con parameter:',char(10),...
'should be a scalar logical or empty double.'];v001.identifier='HJW:print_to:ValidationFailed';
v000=false;if~v003,return,end,end,[v006,v002.fid]=ComputeNonCryptHash_f32(v002.fid);if v006,...
v001.message=['Invalid print_to_fid parameter:',char(10),...
'should be a valid file identifier or 1.'];v001.identifier='HJW:print_to:ValidationFailed';v000=...
false;if~v003,return,end,end,v002.boolean.fid=~isempty(v002.fid);[v006,v002.obj]=...
ComputeNonCryptHash_f33(v002.obj);if v006,v001.message=['Invalid print_to_obj parameter:',...
char(10),'should be a handle to an object with a writeable String property.'];v001.identifier=...
'HJW:print_to:ValidationFailed';v000=false;if~v003,return,end,end,v002.boolean.obj=...
~isempty(v002.obj);[v006,v002.fcn]=ComputeNonCryptHash_f34(v002.fcn);if v006,v001.message=...
['Invalid print_to_fcn parameter:',char(10),...
'should be a struct with the h field containing a function handle,',char(10),...
'anonymous function or inline function.'];v001.identifier='HJW:print_to:ValidationFailed';v000=...
false;if~v003,return,end,end,v002.boolean.fcn=~isempty(v002.fcn);[v006,v002.params]=...
ComputeNonCryptHash_f39(v002.params);if v006,v001.message=...
['Invalid print_to____params parameter:',char(10),...
'should be a scalar struct uniquely matching parameter names.'];v001.identifier=...
'HJW:print_to:ValidationFailed';v000=false;if~v003,return,end,end,if isempty(v002.boolean.con),...
v002.boolean.con=~any([v002.boolean.fid v002.boolean.obj v002.boolean.fcn]);end,if~v000,...
v002.boolean.con=true;end,v002.boolean.IsValidated=true;end
function[v000,v001]=ComputeNonCryptHash_f32(v001),v000=false;for v002=numel(v001):-1:1,try v003=...
ftell(v001(v002));catch,v003=-1;end,if v001(v002)~=1&&v003==-1,v000=true;v001(v002)=[];end,end,...
end
function[v000,v001]=ComputeNonCryptHash_f33(v001),v000=false;for v002=numel(v001):-1:1,try v003=...
get(v001(v002),'String');set(v001(v002),'String','');set(v001(v002),'String',v003);catch,v000=...
true;v001(v002)=[];end,end,end
function[v000,v001]=ComputeNonCryptHash_f34(v001),v000=false;for v002=numel(v001):-1:1,...
if~isa(v001,'struct')||~isfield(v001,'h')||~ismember(class(v001(v002).h),{'function_handle',...
'inline'})||numel(v001(v002).h)~=1,v000=true;v001(v002)=[];end,end,end
function v000=ComputeNonCryptHash_f35(v001),if numel(v001)>1,...
error('this should only be used for single characters'),end,if v001<128,v000=v001;return,end,...
persistent v002,if isempty(v002),v002=struct;v002.limits.lower=hex2dec({'0000','0080','0800',...
'10000'});v002.limits.upper=hex2dec({'007F','07FF','FFFF','10FFFF'});v002.scheme{2}=...
'110xxxxx10xxxxxx';v002.scheme{2}=reshape(v002.scheme{2}.',8,2);v002.scheme{3}=...
'1110xxxx10xxxxxx10xxxxxx';v002.scheme{3}=reshape(v002.scheme{3}.',8,3);v002.scheme{4}=...
'11110xxx10xxxxxx10xxxxxx10xxxxxx';v002.scheme{4}=reshape(v002.scheme{4}.',8,4);for v003=2:4,...
v002.scheme_pos{v003}=find(v002.scheme{v003}=='x');v002.bits(v003)=numel(v002.scheme_pos{v003});
end,end,v004=find(v002.limits.lower<=v001&v001<=v002.limits.upper);v000=v002.scheme{v004};v005=...
v002.scheme_pos{v004};v003=dec2bin(double(v001),v002.bits(v004));v000(v005)=v003;v000=...
bin2dec(v000.').';end
function[v000,v001,v002]=ComputeNonCryptHash_f36(v003,v004),if nargin<2,v004=[];end,v005=...
nargout==1;v003=uint32(reshape(v003,1,[]));[v002,v006,v007]=ComputeNonCryptHash_f38(v003,v005);
if strcmp(v006,'success'),v001=true;v000=v002;elseif strcmp(v006,'error'),v001=false;if v005,...
ComputeNonCryptHash_f15(v004,v007),end,v000=v003;end,end
function v000=ComputeNonCryptHash_f37(v001),if v001<65536,v000=v001;return,end,v002=...
double(v001)-65536;v002=dec2bin(v002,20);v000=bin2dec(['110110' v002(1:10);'110111' ...
v002(11:20)]).';end
function[v000,v001,v002]=ComputeNonCryptHash_f38(v000,v003),v001='success';v002=...
struct('identifier','HJW:UTF8_to_unicode:notUTF8','message','Input is not UTF-8.');persistent ...
v004,if isempty(v004),v004=ComputeNonCryptHash_f23('<',0,'Octave','>',0);end,if any(v000>255),...
v001='error';if v003,return,end,elseif all(v000<128),return,end,for v005=4:-1:2,v006=...
bin2dec([repmat('1',1,v005) repmat('0',1,8-v005)]);v007=v000>=v006&v000<256;if any(v007),v007=...
find(v007);v007=v007(:).';if numel(v000)<(max(v007)+v005-1),v001='error';if v003,return,end,...
v007((v007+v005-1)>numel(v000))=[];end,if~isempty(v007),v008=ComputeNonCryptHash_f22(v007,...
(0:(v005-1)).');v008=v008.';v007=v000(v008);end,else,v007=[];end,v009=[repmat('1',1,v005-1) ...
repmat('10',1,v005)];v010=unique([1:(v005+1) 1:8:(8*v005) 2:8:(8*v005)]);if numel(v007)>0,v007=...
unique(v007,'rows');v011=mat2cell(v007,ones(size(v007,1),1),v005);for v012=1:numel(v011),v013=...
dec2bin(double(v011{v012}))';if~strcmp(v009,v013(v010)),v001='error';if v003,return,end,...
continue,end,v013(v010)='';if~v004,v014=uint32(bin2dec(v013));else,v014=uint32(bin2dec(v013.'));
end,v000=ComputeNonCryptHash_f44(v000,v011{v012},v014);end,end,end,end
function[v000,v001]=ComputeNonCryptHash_f39(v001),v000=false;persistent v002,if isempty(v002),...
v002=ComputeNonCryptHash_f28;v002=v002.params;end,if isempty(v001),v001=struct;end,if~isa(v001,...
'struct'),v000=true;v001=v002;return,end,while true,try v003=[];[v001,v004]=...
ComputeNonCryptHash_f24(v002,v001);break,catch v003;if isempty(v003),v003=lasterror;end,v000=...
true;v001=rmfield(v001,v003.message);end,end,for v005=1:numel(v004),v006=v004{v005};switch v006,...
case'ShowTraceInMessage',[v007,v001.(v006)]=ComputeNonCryptHash_f46(v001.(v006));if~v007,v000=...
true;v001.(v006)=v002.(v006);end,case'WipeTraceForBuiltin',[v007,v001.(v006)]=...
ComputeNonCryptHash_f46(v001.(v006));if~v007,v000=true;v001.(v006)=v002.(v006);end,end,end,end
function[v000,v001,v002,v003,v004]=ComputeNonCryptHash_f40(v005,varargin),v000=false;v003=false;
v002=struct('identifier','','message','');v004=cell(0);try v006=[];[v001,v004]=...
ComputeNonCryptHash_f24(v005,varargin{:});catch v006;if isempty(v006),v006=lasterror;end,v002=...
v006;v003=true;end,if v003,if isa(varargin{1},'struct'),v001=varargin{1};else,try v001=...
struct(varargin{:});catch,v001=struct;end,end,if isfield(v001,'print_to'),v007=v001.print_to;
else,v007=ComputeNonCryptHash_f30(v001);end,else,if ismember('print_to',v004),v007=...
v001.print_to;else,v007=ComputeNonCryptHash_f30(v001);end,end,[v008,v009,v001.print_to]=...
ComputeNonCryptHash_f31(v007);if~v008,v002=v009;v003=true;end,end
function[v000,v001,v002,v003,v004]=ComputeNonCryptHash_f41(varargin),v004=false;if nargin==1,if ...
isa(varargin{1},'struct')||isa(varargin{1},'MException'),v005=varargin{1};if numel(v005)~=1,...
v004=true;[v000,v001,v002,v003]=deal('');return,end,try v002=v005.stack;v003=...
ComputeNonCryptHash_f16(0,v002);catch,[v003,v002]=ComputeNonCryptHash_f16(3);end,v000=...
v005.identifier;v001=v005.message;v006='Error using ==> ';if strcmp(v001(1:min(end,...
numel(v006))),v006),v007=min(find(ismember(double(v001),[10 13])));if any(double(v001(v007+1))==...
[10 13]),v007=v007-1;end,v001(1:v007)='';end,v006=...
'Error using <a href="matlab:matlab.internal.language.introspective.errorDocCallbac';if ...
isa(v005,'struct')&&strcmp(v006,v001(1:min(end,numel(v006)))),v001(1:min(find(v001==10)))='';
end,else,[v003,v002]=ComputeNonCryptHash_f16(3);[v000,v001]=deal('',varargin{1});end,else,[v003,...
v002]=ComputeNonCryptHash_f16(3);if~isempty(strfind(varargin{1},'%')),v000='';v008=...
varargin(2:end);v001=sprintf(varargin{1},v008{:});else,v000=varargin{1};v001=varargin{2};if ...
nargin>2,v008=varargin(3:end);v001=sprintf(v001,v008{:});end,end,end,end
function v000=ComputeNonCryptHash_f42(v000,v001),v002=size(v000).';v000=v000(:);persistent v003,...
if isempty(v003),v003=ComputeNonCryptHash_f00('IntegerArithmetic');end,v004=class(v000);v005=...
~v001.cast_int64_double&&v003&&v004(end)=='4';if~v005,if any(abs(double(v000(:)))>2^52),...
ComputeNonCryptHash_f50(v001,'HJW:ComputeNonCryptHash:int64rounding',...
['int64 and uint64 will be rounded pre-R2010b, resulting in rounding.',char(10),...
'This will result in a hash that is different from newer releases.']),end,end,if v005,if ...
v004(1)~='u',v006=v000>0;v007=-int64(-inf);v008=uint64(v000+v007+1);v008(v006)=...
uint64(v000(v006))+uint64(v007)+1;v000=v008;end,elseif v004(1)~='u',switch v004,case'int8',v000=...
double(v000)-double(int8(-inf));case'int16',v000=double(v000)-double(int16(-inf));case'int32',...
v000=double(v000)-double(int32(-inf));case'int64',v000=double(v000)-double(int64(-inf));end,...
else,v000=double(v000);end,switch v004(end),case'8',if mod(numel(v000),2),v008=...
zeros((numel(v000)+1)/2,2);v008(1:(end-1))=v000;v000=v008;end,v000=reshape(v000,[],2);v000=...
v000(:,1)*255+v000(:,2);v000=uint16(v000);case'6',v000=uint16(v000);case'2',v009=...
floor(v000/2^16);v009=v009.';v010=mod(v000,2^16);v010=v010.';v000=[v009;v010];v000=...
uint16(v000(:));case'4',v011=v000;v012=mod(v011,2^16);v011=v011-v012;v011=v011/2^16;v012=v012.';
v013=mod(v011,2^16);v011=v011-v013;v011=v011/2^16;v013=v013.';v010=mod(v011,2^16);v011=...
v011-v010;v011=v011/2^16;v010=v010.';v009=mod(v011,2^16);v009=v009.';v000=[v009;v010;v013;v012];
v000=uint16(v000(:));end,v000=[v000;uint16(v004.');uint16(mod(v002,2^16))];end
function v000=ComputeNonCryptHash_f43(v000),if isfield(v000,'boolean')&&isfield(v000.boolean,...
'IsValidated')&&v000.boolean.IsValidated,return,end,try v001=...
ComputeNonCryptHash_f24(ComputeNonCryptHash_f28,v000);v001.boolean.IsValidated=false;catch,v001=...
ComputeNonCryptHash_f30(v000);end,[v002,v002,v000]=ComputeNonCryptHash_f31(v001);end
function v000=ComputeNonCryptHash_f44(v001,v002,v003),v001=reshape(v001,1,[]);v000=v001;if ...
numel(v002)==0||numel(v002)>numel(v001),return,end,v004=true(size(v001));
v004((end-numel(v002)+2):end)=false;for v005=1:numel(v002),v006=v001==v002(v005);v006=...
circshift(v006,[0 1-v005]);v006(1:(v005-1))=v004(1:(v005-1));v004=v004&v006;if~any(v004),return,...
end,end,if numel(v003)==0,v000(v004)=[];return,end,if numel(v002)>1,v007=...
ComputeNonCryptHash_f22(find(v004),reshape(1:(numel(v002)-1),[],1));else,v007=find(v004);end,...
v007=reshape(v007,1,[]);v008=repmat(' ',1,numel(v001));v008(v007)='_';v008(v004)='*';v009=v008==...
' ';v008=regexprep(v008,'\*_*',['*' repmat('_',1,numel(v003)-1)]);v000(v008==' ')=v001(v009);
v010=strfind(v008,'*');v007=ComputeNonCryptHash_f22(v010,reshape(0:(numel(v003)-1),[],1));v007=...
reshape(v007,1,[]);v000(v007)=repmat(v003,1,numel(v010));v000((numel(v008)+1):end)=[];end
function v000=ComputeNonCryptHash_f45(v001,v002),persistent v003,if isempty(v003),v003=...
ComputeNonCryptHash_f23('<',0,'Octave','>',0);end,if nargin==1,v002=~ComputeNonCryptHash_f09;
end,if v002,if all(v001<65536),v000=uint16(v001);v000=reshape(v000,1,numel(v000));else,[v004,...
v005,v006]=unique(v001);v000=cell(1,numel(v001));for v007=1:numel(v004),v008=...
ComputeNonCryptHash_f37(v004(v007));v008=uint16(v008);v000(v006==v007)={v008};end,v000=...
cell2mat(v000);end,if~v003,v000=char(v000);end,else,if all(v001<128),v000=char(v001);v000=...
reshape(v000,1,numel(v000));else,[v004,v005,v006]=unique(v001);v000=cell(1,numel(v001));for ...
v007=1:numel(v004),v008=ComputeNonCryptHash_f35(v004(v007));v008=uint8(v008);v000(v006==v007)=...
{v008};end,v000=cell2mat(v000);v000=char(v000);end,end,end
function[v000,v001]=ComputeNonCryptHash_f46(v001),persistent v002,if isempty(v002),v002={true,...
false;1,0;'true','false';'1','0';'on','off';'enable','disable';'enabled','disabled'};end,if ...
isa(v001,'matlab.lang.OnOffSwitchState'),v000=true;v001=logical(v001);return,end,if isa(v001,...
'string'),if numel(v001)~=1,v000=false;return,else,v001=char(v001);end,end,if isa(v001,'char'),...
v001=lower(v001);end,for v003=1:size(v002,1),for v004=1:2,if isequal(v001,v002{v003,v004}),v000=...
true;v001=v002{1,v004};return,end,end,end,v000=false;end
function[v000,v001]=ComputeNonCryptHash_f47(v002),[v003,v004]=log2(v002);v005=...
-floor(sign(v002)/2-0.5);v006=v004+1022;v007=abs(v003)*2-1;v000=zeros(size(v002));v000=...
v000+(v005*2^63);v000=v000+(v006*2^52);v000=v000+(v007*2^52);v001=mod(v007*2^52,2^16);v008=...
isinf(v002);v000(v002==0)=0;v000(isnan(v002))=18444492273895866368;v000(v008&v002>0)=...
9218868437227405312;v000(v008&v002<0)=18442240474082181120;v001(v002==0)=0;v001(isnan(v002))=0;
v001(v008)=0;end
function v000=ComputeNonCryptHash_f48(v000,v001),persistent v002,if isempty(v002),v002=...
ComputeNonCryptHash_f23('<',0,'Octave','>',0);end,if v002&&v001.re_encode_char,v003=size(v000,...
1)==numel(v000);if v003,v000=v000.';end,v000=cellstr(v000);for v004=1:numel(v000),v000{v004}=...
ComputeNonCryptHash_f45(ComputeNonCryptHash_f36(v000{v004},v001.print_to),true);end,v005=...
cellfun('length',v000);v006=max(v005);for v004=find(v005<v006),...
v000{v004}((numel(v000{v004})+1):v006)=uint16(' ');end,v000=cell2mat(v000);if v003,v000=v000.';
end,end,v007=size(v000).';v000=v000(:);v000=uint16(v000);v000=[v000;uint16(mod(v007,2^16))];end
function v000=ComputeNonCryptHash_f49(v000,v001),if v001.string_to_cellstr,v000=cellstr(v000);
v000=ComputeNonCryptHash_f05(v000,v001);else,v000=char(v000);v000=ComputeNonCryptHash_f48(v000,...
v001);end,end
function ComputeNonCryptHash_f50(v001,varargin),persistent v000,if isempty(v000),v000=func2str(...
@ComputeNonCryptHash_f50);end,if isempty(v001),v001=struct;end,v001=...
ComputeNonCryptHash_f43(v001);[v002,v003,v004,v005,v006]=ComputeNonCryptHash_f41(varargin{:});
v007=v005;if v006,return,end,v008=warning;if any(ismember({v008(ismember({v008.identifier},...
{v002,'all'})).state},'off')),return,end,v009=warning('query','backtrace');if strcmp(v009.state,...
'off'),v005='';end,if v001.params.ShowTraceInMessage&&~isempty(v005),v003=sprintf('%s\n%s',v003,...
v005);end,if v001.params.WipeTraceForBuiltin&&strcmp(v009.state,'on'),warning('off',...
'backtrace'),end,if v001.boolean.con,v010=warning('query','verbose');if strcmp(v010.state,'on'),...
warning('off','verbose'),end,if~isempty(v002),warning(v002,'%s',v003),else,warning(v003),end,if ...
strcmp(v010.state,'on'),warning('on','verbose'),end,else,if~isempty(v002),lastwarn(v003,v002);
else,lastwarn(v003),end,end,if v001.params.WipeTraceForBuiltin&&strcmp(v009.state,'on'),...
warning('on','backtrace'),end,if v001.boolean.obj,v011=v003;while v011(end)==10,v011(end)=[];
end,if any(v011==10),v011=ComputeNonCryptHash_f08(['Warning: ' v011]);else,v011=['Warning: ' ...
v011];end,set(v001.obj,'String',v011),for v012=reshape(v001.obj,1,[]),try set(v012,'String',...
v011);catch,end,end,end,if v001.boolean.fid,v013=datestr(now,31);for v014=reshape(v001.fid,1,...
[]),try fprintf(v014,'[%s] Warning: %s\n%s',v013,v003,v005);catch,end,end,end,if ...
v001.boolean.fcn,if ismember(v000,{v004.name}),error('prevent recursion'),end,v015=...
struct('identifier',v002,'message',v003,'stack',v004,'trace',v007);for v016=reshape(v001.fcn,1,...
[]),if isfield(v016,'data'),try feval(v016.h,'warning',v015,v016.data);catch,end,else,try ...
feval(v016.h,'warning',v015);catch,end,end,end,end,end
function error_(options,varargin)
%Print an error to the command window, a file and/or the String property of an object.
% The error will first be written to the file and object before being actually thrown.
%
% Apart from controlling the way an error is written, you can also run a specific function. The
% 'fcn' field of the options must be a struct (scalar or array) with two fields: 'h' with a
% function handle, and 'data' with arbitrary data passed as third input. These functions will be
% run with 'error' as first input. The second input is a struct with identifier, message, and stack
% as fields. This function will be run with feval (meaning the function handles can be replaced
% with inline functions or anonymous functions).
%
% The intention is to allow replacement of every error(___) call with error_(options,___).
%
% NB: the function trace that is written to a file or object may differ from the trace displayed by
% calling the builtin error/warning functions (especially when evaluating code sections). The
% calling code will not be included in the constructed trace.
%
% There are two ways to specify the input options. The shorthand struct described below can be used
% for fast repeated calls, while the input described below allows an input that is easier to read.
% Shorthand struct:
%  options.boolean.IsValidated: if true, validation is skipped
%  options.params:              optional parameters for error_ and warning_, as explained below
%  options.boolean.con:         only relevant for warning_, ignored
%  options.fid:                 file identifier for fprintf (array input will be indexed)
%  options.boolean.fid:         if true print error to file
%  options.obj:                 handle to object with String property (array input will be indexed)
%  options.boolean.obj:         if true print error to object (options.obj)
%  options.fcn                  struct (array input will be indexed)
%  options.fcn.h:               handle of function to be run
%  options.fcn.data:            data passed as third input to function to be run (optional)
%  options.boolean.fnc:         if true the function(s) will be run
%
% Full input description:
%   print_to_con:
%      NB: An attempt is made to use this parameter for warnings or errors during input parsing.
%      A logical that controls whether warnings and other output will be printed to the command
%      window. Errors can't be turned off. [default=true;]
%      Specifying print_to_fid, print_to_obj, or print_to_fcn will change the default to false,
%      unless parsing of any of the other exception redirection options results in an error.
%   print_to_fid:
%      NB: An attempt is made to use this parameter for warnings or errors during input parsing.
%      The file identifier where console output will be printed. Errors and warnings will be
%      printed including the call stack. You can provide the fid for the command window (fid=1) to
%      print warnings as text. Errors will be printed to the specified file before being actually
%      thrown. [default=[];]
%      If print_to_fid, print_to_obj, and print_to_fcn are all empty, this will have the effect of
%      suppressing every output except errors.
%      Array inputs are allowed.
%   print_to_obj:
%      NB: An attempt is made to use this parameter for warnings or errors during input parsing.
%      The handle to an object with a String property, e.g. an edit field in a GUI where console
%      output will be printed. Messages with newline characters (ignoring trailing newlines) will
%      be returned as a cell array. This includes warnings and errors, which will be printed
%      without the call stack. Errors will be written to the object before the error is actually
%      thrown. [default=[];]
%      If print_to_fid, print_to_obj, and print_to_fcn are all empty, this will have the effect of
%      suppressing every output except errors.
%      Array inputs are allowed.
%   print_to_fcn:
%      NB: An attempt is made to use this parameter for warnings or errors during input parsing.
%      A struct with a function handle, anonymous function or inline function in the 'h' field and
%      optionally additional data in the 'data' field. The function should accept three inputs: a
%      char array (either 'warning' or 'error'), a struct with the message, id, and stack, and the
%      optional additional data. The function(s) will be run before the error is actually thrown.
%      [default=[];]
%      If print_to_fid, print_to_obj, and print_to_fcn are all empty, this will have the effect of
%      suppressing every output except errors.
%      Array inputs are allowed.
%   print_to_params:
%      NB: An attempt is made to use this parameter for warnings or errors during input parsing.
%      This struct contains the optional parameters for the error_ and warning_ functions.
%      Each field can also be specified as ['print_to_option_' parameter_name]. This can be used to
%      avoid nested struct definitions.
%      ShowTraceInMessage:
%        [default=false] Show the function trace in the message section. Unlike the normal results
%        of rethrow/warning, this will not result in clickable links.
%      WipeTraceForBuiltin:
%        [default=false] Wipe the trace so the rethrow/warning only shows the error/warning message
%        itself. Note that the wiped trace contains the calling line of code (along with the
%        function name and line number), while the generated trace does not.
%
% Syntax:
%   error_(options,msg)
%   error_(options,msg,A1,...,An)
%   error_(options,id,msg)
%   error_(options,id,msg,A1,...,An)
%   error_(options,ME)               %equivalent to rethrow(ME)
%
% Examples options struct:
%   % Write to a log file:
%   opts = struct;opts.fid = fopen('log.txt','wt');
%   % Display to a status window and bypass the command window:
%   opts = struct;opts.boolean.con = false;opts.obj = uicontrol_object_handle;
%   % Write to 2 log files:
%   opts = struct;opts.fid = [fopen('log2.txt','wt') fopen('log.txt','wt')];

persistent this_fun
if isempty(this_fun),this_fun = func2str(@error_);end

% Parse options struct, allowing an empty input to revert to default.
if isempty(options),options = struct;end
checkpoint('error_','parse_warning_error_redirect_options')
options                    = parse_warning_error_redirect_options(  options  );
checkpoint('error_','parse_warning_error_redirect_inputs')
[id,msg,stack,trace,no_op] = parse_warning_error_redirect_inputs( varargin{:});
if no_op,return,end
forced_trace = trace;
if options.params.ShowTraceInMessage
    msg = sprintf('%s\n%s',msg,trace);
end
ME = struct('identifier',id,'message',msg,'stack',stack);
if options.params.WipeTraceForBuiltin
    ME.stack = stack('name','','file','','line',[]);
end

% Print to object.
if options.boolean.obj
    msg_ = msg;while msg_(end)==10,msg_(end) = '';end % Crop trailing newline.
    if any(msg_==10)  % Parse to cellstr and prepend 'Error: '.
        checkpoint('error_','char2cellstr')
        msg_ = char2cellstr(['Error: ' msg_]);
    else              % Only prepend 'Error: '.
        msg_ = ['Error: ' msg_];
    end
    for OBJ=reshape(options.obj,1,[])
        try set(OBJ,'String',msg_);catch,end
    end
end

% Print to file.
if options.boolean.fid
    T = datestr(now,31); %#ok<DATST,TNOW1> Print the time of the error to the log as well.
    for FID=reshape(options.fid,1,[])
        try fprintf(FID,'[%s] Error: %s\n%s',T,msg,trace);catch,end
    end
end

% Run function.
if options.boolean.fcn
    if ismember(this_fun,{stack.name})
        % To prevent an infinite loop, trigger an error.
        error('prevent recursion')
    end
    ME_ = ME;ME_.trace = forced_trace;
    for FCN=reshape(options.fcn,1,[])
        if isfield(FCN,'data')
            try feval(FCN.h,'error',ME_,FCN.data);catch,end
        else
            try feval(FCN.h,'error',ME_);catch,end
        end
    end
end

% Actually throw the error.
rethrow(ME)
end
function flag=get_MatFileFlag
% This returns '-mat' on Octave (and on pre-v7 Matlab) and '-v6' on Matlab.
% The goal is to allow saving a mat file that can be read on all Matlab and Octave releases.
persistent MatFileFlag
if isempty(MatFileFlag)
    % We could use simple logic, but by using the ifversion function, we can make sure we only need
    % to change 1 function if we want to enabel code generation. In that case calls to version and
    % exist are problematic.
    checkpoint('get_MatFileFlag','ifversion')
    if ifversion('<',7,'Octave','>',0)
        MatFileFlag = '-mat';
    else
        MatFileFlag = '-v6';
    end
end
flag = MatFileFlag;
end
function [str,stack]=get_trace(skip_layers,stack)
if nargin==0,skip_layers = 1;end
if nargin<2, stack = dbstack;end
stack(1:skip_layers) = [];

% Parse the ML6.5 style of dbstack (the name field includes full file location).
if ~isfield(stack,'file')
    for n=1:numel(stack)
        tmp = stack(n).name;
        if strcmp(tmp(end),')')
            % Internal function.
            ind = strfind(tmp,'(');
            name = tmp( (ind(end)+1):(end-1) );
            file = tmp(1:(ind(end)-2));
        else
            file = tmp;
            [ignore,name] = fileparts(tmp); %#ok<ASGLU>
        end
        [ignore,stack(n).file] = fileparts(file); %#ok<ASGLU>
        stack(n).name = name;
    end
end

% Parse Octave style of dbstack (the file field includes full file location).
checkpoint('get_trace','ifversion')
persistent isOctave,if isempty(isOctave),isOctave=ifversion('<',0,'Octave','>',0);end
if isOctave
    for n=1:numel(stack)
        [ignore,stack(n).file] = fileparts(stack(n).file); %#ok<ASGLU>
    end
end

% Create the char array with a (potentially) modified stack.
s = stack;
c1 = '>';
str = cell(1,numel(s)-1);
for n=1:numel(s)
    [ignore_path,s(n).file,ignore_ext] = fileparts(s(n).file); %#ok<ASGLU>
    if n==numel(s),s(n).file = '';end
    if strcmp(s(n).file,s(n).name),s(n).file = '';end
    if ~isempty(s(n).file),s(n).file = [s(n).file '>'];end
    str{n} = sprintf('%c In %s%s (line %d)\n',c1,s(n).file,s(n).name,s(n).line);
    c1 = ' ';
end
str = horzcat(str{:});
end
function[v000,v001]=GetWritableFolder(varargin),[v002,v003,v004]=...
GetWritableFolder_f01(varargin{:});if~v002,rethrow(v004),else,[v005,v006,v007]=...
deal(v003.ForceStatus,v003.ErrorOnNotFound,v003.root_folder_list);end,v007{end}=pwd;if v005,...
v001=v005;v000=fullfile(v007{v001},'PersistentFolder');try if~exist(v000,'dir'),...
GetWritableFolder_f02(v000);end,catch,end,return,end,v001=1;v000=v007{v001};try if~exist(v000,...
'dir'),GetWritableFolder_f02(v000);end,catch,end,if~GetWritableFolder_f08(v000),v001=2;v000=...
v007{v001};try if~exist(v000,'dir'),GetWritableFolder_f02(v000);end,catch,end,...
if~GetWritableFolder_f08(v000),v001=3;v000=v007{v001};end,end,v000=fullfile(v000,...
'PersistentFolder');try if~exist(v000,'dir'),GetWritableFolder_f02(v000);end,catch,end,...
if~GetWritableFolder_f08(v000),if v006,error('HJW:GetWritableFolder:NoWritableFolder',...
'This function was unable to find a folder with write permissions.'),else,v001=0;v000='';end,...
end,end
function v002=GetWritableFolder_f00,if ispc,[v000,v001]=system('echo %APPDATA%');v001(v001<14)=...
'';v002=fullfile(v001,'MathWorks','MATLAB Add-Ons');else,[v000,v003]=system('echo $HOME');
v003(v003<14)='';v002=fullfile(v003,'Documents','MATLAB','Add-Ons');end,end
function[v000,v001,v002]=GetWritableFolder_f01(varargin),v000=false;v002=struct('identifier','',...
'message','');persistent v003,if isempty(v003),v003.ForceStatus=false;v003.ErrorOnNotFound=...
false;v003.root_folder_list={GetWritableFolder_f00;fullfile(tempdir,'MATLAB');''};end,if ...
nargin==2,v001=v003;v000=true;return,end,[v001,v004]=GetWritableFolder_f04(v003,varargin{:});
for v005=1:numel(v004),v006=v004{v005};v007=v001.(v006);v002.identifier=...
['HJW:GetWritableFolder:incorrect_input_opt_' lower(v006)];switch v006,case'ForceStatus',try ...
if~isa(v003.root_folder_list{v007},'char'),...
error('the indexing must have failed, trigger error'),end,catch,v002.message=...
sprintf('Invalid input: expected a scalar integer between 1 and %d.',...
numel(v003.root_folder_list));return,end,case'ErrorOnNotFound',[v008,v001.ErrorOnNotFound]=...
GetWritableFolder_f07(v007);if~v008,v002.message=...
'ErrorOnNotFound should be either true or false.';return,end,otherwise,v002.message=...
sprintf('Name,Value pair not recognized: %s.',v006);v002.identifier=...
'HJW:GetWritableFolder:incorrect_input_NameValue';return,end,end,v000=true;v002=[];end
function varargout=GetWritableFolder_f02(v000),if exist(v000,'dir'),return,end,persistent v001,...
if isempty(v001),v001=GetWritableFolder_f09('<','R2007b','Octave','<',0);end,varargout=cell(1,...
nargout);if v001,[v002,v003]=fileparts(v000);[varargout{:}]=mkdir(v002,v003);else,...
[varargout{:}]=mkdir(v000);end,end
function v000=GetWritableFolder_f03(v000),v000=fix(v000+eps*1e3);end
function[v000,v001]=GetWritableFolder_f04(v002,varargin),switch numel(v002),case 0,...
error('parse_NameValue:MixedOrBadSyntax',...
'Optional inputs must be entered as Name,Value pairs or as a scalar struct.'),case 1,otherwise,...
v002=v002(1);end,v000=v002;v001={};if nargin==1,return,end,try v003=numel(varargin)==...
1&&isa(varargin{1},'struct');v004=mod(numel(varargin),2)==0&&all(cellfun('isclass',...
varargin(1:2:end),'char')|cellfun('isclass',varargin(1:2:end),'string'));if~(v003||v004),...
error('trigger'),end,if nargin==2,v005=fieldnames(varargin{1});v006=struct2cell(varargin{1});
else,v005=cellstr(varargin(1:2:end));v006=varargin(2:2:end);end,if~iscellstr(v005),...
error('trigger');end,catch,error('parse_NameValue:MixedOrBadSyntax',...
'Optional inputs must be entered as Name,Value pairs or as a scalar struct.'),end,v007=...
fieldnames(v002);v008=cell(1,4);v009{1}=v007;v009{2}=lower(v009{1});v009{3}=strrep(v009{2},'_',...
'');v009{4}=strrep(v009{3},'-','');v005=strrep(v005,' ','_');v001=false(size(v007));for v010=...
1:numel(v005),v011=v005{v010};[v012,v008{1}]=GetWritableFolder_f05(v008{1},v009{1},v011);if ...
numel(v012)~=1,v011=lower(v011);[v012,v008{2}]=GetWritableFolder_f05(v008{2},v009{2},v011);end,...
if numel(v012)~=1,v011=strrep(v011,'_','');[v012,v008{3}]=GetWritableFolder_f05(v008{3},v009{3},...
v011);end,if numel(v012)~=1,v011=strrep(v011,'-','');[v012,v008{4}]=...
GetWritableFolder_f05(v008{4},v009{4},v011);end,if numel(v012)~=1,...
error('parse_NameValue:NonUniqueMatch',v005{v010}),end,v000.(v007{v012})=v006{v010};v001(v012)=...
true;end,v001=v007(v001);end
function[v000,v001]=GetWritableFolder_f05(v001,v002,v003),v000=find(ismember(v002,v003));if ...
numel(v000)==1,return,end,if isempty(v001),v001=GetWritableFolder_f06(v002);end,v004=v001(:,...
1:min(end,numel(v003)));if size(v004,2)<numel(v003),v004=[v004 repmat(' ',size(v004,1),...
numel(v003)-size(v004,2))];end,v005=numel(v003)-sum(cumprod(double(v004==repmat(v003,size(v004,...
1),1)),2),2);v000=find(v005==0);end
function v000=GetWritableFolder_f06(v000),v001=cellfun('prodofsize',v000);v002=max(v001);for ...
v003=find(v001<v002).',v000{v003}((end+1):v002)=' ';end,v000=vertcat(v000{:});end
function[v000,v001]=GetWritableFolder_f07(v001),persistent v002,if isempty(v002),v002={true,...
false;1,0;'true','false';'1','0';'on','off';'enable','disable';'enabled','disabled'};end,if ...
isa(v001,'matlab.lang.OnOffSwitchState'),v000=true;v001=logical(v001);return,end,if isa(v001,...
'string'),if numel(v001)~=1,v000=false;return,else,v001=char(v001);end,end,if isa(v001,'char'),...
v001=lower(v001);end,for v003=1:size(v002,1),for v004=1:2,if isequal(v001,v002{v003,v004}),v000=...
true;v001=v002{1,v004};return,end,end,end,v000=false;end
function v000=GetWritableFolder_f08(v001),if~(isempty(v001)||exist(v001,'dir')),v000=false;
return,end,v002='';while isempty(v002)||exist(v002,'file'),[v003,v002]=...
fileparts(GetWritableFolder_f10('write_permission_test_','.txt'));v002=fullfile(v001,v002);end,...
try v004=fopen(v002,'w');fprintf(v004,'test');fclose(v004);delete(v002);v000=true;catch,if ...
exist(v002,'file'),try delete(v002);catch,end,end,v000=false;end,end
function v000=GetWritableFolder_f09(v001,v002,v003,v004,v005),if nargin<2||nargout>1,...
error('incorrect number of input/output arguments'),end,persistent v006 v007 v008,if ...
isempty(v006),v008=exist('OCTAVE_VERSION','builtin');v006=[100,1] * sscanf(version,'%d.%d',2);
v007={'R13' 605;'R13SP1' 605;'R13SP2' 605;'R14' 700;'R14SP1' 700;'R14SP2' 700;'R14SP3' 701;
'R2006a' 702;'R2006b' 703;'R2007a' 704;'R2007b' 705;'R2008a' 706;'R2008b' 707;'R2009a' 708;
'R2009b' 709;'R2010a' 710;'R2010b' 711;'R2011a' 712;'R2011b' 713;'R2012a' 714;'R2012b' 800;
'R2013a' 801;'R2013b' 802;'R2014a' 803;'R2014b' 804;'R2015a' 805;'R2015b' 806;'R2016a' 900;
'R2016b' 901;'R2017a' 902;'R2017b' 903;'R2018a' 904;'R2018b' 905;'R2019a' 906;'R2019b' 907;
'R2020a' 908;'R2020b' 909;'R2021a' 910;'R2021b' 911;'R2022a' 912;'R2022b' 913;'R2023a' 914};end,...
if v008,if nargin==2,warning('HJW:ifversion:NoOctaveTest',...
['No version test for Octave was provided.',char(10),...
'This function might return an unexpected outcome.']),if isnumeric(v002),v009=...
0.1*v002+0.9*GetWritableFolder_f03(v002);v009=round(100*v009);else,v010=ismember(v007(:,1),...
v002);if sum(v010)~=1,warning('HJW:ifversion:NotInDict',...
'The requested version is not in the hard-coded list.'),v000=NaN;return,else,v009=v007{v010,2};
end,end,elseif nargin==4,[v001,v009]=deal(v003,v004);v009=...
0.1*v009+0.9*GetWritableFolder_f03(v009);v009=round(100*v009);else,[v001,v009]=deal(v004,v005);
v009=0.1*v009+0.9*GetWritableFolder_f03(v009);v009=round(100*v009);end,else,if isnumeric(v002),...
v009=GetWritableFolder_f03(v002*100);if mod(v009,10)==0,v009=...
GetWritableFolder_f03(v002)*100+mod(v002,1)*10;end,else,v010=ismember(v007(:,1),v002);if ...
sum(v010)~=1,warning('HJW:ifversion:NotInDict',...
'The requested version is not in the hard-coded list.'),v000=NaN;return,else,v009=v007{v010,2};
end,end,end,switch v001,case'==',v000=v006==v009;case'<',v000=v006 < v009;case'<=',v000=v006 <=...
v009;case'>',v000=v006 > v009;case'>=',v000=v006 >=v009;end,end
function v000=GetWritableFolder_f10(v001,v002),if nargin<1,v001='';end,if~isempty(v001),v001=...
[v001 '_'];end,if nargin<2,v002='';else,if~strcmp(v002(1),'.'),v002=['.' v002];end,end,v000=...
tempname;[v003,v004]=fileparts(v000);v000=fullfile(v003,[v001 v004 v002]);end
function tf=hasFeature(feature)
% Provide a single point to encode whether specific features are available.
persistent FeatureList
if isempty(FeatureList)
    checkpoint('hasFeature','ifversion')
    FeatureList = struct(...
        'HG2'              ,ifversion('>=','R2014b','Octave','<' ,0),...
        'ImplicitExpansion',ifversion('>=','R2016b','Octave','>' ,0),...
        'bsxfun'           ,ifversion('>=','R2007a','Octave','>' ,0),...
        'IntegerArithmetic',ifversion('>=','R2010b','Octave','>' ,0),...
        'String'           ,ifversion('>=','R2016b','Octave','<' ,0),...
        'HTTPS_support'    ,ifversion('>' ,0       ,'Octave','<' ,0),...
        'json'             ,ifversion('>=','R2016b','Octave','>=',7),...
        'strtrim'          ,ifversion('>=',7       ,'Octave','>=',0),...
        'accumarray'       ,ifversion('>=',7       ,'Octave','>=',0));
    checkpoint('hasFeature','CharIsUTF8')
    FeatureList.CharIsUTF8 = CharIsUTF8;
end
tf = FeatureList.(feature);
end
function v000=ifversion(v001,v002,v003,v004,v005),if nargin<2||nargout>1,...
error('incorrect number of input/output arguments'),end,persistent v006 v007 v008,if ...
isempty(v006),v008=exist('OCTAVE_VERSION','builtin');v006=[100,1] * sscanf(version,'%d.%d',2);
v007={'R13' 605;'R13SP1' 605;'R13SP2' 605;'R14' 700;'R14SP1' 700;'R14SP2' 700;'R14SP3' 701;
'R2006a' 702;'R2006b' 703;'R2007a' 704;'R2007b' 705;'R2008a' 706;'R2008b' 707;'R2009a' 708;
'R2009b' 709;'R2010a' 710;'R2010b' 711;'R2011a' 712;'R2011b' 713;'R2012a' 714;'R2012b' 800;
'R2013a' 801;'R2013b' 802;'R2014a' 803;'R2014b' 804;'R2015a' 805;'R2015b' 806;'R2016a' 900;
'R2016b' 901;'R2017a' 902;'R2017b' 903;'R2018a' 904;'R2018b' 905;'R2019a' 906;'R2019b' 907;
'R2020a' 908;'R2020b' 909;'R2021a' 910;'R2021b' 911;'R2022a' 912;'R2022b' 913;'R2023a' 914};end,...
if v008,if nargin==2,warning('HJW:ifversion:NoOctaveTest',...
['No version test for Octave was provided.',char(10),...
'This function might return an unexpected outcome.']),if isnumeric(v002),v009=...
0.1*v002+0.9*ifversion_f00(v002);v009=round(100*v009);else,v010=ismember(v007(:,1),v002);if ...
sum(v010)~=1,warning('HJW:ifversion:NotInDict',...
'The requested version is not in the hard-coded list.'),v000=NaN;return,else,v009=v007{v010,2};
end,end,elseif nargin==4,[v001,v009]=deal(v003,v004);v009=0.1*v009+0.9*ifversion_f00(v009);v009=...
round(100*v009);else,[v001,v009]=deal(v004,v005);v009=0.1*v009+0.9*ifversion_f00(v009);v009=...
round(100*v009);end,else,if isnumeric(v002),v009=ifversion_f00(v002*100);if mod(v009,10)==0,...
v009=ifversion_f00(v002)*100+mod(v002,1)*10;end,else,v010=ismember(v007(:,1),v002);if ...
sum(v010)~=1,warning('HJW:ifversion:NotInDict',...
'The requested version is not in the hard-coded list.'),v000=NaN;return,else,v009=v007{v010,2};
end,end,end,switch v001,case'==',v000=v006==v009;case'<',v000=v006 < v009;case'<=',v000=v006 <=...
v009;case'>',v000=v006 > v009;case'>=',v000=v006 >=v009;end,end
function v000=ifversion_f00(v000),v000=fix(v000+eps*1e3);end
function tf=ifversion___skip_test
% Some runtimes are very twitchy about tests involving graphics. This function lists them so there
% is only a single place I need to turn them off.
persistent tf_
if isempty(tf_)
    checkpoint('ifversion___skip_test','ifversion')
    OldLinuxMatlab = isunix && ~ismac && ifversion('<','R2013a','Octave','<',0);
    checkpoint('ifversion___skip_test','ifversion')
    MacOctave = ifversion('<',0,'Octave','>',0) && ismac;
    skip = OldLinuxMatlab||MacOctave;
    
    % If the release can not be hardcoded, check two other ways to figure out whether graphics are
    % truly supported.
    if ~skip
        % If figures don't work without warnings, no graphics are likely to work.
        [str,works] = evalc(func2str(@test_figure_available)); %#ok<ASGLU>
        skip = ~works;
        if works
            % The online run tool on Matlab Answers allows figures, but doesn't allow waitbars.
            [str,works] = evalc(func2str(@test_waitbar_available)); %#ok<ASGLU>
            skip = ~works;
        end
    end
    tf_ = skip;
end
tf = tf_;
end
function tf=test_figure_available
try
    [w_msg,w_id] = lastwarn('BLANK','BLANK:BLANK');
    delete(figure);
    [w_msg,w_id] = lastwarn(w_msg,w_id);
    if strcmp(w_id,'BLANK:BLANK') && strcmp(w_msg,'BLANK')
        % No warning occurred.
        tf = true;
    else
        clc % Clear the warnings that were generated.
        error('trigger')
    end
catch
    lastwarn(w_msg,w_id); % Reset lastwarn state.
    tf = false;
end
end
function tf=test_waitbar_available
try
    delete(waitbar(0,'test if GUI is available'));
    tf = true;
catch
    tf = false;
end
end
function varargout=makedir(d)
% Wrapper function to account for old Matlab releases, where mkdir fails if the parent folder does
% not exist. This function will use the legacy syntax for those releases.
if exist(d,'dir'),return,end % Take a shortcut if the folder already exists.
persistent IsLegacy
if isempty(IsLegacy)
    % The behavior changed after R14SP3 and before R2007b, but since the legacy syntax will still
    % work in later releases there isn't really a reason to pinpoint the exact release.
    checkpoint('makedir','ifversion')
    IsLegacy = ifversion('<','R2007b','Octave','<',0);
end
varargout = cell(1,nargout);
if IsLegacy
    [d_parent,d_target] = fileparts(d);
    [varargout{:}] = mkdir(d_parent,d_target);
else
    [varargout{:}] = mkdir(d);
end
end
function [opts,replaced]=parse_NameValue(default,varargin)
%Match the Name,Value pairs to the default option, attempting to autocomplete
%
% The autocomplete ignores incomplete names, case, underscores, and dashes, as long as a unique
% match can be found.
%
% The first output is a struct with the same fields as the first input, with field contents
% replaced according to the supplied options struct or Name,Value pairs.
% The second output is a cellstr containing the field names that have been set.
%
% If this fails to find a match, this will throw an error with the offending name as the message.
%
% If there are multiple occurrences of a Name, only the last Value will be returned. This is the
% same as Matlab internal functions like plot. GNU Octave also has this behavior.
%
% If a struct array is provided, only the first element will be used. An empty struct array will
% trigger an error.

switch numel(default)
    case 0
        error('parse_NameValue:MixedOrBadSyntax',...
            'Optional inputs must be entered as Name,Value pairs or as a scalar struct.')
    case 1
        % Do nothing.
    otherwise
        % If this is a struct array, explicitly select the first element.
        default=default(1);
end

% Create default output and return if no other inputs exist.
opts = default;replaced = {};
if nargin==1,return,end

% Unwind an input struct to Name,Value pairs.
try
    struct_input = numel(varargin)==1 && isa(varargin{1},'struct');
    NameValue_input = mod(numel(varargin),2)==0 && all(...
        cellfun('isclass',varargin(1:2:end),'char'  ) | ...
        cellfun('isclass',varargin(1:2:end),'string')   );
    if ~( struct_input || NameValue_input )
        error('trigger')
    end
    if nargin==2
        Names = fieldnames(varargin{1});
        Values = struct2cell(varargin{1});
    else
        % Wrap in cellstr to account for strings (this also deals with the fun(Name=Value) syntax).
        Names = cellstr(varargin(1:2:end));
        Values = varargin(2:2:end);
    end
    if ~iscellstr(Names),error('trigger');end %#ok<ISCLSTR>
catch
    % If this block errors, that is either because a missing Value with the Name,Value syntax, or
    % because the struct input is not a struct, or because an attempt was made to mix the two
    % styles. In future versions of this functions an effort might be made to handle such cases.
    error('parse_NameValue:MixedOrBadSyntax',...
        'Optional inputs must be entered as Name,Value pairs or as a scalar struct.')
end

% The fieldnames will be converted to char matrices in the section below. First an exact match is
% tried, then a case-sensitive (partial) match, then ignoring case, followed by ignoring any
% underscores, and lastly ignoring dashes.
default_Names = fieldnames(default);
Names_char    = cell(1,4);
Names_cell{1} = default_Names;
Names_cell{2} = lower(Names_cell{1});
Names_cell{3} = strrep(Names_cell{2},'_','');
Names_cell{4} = strrep(Names_cell{3},'-','');

% Allow spaces by replacing them with underscores.
Names = strrep(Names,' ','_');

% Attempt to match the names.
replaced = false(size(default_Names));
for n=1:numel(Names)
    name = Names{n};
    
    % Try a case-sensitive match.
    [match_idx,Names_char{1}] = parse_NameValue__find_match(Names_char{1},Names_cell{1},name);
    
    % Try a case-insensitive match.
    if numel(match_idx)~=1
        name = lower(name);
        [match_idx,Names_char{2}] = parse_NameValue__find_match(Names_char{2},Names_cell{2},name);
    end
    
    % Try a case-insensitive match ignoring underscores.
    if numel(match_idx)~=1
        name = strrep(name,'_','');
        [match_idx,Names_char{3}] = parse_NameValue__find_match(Names_char{3},Names_cell{3},name);
    end
    
    % Try a case-insensitive match ignoring underscores and dashes.
    if numel(match_idx)~=1
        name = strrep(name,'-','');
        [match_idx,Names_char{4}] = parse_NameValue__find_match(Names_char{4},Names_cell{4},name);
    end
    
    if numel(match_idx)~=1
        error('parse_NameValue:NonUniqueMatch',Names{n})
    end
    
    % Store the Value in the output struct and mark it as replaced.
    opts.(default_Names{match_idx}) = Values{n};
    replaced(match_idx)=true;
end
replaced = default_Names(replaced);
end
function [match_idx,Names_char]=parse_NameValue__find_match(Names_char,Names_cell,name)
% Try to match the input field to the fields of the struct.

% First attempt an exact match.
match_idx = find(ismember(Names_cell,name));
if numel(match_idx)==1,return,end

% Only spend time building the char array if this point is reached.
if isempty(Names_char),Names_char = parse_NameValue__name2char(Names_cell);end

% Since the exact match did not return a unique match, attempt to match the start of each array.
% Select the first part of the array. Since Names is provided by the user it might be too long.
tmp = Names_char(:,1:min(end,numel(name)));
if size(tmp,2)<numel(name)
    tmp = [tmp repmat(' ', size(tmp,1) , numel(name)-size(tmp,2) )];
end

% Find the number of non-matching characters on every row. The cumprod on the logical array is
% to make sure that only the starting match is considered.
non_matching = numel(name)-sum(cumprod(double(tmp==repmat(name,size(tmp,1),1)),2),2);
match_idx = find(non_matching==0);
end
function Names_char=parse_NameValue__name2char(Names_char)
% Convert a cellstr to a padded char matrix.
len = cellfun('prodofsize',Names_char);maxlen = max(len);
for n=find(len<maxlen).' % Pad with spaces where needed
    Names_char{n}((end+1):maxlen) = ' ';
end
Names_char = vertcat(Names_char{:});
end
function [opts,named_fields]=parse_print_to___get_default
% This returns the default struct for use with warning_ and error_. The second output contains all
% the possible field names that can be used with the parser.
persistent opts_ named_fields_
if isempty(opts_)
    [opts_,named_fields_] = parse_print_to___get_default_helper;
end
opts = opts_;
named_fields = named_fields_;
end
function [opts_,named_fields_]=parse_print_to___get_default_helper
default_params = struct(...
    'ShowTraceInMessage',false,...
    'WipeTraceForBuiltin',false);
opts_ = struct(...
    'params',default_params,...
    'fid',[],...
    'obj',[],...
    'fcn',struct('h',{},'data',{}),...
    'boolean',struct('con',[],'fid',false,'obj',false,'fcn',false,'IsValidated',false));
named_fields_params = fieldnames(default_params);
for n=1:numel(named_fields_params)
    named_fields_params{n} = ['option_' named_fields_params{n}];
end
named_fields_ = [...
    {'params'};
    named_fields_params;...
    {'con';'fid';'obj';'fcn'}];
for n=1:numel(named_fields_)
    named_fields_{n} = ['print_to_' named_fields_{n}];
end
named_fields_ = sort(named_fields_);
end
function opts=parse_print_to___named_fields_to_struct(named_struct)
% This function parses the named fields (print_to_con, print_to_fcn, etc) to the option struct
% syntax that warning_ and error_ expect. Any additional fields are ignored.
% Note that this function will not validate the contents after parsing and the validation flag will
% be set to false.
%
% Input struct:
% options.print_to_con=true;      % or false
% options.print_to_fid=fid;       % or []
% options.print_to_obj=h_obj;     % or []
% options.print_to_fcn=struct;    % or []
% options.print_to_params=struct; % or []
%
% Output struct:
% options.params
% options.fid
% options.obj
% options.fcn.h
% options.fcn.data
% options.boolean.con
% options.boolean.fid
% options.boolean.obj
% options.boolean.fcn
% options.boolean.IsValidated

persistent default print_to_option__field_names_in print_to_option__field_names_out
if isempty(print_to_option__field_names_in)
    % Generate the list of options that can be set by name.
    checkpoint('parse_print_to___named_fields_to_struct','parse_print_to___get_default')
    [default,print_to_option__field_names_in] = parse_print_to___get_default;
    pattern = 'print_to_option_';
    for n=numel(print_to_option__field_names_in):-1:1
        if ~strcmp(pattern,print_to_option__field_names_in{n}(1:min(end,numel(pattern))))
            print_to_option__field_names_in( n)=[];
        end
    end
    print_to_option__field_names_out = strrep(print_to_option__field_names_in,pattern,'');
end

opts = default;

if isfield(named_struct,'print_to_params')
    opts.params = named_struct.print_to_params;
else
    % There might be param fields set with ['print_to_option_' parameter_name].
    for n=1:numel(print_to_option__field_names_in)
        field_in = print_to_option__field_names_in{n};
        if isfield(named_struct,print_to_option__field_names_in{n})
            field_out = print_to_option__field_names_out{n};
            opts.params.(field_out) = named_struct.(field_in);
        end
    end
end

if isfield(named_struct,'print_to_fid'),opts.fid = named_struct.print_to_fid;end
if isfield(named_struct,'print_to_obj'),opts.obj = named_struct.print_to_obj;end
if isfield(named_struct,'print_to_fcn'),opts.fcn = named_struct.print_to_fcn;end
if isfield(named_struct,'print_to_con'),opts.boolean.con = named_struct.print_to_con;end
opts.boolean.IsValidated = false;
end
function [isValid,ME,opts]=parse_print_to___validate_struct(opts)
% This function will validate all interactions. If a third output is requested, any invalid targets
% will be removed from the struct so the remaining may still be used.
% Any failures will result in setting options.boolean.con to true.
%
% NB: Validation will be skipped if opts.boolean.IsValidated is set to true.

% Initialize some variables.
AllowFailed = nargout>=3;
ME=struct('identifier','','message','');
isValid = true;
if nargout>=3,AllowFailed = true;end

% Check to see whether the struct has already been verified.
checkpoint('parse_print_to___validate_struct','test_if_scalar_logical')
[passed,IsValidated] = test_if_scalar_logical(opts.boolean.IsValidated);
if passed && IsValidated
    return
end

% Parse the logical that determines if a warning will be printed to the command window.
% This is true by default, unless an fid, obj, or fcn is specified, which is ensured elsewhere. If
% the fid/obj/fcn turn out to be invalid, this will revert to true at the end of this function.
checkpoint('parse_print_to___validate_struct','test_if_scalar_logical')
[passed,opts.boolean.con] = test_if_scalar_logical(opts.boolean.con);
if ~passed && ~isempty(opts.boolean.con)
    ME.message = ['Invalid print_to_con parameter:',char(10),...
        'should be a scalar logical or empty double.']; %#ok<CHARTEN>
    ME.identifier = 'HJW:print_to:ValidationFailed';
    isValid = false;
    if ~AllowFailed,return,end
end

[ErrorFlag,opts.fid] = validate_fid(opts.fid);
if ErrorFlag
    ME.message = ['Invalid print_to_fid parameter:',char(10),...
        'should be a valid file identifier or 1.']; %#ok<CHARTEN>
    ME.identifier = 'HJW:print_to:ValidationFailed';
    isValid = false;
    if ~AllowFailed,return,end
end
opts.boolean.fid = ~isempty(opts.fid);

[ErrorFlag,opts.obj]=validate_obj(opts.obj);
if ErrorFlag
    ME.message = ['Invalid print_to_obj parameter:',char(10),...
        'should be a handle to an object with a writeable String property.']; %#ok<CHARTEN>
    ME.identifier = 'HJW:print_to:ValidationFailed';
    isValid = false;
    if ~AllowFailed,return,end
end
opts.boolean.obj = ~isempty(opts.obj);

[ErrorFlag,opts.fcn]=validate_fcn(opts.fcn);
if ErrorFlag
    ME.message = ['Invalid print_to_fcn parameter:',char(10),...
        'should be a struct with the h field containing a function handle,',char(10),...
        'anonymous function or inline function.']; %#ok<CHARTEN>
    ME.identifier = 'HJW:print_to:ValidationFailed';
    isValid = false;
    if ~AllowFailed,return,end
end
opts.boolean.fcn = ~isempty(opts.fcn);

[ErrorFlag,opts.params]=validate_params(opts.params);
if ErrorFlag
    ME.message = ['Invalid print_to____params parameter:',char(10),...
        'should be a scalar struct uniquely matching parameter names.']; %#ok<CHARTEN>
    ME.identifier = 'HJW:print_to:ValidationFailed';
    isValid = false;
    if ~AllowFailed,return,end
end

if isempty(opts.boolean.con)
    % Set default value.
    opts.boolean.con = ~any([opts.boolean.fid opts.boolean.obj opts.boolean.fcn]);
end

if ~isValid
    % If any error is found, enable the print to the command window to ensure output to the user.
    opts.boolean.con = true;
end

% While not all parameters may be present from the input struct, the resulting struct is as much
% validated as is possible to test automatically.
opts.boolean.IsValidated = true;
end
function [ErrorFlag,item]=validate_fid(item)
% Parse the fid. We can use ftell to determine if fprintf is going to fail.
ErrorFlag = false;
for n=numel(item):-1:1
    try position = ftell(item(n));catch,position = -1;end
    if item(n)~=1 && position==-1
        ErrorFlag = true;
        item(n)=[];
    end
end
end
function [ErrorFlag,item]=validate_obj(item)
% Parse the object handle. Retrieving from multiple objects at once works, but writing that output
% back to multiple objects doesn't work if Strings are dissimilar.
ErrorFlag = false;
for n=numel(item):-1:1
    try
        txt = get(item(n),'String'    ); % See if this triggers an error.
        set(      item(n),'String','' ); % Test if property is writable.
        set(      item(n),'String',txt); % Restore original content.
    catch
        ErrorFlag = true;
        item(n)=[];
    end
end
end
function [ErrorFlag,item]=validate_fcn(item)
% Parse the function handles. There is no convenient way to test whether the function actually
% accepts the inputs.
ErrorFlag = false;
for n=numel(item):-1:1
    if ~isa(item,'struct') || ~isfield(item,'h') ||...
            ~ismember(class(item(n).h),{'function_handle','inline'}) || numel(item(n).h)~=1
        ErrorFlag = true;
        item(n)=[];
    end
end
end
function [ErrorFlag,item]=validate_params(item)
% Fill any missing options with defaults. If the input is not a struct, this will return the
% defaults. Any fields that cause errors during parsing are ignored.
ErrorFlag = false;
persistent default_params
if isempty(default_params)
    checkpoint('parse_print_to___validate_struct','parse_print_to___get_default')
    default_params = parse_print_to___get_default;
    default_params = default_params.params;
end
if isempty(item),item=struct;end
if ~isa(item,'struct'),ErrorFlag = true;item = default_params;return,end
while true
    try MExc = []; %#ok<NASGU>
        checkpoint('parse_print_to___validate_struct','parse_NameValue')
        [item,replaced] = parse_NameValue(default_params,item);
        break
    catch MExc;if isempty(MExc),MExc = lasterror;end %#ok<LERR>
        ErrorFlag = true;
        % Remove offending field as option and retry. This will terminate, as removing all
        % fields will result in replacing the struct with the default.
        item = rmfield(item,MExc.message);
    end
end
for n=1:numel(replaced)
    p = replaced{n};
    switch p
        case 'ShowTraceInMessage'
            checkpoint('parse_print_to___validate_struct','test_if_scalar_logical')
            [passed,item.(p)] = test_if_scalar_logical(item.(p));
            if ~passed
                ErrorFlag=true;
                item.(p) = default_params.(p);
            end
        case 'WipeTraceForBuiltin'
            checkpoint('parse_print_to___validate_struct','test_if_scalar_logical')
            [passed,item.(p)] = test_if_scalar_logical(item.(p));
            if ~passed
                ErrorFlag=true;
                item.(p) = default_params.(p);
            end
    end
end
end
function [id,msg,stack,trace,no_op]=parse_warning_error_redirect_inputs(varargin)
no_op = false;
if nargin==1
    %  error_(options,msg)
    %  error_(options,ME)
    if isa(varargin{1},'struct') || isa(varargin{1},'MException')
        ME = varargin{1};
        if numel(ME)~=1
            no_op = true;
            [id,msg,stack,trace] = deal('');
            return
        end
        try
            stack = ME.stack; % Use the original call stack if possible.
            checkpoint('parse_warning_error_redirect_inputs','get_trace')
            trace = get_trace(0,stack);
        catch
            checkpoint('parse_warning_error_redirect_inputs','get_trace')
            [trace,stack] = get_trace(3);
        end
        id = ME.identifier;
        msg = ME.message;
        % This line will only appear on older releases.
        pat = 'Error using ==> ';
        if strcmp(msg(1:min(end,numel(pat))),pat)
            % Look for the first newline to strip the entire first line.
            ind = min(find(ismember(double(msg),[10 13]))); %#ok<MXFND>
            if any(double(msg(ind+1))==[10 13]),ind = ind-1;end
            msg(1:ind) = '';
        end
        pat = 'Error using <a href="matlab:matlab.internal.language.introspective.errorDocCallbac';
        % This pattern may occur when using try error(id,msg),catch,ME=lasterror;end instead of
        % catching the MException with try error(id,msg),catch ME,end.
        % This behavior is not stable enough to robustly check for it, but it only occurs with
        % lasterror, so we can use that.
        if isa(ME,'struct') && strcmp( pat , msg(1:min(end,numel(pat))) )
            % Strip the first line (which states 'error in function (line)', instead of only msg).
            msg(1:min(find(msg==10))) = ''; %#ok<MXFND>
        end
    else
        checkpoint('parse_warning_error_redirect_inputs','get_trace')
        [trace,stack] = get_trace(3);
        [id,msg] = deal('',varargin{1});
    end
else
    checkpoint('parse_warning_error_redirect_inputs','get_trace')
    [trace,stack] = get_trace(3);
    if ~isempty(strfind(varargin{1},'%')) % The id can't contain a percent symbol.
        %  error_(options,msg,A1,...,An)
        id = '';
        A1_An = varargin(2:end);
        msg = sprintf(varargin{1},A1_An{:});
    else
        %  error_(options,id,msg)
        %  error_(options,id,msg,A1,...,An)
        id = varargin{1};
        msg = varargin{2};
        if nargin>2
            A1_An = varargin(3:end);
            msg = sprintf(msg,A1_An{:});
        end
    end
end
end
function opts=parse_warning_error_redirect_options(opts)
% The input is either:
% - an empty struct
% - the long form struct (with fields names 'print_to_')
% - the short hand struct (the print_to struct with the fields 'boolean', 'fid', etc)
%
% The returned struct will be a validated short hand struct.

if ...
        isfield(opts,'boolean') && ...
        isfield(opts.boolean,'IsValidated') && ...
        opts.boolean.IsValidated
    % Do not re-check a struct that self-reports to be validated.
    return
end

try
    % First, attempt to replace the default values with the entries in the input struct.
    % If the input is the long form struct, this will fail.
    checkpoint('parse_warning_error_redirect_options','parse_NameValue','parse_print_to___get_default')
    print_to = parse_NameValue(parse_print_to___get_default,opts);
    print_to.boolean.IsValidated = false;
catch
    % Apparently the input is the long form struct, and therefore should be parsed to the short
    % form struct, after which it can be validated.
    checkpoint('parse_warning_error_redirect_options','parse_print_to___named_fields_to_struct')
    print_to = parse_print_to___named_fields_to_struct(opts);
end

% Now we can validate the struct. Here we will ignore any invalid parameters, replacing them with
% the default settings.
checkpoint('parse_warning_error_redirect_options','parse_print_to___validate_struct')
[ignore,ignore,opts] = parse_print_to___validate_struct(print_to); %#ok<ASGLU>
end
function out=PatternReplace(in,pattern,rep)
%Functionally equivalent to strrep, but extended to more data types.
% Any input is converted to a row vector.

in = reshape(in,1,[]);
out = in;
if numel(pattern)==0 || numel(pattern)>numel(in)
    % Return input unchanged (apart from the reshape), as strrep does as well.
    return
end

L = true(size(in));
L((end-numel(pattern)+2):end) = false; % Avoid partial matches
for n=1:numel(pattern)
    % For every element of the pattern, look for matches in the data. Keep track of all possible
    % locations of a match by shifting the logical vector.
    % The last n elements should be left unchanged, to avoid false positives with a wrap-around.
    L_n = in==pattern(n);
    L_n = circshift(L_n,[0 1-n]);
    L_n(1:(n-1)) = L(1:(n-1));
    L = L & L_n;
    
    % If there are no matches left (even if n<numel(pat)), the process can be aborted.
    if ~any(L),return,end
end

if numel(rep)==0
    out(L)=[];
    return
end

% For the replacement, we will create a shadow copy with a coded char array. Non-matching values
% will be coded with a space, the first character of a match will be encoded with an asterisk, and
% trailing characters will be encoded with an underscore.
% In the next step, regexprep will be used to perform the replacement, after which indexing can be
% used to compose the final array.
if numel(pattern)>1
    checkpoint('PatternReplace','bsxfun_plus')
    idx = bsxfun_plus(find(L),reshape(1:(numel(pattern)-1),[],1));
else
    idx = find(L);
end
idx = reshape(idx,1,[]);
str = repmat(' ',1,numel(in));
str(idx) = '_';
str( L ) = '*';
NonMatchL = str==' ';

% The regular expression will take care of the lazy pattern matching. This also shifts the number
% of underscores to the length of the replacement array.
str = regexprep(str,'\*_*',['*' repmat('_',1,numel(rep)-1)]);

% We can paste in the non-matching positions. Positions where the replacement should be inserted
% may or may not be correct.
out(str==' ') = in(NonMatchL);

% Now we can paste in all the replacements.
x = strfind(str,'*');
checkpoint('PatternReplace','bsxfun_plus')
idx = bsxfun_plus(x,reshape(0:(numel(rep)-1),[],1));
idx = reshape(idx,1,[]);
out(idx) = repmat(rep,1,numel(x));

% Remove the elements beyond the range of what the resultant array should be.
out((numel(str)+1):end) = [];
end
function varargout=regexp_outkeys(v000,v001,varargin),if nargin<2,...
error('HJW:regexp_outkeys:SyntaxError','No supported syntax used: at least 3 inputs expected.'),...
end,if~(ischar(v000)&&ischar(v001)),error('HJW:regexp_outkeys:InputError',...
'All inputs must be char vectors.'),end,if nargout>nargin,error('HJW:regexp_outkeys:ArgCount',...
'Incorrect number of output arguments. Check syntax.'),end,persistent v002 v003 v004,if ...
isempty(v002),v002.start=true;v002.end=true;v002.match=regexp_outkeys_f01('<','R14','Octave',...
'<',4);v002.tokens=v002.match;v002.split=regexp_outkeys_f01('<','R2007b','Octave','<',4);v005=...
fieldnames(v002);v003=['Extra regexp output type not implemented,',char(10),...
'only the following',' types are implemented:',char(10),sprintf('%s, ',v005{:})];
v003((end-1):end)='';v002.any=v002.match||v002.split||v002.tokens;v004=v002;for v006=...
fieldnames(v004).',v004.(v006{1})=false;end,end,if v002.any||nargin==...
2||any(ismember(lower(varargin),{'start','end'})),[v007,v008,v009]=regexp(v000,v001);end,if ...
nargin==2,varargout={v007,v008,v009};return,end,varargout=cell(size(varargin));v010=v004;v011=...
[];for v012=1:(nargin-2),if~ischar(varargin{v012}),error('HJW:regexp_outkeys:InputError',...
'All inputs must be char vectors.'),end,switch lower(varargin{v012}),case'match',if v010.match,...
varargout{v012}=v013;continue,end,if v002.match,v013=cell(1,numel(v007));for v014=1:numel(v007),...
v013{v014}=v000(v007(v014):v008(v014));end,else,[v013,v007,v008]=regexp(v000,v001,'match');end,...
varargout{v012}=v013;v010.match=true;case'split',if v010.split,varargout{v012}=v011;continue,...
end,if v002.split,v011=cell(1,numel(v007)+1);v015=[v007 numel(v000)+1];v016=[0 v008];for v014=...
1:numel(v015),v011{v014}=v000((v016(v014)+1):(v015(v014)-1));if numel(v011{v014})==0,v011{v014}=...
char(ones(0,0));end,end,else,[v011,v007,v008]=regexp(v000,v001,'split');end,varargout{v012}=...
v011;v010.split=true;case'tokens',if v010.tokens,varargout{v012}=v017;continue,end,if ...
v002.tokens,v017=cell(numel(v009),0);for v014=1:numel(v009),if size(v009{v014},2)~=2,v017{v014}=...
cell(1,0);else,for v018=1:size(v009{v014},1),v017{v014}{v018}=v000(v009{v014}(v018,...
1):v009{v014}(v018,2));end,end,end,else,[v017,v007,v008]=regexp(v000,v001,'tokens');end,...
varargout{v012}=v017;v010.tokens=true;case'start',varargout{v012}=v007;case'end',...
varargout{v012}=v008;otherwise,error('HJW:regexp_outkeys:NotImplemented',v003),end,end,if ...
nargout>v012,varargout(v012+[1 2])={v007,v008};end,end
function v000=regexp_outkeys_f00(v000),v000=fix(v000+eps*1e3);end
function v000=regexp_outkeys_f01(v001,v002,v003,v004,v005),if nargin<2||nargout>1,...
error('incorrect number of input/output arguments'),end,persistent v006 v007 v008,if ...
isempty(v006),v008=exist('OCTAVE_VERSION','builtin');v006=[100,1] * sscanf(version,'%d.%d',2);
v007={'R13' 605;'R13SP1' 605;'R13SP2' 605;'R14' 700;'R14SP1' 700;'R14SP2' 700;'R14SP3' 701;
'R2006a' 702;'R2006b' 703;'R2007a' 704;'R2007b' 705;'R2008a' 706;'R2008b' 707;'R2009a' 708;
'R2009b' 709;'R2010a' 710;'R2010b' 711;'R2011a' 712;'R2011b' 713;'R2012a' 714;'R2012b' 800;
'R2013a' 801;'R2013b' 802;'R2014a' 803;'R2014b' 804;'R2015a' 805;'R2015b' 806;'R2016a' 900;
'R2016b' 901;'R2017a' 902;'R2017b' 903;'R2018a' 904;'R2018b' 905;'R2019a' 906;'R2019b' 907;
'R2020a' 908;'R2020b' 909;'R2021a' 910;'R2021b' 911;'R2022a' 912;'R2022b' 913;'R2023a' 914};end,...
if v008,if nargin==2,warning('HJW:ifversion:NoOctaveTest',...
['No version test for Octave was provided.',char(10),...
'This function might return an unexpected outcome.']),if isnumeric(v002),v009=...
0.1*v002+0.9*regexp_outkeys_f00(v002);v009=round(100*v009);else,v010=ismember(v007(:,1),v002);
if sum(v010)~=1,warning('HJW:ifversion:NotInDict',...
'The requested version is not in the hard-coded list.'),v000=NaN;return,else,v009=v007{v010,2};
end,end,elseif nargin==4,[v001,v009]=deal(v003,v004);v009=0.1*v009+0.9*regexp_outkeys_f00(v009);
v009=round(100*v009);else,[v001,v009]=deal(v004,v005);v009=...
0.1*v009+0.9*regexp_outkeys_f00(v009);v009=round(100*v009);end,else,if isnumeric(v002),v009=...
regexp_outkeys_f00(v002*100);if mod(v009,10)==0,v009=regexp_outkeys_f00(v002)*100+mod(v002,...
1)*10;end,else,v010=ismember(v007(:,1),v002);if sum(v010)~=1,warning('HJW:ifversion:NotInDict',...
'The requested version is not in the hard-coded list.'),v000=NaN;return,else,v009=v007{v010,2};
end,end,end,switch v001,case'==',v000=v006==v009;case'<',v000=v006 < v009;case'<=',v000=v006 <=...
v009;case'>',v000=v006 > v009;case'>=',v000=v006 >=v009;end,end
function [str,ErrorFlag,conversiontable]=rich_to_plain_text(str,SkipConversion)
% Convert ASCII-encoded rich text to plain text.

ErrorFlag = false; % Suppress errors if there is a second output.

persistent ConversionTable
if isempty(ConversionTable)
    ConversionTable = {...
        ... replace superscript and subscript numbers (and '=()+-') with normal numbers
        8304,48;185,49;178,50;179,51;8308,52;8309,53;8310,54;8311,55;8312,56;8313,57;8320,48;...
        8321,49;8322,50;8323,51;8324,52;8325,53;8326,54;8327,55;8328,56;8329,57;8330,43;8314,43;...
        8331,45;8315,45;8332,61;8333,40;8334,41;8316,61;8317,40;8318,41;...
        ... encode small caps with normal upper case
        7424,65;665,66;7428,67;7429,68;7431,69;42800,70;610,71;668,72;618,73;7434,74;7435,75;...
        671,76;7437,77;628,78;7439,79;7448,80;42927,81;640,82;42801,83;7451,84;7452,85;7456,86;...
        7457,87;120,88;655,89;7458,90;...
        ... replace several kinds of whitespace with a normal space
        160,32;5760,32;8192,32;8193,32;8194,32;8195,32;8196,32;8197,32;8198,32;8199,32;8200,32;...
        8201,32;8202,32;8239,32;8287,32;...
        ... typographic marks like an inverted ! and quotation marks
        161,33;191,63;8230,'...';700,39;8216,39;8217,39;8220,34;8221,34;8222,34;173,45;8211,45;...
        8212,45;8213,45;8218,39;...
        ... digraphs and letter with special accents
        338,'OE';339,'oe';198,'AE';230,'ae';274,69;192,65;193,65;196,65;200,69;201,69;202,69;...
        203,69;205,73;207,73;209,78;211,79;212,79;218,85;219,85;224,97;225,97;226,97;228,97;...
        231,99;232,101;233,101;234,101;235,101;236,105;237,105;238,105;239,105;241,110;242,111;...
        243,111;244,111;246,111;249,117;250,117;251,117;252,117;253,121;275,101;...
        ... special symbols
        169,'(c)';171,'<<';187,'>>';183,32;189,'1/2';8531,'1/3';188,'1/4';...
        ... Hebrew letters
        1488,'ALEF';1489,'BET';1490,'GIMEL';1491,'DALET';1492,'HE';1493,'VAV';1494,'ZAYIN';...
        1495,'HET';1496,'TET';1497,'YOD';1498,'KAF';1499,'KAF';1500,'LAMED';1501,'MEM';...
        1502,'MEM';1503,'NUN';1504,'NUN';1505,'SAMEKH';1506,'AYIN';1507,'PE';1508,'PE';...
        1509,'TSADI';1510,'TSADI';1511,'QOF';1512,'RESH';1513,'SHIN';1514,'TAV'};
    sort_order = zeros(size(ConversionTable,1),1);
    for n=1:size(ConversionTable,1)
        % Determine the value by which this entry should be sorted. Single characters should be
        % sorted by the output characters, multi-characters by their codepoint.
        if numel(ConversionTable{n,2})==1
            sort_order(n) = double(ConversionTable{n,2});
        else
            % Shift by 128 to make sure they come at the end.
            sort_order(n) = 128+ConversionTable{n,1};
        end
        
        % Convert the first part to the ASCII-encoding.
        ConversionTable{n,1} = sprintf('&#%d;',ConversionTable{n,1});
        % Convert the second part to char.
        ConversionTable{n,2} = char(ConversionTable{n,2});
        % Also store the rich text in the table.
        checkpoint('rich_to_plain_text','ASCII_decode')
        ConversionTable{n,3} = ASCII_decode(ConversionTable{n,1});
    end
    [ignore,order] = sort(sort_order); %#ok<ASGLU>
    ConversionTable = ConversionTable(order,:);
end
if nargout>=3,conversiontable = ConversionTable;end

% Determine which symbols occur in str.
checkpoint('rich_to_plain_text','regexp_outkeys')
symbols = regexp_outkeys(str,'&#(\d+);','tokens');
if isempty(symbols),return,end % No symbols to replace.
symbols = unique(str2double([symbols{:}]));

if nargin>=2
    % Skip some codepoints if a skip list is defined. This is usefull if you want to convert rich
    % text above 255, but not 128-255.
    symbols(ismember(symbols,SkipConversion)) = [];
end

% Perform replacements.
for n=numel(symbols):-1:1
    L = ismember(ConversionTable(:,1),sprintf('&#%d;',symbols(n)));
    if ~any(L),continue,end % Not in library.
    str = strrep(str,ConversionTable{L,1},ConversionTable{L,2});
    symbols(n)=[];
end

% Trigger error state if there are any unprocessed symbols.
if ~isempty(symbols)
    if nargout>=2
        ErrorFlag = true;
    else
        symbols = sprintf(' %d',sort(symbols));
        error('rich text characters remaining in text:\n  %s',symbols)
    end
end
end
function SelfTestFailMessage=SelfTest__error_
% Run a self-test to ensure the function works as intended.
% This is intended to test internal function that do not have stand-alone testers, or are included
% in many different functions as subfunction, which would make bug regression a larger issue.

checkpoint('SelfTest__error_','error_')
ParentFunction = 'error_';
% This flag will be reset if an error occurs, but otherwise should ensure this test function
% immediately exits in order to minimize the impact on runtime.
if nargout==1,SelfTestFailMessage='';end
persistent SelfTestFlag,if ~isempty(SelfTestFlag),return,end
SelfTestFlag = true; % Prevent infinite recursion.

test_number = 0;ErrorFlag = false;
while true,test_number=test_number+1;
    switch test_number
        case 0 % (test template)
            try ME=[];
            catch ME;if isempty(ME),ME=lasterror;end %#ok<LERR>
                ErrorFlag = true;break
            end
        case 1
            % Test the syntax: error_(options,msg)
            try ME=[];
                filename = tempname;
                msg = 'some error message';
                options = struct('fid',fopen(filename,'w'));
                error_(options,msg)
            catch ME;if isempty(ME),ME = lasterror;end %#ok<LERR>
                fclose(options.fid);
                str = SelfTest__error_extract_message(filename);
                if ~strcmp(ME.message,msg) || ...
                        ~strcmp(str,['Error: ' msg])
                    ErrorFlag = true;break
                end
            end
            try delete(filename);catch,end % Clean up file
        case 2
            % Test the syntax: error_(options,msg,A1,...,An)
            try ME=[];
                filename = tempname;
                msg = 'important values:\nA1=''%s''\nAn=%d';
                A1 = 'char array';An = 20;
                options = struct('fid',fopen(filename,'w'));
                error_(options,msg,A1,An)
            catch ME;if isempty(ME),ME = lasterror;end %#ok<LERR>
                fclose(options.fid);
                str = SelfTest__error_extract_message(filename);
                if ~strcmp(ME.message,sprintf(msg,A1,An)) || ...
                        ~strcmp(str,sprintf(['Error: ' msg],A1,An))
                    ErrorFlag = true;break
                end
            end
            try delete(filename);catch,end % Clean up file
        case 3
            % Test the syntax: error_(options,id,msg)
            try ME=[];
                filename = tempname;
                id = 'SelfTest:ErrorID';
                msg = 'some error message';
                options = struct('fid',fopen(filename,'w'));
                error_(options,id,msg)
            catch ME;if isempty(ME),ME = lasterror;end %#ok<LERR>
                fclose(options.fid);
                str = SelfTest__error_extract_message(filename);
                if ~strcmp(ME.identifier,id) || ~strcmp(ME.message,msg) || ...
                        ~strcmp(str,['Error: ' msg])
                    ErrorFlag = true;break
                end
            end
            try delete(filename);catch,end % Clean up file
        case 4
            % Test the syntax: error_(options,id,msg,A1,...,An)
            try ME=[];
                filename = tempname;
                id = 'SelfTest:ErrorID';
                msg = 'important values:\nA1=''%s''\nAn=%d';
                A1 = 'char array';An = 20;
                options = struct('fid',fopen(filename,'w'));
                error_(options,id,msg,A1,An)
            catch ME;if isempty(ME),ME = lasterror;end %#ok<LERR>
                fclose(options.fid);
                str = SelfTest__error_extract_message(filename);
                if ~strcmp(ME.identifier,id) || ~strcmp(ME.message,sprintf(msg,A1,An)) || ...
                        ~strcmp(str,sprintf(['Error: ' msg],A1,An))
                    ErrorFlag = true;break
                end
            end
            try delete(filename);catch,end % Clean up file
        case 5
            % Test the syntax: error_(options,ME)
            try ME=[];
                filename = tempname;
                id = 'SelfTest:ErrorID';
                msg = 'some error message';
                options = struct('fid',fopen(filename,'w'));
                try M=[];error(id,msg),catch M;if isempty(M),M=lasterror;end,end %#ok<NASGU,LERR>
                error_(options,M)
            catch ME;if isempty(ME),ME = lasterror;end %#ok<LERR>
                fclose(options.fid);
                str = SelfTest__error_extract_message(filename);
                if ~strcmp(ME.identifier,id) || ~strcmp(ME.message,msg) || ...
                        ~strcmp(str,['Error: ' msg])
                    ErrorFlag = true;break
                end
            end
            try delete(filename);catch,end % Clean up file
        case 6
            % Test the write to object option.
            % Only perform graphics-based tests on runtimes where we expect them to work.
            checkpoint('SelfTest__error_','ifversion___skip_test')
            if ifversion___skip_test,continue,end
            try ME = [];
                S.h_fig = figure('Visible','off');drawnow;
                S.h_obj = text(1,1,'test','Parent',axes('Parent',S.h_fig));
                error_(struct('obj',S.h_obj),...
                    struct(...
                    'identifier','SomeFunction:ThisIsAnIdentifier',...
                    'message',['multiline' char([13 10]) 'message']));
                close(S.h_fig)
                ErrorFlag = true;break
            catch ME;if isempty(ME),ME = lasterror;end %#ok<LERR>
                close(S.h_fig)
                if ~strcmp(ME.identifier,'SomeFunction:ThisIsAnIdentifier')
                    ErrorFlag = true;break
                end
            end
        case 7
            % Test the print to function option.
            try ME = [];
                filename = [tempname '.txt'];
                fid = fopen(filename,'w');
                s_fcn = struct('h',@SelfTest__error_function_call_wrapper,...
                    'data',{{fid,'Very important error message.'}});
                error_(struct('fcn',s_fcn),...
                    struct(...
                    'identifier','SomeFunction:ThisIsAnIdentifier',...
                    'message',['multiline' char([13 10]) 'message']));
                fclose(fid);
                ErrorFlag = true;break
            catch ME;if isempty(ME),ME = lasterror;end %#ok<LERR>
                fclose(fid);
                if ~strcmp(ME.identifier,'SomeFunction:ThisIsAnIdentifier')
                    ErrorFlag = true;break
                end
            end
            % Now we can test whether the contents of the file are correct.
            try
                str=SelfTest__error_extract_message(filename);
                str(str<32) = '';
                if ~strcmp(str,['Error: This <error> was caught:multilinemessageThis message ',...
                        'was included: Very important error message.'])
                    ErrorFlag = true;break
                end
            catch
                ErrorFlag = true;break
            end
            try delete(filename);catch,end % Clean up file
        otherwise % No more tests.
            break
    end
end
if ErrorFlag
    SelfTestFlag = [];
    if isempty(ME)
        if nargout==1
            SelfTestFailMessage=sprintf('Self-validator %s failed on test %d.\n',...
                ParentFunction,test_number);
        else
            error('self-test %d failed',test_number)
        end
    else
        if nargout==1
            SelfTestFailMessage=sprintf(...
                'Self-validator %s failed on test %d.\n   ID: %s\n   msg: %s\n',...
                ParentFunction,test_number,ME.identifier,ME.message);
        else
            error('self-test %d failed\n   ID: %s\n   msg: %s',...
                test_number,ME.identifier,ME.message)
        end
    end
end
end
function SelfTest__error_function_call_wrapper(error_or_warning,ME,data)
fid = data{1};
msg = data{2};
error_(struct('fid',fid),'This <%s> was caught:\n%s\nThis message was included: %s\n',...
    error_or_warning,ME.message,msg);
end
function str=SelfTest__error_extract_message(filename)
% Extract the error message from the log file.
try
    str = fileread(filename);
catch
    str = '';return
end
ind1 = min(strfind(str,']')+2); % Strip the timestamp
ind2 = max(strfind(str,'> In')-1); % Remove the function stack.
while ismember(double(str(ind2)),[10 13 32]),ind2=ind2-1;end
str = str(ind1:ind2);
end
function SelfTestFailMessage=SelfTest__PatternReplace
% Run a self-test to ensure the function works as intended.
% This is intended to test internal function that do not have stand-alone testers, or are included
% in many different functions as subfunction, which would make bug regression a larger issue.

checkpoint('SelfTest__PatternReplace','PatternReplace')
ParentFunction = 'PatternReplace';
% This flag will be reset if an error occurs, but otherwise should ensure this test function
% immediately exits in order to minimize the impact on runtime.
if nargout==1,SelfTestFailMessage='';end
persistent SelfTestFlag,if ~isempty(SelfTestFlag),return,end
SelfTestFlag = true; % Prevent infinite recursion.

test_number = 0;ErrorFlag = false;
while true,test_number=test_number+1;
    switch test_number
        case 0 % (test template)
            try ME=[];
            catch ME;if isempty(ME),ME=lasterror;end %#ok<LERR>
                ErrorFlag = true;break
            end
        case 1
            try ME=[];
                x = {'abababa','aba','1'};
                expect = strrep(x{:});
                result = PatternReplace(x{:});
                if ~strcmp(expect,result),ErrorFlag = true;break,end
            catch ME;if isempty(ME),ME=lasterror;end %#ok<LERR>
                ErrorFlag = true;break
            end
        case 2
            try ME=[];
                x = {'abababa','aba','123'};
                expect = strrep(x{:});
                result = PatternReplace(x{:});
                if ~strcmp(expect,result),ErrorFlag = true;break,end
            catch ME;if isempty(ME),ME=lasterror;end %#ok<LERR>
                ErrorFlag = true;break
            end
        case 3
            try ME=[];
                expect = [1 4 5 3];
                result = PatternReplace([1 2 3],2,[4 5]);
                if ~isequal(expect,result),ErrorFlag = true;break,end
            catch ME;if isempty(ME),ME=lasterror;end %#ok<LERR>
                ErrorFlag = true;break
            end
        case 4
            try ME=[];
                expect = int32([1 -10 3]);
                result = PatternReplace(int32([1 13 10 3]),int32([13 10]),int32(-10));
                if ~isequal(expect,result),ErrorFlag = true;break,end
            catch ME;if isempty(ME),ME=lasterror;end %#ok<LERR>
                ErrorFlag = true;break
            end
        otherwise % No more tests.
            break
    end
end
if ErrorFlag
    SelfTestFlag = [];
    if isempty(ME)
        if nargout==1
            SelfTestFailMessage=sprintf('Self-validator %s failed on test %d.\n',...
                ParentFunction,test_number);
        else
            error('self-test %d failed',test_number)
        end
    else
        if nargout==1
            SelfTestFailMessage=sprintf(...
                'Self-validator %s failed on test %d.\n   ID: %s\n   msg: %s\n',...
                ParentFunction,test_number,ME.identifier,ME.message);
        else
            error('self-test %d failed\n   ID: %s\n   msg: %s',...
                test_number,ME.identifier,ME.message)
        end
    end
end
end
function SelfTestFailMessage=SelfTest__regexp_outkeys
% Run a self-test to ensure the function works as intended.
% This is intended to test internal function that do not have stand-alone testers, or are included
% in many different functions as subfunction, which would make bug regression a larger issue.

checkpoint('SelfTest__regexp_outkeys','regexp_outkeys')
ParentFunction = 'regexp_outkeys';
% This flag will be reset if an error occurs, but otherwise should ensure this test function
% immediately exits in order to minimize the impact on runtime.
if nargout==1,SelfTestFailMessage='';end
persistent SelfTestFlag,if ~isempty(SelfTestFlag),return,end
SelfTestFlag = true; % Prevent infinite recursion.

test_number = 0;ErrorFlag = false;
while true,test_number=test_number+1;
    switch test_number
        case 0 % (test template)
            try ME=[];
            catch ME;if isempty(ME),ME=lasterror;end %#ok<LERR>
                ErrorFlag = true;break
            end
        case 1
            % Test if all implemented output keys will return a value.
            try ME=[];
                str = 'lorem1 ipsum1.2 dolor3 sit amet 99 ';
                [val1,val2,val3] = regexp_outkeys(str,'( )','split','match','tokens');
                if isempty(val1) || isempty(val2) || isempty(val3)
                    error('one of the implemented outkeys is empty')
                end
            catch ME;if isempty(ME),ME=lasterror;end %#ok<LERR>
                ErrorFlag = true;break
            end
        case 2
            % Test if adding the start and end indices as outputs does not alter the others.
            try ME=[];
                str = 'lorem1 ipsum1.2 dolor3 sit amet 99 ';
                [a1,a2,a3,start_,end_] = regexp_outkeys(str,'( )','split','match','tokens');
                [b1,b2,b3] = regexp_outkeys(str,'( )','split','match','tokens');
                if isempty(start_) || isempty(end_) || ...
                        ~isequal(a1,b1) || ~isequal(a2,b2) || ~isequal(a3,b3)
                    error('one of the implemented outkeys is empty')
                end
            catch ME;if isempty(ME),ME=lasterror;end %#ok<LERR>
                ErrorFlag = true;break
            end
        case 3
            % Confirm a regex without tokens will have an empty tokens output.
            try ME=[];
                str = 'lorem1 ipsum1.2 dolor3 sit amet 99 ';
                NoTokenMatch = regexp_outkeys(str,' ','tokens');
                expected = repmat({cell(1,0)},1,6);
                if ~isequal(NoTokenMatch,expected)
                    error('no tokens in regex did not return empty result')
                end
            catch ME;if isempty(ME),ME=lasterror;end %#ok<LERR>
                ErrorFlag = true;break
            end
        case 4
            % Check the split option, including trailing empty.
            try ME=[];
                str = 'lorem1 ipsum1.2 dolor3 sit amet 99 ';
                SpaceDelimitedElements = regexp_outkeys(str,' ','split');
                expected = {'lorem1','ipsum1.2','dolor3','sit','amet','99',char(ones(0,0))};
                if ~isequal(SpaceDelimitedElements,expected)
                    error(['space delimited elements did not match expected result' char(10) ...
                        '(perhaps the trailing empty is 1x0 instead of 0x0)']) %#ok<CHARTEN>
                end
            catch ME;if isempty(ME),ME=lasterror;end %#ok<LERR>
                ErrorFlag = true;break
            end
        case 5
            % Check the split option, including trailing empty.
            try ME=[];
                SpaceDelimitedElements = regexp_outkeys('',' ','split');
                expected = {char(ones(0,0))};
                if ~isequal(SpaceDelimitedElements,expected)
                    size(SpaceDelimitedElements{end}),size(expected{end}),keyboard
                    error('split on empty str did not return 0x0 empty')
                end
            catch ME;if isempty(ME),ME=lasterror;end %#ok<LERR>
                ErrorFlag = true;break
            end
        case 6
            % Check the extraction of a matched pattern.
            try ME=[];
                str = 'lorem1 ipsum1.2 dolor3 sit amet 99 ';
                RawTokens = regexp_outkeys(str,'([a-z]+)[0-9]','tokens');
                words_with_number = horzcat(RawTokens{:});
                expected = {'lorem','ipsum','dolor'};
                if ~isequal(words_with_number,expected)
                    error('actual results did not match expected result')
                end
            catch ME;if isempty(ME),ME=lasterror;end %#ok<LERR>
                ErrorFlag = true;break
            end
        case 7
            % Check the extraction of a matched pattern.
            try ME=[];
                str = 'lorem1 ipsum1.2 dolor3 sit amet 9x9 ';
                numbers = regexp_outkeys(str,'[0-9.]*','match');
                expected = {'1','1.2','3','9','9'};
                if ~isequal(numbers,expected)
                    error('actual results did not match expected result')
                end
            catch ME;if isempty(ME),ME=lasterror;end %#ok<LERR>
                ErrorFlag = true;break
            end
        case 8
            % Check the addition of start and end as tokens.
            try ME=[];
                str = 'lorem1 ipsum1.2 dolor3 sit amet 9x9 ';
                [ignore,end1,start1,end2] = regexp_outkeys(str,' .','match','end'); %#ok<ASGLU>
                [start2,end3] = regexp_outkeys(str,' .');
                expected = [7 16 23 27 32];
                if ~isequal(start1,expected) || ~isequal(start2,expected)
                    error('start indices did not match expectation')
                end
                expected = expected+1;
                if ~isequal(end1,expected) || ~isequal(end2,expected) || ~isequal(end3,expected)
                    error('end indices did not match expectation')
                end
            catch ME;if isempty(ME),ME=lasterror;end %#ok<LERR>
                ErrorFlag = true;break
            end
        case 9
            % Check multi-element tokens.
            [t,s] = regexp_outkeys('2000/12/31','(\d\d\d\d)/(\d\d)/(\d\d)','tokens','split');
            expected1 = {{'2000','12','31'}};
            expected2 = {char(ones(0,0)),char(ones(0,0))};
            if ~isequal(t,expected1) || ~isequal(s,expected2)
                error('result did not match expectation for multiple tokens')
            end
        case 10
            % Check multi-element tokens.
            t = regexp_outkeys('12/34 56/78','(\d\d)/(\d\d)','tokens');
            expected = {{'12','34'},{'56','78'}};
            if ~isequal(t,expected)
                error('result did not match expectation for multiple tokens')
            end
        otherwise % No more tests.
            break
    end
end
if ErrorFlag
    SelfTestFlag = [];
    if isempty(ME)
        if nargout==1
            SelfTestFailMessage=sprintf('Self-validator %s failed on test %d.\n',...
                ParentFunction,test_number);
        else
            error('self-test %d failed',test_number)
        end
    else
        if nargout==1
            SelfTestFailMessage=sprintf(...
                'Self-validator %s failed on test %d.\n   ID: %s\n   msg: %s\n',...
                ParentFunction,test_number,ME.identifier,ME.message);
        else
            error('self-test %d failed\n   ID: %s\n   msg: %s',...
                test_number,ME.identifier,ME.message)
        end
    end
end
end
function [isLogical,val]=test_if_scalar_logical(val)
%Test if the input is a scalar logical or convertible to it.
% The char and string test are not case sensitive.
% (use the first output to trigger an input error, use the second as the parsed input)
%
%  Allowed values:
% - true or false
% - 1 or 0
% - 'on' or 'off'
% - "on" or "off"
% - matlab.lang.OnOffSwitchState.on or matlab.lang.OnOffSwitchState.off
% - 'enable' or 'disable'
% - 'enabled' or 'disabled'
persistent states
if isempty(states)
    states = {...
        true,false;...
        1,0;...
        'true','false';...
        '1','0';...
        'on','off';...
        'enable','disable';...
        'enabled','disabled'};
    % We don't need string here, as that will be converted to char.
end

% Treat this special case.
if isa(val,'matlab.lang.OnOffSwitchState')
    isLogical = true;val = logical(val);return
end

% Convert a scalar string to char and return an error state for non-scalar strings.
if isa(val,'string')
    if numel(val)~=1,isLogical = false;return
    else            ,val = char(val);
    end
end

% Convert char/string to lower case.
if isa(val,'char'),val = lower(val);end

% Loop through all possible options.
for n=1:size(states,1)
    for m=1:2
        if isequal(val,states{n,m})
            isLogical = true;
            val = states{1,m}; % This selects either true or false.
            return
        end
    end
end

% Apparently there wasn't any match, so return the error state.
isLogical = false;
end
function imtext=text2im(text,varargin)
%Generate an image from text (white text on black background)
%
% This function will convert a string or char array to an image. There are several fonts
% implemented, each with their own license and number of included characters. All fonts are free to
% use in some form, but if you plan to use it on a large scale or for commercial purposes you
% should check the license of the specific font you want to use.
%
% The list of included characters in each font is based on a relatively arbitrary selection from
% the pages below. The list of actually available characters depends on the chosen font.
% https://en.wikipedia.org/wiki/List_of_Unicode_characters
% https://en.wikipedia.org/wiki/Newline#Unicode
% https://en.wikipedia.org/wiki/Whitespace_character#Unicode
%
% Syntax:
%   imtext = text2im(text)
%   imtext = text2im(text,font)
%   imtext = text2im(text,options)
%   imtext = text2im(text,Name,Value)
%
% Input/output arguments:
% imtext:
%   A logical array containing the text image. The size is dependent on the font.
% text:
%   The text to be converted can be supplied as char, string, or cellstr. Which characters are
%   allowed is determined by the font. However, all fonts contain the printable and blank
%   characters below 127. Any non-standard newline characters are ignored (i.e. LF/CR/CRLF are
%   parsed as newline). Non-scalar inputs (or non-row vector inputs in the case of char) are
%   allowed, but might not return the desired result.
% options:
%   A struct with Name,Value parameters. Missing parameters are filled with the defaults listed
%   below. Using incomplete parameter names or incorrect capitalization is allowed, as long as
%   there is a unique match.
%
% Name,Value parameters:
%   font:
%      Font name as char array. The currently implemented fonts are:
%       - 'cmu_typewriter_text' (default)
%          Supports 365 characters. This is a public domain typeface.
%          [character size = 90x55]
%       - 'cmu_concrete'
%          Supports 364 characters. This is a public domain typeface.
%          [character size = 90x75]
%       - 'ascii'
%          Contains only 94 characters (all printable chars below 127). This typeface was
%          previously published in the text2im() function (FEX:19896 by Tobias Kiessling).
%          [character size = 20x18]
%       - 'droid_sans_mono'
%          Supports 411 characters. Apache License, Version 2.0
%          [character size = 95x51]
%       - 'ibm_plex_mono'
%          Supports 376 characters. SIL Open Font License
%          [character size = 95x51]
%       - 'liberation_mono'
%          Supports 415 characters. GNU General Public License
%          [character size = 95x51]
%       - 'monoid'
%          Supports 398 characters. MIT License
%          [character size = 95x51]
%   TranslateRichText:
%      Attempt to convert rich text characters missing from the currently selected font to normal
%      characters. As an example, this converts a superscript 4 to a normal 4, but leaves a
%      superscript 3 as-is (except with the 'ascii' font).
%      This is set to false automatically if there is not rich text. [default=true;]
%
%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%
%|                                                                         |%
%|  Version: 2.0.0                                                         |%
%|  Date:    2023-09-14                                                    |%
%|  Author:  H.J. Wisselink                                                |%
%|  Licence: CC by-nc-sa 4.0 ( creativecommons.org/licenses/by-nc-sa/4.0 ) |%
%|  Email = 'h_j_wisselink*alumnus_utwente_nl';                            |%
%|  Real_email = regexprep(Email,{'*','_'},{'@','.'})                      |%
%|                                                                         |%
%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%
%
% Tested on several versions of Matlab (ML 6.5 and onward) and Octave (4.4.1 and onward), and on
% multiple operating systems (Windows/Ubuntu/MacOS). For the full test matrix, see the HTML doc.
% Compatibility considerations:
% - Multi-line inputs may have more trailing blank elements than intended. This is especially true
%   for characters encoded with multiple elements (>127 for Octave and >65535 for Matlab).

checkpoint('text2im','text2im_parse_inputs')
[success,opts,ME] = text2im_parse_inputs(text,varargin{:});
if ~success
    error(ME.identifier,ME.message)
end

checkpoint('text2im','text2im_load_database')
[HasGlyph,glyphs,valid] = text2im_load_database(opts.font);

checkpoint('text2im','CharIsUTF8')
ConvertFromUTF16=~CharIsUTF8;

% Convert string or char array into numeric array. If this fails, that means the input was invalid.
try
    % Convert to uint32 Unicode codepoints.
    c = cellstr(text); % This will deal with the string datatype as well
    for n=1:numel(c)
        row = c{n};
        if opts.TranslateRichText
            % Convert rich symbols to ASCII, look up the HTML decode in the table, and convert back
            % to char. This will not be particularly fast, but it will extend the number of
            % supported characters.
            % Rich text supported by the font will be left as-is.
            checkpoint('text2im','ASCII_encode')
            row = ASCII_encode(row);
            checkpoint('text2im','rich_to_plain_text')
            [row,IgnoreMissing] = rich_to_plain_text(row,valid); %#ok<ASGLU>
            checkpoint('text2im','ASCII_decode')
            row = ASCII_decode(row);
        end
        if ConvertFromUTF16
            % Get the Unicode code points from the UTF-16 encoding.
            checkpoint('text2im','UTF16_to_unicode')
            row = UTF16_to_unicode(row);%Returns uint32.
        else
            % Get the Unicode code points from the UTF-8 encoding.
            checkpoint('text2im','UTF8_to_unicode')
            row = UTF8_to_unicode(row);%Returns uint32.
        end
        c{n} = row;
    end
    
    % Split over standard newlines(LF/CR/CRLF). We can't use regexp() or split() here, as the text
    % is uint32, not char.
    for n=1:numel(c)
        % This function returns a cell array with 1xN elements of the input data type.
        checkpoint('text2im','char2cellstr')
        c{n} = char2cellstr(c{n});
    end
    c = vertcat(c{:});
    
    % Remove newlines and zero width characters.
    for n=1:numel(c)
        c{n} = c{n}(ismember(c{n},HasGlyph));
    end
    
    % Pad with spaces if needed
    len = cellfun('prodofsize',c);maxlen=max(len);
    for n=find(len<maxlen).'
        c{n}((end+1):maxlen) = 32;
    end
    text = cell2mat(c);
    if ~all(ismember(text,valid(1,:)))
        error('invalid char detected') % Trigger error if any invalid chars are detected.
    end
catch
    error('HJW:text2im:InvalidInput',...
        ['The input is invalid or contains symbols that are missing in your font.',char(10),...
        '(all fonts will have the <127 ASCII characters)']) %#ok<CHARTEN>
end

% Index into the glyph database and reshape to the ouput shape before unwrapping from the cells.
imtext = cell2mat(reshape(glyphs(text),size(text)));
end
function S=text2im_create_pref_struct(varargin)
%Supplying an input will trigger the GUI.
S = struct;
font_list = {'CMU Typewriter Text','CMU Concrete','ASCII',...
    'Droid Sans Mono','IBM Plex Mono','Liberation Mono','Monoid'};
for n=1:numel(font_list)
    S(n).name = font_list{n};
    S(n).valid_name = strrep(lower(S(n).name),' ','_');
    switch S(n).valid_name
        case 'cmu_typewriter_text'
            %20200418093655 for a 55px wide version
            S(n).url = ['http://web.archive.org/web/20200418101117im_/',...
                'https://hjwisselink.nl/FEXsubmissiondata/75021-text2im/',...
                'text2im_glyphs_CMU_Typewriter_Text.png'];
        case 'cmu_concrete'
            S(n).url = ['http://web.archive.org/web/20200418093550im_/',...
                'https://hjwisselink.nl/FEXsubmissiondata/75021-text2im/',...
                'text2im_glyphs_CMU_Concrete.png'];
        case 'ascii'
            S(n).url = ['http://web.archive.org/web/20200418093459im_/',...
                'https://hjwisselink.nl/FEXsubmissiondata/75021-text2im/',...
                'text2im_glyphs_ASCII.png'];
        case 'droid_sans_mono'
            S(n).url = ['http://web.archive.org/web/20200418093741im_/',...
                'https://hjwisselink.nl/FEXsubmissiondata/75021-text2im/',...
                'text2im_glyphs_Droid_Sans_Mono.png'];
        case 'ibm_plex_mono'
            S(n).url = ['http://web.archive.org/web/20200418093815im_/',...
                'https://hjwisselink.nl/FEXsubmissiondata/75021-text2im/',...
                'text2im_glyphs_IBM_Plex_Mono.png'];
        case 'liberation_mono'
            S(n).url = ['http://web.archive.org/web/20200418093840im_/',...
                'https://hjwisselink.nl/FEXsubmissiondata/75021-text2im/',...
                'text2im_glyphs_Liberation_Mono.png'];
        case 'monoid'
            S(n).url = ['http://web.archive.org/web/20200418093903im_/',...
                'https://hjwisselink.nl/FEXsubmissiondata/75021-text2im/',...
                'text2im_glyphs_Monoid.png'];
        otherwise
            S(n).url = fullfile(tempdir,['text2im_glyphs_',strrep(font_list{n},' ','_'),'.png']);
    end
    [S(n).printable,S(n).glyphs] = text2im__get_glyphs(S(n),varargin{:});
end
end
function [printable,glyphs]=text2im__get_glyphs(S,varargin)
%Retrieve glyphs from png masterfile.
% The top line encodes the glyph height, glyph width, and number of glyphs in 20 bits for each
% number. A column next to each glyph encodes the codepoint. The png files that are loaded here
% were made with the text2im_generate_glyphs_from_font function, which has many requirements before
% it works properly. For that reason the png files were also put on the Wayback Machine.

if nargin==1
    IM = text2im__download_IM(S.url);
else
    IM = [];
end
if isempty(IM),IM = text2im__get_IM_from_user(S);end

% Read row1.
sz = bin2dec(char('0'+reshape(IM(1,1:60),20,3)'));

% Split into glyphs.
dim1 = (sz(1))*ones(1,ceil(sz(3)/32));
dim2 = (sz(2)+1)*ones(1,32); % +1 to account for the codepoint encoding
c = mat2cell(IM(2:end,:),dim1,dim2);
c = c';c = c(1:sz(3));

glyphs = cell(size(c));
printable = zeros(size(c));
r_ = max(1,sz(1)-17); % At most 16 bits are used for the codepoint.
for k=1:numel(c)
    glyphs{k} = c{k}(:,2:end);
    printable(k) = bin2dec(char('0'+c{k}(r_:end,1)'));
end
end
function IM=text2im__download_IM(url)
for tries=1:3
    try
        IM = imread(url);
        break
    catch
        IM = [];
    end
end
if isempty(IM)
    % As a fallback for when there is something wrong with the Wayback Machine, we can still try
    % loading from hjwisselink.nl directly instead.
    %   remove 'http://web.archive.org/web/yyyymmddhhmmssim_/'
    %          0         1         2         3         4    4
    %          0123456789012345678901234567890123456789012345
    tmp = url(46:end);
    try
        IM = imread(tmp);
    catch
        IM = [];
    end
end
end
function IM=text2im__get_IM_from_user(S)
%Create a GUI to let the user download and select the file.
explanation = {'Loading of image failed.','',['You can try again or manually download the ',...
    'image from the URL below.'],'',['Once you have downloaded the png, click the button and ',...
    'locate the file.']};
menu = 'menu';if exist('OCTAVE_VERSION', 'builtin'),menu = 'menubar';end
f = figure(menu,'none','toolbar','none');
uicontrol('Parent',f,'style','text',...
    'Units','Normalized','Position',[0.15 0.75 0.70 0.15],...
    'String',explanation);
uicontrol('Parent',f,'style','edit',...
    'Units','Normalized','Position',[0.15 0.5 0.70 0.15],...
    'String',S.url);
uicontrol('Parent',f,'style','pushbutton',...
    'Units','Normalized','Position',[0.15 0.15 0.70 0.25],...
    'String',sprintf('Select the file for: %s',S.name),...
    'Callback',@text2im__select_png);
h = struct('f',f);guidata(f,h)
uiwait(f)
h = guidata(f);
close(f)
IM = imread(fullfile(h.path,h.file));
end
function text2im__select_png(obj,e) %#ok<INUSD>
h = guidata(obj);
[h.file,h.path] = uigetfile('text2im_glyphs_*.png');
guidata(obj,h);
uiresume(h.f);
end
function [HasGlyph,glyphs,valid]=text2im_load_database(fontname,varargin)
%The list of included characters is based on a mostly arbitrary selection from the pages below

%types:
% 1: printable (subset of the 'normal' characters with well-defined glyphs)
% 2: blank (spaces and tabs)
% 3: newline (line feed, carriage return, etc)
% 4: zero width (soft hyphen and joining characters)

% An attempt was made to include all of these codepoints:
% printable=sort([33:126 161:172 174:328 330:383 913:929 931:1023 8211:8213 8215:8222 8224:8226 ...
%     8230 8240 8227 8243 8249 8250 8252 8254 8260 8266 8352:8383 8448:8527 8592:8703]);
% This selection is based on these pages:
%https://en.wikipedia.org/wiki/List_of_Unicode_characters
%https://en.wikipedia.org/wiki/Newline#Unicode
%https://en.wikipedia.org/wiki/Whitespace_character#Unicode
persistent glyph_database
if nargin<2,purge = false;else,purge = varargin{1};end
if nargin<3,triggerGUI = false;else,triggerGUI = true;end
if purge,glyph_database = [];end
if isempty(glyph_database)
    checkpoint('text2im_load_database','GetWritableFolder')
    matfilename = fullfile(GetWritableFolder,'FileExchange','text2im','glyph_database.mat');
    checkpoint('text2im_load_database','makedir')
    f = fileparts(matfilename);if ~exist(f,'dir'),makedir(f);end
    if exist(matfilename,'file')
        S = load(matfilename);fn = fieldnames(S);glyph_database = S.(fn{1});
    end
    if purge,glyph_database=[];end
    if isempty(glyph_database)
        checkpoint('text2im_load_database','text2im_create_pref_struct')
        if triggerGUI
            glyph_database = text2im_create_pref_struct(triggerGUI);
        else
            glyph_database = text2im_create_pref_struct;
        end
        checkpoint('text2im_load_database','var2str','get_MatFileFlag')
        save(matfilename,var2str(glyph_database),get_MatFileFlag)
    end
end

if nargin>0
    name_list = {glyph_database.valid_name};
    idx = find(ismember(name_list,fontname));
    if isempty(idx)
        warning('HJW:text2im:IncorrectFontName',...
            'Font name doesn''t match any implemented font, reverting to default.')
        idx = 1;
    end
else
    idx = 1;
end
S = glyph_database(idx);

blank = [9 32 160 5760 8192:8202 8239 8287];
newlines = [10 11 12 13 133 8232 8233];
zerowidth = [173 8203 8204 8205 8288];

printable = S.printable(:)';
glyphs = cell(max(printable),1);
glyphs(printable) = S.glyphs;
glyphs(blank)     = {false(size(S.glyphs{1}))};

valid = [printable blank newlines zerowidth;ones(size(printable)),...
    2*ones(size(blank)),3*ones(size(newlines)),4*ones(size(zerowidth))];
HasGlyph = sort([printable blank]);
end
function [success,opts,ME]=text2im_parse_inputs(text,varargin)
% Parse the required and optional inputs to a struct. If anything fails, an ME struct will be
% created and the first output argument will be set to false.
success = false;

if nargin==2
    % This is either the legacy syntax (with a font), or an options struct.
    if ismember(class(varargin{1}),{'char','string','cell'})
        % Assume it is a font specification. If it isn't, there will be an error later.
        varargin = {'font',varargin{1}};
    end
end

% Attempt to match the inputs to the available options. This will return a struct with the same
% fields as the default option struct.
checkpoint('text2im_parse_inputs','parse_NameValue')
try ME = [];[opts,replaced] = parse_NameValue(text2im_default,varargin{:});
catch ME;if isempty(ME),ME = lasterror;end,return;end %#ok<LERR>

if isa(text,'string'),text = cellstr(text);end
if ~ischar(text) && ~iscellstr(text)
    ME.identifier = 'HJW:text2im:incorrect_input_text';
    ME.message = 'Expected first input to be char, cellstr, or string.';
    return
end

% Check if any rich text exists.
text = cellstr(text); % This only does something if the original input was char.
for n=1:numel(text)
    flag = any(text{n}>=128);
    if flag,break,end
end
% If there is no rich text, set the rich text conversion to false.
if ~flag,opts.TranslateRichText = false;end

success = false;
for k=1:numel(replaced)
    item = opts.(replaced{k});
    ME.identifier = ['HJW:text2im:incorrect_input_opt_' lower(replaced{k})];
    switch replaced{k}
        case 'font'
            % Whether the font is implementated will be checked later, but here we can check
            % whether ismember() will work.
            if isa(item,'string')
                if numel(item)~=1
                    ME.message = 'Expected a string scalar as font name.';
                    return
                end
            elseif isa(item,'char')
                if numel(item)~=length(item)
                    ME.message = 'Expected a char vector as font name.';
                    return
                end
            elseif isa(item,'cell')
                if ~(iscellstr(item) && numel(item)==1) %#ok<ISCLSTR>
                    ME.message = 'Expected a scalar cellstr as font name.';
                    return
                end
            else
                ME.message = 'Expected a font name.';
                return
            end
        case 'TranslateRichText'
            [passed,item] = test_if_scalar_logical(item);
            if ~passed
                ME.message = 'TranslateRichText should be either true or false.';
                return
            end
            opts.TranslateRichText = item;
        otherwise
    end
end
success = true;
end
function s=text2im_default
s = struct(...
    'font','cmu_typewriter_text',...
    'TranslateRichText',true);
end
function str=unicode_to_char(unicode,encode_as_UTF16)
%Encode Unicode code points with UTF-16 on Matlab and UTF-8 on Octave.
%
% Input is either implicitly or explicitly converted to a row-vector.

checkpoint('unicode_to_char','ifversion')
persistent isOctave,if isempty(isOctave),isOctave = ifversion('<',0,'Octave','>',0);end
if nargin==1
    checkpoint('unicode_to_char','CharIsUTF8')
    encode_as_UTF16 = ~CharIsUTF8;
end
if encode_as_UTF16
    if all(unicode<65536)
        str = uint16(unicode);
        str = reshape(str,1,numel(str));%Convert explicitly to a row-vector.
    else
        % Encode as UTF-16.
        [char_list,ignore,positions] = unique(unicode); %#ok<ASGLU>
        str = cell(1,numel(unicode));
        for n=1:numel(char_list)
            checkpoint('unicode_to_char','unicode_to_UTF16')
            str_element = unicode_to_UTF16(char_list(n));
            str_element = uint16(str_element);
            str(positions==n) = {str_element};
        end
        str = cell2mat(str);
    end
    if ~isOctave
        str = char(str); % Conversion to char could trigger a conversion range error in Octave.
    end
else
    if all(unicode<128)
        str = char(unicode);
        str = reshape(str,1,numel(str));% Convert explicitly to a row-vector.
    else
        % Encode as UTF-8.
        [char_list,ignore,positions] = unique(unicode); %#ok<ASGLU>
        str = cell(1,numel(unicode)); % Create a row-vector for the result.
        for n=1:numel(char_list)
            checkpoint('unicode_to_char','unicode_to_UTF8')
            str_element = unicode_to_UTF8(char_list(n));
            str_element = uint8(str_element);
            str(positions==n) = {str_element};
        end
        str = cell2mat(str);
        str = char(str);
    end
end
end
function str=unicode_to_UTF16(unicode)
% Convert a single character to UTF-16 bytes.
%
% The value of the input is converted to binary and padded with 0 bits at the front of the string
% to fill all 'x' positions in the scheme.
% See https://en.wikipedia.org/wiki/UTF-16
%
% 1 word (U+0000 to U+D7FF and U+E000 to U+FFFF):
%  xxxxxxxx_xxxxxxxx
% 2 words (U+10000 to U+10FFFF):
%  110110xx_xxxxxxxx 110111xx_xxxxxxxx
if unicode<65536
    str = unicode;return
end
U = double(unicode)-65536; % Cast to double to avoid an error in old versions of Matlab.
U = dec2bin(U,20);
str = bin2dec(['110110' U(1:10);'110111' U(11:20)]).';
end
function str=unicode_to_UTF8(unicode)
% Convert a single character to UTF-8 bytes.
%
% The value of the input is converted to binary and padded with 0 bits at the front of the string
% to fill all 'x' positions in the scheme.
% See https://en.wikipedia.org/wiki/UTF-8
if numel(unicode)>1,error('this should only be used for single characters'),end
if unicode<128
    str = unicode;return
end
persistent pers
if isempty(pers)
    pers = struct;
    pers.limits.lower = hex2dec({'0000','0080','0800', '10000'});
    pers.limits.upper = hex2dec({'007F','07FF','FFFF','10FFFF'});
    pers.scheme{2} = '110xxxxx10xxxxxx';
    pers.scheme{2} = reshape(pers.scheme{2}.',8,2);
    pers.scheme{3} = '1110xxxx10xxxxxx10xxxxxx';
    pers.scheme{3} = reshape(pers.scheme{3}.',8,3);
    pers.scheme{4} = '11110xxx10xxxxxx10xxxxxx10xxxxxx';
    pers.scheme{4} = reshape(pers.scheme{4}.',8,4);
    for b=2:4
        pers.scheme_pos{b} = find(pers.scheme{b}=='x');
        pers.bits(b) = numel(pers.scheme_pos{b});
    end
end
bytes = find(pers.limits.lower<=unicode & unicode<=pers.limits.upper);
str = pers.scheme{bytes};
scheme_pos = pers.scheme_pos{bytes};
% Cast to double to avoid an error in old versions of Matlab.
b = dec2bin(double(unicode),pers.bits(bytes));
str(scheme_pos) = b;
str = bin2dec(str.').';
end
function [unicode,IsUTF16]=UTF16_to_unicode(UTF16)
%Convert UTF-16 to the code points stored as uint32
%
%See https://en.wikipedia.org/wiki/UTF-16
%
% 1 word (U+0000 to U+D7FF and U+E000 to U+FFFF):
%  xxxxxxxx_xxxxxxxx
% 2 words (U+10000 to U+10FFFF):
%  110110xx_xxxxxxxx 110111xx_xxxxxxxx
%
% If a second output argument is specified, an attempt is made to convert to Unicode, leaving any
% invalid encodings in place.
if nargout>=2,IsUTF16 = true;end

persistent isOctave,if isempty(isOctave),isOctave = exist('OCTAVE_VERSION', 'builtin') ~= 0;end
UTF16 = uint32(UTF16);

multiword = UTF16>55295 & UTF16<57344; % 0xD7FF and 0xE000
if ~any(multiword)
    unicode = UTF16;return
end

word1 = find( UTF16>=55296 & UTF16<=56319 );
word2 = find( UTF16>=56320 & UTF16<=57343 );
try
    d = word2-word1;
    if any(d~=1) || isempty(d)
        error('trigger error')
    end
catch
    if nargout>=2
        IsUTF16 = false;
        % Remove elements that will cause problems.
        word2 = intersect(word2,word1+1);
        if isempty(word2),return,end
        word1 = word2-1;
    else
        error('input is not valid UTF-16 encoded')
    end
end

% Binary header:
%  110110xx_xxxxxxxx 110111xx_xxxxxxxx
%  00000000 01111111 11122222 22222333
%  12345678 90123456 78901234 56789012
header_bits = '110110110111';header_locs=[1:6 17:22];
multiword = UTF16([word1.' word2.']);
multiword = unique(multiword,'rows');
S2 = mat2cell(multiword,ones(size(multiword,1),1),2);
unicode = UTF16;
for n=1:numel(S2)
    bin = dec2bin(double(S2{n}))';
    
    if ~strcmp(header_bits,bin(header_locs))
        if nargout>=2
            % Set flag and continue to the next pair of words.
            IsUTF16 = false;continue
        else
            error('input is not valid UTF-16')
        end
    end
    bin(header_locs) = '';
    if ~isOctave
        S3 = uint32(bin2dec(bin  ));
    else
        S3 = uint32(bin2dec(bin.')); % Octave needs an extra transpose.
    end
    S3 = S3+65536;% 0x10000
    % Perform actual replacement.
    checkpoint('UTF16_to_unicode','PatternReplace')
    unicode = PatternReplace(unicode,S2{n},S3);
end
end
function [unicode,isUTF8,assumed_UTF8]=UTF8_to_unicode(UTF8,print_to)
%Convert UTF-8 to the code points stored as uint32
% Plane 16 goes up to 10FFFF, so anything larger than uint16 will be able to hold every code point.
%
% If there a second output argument, this function will not return an error if there are encoding
% error. The second output will contain the attempted conversion, while the first output will
% contain the original input converted to uint32.
%
% The second input can be used to also print the error to a GUI element or to a text file.
if nargin<2,print_to = [];end
return_on_error = nargout==1 ;

UTF8 = uint32(reshape(UTF8,1,[]));% Force row vector.
[assumed_UTF8,flag,ME] = UTF8_to_unicode_internal(UTF8,return_on_error);
if strcmp(flag,'success')
    isUTF8 = true;
    unicode = assumed_UTF8;
elseif strcmp(flag,'error')
    isUTF8 = false;
    if return_on_error
        checkpoint('UTF8_to_unicode','error_')
        error_(print_to,ME)
    end
    unicode = UTF8; % Return input unchanged (apart from casting to uint32).
end
end
function [UTF8,flag,ME]=UTF8_to_unicode_internal(UTF8,return_on_error)
flag = 'success';
ME = struct('identifier','HJW:UTF8_to_unicode:notUTF8','message','Input is not UTF-8.');

checkpoint('UTF8_to_unicode','ifversion')
persistent isOctave,if isempty(isOctave),isOctave = ifversion('<',0,'Octave','>',0);end

if any(UTF8>255)
    flag = 'error';
    if return_on_error,return,end
elseif all(UTF8<128)
    return
end

for bytes=4:-1:2
    val = bin2dec([repmat('1',1,bytes) repmat('0',1,8-bytes)]);
    multibyte = UTF8>=val & UTF8<256; % Exclude the already converted chars.
    if any(multibyte)
        multibyte = find(multibyte);multibyte=multibyte(:).';
        if numel(UTF8)<(max(multibyte)+bytes-1)
            flag = 'error';
            if return_on_error,return,end
            multibyte( (multibyte+bytes-1)>numel(UTF8) ) = [];
        end
        if ~isempty(multibyte)
            checkpoint('UTF8_to_unicode','bsxfun_plus')
            idx = bsxfun_plus(multibyte , (0:(bytes-1)).' );
            idx = idx.';
            multibyte = UTF8(idx);
        end
    else
        multibyte = [];
    end
    header_bits = [repmat('1',1,bytes-1) repmat('10',1,bytes)];
    header_locs = unique([1:(bytes+1) 1:8:(8*bytes) 2:8:(8*bytes)]);
    if numel(multibyte)>0
        multibyte = unique(multibyte,'rows');
        S2 = mat2cell(multibyte,ones(size(multibyte,1),1),bytes);
        for n=1:numel(S2)
            bin = dec2bin(double(S2{n}))';
            % To view the binary data, you can use this: bin=bin(:)';
            % Remove binary header (3 byte example):
            % 1110xxxx10xxxxxx10xxxxxx
            %     xxxx  xxxxxx  xxxxxx
            if ~strcmp(header_bits,bin(header_locs))
                % Check if the byte headers match the UTF-8 standard.
                flag = 'error';
                if return_on_error,return,end
                continue % Leave unencoded
            end
            bin(header_locs) = '';
            if ~isOctave
                S3 = uint32(bin2dec(bin  ));
            else
                S3 = uint32(bin2dec(bin.'));% Octave needs an extra transpose.
            end
            % Perform actual replacement.
            checkpoint('UTF8_to_unicode','PatternReplace')
            UTF8 = PatternReplace(UTF8,S2{n},S3);
        end
    end
end
end
function varargout=var2str(varargin)
%Analogous to func2str, return the variable names as char arrays, as detected by inputname
% This returns an error for invalid inputs and if nargin~=max(1,nargout).
%
% You can use comma separated lists to create a cell array:
%   out=cell(1,2);
%   foo=1;bar=2;
%   [out{:}]=var2str(foo,bar);

% One-line alternative: function out=var2str(varargin),out=inputname(1);end
err_flag = nargin~=max(1,nargout) ;
if ~err_flag
    varargout = cell(nargin,1);
    for n=1:nargin
        try varargout{n} = inputname(n);catch,varargout{n} = '';end
        if isempty(varargout{n}),err_flag = true;break,end
    end
end
if err_flag
    error('Invalid input and/or output.')
end
end

function out=checkpoint(caller,varargin)
% This function has limited functionality compared to the debugging version.
% (one of the differences being that this doesn't read/write to a file)
% Syntax:
%   checkpoint(caller,dependency)
%   checkpoint(caller,dependency_1,...,dependency_n)
%   checkpoint(caller,checkpoint_flag)
%   checkpoint('reset')
%   checkpoint('read')
%   checkpoint('write_only_to_file_on_read')
%   checkpoint('write_to_file_every_call')

persistent data
if isempty(data)||strcmp(caller,'reset')
    data = struct('total',0,'time',0,'callers',{{}});
end
if strcmp(caller,"read")
    out = data.time;return
end
if nargin==1,return,end
then = now;
for n=1:numel(varargin)
    data.total = data.total+1;
    data.callers = sort(unique([data.callers {caller}]));
    if ~isfield(data,varargin{n}),data.(varargin{n})=0;end
    data.(varargin{n}) = data.(varargin{n})+1;
end
data.time = data.time+ (now-then)*( 24*60*60*1e3 );
data.time = round(data.time);
end

