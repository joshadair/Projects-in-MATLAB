function imtext=text2im(text,varargin)
% Generate an image from text (white text on black background)
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
%
% /=========================================================================================\
% ||                     | Windows             | Linux               | MacOS               ||
% ||---------------------------------------------------------------------------------------||
% || Matlab R2023a       | W11: Pass           |                     |                     ||
% || Matlab R2022b       | W11: Pass           | Ubuntu 22.04: Pass  | Monterey: Pass      ||
% || Matlab R2022a       | W11: Pass           |                     |                     ||
% || Matlab R2021b       | W11: Pass           | Ubuntu 22.04: Pass  | Monterey: Pass      ||
% || Matlab R2021a       | W11: Pass           |                     |                     ||
% || Matlab R2020b       | W11: Pass           | Ubuntu 22.04: Pass  | Monterey: Pass      ||
% || Matlab R2020a       | W11: Pass           |                     |                     ||
% || Matlab R2019b       | W11: Pass           | Ubuntu 22.04: Pass  | Monterey: Pass      ||
% || Matlab R2019a       | W11: Pass           |                     |                     ||
% || Matlab R2018a       | W11: Pass           | Ubuntu 22.04: Pass  |                     ||
% || Matlab R2017b       | W11: Pass           | Ubuntu 22.04: Pass  | Monterey: Pass      ||
% || Matlab R2016b       | W11: Pass           | Ubuntu 22.04: Pass  | Monterey: Pass      ||
% || Matlab R2015a       | W11: Pass           | Ubuntu 22.04: Pass  |                     ||
% || Matlab R2013b       | W11: Pass           |                     |                     ||
% || Matlab R2007b       | W11: Pass           |                     |                     ||
% || Matlab 6.5 (R13)    | W11: Pass           |                     |                     ||
% || Octave 8.2.0        | W11: Pass           |                     |                     ||
% || Octave 7.2.0        | W11: Pass           |                     |                     ||
% || Octave 6.2.0        | W11: Pass           | Raspbian 11: Pass   | Catalina: Pass      ||
% || Octave 5.2.0        | W11: Pass           |                     |                     ||
% || Octave 4.4.1        | W11: Pass           |                     | Catalina: Pass      ||
% \=========================================================================================/

[success,opts,ME] = text2im_parse_inputs(text,varargin{:});
if ~success
    error(ME.identifier,ME.message)
end

[HasGlyph,glyphs,valid] = text2im_load_database(opts.font);

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
            row = ASCII_encode(row);
            [row,IgnoreMissing] = rich_to_plain_text(row,valid); %#ok<ASGLU>
            row = ASCII_decode(row);
        end
        if ConvertFromUTF16
            % Get the Unicode code points from the UTF-16 encoding.
            row = UTF16_to_unicode(row);%Returns uint32.
        else
            % Get the Unicode code points from the UTF-8 encoding.
            row = UTF8_to_unicode(row);%Returns uint32.
        end
        c{n} = row;
    end
    
    % Split over standard newlines(LF/CR/CRLF). We can't use regexp() or split() here, as the text
    % is uint32, not char.
    for n=1:numel(c)
        % This function returns a cell array with 1xN elements of the input data type.
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
[match,split] = regexp_outkeys(str,'&#\d+;','match','split');
symbols = unique(match);
match{end+1} = ''; % Make sure the allignment is correct.
txt = [split;match];txt = txt(:).'; % Merge and linearize.
for n=1:numel(symbols)
    % Convert each &#___; to the Unicode number and then to char.
    u = str2double(symbols{n}(3:(end-1)));
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
        str = PatternReplace(str,int32([13 10]),int32(-10));
        str(str==13) = -10;
    end
    str(str==10) = -10;
