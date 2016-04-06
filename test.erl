-module(test).
-export([try1/0, try2/0, try3/0, try4/0, try5/0, try6/0]).
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
	apilib:eth_compileSolidity("contract test { function multiply(string a) returns(string d) {   return \\\"hello\\\";   } }").

try4() ->
	{ok, S} = file:open("contract.Template.MVP01.sol", read),
	Code = getLine(S, []),
	apilib:eth_compileSolidity(Code).
	% getLine(S, []).

try5() ->
	{ok, S} = file:open("contract.Template.MVP01.sol", read),
	Code = getLine(S, []),
	{_, [BH|_], _} = apilib:eth_compileSolidity(Code),
	apilib:eth_sendTransaction("0x01e4cb51ec4768b9430b06a6ec2284c7977cca48","0x186a00","0x0",binary_to_list(BH)).

try6() ->
	apilib:eth_getTransactionReceipt("0x2a083e179dc75225361da2f86ced4a1178dabeb85859e8cb159626545c9b9839").

getLine(S, R) ->
	case io:get_line(S, '') of
		eof -> R;
		C -> R ++ regularLine(C) ++ getLine(S, R)
	end.

regularLine(C) ->
	C1 = string:join(string:tokens(C, "\""), "\\\""),
	C2 = re:replace(C1,"_RoleA_","1234",[{return, list}]),
	C3 = re:replace(C2,"_RoleC_","5678",[{return, list}]),
	re:replace(C3,"_Aword_","100",[{return, list}]).