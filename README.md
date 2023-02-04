## <u>Arquitectura y Desarrollo de NFTs</u>

En este workshop vamos a desarrollar una colección de NFTs. En su desarrollo aprenderemos todo el ecosistema de herramientas necesarios para publicar la colección de NFTs usando smart contracts. El estándar de implementación para esta colección es el ERC721.

### Ecosistema para el desarrollo de NFTs:

1. **Activos digitales**: usaremos la ténica de combinación de capas aleatorias para la creación de los activos digitales. Se usará la librearía [HashLips](https://github.com/HashLips/hashlips_art_engine).
2. **Metadata**: Cada activo digital viene acompañado de su archivo metada que guarda la ruta donde se guardó el activo digital en IPFS.
3. **Smart Contract de NFT**: se seguirá el estándar ERC721 para el desarrollo del contrato de NFTs.
4. **IPFS**: Los activos digitales, así como también los archivos de metadata, serán guardados en el Sistema Interplanetario de Archivos (IPFS). Se usarán sus rutas de ubicación desde el smart contract para poder encontrarlos en el IPFS.
5. **Piñata**: Se indexarán los archivos guardados en IPFS en Piñata dado que este servicio mantiene disponibles y "despiertos" los activos guardados en IPFS.
6. **Hardhat**: A través de esta librería crearemos las automatizaciones necesarias para publicar, verificar y testear los smart contracta a demanda.

### **Guía de instalación:**

_Requisito: Tener una versión de NodeJs superior al 14_

Comenzaremos con la creación de un proyecto Hardhat desde cero. Crear una carpeta nueva. Ingresar a la carpeta desde el terminal y continuar con la instalación descrita a continuación:

1. En el terminal, ejecutar `npm init -y` para instalar el `package.json` del repositorio
2. En el terminal, ejecutar `npx hardhat` para comenzar la instalación. Al hacerlo, preguntará lo siguiente:

```
Need to install the following packages:
  hardhat
Ok to proceed? (y)
```

Tipear `y` y luego Enter. Al hacerlo, aparecerá el siguiente mensaje:

```
888    888                      888 888               888
888    888                      888 888               888
888    888                      888 888               888
8888888888  8888b.  888d888 .d88888 88888b.   8888b.  888888
888    888     "88b 888P"  d88" 888 888 "88b     "88b 888
888    888 .d888888 888    888  888 888  888 .d888888 888
888    888 888  888 888    Y88b 888 888  888 888  888 Y88b.
888    888 "Y888888 888     "Y88888 888  888 "Y888888  "Y888

👷 Welcome to Hardhat v2.12.0 👷‍

? What do you want to do? …
❯ Create a JavaScript project
  Create a TypeScript project
  Create an empty hardhat.config.js
  Quit
```

Escogemos la opción `Create a JavaScript project` con el teclado y luego presionamos Enter. Para continuar con el set up, darle a todo Enter.

```
✔ What do you want to do? · Create a JavaScript project
✔ Hardhat project root: · /Users/steveleec/Documents/0xLee/nfts-workshop
✔ Do you want to add a .gitignore? (Y/n) · y
✔ Do you want to install this sample project's dependencies with npm (hardhat @nomicfoundation/hardhat-toolbox)? (Y/n) · y
```

Al finalizar la instalación, obtendremos el siguiente mensaje:

```
✨ Project created ✨
```

Con todo esto, tendremos el cascaron de un entorno de desarrollo usando hardhat. Continuemos con la configuración

3. Instalar librería npm dotenv mediante `npm install --save dotenv`. Seguido a ello crearmos un archivo llamado `.env` con el comando `touch .env` ejecutado en el terminal. En el punto 8 se detalla el cómo obtener los valores para cada una de estas variables. Replicar el siguiente modelo dentro del archivo `.env`:

```
ADMIN_ACCOUNT_PRIVATE_KEY= es la llave privada obtenida de metamask
MUMBAI_TESNET_URL= URL de servicios de Alchemy
POLYGONSCAN_API_KEY= API KEY obtenida de Polygonscan
```

4. Intalar librería de contratos de Open Zeppelin mediante el command `npm install --save @openzeppelin/contracts`. De esta librer a reutilizaremos código ya testeado y validado.
5. Instalamos `@nomiclabs/hardhat-etherscan` para poder verificar los contratos mediante scripts desde Hardhat: `npm install --save-dev @nomiclabs/hardhat-etherscan`.
6. Actualizamos el archivo `hardhat.config.js` y debería contener lo siguiente:

```js
require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.17",
  networks: {
    mumbai: {
      url: process.env.MUMBAI_TESNET_URL,
      // url: "https://matic-mumbai.chainstacklabs.com",
      accounts: [process.env.ADMIN_ACCOUNT_PRIVATE_KEY],
      timeout: 0,
      gas: "auto",
      gasPrice: "auto",
    },
  },
  etherscan: { apiKey: process.env.POLYGONSCAN_API_KEY },
};
```

- `localhost`, `goerli` y `matic` son las redes que hardhat utilizará para poder publicar los contratos inteligentes.
- `url` es uno de los urls usados para poder conectarse a algún nodo privado. En la actualidad existen muchos servicios de conexión. En este caso en particular usaremos `Alchemy`.
- `accounts` es un array que contiene todas las llaves privadas de los address que serán usados para publicar los contratos
- `etherscan` hace referencia a una key obtenida en el explorador de bloques de cada blockchain (usualmente en mainnet) que permite hacer la verificación de smart contracts de manera automática

8. Rellenar las claves del archivo `.env`:

- `POLYGONSCAN_API_KEY`: Dirigirte a [Polygonscan](https://polygonscan.com/). Click en `Sign in`. Click en `Click to sign up` y terminar de crear la cuenta en Etherscan. Luego de crear la cuenta ingresar con tus credenciales. Dirigirte a la columna de la derecha. Buscar `OTHER` > `API Keys`. Crear un nuevo api key haciendo click en `+ Add` ubicado en la esquina superior derecha. Darle nombre al proyecto y click en `Create New API Key`. Copiar el `API Key Token` dentro del archivo `.env`.

- `ADMIN_ACCOUNT_PRIVATE_KEY`: Obtener el `private key` de la wallet que se usará para firmar transacciones. Esta wallet deberá tener fondos. Sigue [estos pasos](http://help.silamoney.com/en/articles/4254246-how-to-generate-ethereum-keys#:~:text=Retrieving%20your%20Private%20Key%20using,password%20and%20then%20click%20Confirm.). Al obtener la llave privada copiarlo en esta variable del archivo `.env`.

- `MUMBAI_TESNET_URL`: Crear una cuenta en [Alchemy](https://dashboard.alchemyapi.io/). Ingresar al dashboard y crear una app `+ CREATE APP`. Escoger `NAME` y `DESCRIPTION` cualquiera. Escoger `ENVIRONMENT` = `Development`, `CHAIN` = `Polygon` y `NETWORK` = `Mumbai`. Hacer click en `VIEW KEY` y copiar el link `HTTPS` en el documento `.env` para esta variable de entorno. Saltar el paso que te pide incluir tarjeta de débito.

  ![image-20230203175202108](https://user-images.githubusercontent.com/3300958/216736196-7c319e0a-36ca-456e-b4b9-72984d27e9b2.png)

![image-20230203175233207](https://user-images.githubusercontent.com/3300958/216736197-e81d4648-6c38-470a-9c48-2c883c9a9701.png)

9. Crear un archivo en la carpeta `contracts` llamado `MiPrimerToken.sol`. Puedes usar el comando `touch contracts/MiPrimerToken.sol` y pegar el siguiente script en dicho archivo:

   ```solidity
   // SPDX-License-Identifier: MIT
   pragma solidity 0.8.17;
   
   import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
   import "@openzeppelin/contracts/access/Ownable.sol";
   
   contract MiPrimerToken is ERC20, Ownable {
       constructor() ERC20("Mi Primer Token", "MPRTKN") {}
   
       function mint(address to, uint256 amount) public onlyOwner {
           _mint(to, amount);
       }
   }
   ```

10. Creamos el archivo de deployment `deploy.js` dentro de la carpeta scripts. Puedes usar el siguiente comando: `touch scripts/deploy.js` y pegar el siguiente script:

    ```javascript
    const hre = require("hardhat");
    
    async function main() {
      const MiPrimerToken = await hre.ethers.getContractFactory(
        "MiPrimerToken"
      );
      const miPrimerToken = await MiPrimerToken.deploy();
    
      var tx = await miPrimerToken.deployed();
      await tx.deployTransaction.wait(5);
    
      console.log(`Deploy at ${miPrimerToken.address}`);
    
      await hre.run("verify:verify", {
        address: miPrimerToken.address,
        constructorArguments: [],
      });
    }
    
    // We recommend this pattern to be able to use async/await everywhere
    // and properly handle errors.
    main().catch((error) => {
      console.error(error);
      process.exitCode = 1;
    });
    ```

11. Ejecutar el siguiente comando desde el terminal: `npx hardhat --network matic run scripts/deploy.js`. Con el uso de este comando, el smart contract se publicará en la red Matic testnet y también será verificado de manera automática. Si todos los pasos anterios fueron correctamente ejecutados, obtendrán el siguiente mensaje:

    ```
    Compiled 7 Solidity files successfully
    Deploy at 0x70330D4C4789981585B6e1B3D8d24E922BB84bCA
    Nothing to compile
    Successfully submitted source code for contract
    contracts/MiPrimerToken.sol:MiPrimerToken at 0x70330D4C4789981585B6e1B3D8d24E922BB84bCA
    for verification on the block explorer. Waiting for verification result...
    
    Successfully verified contract MiPrimerToken on Etherscan.
    https://mumbai.polygonscan.com/address/0x70330D4C4789981585B6e1B3D8d24E922BB84bCA#code
    ```

    Puedes rastrear la publicación y verificación del smart contract [aquí](https://mumbai.polygonscan.com/address/0x70330D4C4789981585B6e1B3D8d24E922BB84bCA#code).

12. Ingresar a [Open Zeppelin Defender](https://defender.openzeppelin.com/) y crear una cuenta. Utilizaremos este servicio para recibir notificaciones cuando se efectúan transacciones en el smart contract

13. Ingresar a [Pinata Cloud](https://www.pinata.cloud/) y crear una cuenta. Usaremos Pinata para mantener disponibles nuestros acticos digitales guardados en el IPFS