else
    for n=1:numel(LineEnding)
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
options                    = parse_warning_error_redirect_options(  options  );
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
function [f,status]=GetWritableFolder(varargin)
%Return a folder with write permission
%
% If the output folder doesn't already exist, this function will attempt to create it. This
% function should provide a reliable and repeatable location to write files.
%
% Syntax:
%   f = GetWritableFolder
%   [f,status] = GetWritableFolder
%   [__] = GetWritableFolder(Name,Value)
%   [__] = GetWritableFolder(options)
%
% Input/output arguments:
% f:
%   Char array with the full path to the writable folder. This does not contain a trailing filesep.
% status:
%   A scalar double ranging from 0 to 3. 0 denotes a failure to find a folder, 1 means the folder
%   is in a folder close to the AddOn folder, 2 that it is a folder in the tempdir, 3 mean that the
%   returned path is a folder in the current directory.
% options:
%   A struct with Name,Value parameters. Missing parameters are filled with the defaults listed
%   below. Using incomplete parameter names or incorrect capitalization is allowed, as long as
%   there is a unique match.
%
% Name,Value parameters:
%   ForceStatus:
%      Retrieve the path corresponding to the status value. Using 0 allows an automatic
%      determination of the location (default=0;).
%    ErrorOnNotFound:
%      Throw an error when failing to find a writeable folder (default=true;).
%
%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%
%|                                                                         |%
%|  Version: 1.0.0                                                         |%
%|  Date:    2021-02-19                                                    |%
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
% - The path returned with status=1 is mostly the same as the addonpath for most releases. Although
%   it is not correct for all release/OS combinations, it should still work. If you have a managed
%   account, this might result in strange behavior.

[success,options,ME] = GetWritableFolder_parse_inputs(varargin{:});
if ~success
    rethrow(ME)
else
    [ForceStatus,ErrorOnNotFound,root_folder_list] = deal(options.ForceStatus,...
        options.ErrorOnNotFound,options.root_folder_list);
end
root_folder_list{end} = pwd; % Set this default here to avoid storing it in a persistent.
if ForceStatus
    status = ForceStatus;f=fullfile(root_folder_list{status},'PersistentFolder');
    try if ~exist(f,'dir'),makedir(f);end,catch,end
    return
end

% Option 1: use a folder similar to the AddOn Manager.
status = 1;f = root_folder_list{status};
try if ~exist(f,'dir'),makedir(f);end,catch,end
if ~TestFolderWritePermission(f)
    % If the Add-On path is not writable, return the tempdir. It will not be persistent, but it
    % will be writable.
    status = 2;f = root_folder_list{status};
    try if ~exist(f,'dir'),makedir(f);end,catch,end
    if ~TestFolderWritePermission(f)
        % The tempdir should always be writable, but if for some reason it isn't: return the pwd.
        status = 3;f = root_folder_list{status};
    end
end

% Add 'PersistentFolder' to whichever path was determined above.
f = fullfile(f,'PersistentFolder');
try if ~exist(f,'dir'),makedir(f);end,catch,end

if ~TestFolderWritePermission(f)
    % Apparently even the pwd isn't writable, so we will either return an error, or a fail state.
    if ErrorOnNotFound
        error('HJW:GetWritableFolder:NoWritableFolder',...
            'This function was unable to find a folder with write permissions.')
    else
        status = 0;f = '';
    end
end
end
function [success,options,ME]=GetWritableFolder_parse_inputs(varargin)
%Parse the inputs of the GetWritableFolder function
% This function returns a success flag, the parsed options, and an ME struct.
% As input, the options should either be entered as a struct or as Name,Value pairs. Missing fields
% are filled from the default.

% Pre-assign outputs.
success = false;
ME = struct('identifier','','message','');

persistent default
if isempty(default)
    %Set defaults for options.
    default.ForceStatus = false;
    default.ErrorOnNotFound = false;
    default.root_folder_list = {...
        GetPseudoAddonpath;
        fullfile(tempdir,'MATLAB');
        ''};% Overwrite this last element with pwd when called.
end

if nargin==2
    options = default;
    success = true;
    return
end

% Actually parse the Name,Value pairs (or the struct).
[options,replaced] = parse_NameValue(default,varargin{:});

