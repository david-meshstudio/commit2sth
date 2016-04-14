-module(c2s_controller).
-import(mvp01,[getBalance/0,getMember/1,register/1,deposite/1,withdraw/1,getTranBlockGap/1]).
-import(rfc4627,[encode/1,decode/1]).
-export([do/3]).

do(SessionID, _Env, Input) ->
	Data = decode(Input),
	io:format("~p~n", [Data]),
	Header = ["Content-Type: text/plain; charset=utf-8\r\n\r\n"],
	{ok, {obj, [{_, Command}, {_, Params}]}, []} = Data,
	case binary_to_list(Command) of
		"getBalance" ->
			Content = getBalance();
		"getMember" ->
			Content = getMember(Params);
		"register" ->
			Content = register(Params);
		"deposite" ->
			Content = deposite(Params);
		"withdraw" ->
			Content = withdraw(Params);
		"tranBlockGap" ->
			Content = getTranBlockGap(Params);
		_ ->
			Content = "No such query."
	end,
	mod_esi:deliver(SessionID, [Header, unicode:characters_to_binary(Content), ""]).