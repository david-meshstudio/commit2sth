contract MemberRegister
{
	struct Member
	{
		string name;
		uint balance;
	}
	mapping(bytes32 => Member) public memberList;
	mapping(bytes32 => address[]) public commitHistory;
	function Register(bytes32 _oid, string _name) public
	{
		memberList[_oid] = Member({
			name: _name,
			balance: 0
		});
	}
	function Deposite(bytes32 _oid, uint _amount) public
	{
		memberList[_oid].balance += _amount;
	}
	function Withdraw(bytes32 _oid, uint _amount) public
	{
		memberList[_oid].balance -= _amount;
	}
	function Record(bytes32 _oid, address _commit) public
	{
		commitHistory[_oid].push(_commit);
	}
}
contract MVP01
{
	string public name;
	uint public start;
	uint public duration;
	bytes32 public roleA = "_RoleA_";
	bytes32 public roleC = "_RoleC_";
	uint public aword = _Aword_;
	uint public resultA = 0;
	uint public result = 0;
	MemberRegister memberRegister;
	function Fund() public
	{
		memberRegister.Withdraw(roleA, aword);
	}
	function Close(bytes32 caller, uint _result) public returns(string res)
	{
		if(now < start + duration * 1 days)
		{
			if(caller == roleC)
			{
				result = _result;
				return Execute();
			}
			else
			{
				resultA = _result;
				return "wait";
			}
		}
		else
		{
			return HasExpired();
		}
	}
	function HasExpired() public returns(string res)
	{
		if(now >= start + duration * 1 days)
		{
			return Execute();
		}
		else
		{
			return "not";
		}
	}
	function Execute() private returns(string res)
	{
		if(result == 1)
		{
			memberRegister.Deposite(roleA, aword);
			return "ok";
		}
		else
		{
			if(result == 2)
			{
				memberRegister.Deposite(roleC, aword);
				return "ok";
			}
			else
			{
				if(resultA == 1)
				{
					memberRegister.Deposite(roleA, aword);
					return "ok";
				}
				else
				{
					if(resultA == 2)
					{
						memberRegister.Deposite(roleC, aword);
						return "ok";
					}
					else
					{
						return Fail();
					}
				}
			}			
		}
	}
	function Fail() private returns(string res)
	{
		memberRegister.Deposite(roleA, aword);
		return "fail";
	}
}