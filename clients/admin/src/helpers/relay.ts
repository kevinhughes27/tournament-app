const separator = "-";

export const encodeId = (typeName: string, id: number) => {
  return btoa(`${typeName}${separator}${id}`);
}

export const decodeId = (id: string) => {
  return atob(id).split(separator)[1];
}