% Test the optional inputs.
for k=1:numel(replaced)
    curr_option = replaced{k};
    item = options.(curr_option);
    ME.identifier = ['HJW:GetWritableFolder:incorrect_input_opt_' lower(curr_option)];
    switch curr_option
        case 'ForceStatus'
            try
                if ~isa(default.root_folder_list{item},'char')
                    % This ensures an error for item=[true false true]; as well.
                    error('the indexing must have failed, trigger error')
                end
            catch
                ME.message=sprintf('Invalid input: expected a scalar integer between 1 and %d.',...
                    numel(default.root_folder_list));
                return
            end
        case 'ErrorOnNotFound'
            [passed,options.ErrorOnNotFound] = test_if_scalar_logical(item);
            if ~passed
                ME.message = 'ErrorOnNotFound should be either true or false.';
                return
            end
        otherwise
            ME.message = sprintf('Name,Value pair not recognized: %s.',curr_option);
            ME.identifier = 'HJW:GetWritableFolder:incorrect_input_NameValue';
            return
    end
end
success = true;ME = [];
end
function f=GetPseudoAddonpath
% This is mostly the same as the addonpath. Technically this is not correct for all release/OS
% combinations and the code below should be used:
%     addonpath='';
%     try s = Settings;addonpath=get(s.matlab.addons,'InstallationFolder');end %#ok<TRYNC>
%     try s = Settings;addonpath=get(s.matlab.apps,'AppsInstallFolder');end %#ok<TRYNC>
%     try s = settings;addonpath=s.matlab.addons.InstallationFolder.ActiveValue;end %#ok<TRYNC>
%
% However, this returns an inconsistent output:
%     R2011a          <pref doesn't exist>
%     R2015a Ubuntu  $HOME/Documents/MATLAB/Apps
%            Windows %HOMEPATH%\MATLAB\Apps
%     R2018a Ubuntu  $HOME/Documents/MATLAB/Add-Ons
%            Windows %HOMEPATH%\MATLAB\Add-Ons
%     R2020a Windows %APPDATA%\MathWorks\MATLAB Add-Ons
%
% To make the target folder consistent, only one of these options is chosen.
if ispc
    [ignore,appdata] = system('echo %APPDATA%'); %#ok<ASGLU>
    appdata(appdata<14) = ''; % (remove LF/CRLF)
    f = fullfile(appdata,'MathWorks','MATLAB Add-Ons');
else
    [ignore,home_dir] = system('echo $HOME'); %#ok<ASGLU>
    home_dir(home_dir<14) = ''; % (remove LF/CRLF)
    f = fullfile(home_dir,'Documents','MATLAB','Add-Ons');
end
end
function tf=hasFeature(feature)
% Provide a single point to encode whether specific features are available.
persistent FeatureList
if isempty(FeatureList)
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
    FeatureList.CharIsUTF8 = CharIsUTF8;
end
tf = FeatureList.(feature);
end
function tf=ifversion(test,Rxxxxab,Oct_flag,Oct_test,Oct_ver)
%Determine if the current version satisfies a version restriction
%
% To keep the function fast, no input checking is done. This function returns a NaN if a release
% name is used that is not in the dictionary.
%
% Syntax:
%   tf = ifversion(test,Rxxxxab)
%   tf = ifversion(test,Rxxxxab,'Octave',test_for_Octave,v_Octave)
%
% Input/output arguments:
% tf:
%   If the current version satisfies the test this returns true. This works similar to verLessThan.
% Rxxxxab:
%   A char array containing a release description (e.g. 'R13', 'R14SP2' or 'R2019a') or the numeric
%   version (e.g. 6.5, 7, or 9.6). Note that 9.10 is interpreted as 9.1 when using numeric input.
% test:
%   A char array containing a logical test. The interpretation of this is equivalent to
%   eval([current test Rxxxxab]). For examples, see below.
%
% Examples:
% ifversion('>=','R2009a') returns true when run on R2009a or later
% ifversion('<','R2016a') returns true when run on R2015b or older
% ifversion('==','R2018a') returns true only when run on R2018a
% ifversion('==',9.14) returns true only when run on R2023a
% ifversion('<',0,'Octave','>',0) returns true only on Octave
% ifversion('<',0,'Octave','>=',6) returns true only on Octave 6 and higher
% ifversion('==',9.10) returns true only when run on R2016b (v9.1) not on R2021a (9.10).
%
% The conversion is based on a manual list and therefore needs to be updated manually, so it might
% not be complete. Although it should be possible to load the list from Wikipedia, this is not
% implemented.
%
%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%
%|                                                                         |%
%|  Version: 1.2.0                                                         |%
%|  Date:    2023-04-06                                                    |%
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
% - This is expected to work on all releases.

