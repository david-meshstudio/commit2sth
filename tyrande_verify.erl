-module(tyrande_verify).
-export([register/1, verify/1]).
-import(rfc4627,[encode/1,decode/1]).
-import(apilib,[call/2,eth_getBalance/1,eth_getCompilers/0,eth_compileSolidity/1,eth_sendTransaction/4,eth_getTransactionReceipt/1,web3_sha3/1,padleft/2,get_methodCallData/2,get_methodSignHash/1,eth_methodCall/3,get_methodSign/2,eth_propertyCall/2,eth_propertyMappingCall/3,string2hexstring/1,hexstring2string/1,hex2de/1,hexstring2de/1,get_tranBlockGap/1]).
-define(CA, "0x84C14009978cE66a57bE226457f08E6f3f34D2A6").

register(Params) ->
	[SN, Content|_] = Params,
	eth_methodCall(?CA, "Register", [{"bytes32", binary_to_list(SN), 64, 0}, {"string", binary_to_list(Content), 64, 64}]).

verify(Params) ->
	[SN|_] = Params,
	readMemberData(eth_propertyMappingCall(?CA, "productList", [{"bytes32", binary_to_list(SN), 64, 0}])).

readMemberData(Data) ->
	Offset = hex2de(lists:sublist(Data, 1, 64)),
	Balance = hex2de(lists:sublist(Data, 64 + 1, 64)),
	NameLength = hex2de(lists:sublist(Data, 64 + Offset + 1, 64)),
	Name = hexstring2string(lists:sublist(Data, 64 + Offset + 64 + 1, NameLength * 2)),
	lists:flatten(io_lib:format("~s|||~p",[Name, Balance])).