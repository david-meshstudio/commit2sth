-module(mvp01).
-export([getBalance/0,getMember/1,register/2,deposite/2]).
-import(rfc4627,[encode/1,decode/1]).
-import(apilib,[call/2,eth_getBalance/1,eth_getCompilers/0,eth_compileSolidity/1,eth_sendTransaction/4,eth_getTransactionReceipt/1,web3_sha3/1,padleft/2,get_methodCallData/2,get_methodSignHash/1,eth_methodCall/3,get_methodSign/2,eth_propertyCall/2,eth_propertyMappingCall/3,string2hexstring/1]).
-define(CA, "0x6B015e3c7D407977fa053e577F89A319667d3A21").

getBalance() ->
	eth_getBalance("0x01E4Cb51Ec4768B9430b06A6EC2284C7977cCa48").

getMember(Oid) ->
	eth_propertyMappingCall(?CA, "memberList", [{"bytes32", Oid, 64, 0}]).

register(Oid, Name) ->
	eth_methodCall(?CA, "Register", [{"bytes32", Oid, 64, 0}, {"string", Name, 64, 64}]).

deposite(Oid, Amount) ->
	eth_methodCall(?CA, "Deposite", [{"bytes32", Oid, 64, 0}, {"uint256", Amount, 64, 0}]).

withdraw(Oid, Amount) ->
	eth_methodCall(?CA, "Withdraw", [{"bytes32", Oid, 64, 0}, {"uint256", Amount, 64, 0}]).