if nargin<2 || nargout>1,error('incorrect number of input/output arguments'),end

% The decimal of the version numbers are padded with a 0 to make sure v7.10 is larger than v7.9.
% This does mean that any numeric version input needs to be adapted. multiply by 100 and round to
% remove the potential for float rounding errors.
% Store in persistent for fast recall (don't use getpref, as that is slower than generating the
% variables and makes updating this function harder).
persistent  v_num v_dict octave
if isempty(v_num)
    % Test if Octave is used instead of Matlab.
    octave = exist('OCTAVE_VERSION', 'builtin');
    
    % Get current version number. This code was suggested by Jan on this thread:
    % https://mathworks.com/matlabcentral/answers/1671199#comment_2040389
    v_num = [100, 1] * sscanf(version, '%d.%d', 2);
    
    % Get dictionary to use for ismember.
    v_dict = {...
        'R13' 605;'R13SP1' 605;'R13SP2' 605;'R14' 700;'R14SP1' 700;'R14SP2' 700;
        'R14SP3' 701;'R2006a' 702;'R2006b' 703;'R2007a' 704;'R2007b' 705;
        'R2008a' 706;'R2008b' 707;'R2009a' 708;'R2009b' 709;'R2010a' 710;
        'R2010b' 711;'R2011a' 712;'R2011b' 713;'R2012a' 714;'R2012b' 800;
        'R2013a' 801;'R2013b' 802;'R2014a' 803;'R2014b' 804;'R2015a' 805;
        'R2015b' 806;'R2016a' 900;'R2016b' 901;'R2017a' 902;'R2017b' 903;
        'R2018a' 904;'R2018b' 905;'R2019a' 906;'R2019b' 907;'R2020a' 908;
        'R2020b' 909;'R2021a' 910;'R2021b' 911;'R2022a' 912;'R2022b' 913;
        'R2023a' 914};
end

if octave
    if nargin==2
        warning('HJW:ifversion:NoOctaveTest',...
            ['No version test for Octave was provided.',char(10),...
            'This function might return an unexpected outcome.']) %#ok<CHARTEN>
        if isnumeric(Rxxxxab)
            v = 0.1*Rxxxxab+0.9*fixeps(Rxxxxab);v = round(100*v);
        else
            L = ismember(v_dict(:,1),Rxxxxab);
            if sum(L)~=1
                warning('HJW:ifversion:NotInDict',...
                    'The requested version is not in the hard-coded list.')
                tf = NaN;return
            else
                v = v_dict{L,2};
            end
        end
    elseif nargin==4
        % Undocumented shorthand syntax: skip the 'Octave' argument.
        [test,v] = deal(Oct_flag,Oct_test);
        % Convert 4.1 to 401.
        v = 0.1*v+0.9*fixeps(v);v = round(100*v);
    else
        [test,v] = deal(Oct_test,Oct_ver);
        % Convert 4.1 to 401.
        v = 0.1*v+0.9*fixeps(v);v = round(100*v);
    end
else
    % Convert R notation to numeric and convert 9.1 to 901.
    if isnumeric(Rxxxxab)
        % Note that this can't distinguish between 9.1 and 9.10, and will the choose the former.
        v = fixeps(Rxxxxab*100);if mod(v,10)==0,v = fixeps(Rxxxxab)*100+mod(Rxxxxab,1)*10;end
    else
        L = ismember(v_dict(:,1),Rxxxxab);
        if sum(L)~=1
            warning('HJW:ifversion:NotInDict',...
                'The requested version is not in the hard-coded list.')
            tf = NaN;return
        else
            v = v_dict{L,2};
        end
    end
