import * as React from "react";

const GameText = (game: Game, length: number) => {
  if (!game.pool) {
    return BracketText(game, length);
  } else {
    return PoolText(game, length);
  }
};

const BracketText = (game: Game, length: number) => {
  if (length <= 60) {
    return (
      <div className="game-text-1">
        <strong>{game.bracketUid}</strong> {game.homePrereq} v {game.awayPrereq}
      </div>
    );
  } else {
    return (
      <div className="game-text-2">
        <strong>{game.bracketUid}</strong>
        <span>{game.homePrereq} v {game.awayPrereq}</span>
      </div>
    );
  }
};

const PoolText = (game: Game, length: number) => {
  if (length <= 60) {
    return (
      <div className="game-text-1">
        <strong>{game.pool}</strong> {game.homePoolSeed} v {game.awayPoolSeed}
      </div>
    );
  } else {
    return (
      <div className="game-text-2">
        <strong>{game.pool}</strong>
        <span>{game.homePoolSeed} v {game.awayPoolSeed}</span>
      </div>
    );
  }
};

export default GameText;
