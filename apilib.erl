-module(apilib).
-export([call/2,eth_getBalance/1,eth_getCompilers/0,eth_compileSolidity/1]).
-import(rfc4627,[encode/1,decode/1]).

call(Method, Params) ->
	inets:start(),
	% case httpc:request(post,{"http://localhost:8545",[],"application/x-www-form-urlencoded",lists:concat([])})
	% {ok, {{_, 200, _}, _, _}} = httpc:request(get, {"http://www.baidu.com", []}, [], []).
	case httpc:request(post,{"http://localhost:8545",[],"application/x-www-form-urlencoded","{\"jsonrpc\":\"2.0\",\"method\":\""++Method++"\",\"params\":"++Params++",\"id\":1}"},[],[]) of
		{ok, {_, _, Body}} -> Body;
		{error, Reason} -> io:format("error cause ~p~n", [Reason])
	end.

eth_getBalance(Account) ->
	{ok, {obj, [_, _, {_, Result}]}, _} = decode(call("eth_getBalance","[\""++Account++"\",\"latest\"]")),
	Result.

eth_getCompilers() ->
	{ok, {obj, [_, _, {_, Result}]}, _} = decode(call("eth_getCompilers","[]")),
	Result.

eth_compileSolidity(Code) ->
	% {ok, {obj, [_, _, {_, Result}]}, _} = decode(call("eth_compileSolidity","[\""++Code++"\"]")),
	% Result.
	call("eth_compileSolidity","[\""++Code++"\"]").