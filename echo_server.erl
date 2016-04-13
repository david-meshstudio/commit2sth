-module(echo_server).
-export([start/0, echo/3]).

start() ->
	inets:stop(),
	application:ensure_started(inets),
	inets:start(httpd, [
			{modules, [mod_esi]},
			{port, 5000},
			{server_name, "test"},
			{document_root, "www"},
			{server_root, "www"},
			{erl_script_alias, {"/api", [echo_controller]}}
		]).

echo(SessionID, [{request_method, "GET"}], Input) ->
	io:format("~p~n", [Input]),
	Header = ["Content-Type: text/plain; charset=utf-8\r\n\r\n"],
	Content = "echo GET:",
	mod_esi:deliver(SessionID, [Header, unicode:characters_to_binary(Content), Input]);
echo(SessionID, [{request_method, "POST"}], Input) ->
	io:format("~p~n", [Input]),
	Header = ["Content-Type: text/plain; charset=utf-8\r\n\r\n"],
	Content = "echo POST:",
	mod_esi:deliver(SessionID, [Header, unicode:characters_to_binary(Content), Input]).