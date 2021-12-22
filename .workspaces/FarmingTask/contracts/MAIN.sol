// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import"https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";

contract MAIN {
    IERC20 public BNBtoken;
    uint private _totalSupply;
    mapping(address => uint) public _balances;
    uint public LPval1;
    uint public LPval2;
    uint public LPval3;
    uint public depositAmount;
    uint public poolnum;
    uint public currentPool;
    // uint public rewardclaim;
    constructor(address _bnb){
        BNBtoken = IERC20(_bnb);
        
    }
    function DepositBNB(uint _amount) public {
        depositAmount = _amount;
      _totalSupply += _amount;
        _balances[msg.sender] += _amount;
        BNBtoken.transferFrom(msg.sender, address(this), _amount);  
    }
      function SendForLiquidity(uint _amount) public  {
        // WithdrawBlock = block.timestamp;
        // withdrawAmount = _amount;
        _totalSupply -= _amount;
        _balances[msg.sender] -= _amount;
        BNBtoken.transfer(msg.sender, _amount);
      }
     function CallApprove( address _spender, uint256 amount) external returns(bool) {
        return BNBtoken.approve(_spender,amount);
    }
     
    function Calltransfer(address _account,address recipient, uint256 amount) external returns(bool){
        return IERC20(_account).transfer(recipient,amount);
    }
    
    function CallTotalSuply() external view returns (uint){
        uint c =BNBtoken.totalSupply();
        return c;
    }
    function CallAllowance(address _owner,address _spender) external view returns (uint){
        uint c =BNBtoken.allowance(_owner,_spender);
        return c;
    }
    
    function createPool (address _factory, address _bnb , address _Btoken) external {
        currentPool = poolnum;
        
        user(_factory).createPair(_bnb,_Btoken);
        poolnum +=1;
        
    }
    
    // function ClaimREWARD(address _rwd) external{
        
    //      return user(_rwd).transferFrom(msg.sender, address(this), _amount); 
    // }
    
    
    function split()public {
        LPval1 = ((depositAmount)*30)/100;
        LPval2 = ((depositAmount)*40)/100;
        LPval3 = ((depositAmount)*20)/100;
    }
    function liquidityamount() public{
        uint tempamou = LPval3 + LPval2 +LPval1;
        SendForLiquidity(tempamou);
    }
    
    function addLP(address _router,
    address _tokenA,address _tokenB,
    uint _amountAD,uint _amountBD,
    uint _Amin,uint _Bmin ,
    address _to,uint _deadline) external{
    user(_router).addLiquidity(_tokenA,_tokenB,_amountAD,_amountBD,_Amin,_Bmin,_to,_deadline);    
    }
    
    function addinFarm(address _farm,uint256 __allocPoint,
        IERC20 __want,
        bool __withUpdate,
        address __strat) external{
            
            user(_farm).add(__allocPoint,__want,__withUpdate,__strat);
            
        }
    
    function FarmDeposit(address _farm,uint _pid,uint _amount) external {
        user(_farm).deposit(_pid,_amount);
    }
    
    function FarmWithdraw(address _farm,uint _pid,uint _amount) external{
        
        user(_farm).withdraw(_pid,_amount);
        
    }
    
}
interface user {
    // function totalSupply() external view returns (uint);

    // function balanceOf(address account) external view returns (uint);

    // function transfer(address recipient, uint amount) external returns (bool);

    // function allowance(address owner, address spender) external view returns (uint);

    // function approve(address spender, uint amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint amount
    ) external returns (bool);
    function createPair(address tokenA, address tokenB) external returns (address pair);
    
     function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity);
    
    function deposit(uint256 _pid, uint256 _wantAmt) external;
    
    function add(
        uint256 _allocPoint,
        IERC20 _want,
        bool _withUpdate,
        address _strat
    ) external ;
    
    function withdraw(uint256 _pid, uint256 _wantAmt) external;
    
    
    function mint(address to,uint amount) external;

    // event Transfer(address indexed from, address indexed to, uint value);
    // event Approval(address indexed owner, address indexed spender, uint value);
}