import React, { Component } from "react";
import { ContractData, ContractForm } from "drizzle-react-components";

class Home extends Component {
  render() {
    console.log("Home.js");
    return (
      <main className="container">
        <div className="pure-g">
          <div className="pure-u-1-1 header">
            <h1>Artonomous</h1>
          </div>

          <div className="pure-u-1-1">
            <p>
              <strong>Staking</strong>:{" "}
              <ContractData contract="Artonomous" method="artonomousStaking" />
            </p>
            <p>
              <strong>Piece Token</strong>:{" "}
              <ContractData contract="Artonomous" method="pieceToken" />
            </p>
            <p>
              <strong>Beneficiary</strong>:{" "}
              <ContractData contract="Artonomous" method="beneficiary" />
            </p>
            <p>
              <strong>Auction Length (in seconds)</strong>:{" "}
              <ContractData contract="Artonomous" method="AUCTION_LENGTH" />
            </p>
            <p>
              <strong>Current Auction</strong>:{" "}
              <ContractData contract="Artonomous" method="currentAuction" />
              <ContractForm
                contract="Artonomous"
                method="buyArt"
                methodArgs={[{ value: 1000000000000 }]}
              />
            </p>
          </div>
        </div>
      </main>
    );
  }
}

export default Home;
