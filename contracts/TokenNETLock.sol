pragma solidity ^0.4.24;

import "zeppelin-solidity/contracts/token/ERC20/SafeERC20.sol";


/**
 * @title TokenTimelock
 * @dev TokenTimelock is a token holder contract that will allow a
 * beneficiary to extract the tokens after a given release time
 */
contract TokenTimelock {
  using SafeERC20 for ERC20Basic;

  // ERC20 basic token contract being held
  ERC20Basic public token;

  // beneficiary and token number to be send after contract tokens are released
  struct TokensLock{
    address beneficiary;
    uint256 numTokens;
  }

  //List with address and number of tokens lock
  TokensLock[] private tokensLockList;

  mapping(address->uint256) indexReference;

  // timestamp when token release is enabled
  uint256 public releaseTime;

  constructor(
    ERC20Basic _token,
    address _beneficiary,
    uint256 _numTokens,
    uint256 _releaseTime
  )
    public
  {
    // solium-disable-next-line security/no-block-members
    require(_releaseTime > block.timestamp);
    token = _token;
    tokensLockList.push(TokensLock({beneficiary:_beneficiary,numTokens:_numTokens}));
    indexReference[_beneficiary]=tokensLockList.lenght;
    releaseTime = _releaseTime;
  }

  // ***Owneronly***
  function addTokensToLock(
    address _beneficiary,
    uint256 _numTokens
  )
    public
  {
    tokensLockList.push(TokensLock({beneficiary:_beneficiary,numTokens:_numTokens}));
  }

  //** TODO: function to return the tokens locked by address
  function getTokensLock(address _beneficiary) public {

  }
  /**
   * @notice Transfers tokens held by timelock to beneficiary.
   */
  function release() public {
    // solium-disable-next-line security/no-block-members
    require(block.timestamp >= releaseTime);

    uint256 amount =0;
    for (uint i = 0; i < tokensLockList.length; i++) {
        amount = tokensLockList[i].numTokens;
        require(amount > 0);
        token.safeTransfer(tokensLockList[i].beneficiary, amount);
    }

  }
}
