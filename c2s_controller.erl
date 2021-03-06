-module(c2s_controller).
-import(mvp01,[getBalance/0,getBalance/1,getMember/1,register/1,deposite/1,withdraw/1,getTranBlockGap/1]).
-import(rfc4627,[encode/1,decode/1]).
-export([do/3]).

do(SessionID, _Env, Input) ->
	Data = decode(Input),
	io:format("~p~n", [Data]),
	Header = ["Content-Type: text/plain; charset=utf-8\r\n\r\n"],
	{ok, {obj, [{_, Command}, {_, Params}]}, []} = Data,
	case binary_to_list(Command) of
		"getBalance" when Params =:= <<>> ->
			Content = encode(getBalance());
		"getBalance" ->
			Content = encode(getBalance(binary_to_list(Params)));
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
		"tyrande_register" ->
			Content = tyrande_verify:register(Params);
		"tyrande_verify" ->
			Content = tyrande_verify:verify(Params);
		"tyrande_file_register" ->
			Content = tyrande_file_verify:register(Params);
		"tyrande_file_verify" ->
			Content = tyrande_file_verify:verify(Params);
		_ ->
			Content = "No such query."
	end,
	mod_esi:deliver(SessionID, [Header, unicode:characters_to_binary(Content), ""]).