//SPDX-License-Identifier: MIT
pragma solidity 0.7.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20Capped.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
contract DISCODEX is ERC20, ERC20Capped, ERC20Burnable, Ownable {  

    uint256 public constant HARD_CAP = 100_000 * (10 ** 18); // 100k tokens
    bool allowTransfer;
    mapping (address => bool) public whiteListTransfer;

    modifier isUnlocked() {
        require(allowTransfer || whiteListTransfer[msg.sender], "Can-not-transfer");
        _;
    }

    /**
     * @dev Constructor function of DISCO Token
     * @dev set name, symbol and decimal of token
     * @dev mint hardcap to deployer
     */
    constructor() public 
    ERC20("DISCO", "DISCO") 
    ERC20Capped(HARD_CAP) {
        _setupDecimals(18);
        whiteListTransfer[_msgSender()] = true;
        _mint(msg.sender, HARD_CAP);
    }

    /**
     * @dev Admin whitelist/un-whitelist transfer  
     * @dev to allow address transfer
     * @dev token before allowTransferOn
     */
    function adminWhiteList(address _whitelistAddr, bool _whiteList) public onlyOwner returns (bool) {
        whiteListTransfer[_whitelistAddr] = _whiteList;
        return true;
    }

    /**
     * @dev Admin can set allowTransfer to allow user transfer token normally
     */
    function adminUnlockTransfer() public onlyOwner returns (bool) {
        require(!allowTransfer, "Already-allowed");
        allowTransfer = true;
        return true;
    }

    function transfer(address to, uint amount) public isUnlocked override(ERC20) returns (bool) {
        return super.transfer(to, amount);
    }

    function transferFrom(address from, address to, uint amount) public isUnlocked override(ERC20) returns (bool) {
        return super.transferFrom(from, to, amount);
    }
     /**
     * @dev See {ERC20-_beforeTokenTransfer}.
     */
    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override(ERC20, ERC20Capped) {
        super._beforeTokenTransfer(from, to, amount);
    }
}
