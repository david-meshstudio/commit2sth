-module(apilib).
-export([call/2,eth_getBalance/1,eth_getCompilers/0,eth_compileSolidity/1,eth_sendTransaction/4,eth_getTransactionReceipt/1]).
-import(rfc4627,[encode/1,decode/1]).

call(Method, Params) ->
	inets:start(),
	case httpc:request(post,{"http://localhost:8545",[],"application/x-www-form-urlencoded","{\"jsonrpc\":\"2.0\",\"method\":\""++Method++"\",\"params\":"++Params++",\"id\":1}"},[],[]) of
		{ok, {_, _, Body}} -> Body;
		{error, Reason} -> io:format("error cause ~p~n", [Reason])
	end.

call_cpp(Method, Params) ->
	inets:start(),
	case httpc:request(post,{"http://localhost:8546",[],"application/x-www-form-urlencoded","{\"jsonrpc\":\"2.0\",\"method\":\""++Method++"\",\"params\":"++Params++",\"id\":1}"},[],[]) of
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
	{ok, {obj, [_, _, {_, {obj, ContractCodes}}]}, _} = decode(call_cpp("eth_compileSolidity","[\""++Code++"\"]")),
	{ContractNames, BinCodes, Infos} = get_contractCodeInfo(ContractCodes),
	{ContractNames, BinCodes, Infos}.

get_contractCodeInfo([H|CL]) ->
	{ContractName, {obj, [{_, BinCode}, {_, Info}]}} = H,
	{C, B, I} = get_contractCodeInfo(CL),
	{[ContractName|C], [BinCode|B], [Info|I]};
get_contractCodeInfo([]) ->
	{[], [], []}.

eth_sendTransaction(From, Gas, Value, Data) ->
	Params = "[{\"from\":\""++From++"\",\"gas\":\""++Gas++"\",\"value\":\""++Value++"\",\"data\":\""++Data++"\"}]",
	call("eth_sendTransaction", Params).

eth_getTransactionReceipt(Txid) ->
	call("eth_getTransactionReceipt","[\""++Txid++"\"]").