end
switch test
    case '==', tf = v_num == v;
    case '<' , tf = v_num <  v;
    case '<=', tf = v_num <= v;
    case '>' , tf = v_num >  v;
    case '>=', tf = v_num >= v;
end
end
function val=fixeps(val)
% Round slightly up to prevent rounding errors using fix().
val = fix(val+eps*1e3);
end
function varargout=makedir(d)
% Wrapper function to account for old Matlab releases, where mkdir fails if the parent folder does
% not exist. This function will use the legacy syntax for those releases.
if exist(d,'dir'),return,end % Take a shortcut if the folder already exists.
persistent IsLegacy
if isempty(IsLegacy)
    % The behavior changed after R14SP3 and before R2007b, but since the legacy syntax will still
    % work in later releases there isn't really a reason to pinpoint the exact release.
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
[passed,IsValidated] = test_if_scalar_logical(opts.boolean.IsValidated);
if passed && IsValidated
    return
end

% Parse the logical that determines if a warning will be printed to the command window.
% This is true by default, unless an fid, obj, or fcn is specified, which is ensured elsewhere. If
% the fid/obj/fcn turn out to be invalid, this will revert to true at the end of this function.
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
    default_params = parse_print_to___get_default;
    default_params = default_params.params;
end
if isempty(item),item=struct;end
if ~isa(item,'struct'),ErrorFlag = true;item = default_params;return,end
while true
    try MExc = []; %#ok<NASGU>
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
            [passed,item.(p)] = test_if_scalar_logical(item.(p));
            if ~passed
                ErrorFlag=true;
                item.(p) = default_params.(p);
            end
        case 'WipeTraceForBuiltin'
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
            trace = get_trace(0,stack);
        catch
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
        [trace,stack] = get_trace(3);
        [id,msg] = deal('',varargin{1});
    end
else
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
    print_to = parse_NameValue(parse_print_to___get_default,opts);
    print_to.boolean.IsValidated = false;
catch
    % Apparently the input is the long form struct, and therefore should be parsed to the short
    % form struct, after which it can be validated.
    print_to = parse_print_to___named_fields_to_struct(opts);
end

% Now we can validate the struct. Here we will ignore any invalid parameters, replacing them with
% the default settings.
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
idx = bsxfun_plus(x,reshape(0:(numel(rep)-1),[],1));
idx = reshape(idx,1,[]);
out(idx) = repmat(rep,1,numel(x));

% Remove the elements beyond the range of what the resultant array should be.
out((numel(str)+1):end) = [];
end
function varargout=regexp_outkeys(str,expression,varargin)
%Regexp with outkeys in old releases
%
% On older versions of Matlab the regexp function did not allow you to specify the output keys.
% This function has an implementation of the 'split', 'match', and 'tokens' output keys, so they
% can be used on any version of Matlab or GNU Octave. The 'start' and 'end' output keys were
% already supported as trailing outputs, but are now also explictly supported.
% On releases where this is possible, the builtin is called.
%
% Syntax:
%   out = regexp_outkeys(str,expression,outkey);
%   [out1,...,outN] = regexp_outkeys(str,expression,outkey1,...,outkeyN);
%   [___,startIndex] = regexp_outkeys(___);
%   [___,startIndex,endIndex] = regexp_outkeys(___);
%
% Example:
%  str = 'lorem1 ipsum1.2 dolor3 sit amet 99 ';
%  words = regexp_outkeys(str,'[ 0-9.]+','split')
%  numbers = regexp_outkeys(str,'[0-9.]*','match')
%  [white,end1,start,end2] = regexp_outkeys(str,' ','match','end')
%
%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%
%|                                                                         |%
%|  Version: 2.0.0.1                                                       |%
%|  Date:    2023-09-12                                                    |%
%|  Author:  H.J. Wisselink                                                |%
%|  Licence: CC by-nc-sa 4.0 ( creativecommons.org/licenses/by-nc-sa/4.0 ) |%
%|  Email = 'h_j_wisselink*alumnus_utwente_nl';                            |%
%|  Real_email = regexprep(Email,{'*','_'},{'@','.'})                      |%
%|                                                                         |%
%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%
%
% Tested on several versions of Matlab (ML 6.5 and onward) and Octave (4.4.1 and onward), and on
% multiple operating systems (Windows/Ubuntu/MacOS). You can see the full test matrix below.
% Compatibility considerations:
% - Only the 'match', 'split', 'tokens', 'start', and 'end' options are supported. The additional
%   options provided by regexp are not implemented.
% - Cell array input is not supported.

