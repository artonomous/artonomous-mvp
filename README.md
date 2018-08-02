# Artonomous

Artonomous is a self-sustaining, self-improving, autonomous artist.

The premise is that it sells generative art as an ERC721 NFT at a regular interval. The ETH it makes from selling the art gets deposited into a curved bond (SOUL tokens).

Utilizing digital art generators created by humans, it seeds art into them, sells it daily and incentivizes humans to create more generators to sell more art. Owners of the art pieces it sells are owned by them without relying on any other third parties or intermediaries. It is scarce, digital, collectible art. This is implemented on the Ethereum blockchain.

There's variants on how this can be implemented. All of them have trade-offs in economic designs.

#### A Hardcoded Generator:

There's only one software generator used. It's a hardcoded hash. It can never be changed.

#### A Single, Shifting Generator:

There's only one generator at a time, but using the token minted from the curved bond, it is used to curate and change the generator to a different one. Only the highest ranked generator is allowed to sell its art.

#### Multiple Generators:

There's multiple generators, and multiple auctions at any given time. The curved bond token (SOUL) is used to deposit into multiple generators (creating multiple, nested curved bonds).

Art sold by a specific generator rewards those who are backing that generator, and also the whole autonomous artist.

## Generators

A generator is a piece of software that takes in a specific input and always generates the same artwork.

Such an example is: https://mattdesl.svbtle.com/generative-art-with-nodejs-and-canvas.

## Daily Art Auctions

Depending on the generator implmentation, for every generator that has been brought online, it takes a blockhash every 24 hours and starts an auction with that blockhash as the input. It starts at a fixed price and depreciates to zero over 24 hours. At any point in time, someone can buy it at the designated price. When it approaches zero, anyone can claim the art. Once the art is claimed or bought, and 24 hours has passed, a new auction starts with a new blockhash. The next art piece's starting price for that generator is increased on a moving average.

The art pieces uses the ERC721 standard so that it becomes tradable and transferable on the Ethereum blockchain. The proceeds from the art that is denonimated in ETH gets deposited into a communal pool that is accessible through a curved bond.

When an artwork is sold, it also rewards those who opted to support that specific generator (hardcoded, shifting or multiple). For any specific implementation, the mechanics would be roughly the same, except there would be a restriction on auctions.

## Curved Bonds & Generator Engines

The art bot thrives on a curved bond (https://medium.com/@simondlr/tokens-2-0-curved-token-bonding-in-curation-markets-1764a2e0bee5).

At any point someone can buy (with ETH) a SOUL token whose price is calculated based on the current supply of SOUL tokens. The more soul tokens that are in circulation, the higher the price of the new soul tokens. The ETH used to buy the soul token is also deposited and owned by the autonomous artist. A SOUL token can at any point be destroyed for access to the ETH in the communal pool.

Buying SOUL tokens with ETH, allows holders to stake their SOUL tokens towards specific generators on their own curved bonds. When this happens, a generator starts its lifecycle. If no SOUL tokens are staked to a generator, it goes offline and can't sell anymore art. In a hardcoded generator, there's only ever one generator to stake towards. In a shifting generator, you can stake to multiple generators, but only the top generator would be allowed to auction artwork. In multiple generators, multiple auctions would occur simultaneously.

When an art piece is sold by a generator, that ETH is used to buy SOUL tokens to deposit into the curved bond of the generator. New generator tokens are NOT minted through this process.

Thus: as generators sell art, the overall ETH the autonomous artist owns increases. Successful generators earn more SOUL tokens.

Those who back and curate successful generators can earn SOUL tokens.

In order for a generator to be successful, it needs to be able to show the front-end what art it creates from using the blockhash as its input. This needs to be merged in, into this repo, or viewed separately in another interface.

BANCOR formulas are used to derive the price of the tokens.

## ERC721

Every art piece conforms to the ERC721 Non-Fungible Token standard allowing it to be easily sold and transferred.

Every art piece contains two core components. The hash of the generator & the block number of the start of its creation auction. Clients would use the block hash of that block as the input for the generator.

## Metadata

When querying the ERC721 contract, it would be meaningful if the metadata describes how to view the artwork it contains. If this works, then a more generic interface can be built around middleware to 1) pull in the generator and 2) immediately generate it, all from the client side (hopefully).

## Serving the Art Bot

The goal for the art bot is that it could run completely client-side: all implemented fully decentralized: utilizing IPFS/Swarm & ENS for serving it.

## Help & Contributing

Thanks to everyone who has contributed thus far! The issues present the work necessary. Feel free to pick up where you can. I'll be writing a more extensive contributors guide soon.

## Licensing

It's imperative that the software used to generate the art is permissively licensed.

This code is ideally licensed as MIT.

## Thanks & Inspiration

Here's the original post. https://medium.com/@simondlr/lets-summon-an-autonomous-artist-a-bot-that-creates-owns-and-sells-its-own-art-ada1afad086a. Thanks to Trent McConaghy & Greg McMullen with whom I initially had this discussion with back in 2016 to create such an experiment.
