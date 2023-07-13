// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract MembershipNFT is ERC1155, Ownable, AccessControl {
    uint256 public constant Harmonizer = 0;
    uint256 public constant Balancer = 1;
    uint256 public constant Magician = 2;
    uint256 public constant Accountant = 3;
    uint256 public constant Pathfinder = 4;
    uint256 public constant Maestro = 5;
    uint256 public constant SystemAdministrator = 6;
    uint256 public constant GuildAssociationMember = 7;
    uint256 public constant QuestBoardMember = 8;
    uint256 public constant Crypto = 9;
    uint256 public constant Metaverse = 10;

    mapping(uint256 => string) private _uris;
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");

    constructor(
        address admin
    )
        public
        ERC1155(
            "https://gateway.pinata.cloud/ipfs/Qmbot1Q9mVskrMHd6MPE7d6gqAsLnuFWWbgdD155smbcyg/{id}.json"
        )
    {
        _setupRole(ADMIN_ROLE, admin);

        _mint(msg.sender, Harmonizer, 100, "");
        _mint(msg.sender, Balancer, 100, "");
        _mint(msg.sender, Magician, 100, "");
        _mint(msg.sender, Accountant, 100, "");
        _mint(msg.sender, Pathfinder, 100, "");
        _mint(msg.sender, Maestro, 100, "");
        _mint(msg.sender, SystemAdministrator, 100, "");
        _mint(msg.sender, GuildAssociationMember, 100, "");
        _mint(msg.sender, QuestBoardMember, 100, "");
        _mint(msg.sender, Crypto, 100, "");
        _mint(msg.sender, Metaverse, 100, "");
    }

    modifier onlyAdmin() {
        require(hasRole(ADMIN_ROLE, msg.sender), "Caller is not a admin");
        _;
    }

    function supportsInterface(
        bytes4 interfaceId
    ) public view virtual override(ERC1155, AccessControl) returns (bool) {
        return
            interfaceId == type(IAccessControl).interfaceId ||
            interfaceId == type(IERC1155).interfaceId ||
            interfaceId == type(IERC1155MetadataURI).interfaceId ||
            super.supportsInterface(interfaceId);
    }

    function mint(
        address[] calldata to,
        uint256 id,
        bytes memory data
    ) public onlyAdmin {
        for (uint256 i = 0; i < to.length; i++) {
            if (balanceOf(to[i], id) == 0) {
                _mint(to[i], id, 1, data);
            }
        }
    }

    function burn(address from, uint256 id) external onlyAdmin {
        _burn(from, id, 1);
    }

    function uri(uint256 tokenId) public view override returns (string memory) {
        return
            string(
                abi.encodePacked(
                    "https://gateway.pinata.cloud/ipfs/Qmbot1Q9mVskrMHd6MPE7d6gqAsLnuFWWbgdD155smbcyg/",
                    Strings.toString(tokenId),
                    ".json"
                )
            );
    }

    function setTokenUri(uint256 tokenId, string memory _uri) public onlyAdmin {
        require(bytes(_uris[tokenId]).length == 0, "Cannot set uri twice");
        _uris[tokenId] = _uri;
    }

    function _beforeTokenTransfer(
        address,
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory,
        bytes memory
    ) internal virtual override {
        for (uint256 i = 0; i < ids.length; i++) {
            require(
                from == address(0) || to == address(0),
                "This token is not transferable."
            );
        }
    }

    function setApprovalForAll(address, bool) public virtual override {
        require(
            false,
            "You can't approve this NFT because this is Non Transferable NFT."
        );
    }
}