if nargin<2
    error('HJW:regexp_outkeys:SyntaxError',...
        'No supported syntax used: at least 3 inputs expected.')
    % As an undocumented feature this can also return s1,s2 without any outkeys specified.
end
if ~(ischar(str) && ischar(expression))
    % The extra parameters in varargin are checked inside the loop.
    error('HJW:regexp_outkeys:InputError',...
        'All inputs must be char vectors.')
end
if nargout>nargin
    error('HJW:regexp_outkeys:ArgCount',...
        'Incorrect number of output arguments. Check syntax.')
end

persistent legacy errorstr KeysDone__template
if isempty(legacy)
    % The legacy struct contains the implemented options as field names. It is used in the error
    % message.
    % It is assumed that all Octave versions later than 4.0 support the expanded output, and all
    % earlier versions do not, even if it is very likely most versions will support it.
    
    % Create these as fields so they show up in the error message.
    legacy.start = true;
    legacy.end = true;
    
    % The switch to find matches was introduced in R14 (along with the 'tokenExtents', 'tokens'
    % and 'names' output switches).
    legacy.match = ifversion('<','R14','Octave','<',4);
    legacy.tokens = legacy.match;
    
    % The split option was introduced in R2007b.
    legacy.split = ifversion('<','R2007b','Octave','<',4);
    
    fn = fieldnames(legacy);
    errorstr = ['Extra regexp output type not implemented,',char(10),'only the following',...
        ' types are implemented:',char(10),sprintf('%s, ',fn{:})]; %#ok<CHARTEN>
    errorstr((end-1):end) = ''; % Remove trailing ', '
    
    legacy.any = legacy.match || legacy.split || legacy.tokens;
    
    % Copy all relevant fields and set them to false.
    KeysDone__template = legacy;
    for x=fieldnames(KeysDone__template).',KeysDone__template.(x{1}) = false;end
end

if legacy.any || nargin==2 || any(ismember(lower(varargin),{'start','end'}))
    % Determine s1, s2, and TokenIndices only once for the legacy implementations.
    [s1,s2,TokenIndices] = regexp(str,expression);
end

if nargin==2
    varargout = {s1,s2,TokenIndices};return
end

