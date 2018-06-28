const COLORS = [
  "#a6cee3",
  "#1f78b4",
  "#b2df8a",
  "#33a02c",
  "#fb9a99",
  "#e31a1c",
  "#fdbf6f",
  "#ff7f00",
  "#cab2d6",
  "#6a3d9a",
  "#ffcc00",
  "#ff0066"
];

const GameColor = (game: Game) => {
  const divisionId = game.division.id;
  const color = COLORS[parseInt(divisionId, 10) % 12];
  return color;
};

export default GameColor;
