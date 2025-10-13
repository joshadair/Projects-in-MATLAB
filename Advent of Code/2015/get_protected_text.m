function textData = get_protected_text(url)
    % Prompt for session cookie
    session_cookie = input('Paste your session cookie: ', 's');

    % Create Java URL object
    urlObj = java.net.URL(url);
    connection = urlObj.openConnection();

    % Set the session cookie header
    connection.setRequestProperty('Cookie', ['session=' session_cookie]);

    % Set User-Agent to mimic a browser (optional but recommended)
    connection.setRequestProperty('User-Agent', ...
        'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/117.0 Safari/537.36');

    % Connect and get input stream
    inputStream = connection.getInputStream();
    scanner = java.util.Scanner(inputStream).useDelimiter('\A');

    if scanner.hasNext()
        textData = char(scanner.next());
    else
        textData = '';
    end

    % Clean up
    scanner.close();
    inputStream.close();
end
