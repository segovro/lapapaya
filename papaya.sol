pragma solidity ^0.4.11;

contract papaya {
    /* Public variables of the token */
    string public standard = 'Token 0.1';
    string public name = 'papaya';
    string public symbol = 'φ';
    uint8 public decimals = 2;
    uint256 public totalSupply = 100000000000;
    int256 public negLim = 5000;  // Limit of negative balances
    
    // Owner of this contract
    address public owner;
   
     // Balances for each account
    mapping(address => int256) balances;
  
     // Owner of account approves the transfer of an amount to another account
     mapping(address => mapping (address => uint256)) allowed;
     
     // Functions with this modifier can only be executed by the owner
     modifier onlyOwner() {
         if (msg.sender != owner) {
            throw;
         }
        _;
     }
     
     /* Initializes contract with initial supply tokens to the creator of the contract */
     function papaya(            					
         ) {
     		owner = msg.sender;
     		balances[msg.sender] = int256(totalSupply);       // Give the creator all initial tokens
     }

    /* This generates public events on the blockchain that will notify clients */
     
     // Triggered when tokens are transferred.
     event Transfer(address indexed _from, address indexed _to, uint256 _value);
 
      // Triggered whenever approve(address _spender, uint256 _value) is called.
     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
    
    /* Send coins */
    function transfer(address _to, uint256 _value) {			// Transfer the balance from owner's account to another account
    	int256 _ivalue = int256(_value);
        if (balances[msg.sender] < (_ivalue + negLim)) throw;   // Check if the sender has enough
        if (balances[_to] + _ivalue < balances[_to]) throw; 	// Check for overflows
        balances[msg.sender] -= _ivalue;                     	// Subtract from the sender
        balances[_to] += _ivalue;                            	// Add the same to the recipient
        Transfer(msg.sender, _to, _value);                   	// Notify anyone listening that this transfer took place
    }

    // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
    // If this function is called again it overwrites the current allowance with _value.
     function approve(address _spender, uint256 _amount) returns (bool success) {
         allowed[msg.sender][_spender] = _amount;
         Approval(msg.sender, _spender, _amount);
         return true;
    }
     
     // Send _value amount of tokens from address _from to address _to
     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
     // fees in sub-currencies; the command should fail unless the _from account has
     // deliberately authorized the sender of the message via some mechanism; we propose
     // these standardized APIs for approval:
     function transferFrom(
         address _from,
         address _to,
         uint256 _amount
     ) {
     		int256 _ivalue = int256(_amount);   
     		if (balances[_from] < (_ivalue + negLim)) throw;   		// Check if the sender has enough
	        if (balances[_to] + _ivalue < balances[_to]) throw; 	// Check for overflows
	        balances[_from] -= _ivalue;                     		// Subtract from the sender
	        balances[_to] += _ivalue;                            	// Add the same to the recipient
            Transfer(_from, _to, _amount);
     }

    // What is the balance of a particular account?
     function balanceOf(address _owner) constant returns (int256 balance) {
         return balances[_owner];
     }

	function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
	    return allowed[_owner][_spender];
	}

    /* This unnamed function is called whenever someone tries to send ether to it */
    function () {
        throw;     // Prevents accidental sending of ether
    }
}
