import React from 'react'

export default function GameText (game) {
  if (game.bracket) {
    return BracketText(game)
  } else {
    return PoolText(game)
  }
}

function BracketText (game) {
  if (game.length && game.length <= 60) {
    return (
      <div style={{width: '100%'}}>
        <h4><strong>{game.bracket_uid}</strong> {game.home_prereq} v {game.away_prereq}</h4>
      </div>
    )
  } else {
    return (
      <div style={{width: '100%'}}>
        <h4>{game.bracket_uid}</h4>
        <span>{game.home_prereq} v {game.away_prereq}</span>
      </div>
    )
  }
}

function PoolText (game) {
  if (game.length && game.length <= 60) {
    return (
      <div style={{width: '100%'}}>
        <h4><strong>{game.pool}</strong> {game.home_pool_seed} v {game.away_pool_seed}</h4>
      </div>
    )
  } else {
    return (
      <div style={{width: '100%'}}>
        <h4>{game.pool}</h4>
        <span>{game.home_pool_seed} v {game.away_pool_seed}</span>
      </div>
    )
  }
}
