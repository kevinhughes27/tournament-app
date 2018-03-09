import React from 'react'

export default function GameText (game) {
  if (game.bracket) {
    return (
      <div style={{width: '100%'}}>
        <h4>{game.bracket_uid}</h4>
        <span>{game.home_prereq} v {game.away_prereq}</span>
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
