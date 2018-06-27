# Artonomous

Artonomous is a self-sustaining, self-improving, autonomous artist. It generates art by itself, sells it and incentivizes humans to improve the art it creates. Owners of the art piece owns the scarce, immutable, collectible art. This is implemented on the Ethereum blockchain.

## Daily Art Auction

Every day, it sells a piece of art using generative art along with a blockhash from Ethereum as its input. This art uses the ERC721 standard so that it becomes tradable and transferable on the Ethereum blockchain. The proceeds from the art that is sold gets deposited into a pool that it controls (the pool). The issues have more information on how the art auction works.

## Curve Bond as Lifeblood

The art bot thrives on a curved bond (https://medium.com/@simondlr/tokens-2-0-curved-token-bonding-in-curation-markets-1764a2e0bee5). At any point someone can buy a soul token whose price is calculated based on the current supply of soul tokens. The more soul tokens in circulation, the higher the price of the new soul tokens. The ETH used to buy the soul token is also deposited and owned by the autonomous artist. A soul token can at any point be destroyed for access to a percentage of the ETH in this communal pool.

The ETH owned by the artist thus grows as more are buying soul tokens and as more art is sold.

Besides being able to claim the ETH that the autonomous artist makes from selling its generative art, the soul tokens are used to stake against the current hash of the software used to generate the new art.

The proposed first iteration is this generator: https://mattdesl.svbtle.com/generative-art-with-nodejs-and-canvas.

NOTE: There's currently a discussion on starting off with multiple generators. Please contribute -> https://github.com/simondlr/artonomous/issues/21.

## ERC721

Every art piece conforms to the ERC721 Non-Fungible Token standard allowing it to be easily sold and transferred.

Every art piece contains two core components. It's hash at the time of auction (derived from most staked soul tokens) & its blockhash that serves as input for its art.

## Serving the Art Bot

This project can implemented all on the client side. It doesn't have to utilise other components such as IPFS.

## Help

Thanks to everyone who has contributed thus far! The issues present the work necessary. Feel free to pick up where you can. I'll be writing a more extensive contributers guide soon.

## Licensing

It's imperative that the software used to generate the art is permissively licensed.

This code is ideally licensed as MIT.

## Thanks & Inspiration

Here's the original post. https://medium.com/@simondlr/lets-summon-an-autonomous-artist-a-bot-that-creates-owns-and-sells-its-own-art-ada1afad086a. Thanks to Trent McConaghy & Greg McMullen with whom I initially had this discussion with back in 2016 to create such an experiment.
