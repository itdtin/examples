// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import '@openzeppelin/contracts/token/common/ERC2981.sol';
import "./ERC721A.sol";

contract NFTToken is ERC721A, ReentrancyGuard, AccessControl, Ownable {
    bytes32 public constant SUPPORT_ROLE = keccak256('SUPPORT');
    bytes32 public constant REFUND_ROLE = keccak256('REFUND');

    uint256 public constant MAX_SUPPLY = 1000; //Todo should be changed
    string private _baseURIextended;

    address payable public immutable withdrawAddress;
    bool public auctionActive;

    event Bid(address bidder, uint256 bidAmount, uint256 bidderTotal, uint256 bucketTotal);

    constructor(address payable _withdrawAddress) ERC721A("NFT token", "NFT") {
        require(_withdrawAddress != address(0));

        // set immutable variables
        withdrawAddress = _withdrawAddress;

        // set up roles
        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
        _setupRole(SUPPORT_ROLE, _msgSender());
    }

    function mint(address to, uint256 numberOfTokens) public onlyRole(REFUND_ROLE) nonReentrant {
        uint256 totalMinted = _totalMinted(); // ignore burn counter here
        require(totalMinted + numberOfTokens <= MAX_SUPPLY, 'Number would exceed max supply');
        _safeMint(to, numberOfTokens);
    }

    /**
    * @notice send refunds and tokens to a batch of addresses.
    * @param addresses array of addresses to send tokens to.
    */
    function sendTokensBatch(address[] calldata addresses, uint256 amountForEach) external onlyRole(REFUND_ROLE) {
        for (uint256 i; i < addresses.length; i++) {
            mint(addresses[i], amountForEach);
        }
    }

    /**
    * @notice mint reserve tokens.
    * @param n number of tokens to mint.
    */
    function reserve(uint256 n) external onlyOwner {
        mint(_msgSender(), n);
    }

    /**
    * @notice burn a token you own.
    * @param tokenId token ID to burn.
    */
    function burn(uint256 tokenId) external onlyOwner {
        _burn(tokenId, true);
    }

    /**
     * @dev sets the base uri for {_baseURI}
     */
    function setBaseURI(string memory baseURI_) external onlyRole(SUPPORT_ROLE) {
        _baseURIextended = baseURI_;
    }

    /**
     * @dev See {ERC721-_baseURI}.
     */
    function _baseURI() internal view virtual override returns (string memory) {
        return _baseURIextended;
    }

    /**
     * @dev withdraw function for owner.
     */
    function withdraw() external onlyOwner {
        (bool success, ) = withdrawAddress.call{value: address(this).balance}("");
        require(success, "Transfer failed.");
    }

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId)
    public
    view
    virtual
    override(AccessControl, ERC721A)
    returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}