% Pre-allocate output.
varargout = cell(size(varargin));
done = KeysDone__template; % Keep track of outkey in case of repeats.
% On some releases the Matlab is not convinced split is a variable, so explicitly assign it here.
split = [];
for param=1:(nargin-2)
    if ~ischar(varargin{param})
        error('HJW:regexp_outkeys:InputError',...
            'All inputs must be char vectors.')
    end
    switch lower(varargin{param})
        case 'match'
            if done.match,varargout{param} = match;continue,end
            if legacy.match
                % Legacy implementation.
                match = cell(1,numel(s1));
                for n=1:numel(s1)
                    match{n} = str(s1(n):s2(n));
                end
            else
                [match,s1,s2] = regexp(str,expression,'match');
            end
            varargout{param} = match;done.match = true;
        case 'split'
            if done.split,varargout{param} = split;continue,end
            if legacy.split
                % Legacy implementation.
                split = cell(1,numel(s1)+1);
                start_index = [s1 numel(str)+1];
                stop_index = [0 s2];
                for n=1:numel(start_index)
                    split{n} = str((stop_index(n)+1):(start_index(n)-1));
                    if numel(split{n})==0,split{n} = char(ones(0,0));end
                end
            else
                [split,s1,s2] = regexp(str,expression,'split');
            end
            varargout{param}=split;done.split = true;
        case 'tokens'
            if done.tokens,varargout{param} = tokens;continue,end
            if legacy.tokens
                % Legacy implementation.
                tokens = cell(numel(TokenIndices),0);
                for n=1:numel(TokenIndices)
                    if size(TokenIndices{n},2)~=2
                        % No actual matches for the tokens.
                        tokens{n} = cell(1,0);
                    else
                        for m=1:size(TokenIndices{n},1)
                            tokens{n}{m} = str(TokenIndices{n}(m,1):TokenIndices{n}(m,2));
                        end
                    end
                end
            else
                [tokens,s1,s2] = regexp(str,expression,'tokens');
            end
            varargout{param} = tokens;done.tokens = true;
        case 'start'
            varargout{param} = s1;
        case 'end'
            varargout{param} = s2;
        otherwise
            error('HJW:regexp_outkeys:NotImplemented',errorstr)
    end
end
if nargout>param
    varargout(param+[1 2]) = {s1,s2};
end
end
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
        ConversionTable{n,3} = ASCII_decode(ConversionTable{n,1});
    end
    [ignore,order] = sort(sort_order); %#ok<ASGLU>
    ConversionTable = ConversionTable(order,:);
end
if nargout>=3,conversiontable = ConversionTable;end

% Determine which symbols occur in str.
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
function tf=TestFolderWritePermission(f)
%Returns true if the folder exists and allows Matlab to write files.
% An empty input will generally test the pwd.
%
% examples:
%   fn='foo.txt';if ~TestFolderWritePermission(fileparts(fn)),error('can''t write!'),end

if ~( isempty(f) || exist(f,'dir') )
    tf = false;return
end

fn = '';
while isempty(fn) || exist(fn,'file')
    % Generate a random file name, making sure not to overwrite any existing file.
    % This will try to create a file without an extension.
    [ignore,fn] = fileparts(tmpname('write_permission_test_','.txt')); %#ok<ASGLU>
    fn = fullfile(f,fn);
end
try
    % Test write permission.
    fid = fopen(fn,'w');fprintf(fid,'test');fclose(fid);
    delete(fn);
    tf = true;
catch
    % Attempt to clean up.
    if exist(fn,'file'),try delete(fn);catch,end,end
    tf = false;
end
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
    matfilename = fullfile(GetWritableFolder,'FileExchange','text2im','glyph_database.mat');
    f = fileparts(matfilename);if ~exist(f,'dir'),makedir(f);end
    if exist(matfilename,'file')
        S = load(matfilename);fn = fieldnames(S);glyph_database = S.(fn{1});
    end
    if purge,glyph_database=[];end
    if isempty(glyph_database)
        if triggerGUI
            glyph_database = text2im_create_pref_struct(triggerGUI);
        else
            glyph_database = text2im_create_pref_struct;
        end
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
function str=tmpname(StartFilenameWith,ext)
% Inject a string in the file name part returned by the tempname function.
if nargin<1,StartFilenameWith = '';end
if ~isempty(StartFilenameWith),StartFilenameWith = [StartFilenameWith '_'];end
if nargin<2,ext='';else,if ~strcmp(ext(1),'.'),ext = ['.' ext];end,end
str = tempname;
[p,f] = fileparts(str);
str = fullfile(p,[StartFilenameWith f ext]);
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
        error_(print_to,ME)
    end
    unicode = UTF8; % Return input unchanged (apart from casting to uint32).
end
end
function [UTF8,flag,ME]=UTF8_to_unicode_internal(UTF8,return_on_error)
flag = 'success';
ME = struct('identifier','HJW:UTF8_to_unicode:notUTF8','message','Input is not UTF-8.');

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

