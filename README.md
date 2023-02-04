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

11. Ejecutar el siguiente comando desde el terminal: `npx hardhat --network mumbai run scripts/deploy.js`. Con el uso de este comando, el smart contract se publicará en la red Matic testnet y también será verificado de manera automática. Si todos los pasos anterios fueron correctamente ejecutados, obtendrán el siguiente mensaje:

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

12. Dirígete a `https://ipfs.tech/#install` e instala la versión desktop de IPFS.

    ![image-20221024220019114](https://user-images.githubusercontent.com/3300958/198416349-1b953f59-d7d1-4079-ad4b-b5fd529346d3.png)

13. Ingresar a [Open Zeppelin Defender](https://defender.openzeppelin.com/) y crear una cuenta. Utilizaremos este servicio para recibir notificaciones cuando se efectúan transacciones en el smart contract

14. Ingresar a [Pinata Cloud](https://www.pinata.cloud/) y crear una cuenta. Usaremos Pinata para mantener disponibles nuestros acticos digitales guardados en el IPFS



### Temario del Workshop

0

Entender el panorama general de NFTs.

Interactuaremos con el [smart contract de NFTs](https://mumbai.polygonscan.com/address/0xc52Fa70CD7D4c56A30E30575394279D21a0c03df) de Cuyes ya publicado en Mumbai Polygon y entenderemos su funcionamiento interno.

Cada uno realizará un mint del NFT podrá ver su NFT en [Testnet OpenSea](https://testnets.opensea.io/).

Conferencia Activos digitales [aquí](https://www.canva.com/design/DAFQWmz4oxU/MKUJRFwEzgL2Z__UIZnNfg/edit)

1

Empezaremos por desarrollar los activos digitales mediante la combinación de diferentes capas usando la librearía [HashLips](https://github.com/HashLips/hashlips_art_engine).

2

Proyecto a desarrollar:

- Crear un mecanismo de airdrop en el contrato de token MPRTKN. Cada usuario podrá solicitar hasta 10,000 tokens cada 24 horas. Se usará este token para comprar un NFT.
- Desarrollar un contrato de NFT con 30 activos digitales que se puedan visualizar en OpenSea. Aplicar ingeniería inversa para deducir los métodos a implementar que son parte del estándar ERC721. Implementar cada uno de dichos métodos en un contrato NFT desde cero.
- En el contrato de NFT, desarrollar un mecanismo de compra de NFTs usando los tokens MPRTKN.
  - Si se deposita 5,000 tokens, se le entregará un NFT aleatorio
  - Si se deposita 10,000 tokens, el comprador escoge el ID del NFT
- En el contrato de NFT, desarrollar un mecanismo de Airdrop con lista blanca. Estos usuarios solo pueden solicitar un NFT.

### Desarrollo del Workshop

#### 1

**Generación de Imágenes usando HashLips**

 Imagen creada con software de generación de imágenes usando capas superpuestas. Descargar la librearía [HashLips art engine](https://github.com/HashLips/hashlips_art_engine).

![image-20221027154305989](https://user-images.githubusercontent.com/3300958/198416372-384d1216-24be-4fad-9e7a-a66cbbb27441.png)

_Carpeta `layers`_

 El punto de partida para la generación de NFTs, es la creación de capas a combinar. Cada NFT se puede descomponer en diferentes capas superpuestas. Estas capas se pueden combinar de manera aleatoria o incluir ciertos parámetros para asegurar que ciertas capas se repitan menos que otras.

 Por lo general, dichas capas son creadas en programas de edición de imágenes. Es importante que dicha capa mida en ancho y largo que cualquier otra capa y que, además, mantengan un fondo transparente permitir la visibilidad de una capa inferior.

 En dicha carpeta `layers`, se crea una carpeta por cada capa a usar. En dicha carpeta pueden existir varias imágenes. El orden de las capas a combinar se configura en el archivo `config.js`. Los nombres de dichas imágenes tienen un formato especial que contribuye con la cantidad de veces que se repetirá.

 El format es como sigue: `Black#1.png` `High#20.png`. Se guardan los archivos seguidos de un `#` y un número que representa su rareza. Si el valor de la rareza es mayor, su repetición en las imágenes será mayor.

![image-20221027134429840](https://user-images.githubusercontent.com/3300958/198416370-eacae6e7-5f6c-4156-84e2-a4ed13d8b3e9.png)

_Archivo `src/config.js`_

 Este es el único archivo que se tiene que cambiar para poder crear una colección. La configuración más importante se da en la siguiente variable del archivo `config.js`:

```javascript
const layerConfigurations = [
  {
    growEditionSizeTo: 5,
    layersOrder: [
      { name: "Background" },
      { name: "Eyeball" },
      { name: "Eye color" },
      { name: "Iris" },
      { name: "Shine" },
      { name: "Bottom lid" },
      { name: "Top lid" },
    ],
  },
  /**
		//incluir otras combinaciones de capas
		{...},
		{...},
	*/
];
```

 La variable `layerConfigurations` es un array de objectos en el que cada objeto representa una combinación diferente de capas. Se pueden considerar tantas capas como se desee. Las capas a usar se encuentran ya creadas en la carpeta `layers`, cuya creación se debe hacer con anterioridad a crear las imágenes.

 Cada objeto (combinación de capas) tiene dos propiedades: `growEditionSizeTo` y `layersOrder`. La primera variable (`growEditionSizeTo`) indica la cantidad de NFTs que se desea crear (puede ser un número grande como 10,000). La segunda variable (`layersOrder`) es un array que especifica las capas a usar y además el orden que se ubicarán las capas para crear los NFTs.

 _Nota: en el caso en que exitan varias combinaciones de capas, la variable `growEditionSizeTo` de cada objeto debe incluir el conteo del anterior._

 En el ejemplo mostrado, se ha considera una sola combinación de capas. En dicha combinación, se especifica que se generarán cinco NFTs. Las capas a usar y el orden están descritas en `layersOrder`. El nombre de las capas descritas en `layersOrder`, debe corresponder con el nombre de las carpetas que se encuentran en la carpeta `layers`.

_Generando los NFTs via terminal_

 Para generar las imágenes que serán parte de los NFTs, ejecutar el siguiente comando desde el terminal en la carpeta raíz: `node index.js`. Al hacerlo, se producirá el siguiente resultado:

```
Created edition: 1, with DNA: 092b37710d6bfc92aa049d4b05accc841e7c22fd
Created edition: 2, with DNA: 57980f389a30ca9db9bf31c11ee8a2794dcbbb72
Created edition: 3, with DNA: a07a9dad7fa467f9841644fe96e551bec34fca68
Created edition: 4, with DNA: 594219bfa83c650c4811a0db3ad0c2ec03f5bdf2
Created edition: 5, with DNA: 749f101fac6b14a3ad2024d979ad264167b8f104
```

 Al mismo, tiempo, notar que se ha creado una cartepa que se llama `build` que contiene dos carpetas: `images` y `json`. En la primera carpeta se guardan las imágenes generadas del resultado de combinar capas. La segunda carpeta guarda la metadata de cada imagen generada.

 Cada imagen posee su correspondiente archivo de metadata que ayuda a describirlo.

 Al ejecutar el comando otra vez, se generará otro set de imágenes diferentes al anterior producto de la aleatoreidad.

_¿Qué es la `metadata`?_

 Según la [documentación de Open Sea](https://docs.opensea.io/docs/metadata-standards), la metadata de cada imagen guardada en los archivos json, ayuda a describir los atributos y características de cada NFT para poder entender mejor su naturaleza.

![image-20221027145906629](https://user-images.githubusercontent.com/3300958/198416371-b4dde17f-b7b7-4dd9-a090-32eb350c0d74.png)

 Dentro de cada archivo json hay un atributo llamado `attributes` que es un arary de todos los atributos que describen dicha imagen en particular. Dichos atributos se verán reflejados en los diferentes marketplaces que pueden leer la matadata desde el front-end.

 Al generar los archivos json, notar que en el array `attributes`, se han creado dos atributos más: `trait_type` y `value`. `trait_type` ha adquirido el nombre de una carpeta de capas y `value` adquirió el nombre de uno de los archivos de esa carpeta capas. Veamos el siguiente ejemplo:

```json
"attributes": [
    {
      "trait_type": "Background",
      "value": "Black"
    },
  //...
```

 Aquí, "Background" es el nombre de una carpeta capa y "Black" el nombre de un archivo de esa carpeta.

_El archivo `.json`_

 Además de los atributos arriba mencionados, los archivos de formato `.json` generados en `build`, tienen otras propiedades que se muestran a continuación:

```json
{
  "name": "Your Collection #2",
  "description": "Remember to replace this description",
  "image": "ipfs://NewUriToReplace/2.png",
  "dna": "57980f389a30ca9db9bf31c11ee8a2794dcbbb72",
  "edition": 2,
  "date": 1666894593527,
  "attributes": [...]
}
```

Siendo las más importantes:

- `name`: nombre de la colección
- `description`: descripción de la colección
- `image`: ruta en IPFS en donde la imagen está guardada (se actualizará después)

_Modificar la rareza de cada capa_

 Supongamos que dentro de la carpeta `layers`, tenemos la siguiente capa `Eyeball` y dentro hay cuatro opciones de imágenes con su respectiva rareza denotada después del `#`:

```
Eyeball
- Gold#10.png
- Purple#20.png
- Read#30.png
- White#40.png
```

Se realiza una suma de todas las rarezas (10 + 20 + 30 + 40) y cada imagen aparecerá en una proporción de su rareza con respecto al total (10/100, 20/100, 30/100, 40/100). Es decir, `Purple#20` aparecerá dos veces más que `Gold#10`. `White#40` aparecerá dos veces más que `Purple#20` y así sucesivamente.

_Crear las imágenes en orden aleatorio_

 Cuando se tienen varias configuraciones de capas en el objeto `layerConfigurations`, para lograr que las diferentes imágenes se produzcan en un orden aleatorio (y no en el orden en que fueron puestos en `layerConfigurations`), dentro del archivo `src/config.js`, alterar la siguiente variable.

```javascript
const shuffleLayerConfigurations = true; // false => no cambiar el orden
```

_Incrementar tamaño de imágenes_

 En el archivo `config.js` la variable `format` puede ser modificada para cambiar el tamaño de las imágenes. Incrementar o decrementar `width` o `height` para incrementar o decrementar la resolución de las imágenes:

```javascript
const format = {
  width: 512,
  height: 512,
  smoothing: false,
};
```

_Incluir background en las imágenes_

 En el caso en que no se tenga una capa de background para las imágenes, la librería lo puede generar. La siguiente variable dentro del archivo `config.js` nos ayudará con ello:

```javascript
const background = {
  generate: true,
  brightness: "80%",
  static: false,
  default: "#000000",
};
```

_Tolerancia para la repetición_

 Si no existe una cantidad suficiente para generar imágenes, el sistema puede arrojar un error si la sensibilidad es alta. Para incrementar o disminuir la tolerancia, usar la siguiente variable:

```javascript
const uniqueDnaTorrance = 10000;
```

 Indica la cantidad de imágenes únicas que deben crearse antes de arrojar un error.

**Guardar imágenes en IPFS**

 Al correr el comando `node index.js`, se genera la carpeta `images` dentro de `build`. Abrimos la aplicación desktop de IPFS y nos dirigimos a `FILES` para poder arrastrar nuestra carpeta `images`.

![image-20221027171954458](https://user-images.githubusercontent.com/3300958/198416374-6fedb504-60fc-4d5a-8b4f-31a1a28b7db9.png)

 Notemos que el CID para esta carpeta es la siguiente: `QmfYqFm3NygtoX7kb7y9ukwV2Q9vF5UUdEKFUrCzn4Eb2f`. Este hash es importante porque apunta a la ubicación de nuestra carpeta dentro de IPFS y es requerido en los archivos json que contienen la metadata de las imágenes.

 Con el CID hallado, nos podemos dirigir a la siguiente ruta y encontrar las imágenes en IPFS: https://ipfs.io/ipfs/QmfYqFm3NygtoX7kb7y9ukwV2Q9vF5UUdEKFUrCzn4Eb2f

**Actualizando metadata con CID**

 Tenemos que actualizar la metadata con el nuevo CID generado en IPFS. Pasamos de:

```json
{
  "name": "Your Collection #1",
  "description": "Remember to replace this description",
  "image": "ipfs://UPDATEDURI/1.png",
  //...
```

a lo siguiente:

```json
{
  "name": "Your Collection #1",
  "description": "Remember to replace this description",
  "image": "ipfs://QmfYqFm3NygtoX7kb7y9ukwV2Q9vF5UUdEKFUrCzn4Eb2f/1.png",
  //...
```

 Para lograr actualizar el CID en todos los archivos json, nos dirigimos al archivo `config.js` y actualizamos la variable `baseUri`:

```javascript
const baseUri = "ipfs://QmfYqFm3NygtoX7kb7y9ukwV2Q9vF5UUdEKFUrCzn4Eb2f";
```

 Luego, corremos el siguiente comando para que se vea reflejado en los archivos json de metadata `node utils/update_info.js`.

**Subiendo metadata a IPFS**

 Al correr el comando, se actualiza los archivos json. Arrastrar la carpeta a IPFS y copiar el CID

![image-20221027175105353](https://user-images.githubusercontent.com/3300958/198416377-56a40d91-826d-4361-934c-3d23dbc99398.png)

 Para el archivo de metadata, el CID que nos arroja IPFS es `QmPz8pTK2kdAmAZGvbuRLJpKAhg4ojAdbXdtZKetigsjZY`. Usaremos este valor dentro del smart contract.

 Con el CID hallado, nos podemos dirigir a la siguiente ruta y encontrar los archivos metadata en IPFS: https://ipfs.io/ipfs/QmPz8pTK2kdAmAZGvbuRLJpKAhg4ojAdbXdtZKetigsjZY

**Pinata**

 En muchas circunstancias, es necesario usar un tercer servicio que nos ayuda a mantener la información disponible. Incluso cuando hay nodos que están fuera de línea, Pinata nos ayudará a mantener dichos recursos online.

_Subir recursos_

 Para subir recursos a Pinata, es posible hacerlo también usando el CID obtenido en IPFS. Seguir la siguiente ruta en [Pinata Manager](https://app.pinata.cloud/pinmanager):

`Upload + > * CID > IPFS CID to Pin > Copiar y Pegar el CID > Search and Pin`

_Ver recursos_

 Al finalizar la subida, se podrá visualizar los recursos en Pinata

![image-20221027180253186](https://user-images.githubusercontent.com/3300958/198416378-fc80da45-2f5a-4c9f-ba79-65214e2df4e2.png)

 Cabe notar que Pinata nos arroja diferentes links para acceder a los recursos:

https://gateway.pinata.cloud/ipfs/QmfYqFm3NygtoX7kb7y9ukwV2Q9vF5UUdEKFUrCzn4Eb2f

y

https://gateway.pinata.cloud/ipfs/QmPz8pTK2kdAmAZGvbuRLJpKAhg4ojAdbXdtZKetigsjZY

 Ya sea através del link provisto por IPFS o Pinata, podemos acceder a los recursos guardados en IPFS.

**Actualizando el Smart Contract**

 El contrato ERC721 posee un método que le permite leer los archivos de metadata guardados en IPFS. Dicho método es consultado para poder mostrar los atributos e imágenes guardados en IPFS.

 Debemos modificar el siguiente método:

```solidity
function _baseURI() internal pure returns (string memory) {
	return "ipfs://QmPz8pTK2kdAmAZGvbuRLJpKAhg4ojAdbXdtZKetigsjZY/";
}
```

 Una vez puesto el CID que apunta a los archivos metadata, el contrato puede ser publicado.

#### 2

name
symbol
safeMint
balanceOf
ownerOf
