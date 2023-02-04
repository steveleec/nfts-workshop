// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

contract MiPrimerTokenDesdeZero {
    /**
    1. Debeteria tener un nombre que lo identifique
    2. Debeteria tener un simbolo que lo identifique
    3. Metodo que nos permite recuperar la cantidad de decimales
    4. Metodo 'balanceOf' que me devuelve la cantidad de tokens de un address
        - lleva un argumento: address
        - retorna cantidad de tokens de esa address
    5. Metodo 'totalSuuply' me devuelve el total de tokens acuñados
    7. Método 'transfer' - envia tokens de mi cuenta a otra cuenta
        - lleva dos argumentos: address de destino y cantidad de tokens
    8. Método 'mint' - acuña tokens a favor de una persona
        - lleva dos argumentos: address de destino y cantidad de tokens
    9. Metodo 'transferFrom' - transfiere tokens de un address A a un address B
        - lleva 3 argumentos: addres origen, address destino y Q de tokens
    10. Metodo 'approve' - otorga permiso de manejar tokens a otra address
        - lleva 2 argumentos: address de spender y Q de tokens dados como permiso
    6. Metodo 'allowance' que devuelve la cantidad de permiso otorgado
        - lleva dos argumentos: owner y spender 
        - retorna la cantidad de tokens a operar en nombre de la otra persona
*/
    // 1.  Debeteria tener un nombre que lo identifique
    function name() public pure returns (string memory) {
        return "NTT Token"; // Incluir aqui el nombre del token
    }

    //    2. Debeteria tener un simbolo que lo identifique
    function symbol() public pure returns (string memory) {
        return "NTTTKN"; // Incluir aqui el nombre del token
    }

    //  3. Metodo que nos permite recuperar la cantidad de decimales
    function decimals() public pure returns (uint256) {
        return 18;
    }

    // 4. Metodo 'balanceOf' que me devuelve la cantidad de tokens de un address
    //     - lleva un argumento: address
    //     - retorna cantidad de tokens de esa address
    mapping(address => uint256) balances;

    function balanceOf(address account) public view returns (uint256) {
        return balances[account];
    }

    //    5. Metodo 'totalSuuply' me devuelve el total de tokens acuñados
    uint256 _totalSupply;

    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    address _owner;

    // Constructor
    // - se ejecuta una sola vez al publicar el smart contract
    constructor() {
        // aqui msg.sender es el address de quien publica el smart contract
        _owner = msg.sender;
    }

    modifier onlyOwner() {
        // if (msg.sender != owner) revert("No es el duenio");
        require(msg.sender == _owner, "No es el duenio");
        _;
    }

    // eventos
    event Transfer(address from, address to, uint256 amount);

    // 8. Método 'mint' - acuña tokens a favor de una persona
    // - lleva dos argumentos: address de destino y cantidad de tokens
    function mint(address to, uint256 amount) public onlyOwner {
        // balances[to] = balances[to] + amout;
        balances[to] += amount;
        _totalSupply += amount;

        emit Transfer(address(0), to, amount);
    }

    // 7. Método 'transfer' - envia tokens de mi cuenta a otra cuenta
    // - lleva dos argumentos: address de destino y cantidad de tokens
    function transfer(address to, uint256 amount) public {
        // if ( balances[msg.sender] < amount) revert("No tienes suficiente balance");
        // address que no tiene llave privada. Es decir, no puede realizar txs
        // address(0) no tiene llave privada = 0x0000000000000000000000000000000000000000
        require(balances[msg.sender] >= amount, "No tienes suficiente balance");
        require(to != address(0), "No se puede enviar a address(0)");

        balances[msg.sender] -= amount;
        balances[to] += amount;

        emit Transfer(msg.sender, to, amount);
    }

    function burn(uint256 amount) public {
        // 1 - se quema tokens del que llama (msg.sender)
        // totalSuuply? - disminuye
        // tabla balances - disminuye en 'amount'
        require(balances[msg.sender] >= amount, "No tiene suficiente balance");
        balances[msg.sender] -= amount;
        _totalSupply -= amount;
        emit Transfer(msg.sender, address(0), amount);
    }

    // 10. Metodo 'approve' - otorga permiso de manejar tokens a otra address
    //     - lleva 2 argumentos: address de spender y Q de tokens dados como permiso
    // 6. Metodo 'allowance' que devuelve la cantidad de permiso otorgado
    //     - lleva dos argumentos: owner y spender
    //     - retorna la cantidad de tokens a operar en nombre de la otra persona

    // Vamos a crear un mapping que guarde un mapping: 'allowances'
    event Approval(address owner, address spender, uint256 value);

    mapping(address => mapping(address => uint256)) allowances;

    function approve(address spender, uint256 amount) public {
        require(spender != address(0), "No se puede enviar a address(0)");
        // necesito 3 valores: owner, spender y amount
        // owner => msg.sender
        allowances[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
    }

    function allowance(
        address owner,
        address spender
    ) public view returns (uint256) {
        return allowances[owner][spender];
    }

    // 9. Metodo 'transferFrom' - transfiere tokens de un address A a un address B
    //     - lleva 3 argumentos: addres origen, address destino y Q de tokens
    function transferFrom(address from, address to, uint256 amount) public {
        // se tiene que confirmar que hay un permiso
        // msg.sender = spender

        require(from != address(0), "No se puede enviar desde address(0)");
        require(to != address(0), "No se puede enviar a address(0)");

        // allowances[from][msg.sender]: permiso del que llama este método
        require(
            allowances[from][msg.sender] >= amount,
            "El que llama no tiene permiso"
        );
        require(balances[from] >= amount, "Duenio no tiene balance");

        // actualizando los permisos
        allowances[from][msg.sender] -= amount;

        balances[from] -= amount;
        balances[to] += amount;

        emit Transfer(from, to, amount);
    }
}
