-module(c2s_controller).
-import(mvp01,[getBalance/0,getMember/1]).
-export([do/3,echo/3]).

do(SessionID, _Env, Input) ->
	[{server_software, _},{server_name, _},{gateway_interface, _},{server_protocol, _},{server_port, _},{request_method, Method},{remote_addr, _},{script_name, _},{http_host, _},{http_connection, _},{http_cache_control, _},{http_accept, _},{http_upgrade_insecure_requests, _},{http_user_agent, _},{http_accept_encoding, _},{http_accept_language, _},{http_cookie, _},{query_string, Query}] = _Env,
	io:format("~p~n ~p~n ~p~n", [Input, Method, Query]),
	Header = ["Content-Type: text/plain; charset=utf-8\r\n\r\n"],
	case Query of
		"getBalance" ->
			Content = getBalance();
		"getMember" ->
			Content = getMember(Input);
		true ->
			Content = "No such query."
	end,
	mod_esi:deliver(SessionID, [Header, unicode:characters_to_binary(Content), ""]).

echo(SessionID, _Env, Input) ->
	[{server_software, _},{server_name, _},{gateway_interface, _},{server_protocol, _},{server_port, _},{request_method, Method},{remote_addr, _},{script_name, _},{http_host, _},{http_connection, _},{http_cache_control, _},{http_accept, _},{http_upgrade_insecure_requests, _},{http_user_agent, _},{http_accept_encoding, _},{http_accept_language, _},{http_cookie, _},{query_string, _}] = _Env,
	io:format("~p~n ~p~n", [Input, Method]),
	Header = ["Content-Type: text/plain; charset=utf-8\r\n\r\n"],
	case Method of
		"GET" ->
			Content = "echo GET:";
		"POST" ->
			Content = "echo POST:";
		true ->
			Content = "echo OTHER:"
	end,
	mod_esi:deliver(SessionID, [Header, unicode:characters_to_binary(Content), Input]).