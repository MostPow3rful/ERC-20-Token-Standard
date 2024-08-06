// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

error ERC20_NotEnoughAmount();
error ERC20_NotAllowedAddress();

contract ERC20 {
    string immutable _NAME;
    string immutable _SYMBOL;
    address immutable _OWNER;
    uint256 _totalSupply;

    mapping(address userAddress => uint256 balance) _balanceOf;
    mapping(address owner => mapping(address spender => uint256 amount)) _allowance;

    event Transfer(address indexed from, address indexed to, uint256 _amount);
    event Approval(address indexed owner, address indexed spender, uint256 amount);

    modifier onlyOwner {
        require(msg.sender == _OWNER);
        _;
    }

    constructor(string _name, string _symbol, uint256 _supply) {
        _OWNER = msg.sender;
        _NAME = _name;
        _SYMBOL = _symbol;
        _balanceOf[msg.sender] = _supply;
        _totalSupply = _supply;
    }

    function name() external view returns (string memory) {
        return _NAME;
    }

    function symbol() external view returns (string memory) {
        return _SYMBOL;
    }

    function owner() external view returns (address) {
        return _OWNER;
    }

    function totalSupply() external view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address _addr) external view returns (uint256) {
        return _balanceOf[_addr];
    }

    function allowance(address _owner, address _spender) external view returns (uint256) {
        return _allowance[_owner][_spender];
    }

    function mint(address _to, uint256 _amount) external onlyOwner {
        _balanceOf[_to] += _amount;
        _totalSupply += _amount;

        emit Transfer(address(0), _to, _amount);
    }

    function approve(address _spender, uint256 _amount) external returns (bool) {
        _allowance[msg.sender][_spender] = _amount;
        emit Approval(msg.sender, _spender, _amount);
        return true;
    }

    function burn(uint256 _amount) external returns (bool) {
        require(_balanceOf[msg.sender] >= _amount, ERC20_NotEnoughAmount());

        _balanceOf[msg.sender] -= _amount;
        _totalSupply -= _amount;

        return true;
    }

    function transfer(address _to, uint256 _amount) external returns (bool) {
        require(_balanceOf[msg.sender] >= _amount, ERC20_NotEnoughAmount());
        require(_to != address(0), ERC20_NotAllowedAddress());

        _balanceOf[msg.sender] -= _amount;
        _balanceOf[_to] += _amount;

        emit Transfer(msg.sender, _to, _amount);

        return true;
    }

    function transferFrom(address _from, address _to, uint256 _amount) external returns (bool) {
        require(_allowance[_from][msg.sender] >= _amount, ERC20_NotEnoughAmount());
        require(_from != address(0), ERC20_NotAllowedAddress());
        require(_to != address(0), ERC20_NotAllowedAddress());

        _allowance[_from][msg.sender] -= _amount;

        _balanceOf[_from] -= _amount;
        _balanceOf[_to] += _amount;

        emit Transfer(_from, _to, _amount);

        return true;
    }
}

