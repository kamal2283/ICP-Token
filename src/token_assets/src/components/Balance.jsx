import React, { useState} from "react";
import { Principal } from "@dfinity/principal";
import {token} from "../../../declarations/token";

function Balance() {

  const [inuptValue, setInputValue] = React.useState("");
  const [balanceResult, setBalance] = React.useState("");
  const [cryptoSymbol, setSymbol] = React.useState("ICP");
  const [isHidden, setHidden] = React.useState(true);

  
  async function handleClick() {
    // console.log("Balance Button Clicked");
    const principal = Principal.fromText(inuptValue);
   const balance = await token.balanceOf(principal);
    setBalance(balance.toLocaleString());
    setSymbol(await token.getSymbol());
    setHidden(false);
  }


  return (
    <div className="window white">
      <label>Check account token balance:</label>
      <p>
        <input
          id="balance-principal-id"
          type="text"
          placeholder="Enter a Principal ID"
          value={inuptValue}
          onChange={(e) => setInputValue(e.target.value)}
        />
      </p>
      <p className="trade-buttons">
        <button
          id="btn-request-balance"
          onClick={handleClick}
        >
          Check Balance
        </button>
      </p>
      <p hidden={isHidden} >This account has a balance of {balanceResult} {cryptoSymbol}.</p>
    </div>
  );
}

export default Balance;
