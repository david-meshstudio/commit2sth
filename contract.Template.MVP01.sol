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
		if(memberList[_oid].balance >= _amount)
		{
			memberList[_oid].balance -= _amount;
		}
	}
	function Record(bytes32 _oid, address _commit) public
	{
		commitHistory[_oid].push(_commit);
	}
}
contract MVP01
{
	MemberRegister memberRegister;
	bytes64 public name = "_Name_";
	uint public start = _Start_;
	uint public duration = _Duration_;
	bytes32 public roleA = "_RoleA_";
	bytes32 public roleC = "_RoleC_";
	uint public aword = _Aword_;
	uint public resultA = 0;
	uint public result = 0;
	function Init(address addr) public
	{
		memberRegister = MemberRegister(addr);
	}
	function Fund() public
	{
		memberRegister.Withdraw(roleA, aword);
	}
	function Close(bytes32 caller, uint judge) public returns(uint res)
	{
		if(now < start + duration * 1 days)
		{
			if(caller == roleC)
			{
				result = judge;
				return Execute();
			}
			else
			{
				if(caller == roleA)
				{
					resultA = judge;
					return 3;
				}
			}
		}
		else
		{
			return Execute();
		}
	}
	function HasExpired() public returns(uint res)
	{
		if(now >= start + duration * 1 days)
		{
			return Execute();
		}
		else
		{
			return 2;
		}
	}
	function Execute() private returns(uint res)
	{
		if(result == 1)
		{
			memberRegister.Deposite(roleA, aword);
			return 1;
		}
		else
		{
			if(result == 2)
			{
				memberRegister.Deposite(roleC, aword);
				return 1;
			}
			else
			{
				if(resultA == 1)
				{
					memberRegister.Deposite(roleA, aword);
					return 1;
				}
				else
				{
					if(resultA == 2)
					{
						memberRegister.Deposite(roleC, aword);
						return 1;
					}
					else
					{
						return Fail();
					}
				}
			}			
		}
	}
	function Fail() private returns(uint res)
	{
		memberRegister.Deposite(roleA, aword);
		return 0;
	}
}