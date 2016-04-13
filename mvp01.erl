-module(mvp01).
-export([getBalance/0,getMember/1,register/1,deposite/1,withdraw/1,readMemberData/1]).
-import(rfc4627,[encode/1,decode/1]).
-import(apilib,[call/2,eth_getBalance/1,eth_getCompilers/0,eth_compileSolidity/1,eth_sendTransaction/4,eth_getTransactionReceipt/1,web3_sha3/1,padleft/2,get_methodCallData/2,get_methodSignHash/1,eth_methodCall/3,get_methodSign/2,eth_propertyCall/2,eth_propertyMappingCall/3,string2hexstring/1,hexstring2string/1,hex2de/1]).
-define(CA, "0x6B015e3c7D407977fa053e577F89A319667d3A21").

getBalance() ->
	eth_getBalance("0x01E4Cb51Ec4768B9430b06A6EC2284C7977cCa48").

getMember(Params) ->
	[Oid|L] = Params,
	readMemberData(eth_propertyMappingCall(?CA, "memberList", [{"bytes32", Oid, 64, 0}])).

register(Params) ->
	[Oid, Amount|L] = Params,
	eth_methodCall(?CA, "Register", [{"bytes32", Oid, 64, 0}, {"string", Name, 64, 64}]).

deposite(Params) ->
	[Oid, Amount|L] = Params,
	eth_methodCall(?CA, "Deposite", [{"bytes32", Oid, 64, 0}, {"uint256", Amount, 64, 0}]).

withdraw(Params) ->
	[Oid, Amount|L] = Params,
	eth_methodCall(?CA, "Withdraw", [{"bytes32", Oid, 64, 0}, {"uint256", Amount, 64, 0}]).

readMemberData(Data) ->
	Offset = hex2de(lists:sublist(Data, 1, 64)),
	Balance = hex2de(lists:sublist(Data, 64 + 1, 64)),
	NameLength = hex2de(lists:sublist(Data, 64 + Offset + 1, 64)),
	Name = hexstring2string(lists:sublist(Data, 64 + Offset + 64 + 1, NameLength * 2)),
	lists:flatten(io_lib:format("~s ~p",[Name, Balance])).
	% encode({Name, Balance}).