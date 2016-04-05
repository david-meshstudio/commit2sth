-module(test).
-export([try1/0, try2/0, try3/0]).
-import(apilib,[call/2]).

try1() ->
	apilib:eth_getBalance("0x01e4cb51ec4768b9430b06a6ec2284c7977cca48").
	% inets:start(),
	% % case httpc:request(post,{"http://localhost:8545",[],"application/x-www-form-urlencoded",lists:concat([])})
	% % {ok, {{_, 200, _}, _, _}} = httpc:request(get, {"http://www.baidu.com", []}, [], []).
	% case httpc:request(post,{"http://localhost:8545",[],"application/x-www-form-urlencoded","{\"jsonrpc\":\"2.0\",\"method\":\"eth_getBalance\",\"params\":[\"0x01e4cb51ec4768b9430b06a6ec2284c7977cca48\",\"latest\"],\"id\":1}"},[],[]) of
	% 	{ok, {_, _, Body}} -> Body;
	% 	{error, Reason} -> io:format("error cause ~p~n", [Reason])
	% end.

try2() ->
	apilib:eth_getCompilers().

try3() ->
	apilib:eth_compileSolidity("contract test { function multiply(uint a) returns(uint d) {   return a * 7;   } }").